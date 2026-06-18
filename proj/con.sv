`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: conv
// Description: Refactored Parallel Fixed-point 2D Convolution Engine (SystemVerilog)
// Fixes Applied: Resolved RTL simulation Pass-Through Read/Write 'X' Race conditions
//////////////////////////////////////////////////////////////////////////////////

module conv #(
    parameter int PIX_WIDTH          = 8,
    parameter int WEIGHT_WIDTH       = 10,
    parameter int WEIGHT_FRACT_WIDTH = 5,
    parameter int KERNEL_DIMENSION   = 3,
    parameter string TRUNK           = "TRUE",
    parameter bit [11:0] img_width   = 28,
    parameter bit [11:0] img_height  = 28
) (
    input  logic                        clk,        // Clock
    input  logic                        clk_en,     // Clock Enable
    input  logic                        rst_n,      // Asynchronous reset active low
    
    // Input Pixel Stream
    input  logic [PIX_WIDTH-1:0]        i_data,
    input  logic                        i_valid,
    input  logic                        i_sop,
    input  logic                        i_eop,
    
    // Output Pixel Stream
    output logic [((TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH+WEIGHT_FRACT_WIDTH))-1:0] o_data,
    output logic                        o_valid,
    output logic                        o_sop,
    output logic                        o_eop,
    
    // Clean 2D Native SystemVerilog Packed Array for Kernel Values
    input  logic signed [WEIGHT_WIDTH-1:0] kernel [0:KERNEL_DIMENSION-1][0:KERNEL_DIMENSION-1],
    
    output logic                        ready,
    output logic [11:0]                 cols_cntr,
    output logic [11:0]                 rows_cntr
);

    localparam int MAX_DEPTH = 1920;

    // -------------------------------------------------------------------------
    // Line Buffers (Inferred Block RAMs)
    // -------------------------------------------------------------------------
    logic [11:0] line_buf_waddr;
    logic [11:0] line_buf_raddr;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            line_buf_waddr <= '0;
        end else if (clk_en && (i_valid || !ready)) begin
            if (line_buf_waddr == img_width - 1)
                line_buf_waddr <= '0;
            else
                line_buf_waddr <= line_buf_waddr + 1'b1;
        end
    end
    
    assign line_buf_raddr = line_buf_waddr;

    // Line buffer unpack matrices
    logic [PIX_WIDTH-1:0] line_buf_out [0:KERNEL_DIMENSION-2];
    logic [PIX_WIDTH-1:0] delayed_line [0:KERNEL_DIMENSION-1];

    generate
        for (genvar k = 0; k < KERNEL_DIMENSION-1; k++) begin : gen_line_buffers
            logic [PIX_WIDTH-1:0] ram [0:MAX_DEPTH-1];
            logic [PIX_WIDTH-1:0] din;
            
            assign din = (k == 0) ? i_data : line_buf_out[k-1];
            
            // FIXED: Emulated a pass-through bypass mechanism to eliminate 
            // behavioral simulator simultaneous read/write 'X' race conditions.
            always_ff @(posedge clk) begin
                if (clk_en && (i_valid || !ready)) begin
                    ram[line_buf_waddr] <= din;
                    line_buf_out[k]     <= din; // Push directly to output registers on write cycle
                end else begin
                    line_buf_out[k]     <= ram[line_buf_raddr]; // Standard Read cycle
                end
            end
        end
    endgenerate

    // -------------------------------------------------------------------------
    // Sliding Window Register Matrix
    // -------------------------------------------------------------------------
    logic [PIX_WIDTH-1:0] after_fifos_ffs [0:KERNEL_DIMENSION-1][0:KERNEL_DIMENSION-2];
    logic [PIX_WIDTH-1:0] delayed_pix     [0:KERNEL_DIMENSION-1][0:KERNEL_DIMENSION-1];

    always_comb begin
        for (int i = 0; i < KERNEL_DIMENSION; i++) begin
            delayed_line[i] = (i == 0) ? i_data : line_buf_out[i-1];
        end

        for (int i = 0; i < KERNEL_DIMENSION; i++) begin
            for (int y = 0; y < KERNEL_DIMENSION; y++) begin
                delayed_pix[i][y] = (y == 0) ? delayed_line[i] : after_fifos_ffs[i][y-1];
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            after_fifos_ffs <= '{default: '0};
        end else if (clk_en && (i_valid || !ready)) begin
            for (int i = 0; i < KERNEL_DIMENSION; i++) begin
                for (int y = KERNEL_DIMENSION-2; y > 0; y--) begin
                    after_fifos_ffs[i][y] <= after_fifos_ffs[i][y-1];
                end
                after_fifos_ffs[i][0] <= delayed_line[i];
            end
        end
    end

    // -------------------------------------------------------------------------
    // Convolution Mathematics (Fixed Array Fabric)
    // -------------------------------------------------------------------------
    logic signed [WEIGHT_WIDTH+PIX_WIDTH-1:0] mult_result [0:KERNEL_DIMENSION-1][0:KERNEL_DIMENSION-1];

    // FIXED: Guarded multiplication fabric logic to prevent uninitialized 
    // sliding window states ('X') from leaking into the adder tree.
    always_ff @(posedge clk or negedge rst_n) begin : proc_multiplying
        if (~rst_n) begin
            mult_result <= '{default: '0};
        end else if (clk_en) begin
            if (i_valid) begin
                for (int i = 0; i < KERNEL_DIMENSION; i++) begin
                    for (int y = 0; y < KERNEL_DIMENSION; y++) begin
                        // Padding a leading zero to unsigned pixel before conversion to prevent signed extension bugs
                        mult_result[i][y] <= $signed({1'b0, delayed_pix[(KERNEL_DIMENSION-1)-i][(KERNEL_DIMENSION-1)-y]}) * kernel[i][y];
                    end
                end
            end else begin
                mult_result <= '{default: '0}; // Force mathematical zero states when input stream is stalling
            end
        end
    end

    localparam int SUM1_WIDTH = 4 + (WEIGHT_WIDTH + PIX_WIDTH); 
    
    logic signed [SUM1_WIDTH-1:0] total_combinational_sum;
    logic signed [SUM1_WIDTH-1:0] mult_sum_out;

    // Parallel Structural Adder tree to preserve timing closure and prevent structural simulator glitches
    assign total_combinational_sum = 
        mult_result[0][0] + mult_result[0][1] + mult_result[0][2] +
        mult_result[1][0] + mult_result[1][1] + mult_result[1][2] +
        mult_result[2][0] + mult_result[2][1] + mult_result[2][2];

    always_ff @(posedge clk or negedge rst_n) begin : proc_mult_sum
        if (~rst_n) begin
            mult_sum_out <= '0;
        end else if (clk_en) begin
            mult_sum_out <= (TRUNK == "TRUE") ? (total_combinational_sum >>> WEIGHT_FRACT_WIDTH) : total_combinational_sum;
        end
    end

    // Normalization / Activation ReLU Logic Mapping
`ifdef RELU
    assign o_data = (mult_sum_out < 0) ? '0 : ((|mult_sum_out[SUM1_WIDTH-1:PIX_WIDTH]) ? ({PIX_WIDTH{1'b1}}) : mult_sum_out[PIX_WIDTH-1:0]);
