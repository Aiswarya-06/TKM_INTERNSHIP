module conv_block #(
    parameter PIX_WIDTH          = 8     ,
    parameter WEIGHT_WIDTH       = 10    ,
    parameter WEIGHT_FRACT_WIDTH = 5     ,
    parameter TRUNK              = "TRUE",
    parameter IMG_WIDTH          = 28    ,
    parameter IMG_HEIGHT         = 28    ,
    parameter KERNEL_DIMENSION   = 3     ,
    parameter IN_DIMENSION       = 1     ,
    parameter OUT_DIMENSION      = 4
) (
    input                                              clk,
    input                                              clk_en,
    input                                              rst_n,
    
    // Image input stream
    input        [IN_DIMENSION-1:0][PIX_WIDTH-1:0]     i_data,
    input                                              i_valid,
    input                                              i_sop,
    input                                              i_eop,
    
    // Output stream
    output logic [OUT_DIMENSION-1:0][((TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH+WEIGHT_FRACT_WIDTH))-1:0] o_data,
    output logic                                       o_valid,
    output logic                                       o_sop,
    output logic                                       o_eop,
    
    // Improvement 4: Unified runtime memory configuration signals
    input  logic                                       weight_load_en,
    input  logic [15:0]                                weight_addr,
    input  logic [WEIGHT_WIDTH-1:0]                    weight_data,
    
    output logic                                       o_ready
);

    // Internal structural connecting wires
    wire [OUT_DIMENSION-1:0][IN_DIMENSION-1:0][KERNEL_DIMENSION-1:0][KERNEL_DIMENSION-1:0][WEIGHT_WIDTH-1:0] kernel;
    wire [OUT_DIMENSION-1:0][WEIGHT_WIDTH-1:0] bias;

    // Separate memory module assignment
    kernel_memory #(
        .WEIGHT_WIDTH     (WEIGHT_WIDTH),
        .KERNEL_DIMENSION (KERNEL_DIMENSION),
        .IN_DIMENSION     (IN_DIMENSION),
        .OUT_DIMENSION    (OUT_DIMENSION)
    ) inst_kernel_mem (
        .clk              (clk),
        .rst_n            (rst_n),
        .weight_load_en   (weight_load_en),
        .weight_addr      (weight_addr[$clog2(OUT_DIMENSION*(IN_DIMENSION*KERNEL_DIMENSION*KERNEL_DIMENSION)+OUT_DIMENSION)-1:0]),
        .weight_data      (weight_data),
        .o_kernel         (kernel),
        .o_bias           (bias)
    );

    // Data width processing limits
    localparam OUT_DATA_WIDTH = (TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH+WEIGHT_FRACT_WIDTH);
    logic signed [OUT_DATA_WIDTH-1:0] conv_outputs[OUT_DIMENSION][IN_DIMENSION];

    logic valid[OUT_DIMENSION][IN_DIMENSION];
    logic sop  [OUT_DIMENSION][IN_DIMENSION];
    logic eop  [OUT_DIMENSION][IN_DIMENSION];
    logic ready[OUT_DIMENSION][IN_DIMENSION];
    
    // Multi-dimensional filter engine block grid
    genvar row, col;
    generate
        for (row = 0; row < OUT_DIMENSION; row++) begin : gen_row
            for (col = 0; col < IN_DIMENSION; col++) begin : gen_col
                conv #(
                    .PIX_WIDTH         (PIX_WIDTH),
                    .WEIGHT_WIDTH      (WEIGHT_WIDTH),
                    .WEIGHT_FRACT_WIDTH(WEIGHT_FRACT_WIDTH),
                    .TRUNK             (TRUNK),
                    .KERNEL_DIMENSION  (KERNEL_DIMENSION),
                    .img_width         (IMG_WIDTH),
                    .img_height        (IMG_HEIGHT)
                ) inst_conv (
                    .clk      (clk),
                    .clk_en   (clk_en),
                    .rst_n    (rst_n),
                    .i_data   (i_data[col]),
                    .i_valid  (i_valid),
                    .i_sop    (i_sop),
                    .i_eop    (i_eop),
                    .o_data   (conv_outputs[row][col]),
                    .o_valid  (valid[row][col]),
                    .o_sop    (sop[row][col]),
                    .o_eop    (eop[row][col]),
                    .kernel   (kernel[row][col]),
                    .ready    (ready[row][col]),
                    .cols_cntr(),
                    .rows_cntr()
                );
            end
        end
    endgenerate

    // Multi-channel adder logic paths
    logic signed [OUT_DATA_WIDTH-1:0] sum[OUT_DIMENSION];

    always_comb begin
        for (int x = 0; x < OUT_DIMENSION; x++) begin
            sum[x] = '0;
            for (int z = 0; z < IN_DIMENSION; z++) begin
                sum[x] = sum[x] + $signed(conv_outputs[x][z]);
            end
        end
    end

    // Clock-synchronous pipeline matching control signals
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            o_valid <= 1'b0;
            o_sop   <= 1'b0;
            o_eop   <= 1'b0;
            o_data  <= '0;
        end else if (clk_en) begin
            o_valid <= valid[0][0];
            o_sop   <= sop[0][0];
            o_eop   <= eop[0][0];

            for (int x = 0; x < OUT_DIMENSION; x++) begin
                o_data[x] <= $signed(sum[x]) + $signed(bias[x]);
            end
        end
    end

    assign o_ready = ready[0][0];

endmodule : conv_block