`else 
    assign o_data = mult_sum_out[((TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH+WEIGHT_FRACT_WIDTH))-1:0];
`endif

    // -------------------------------------------------------------------------
    // Latency Pipeline & Control Counters
    // -------------------------------------------------------------------------
    logic [2:0] valid_delay;
    logic       valid_delayed;
    
    assign valid_delayed = valid_delay[2];
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_delay <= '0;
        end else if (clk_en) begin
            valid_delay <= {valid_delay[1:0], i_valid && ready};
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cols_cntr <= '0;
            rows_cntr <= '0;
        end else if (clk_en) begin
            if (valid_delayed || (!ready && (rows_cntr == img_height))) begin
                cols_cntr <= (cols_cntr == img_width-1) ? '0 : (cols_cntr + 1'b1);
                if (cols_cntr == img_width-1)
                    rows_cntr <= (rows_cntr == img_height) ? '0 : (rows_cntr + 1'b1);
            end
            else if (i_sop) begin
                cols_cntr <= '0;
                rows_cntr <= '0;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ready <= 1'b1;
        end else if (clk_en) begin
            if (i_eop) begin
                ready <= 1'b0;
            end
            else if (rows_cntr == 0)
                ready <= 1'b1;
        end
    end

    assign o_valid = valid_delayed && (rows_cntr > 1) && (rows_cntr < img_height) && (cols_cntr > 1) && (cols_cntr < img_width);
    assign o_eop   = valid_delayed && (cols_cntr == img_width-1) && (rows_cntr == img_height-1);
    assign o_sop   = valid_delayed && (rows_cntr == 2) && (cols_cntr == 2);

endmodule
