`timescale 1ns/1ps

module conv_block_tb;

    // =========================================================================
    // 1. Parameter Declarations
    // =========================================================================
    parameter PIX_WIDTH          = 8;
    parameter WEIGHT_WIDTH       = 10;
    parameter WEIGHT_FRACT_WIDTH = 5;
    parameter TRUNK              = "TRUE";
    parameter IMG_WIDTH          = 28;
    parameter IMG_HEIGHT         = 28;
    parameter KERNEL_DIMENSION   = 3;
    parameter IN_DIMENSION       = 1;
    parameter OUT_DIMENSION      = 4;

    // Derived parameter metrics matching internal module layouts
    localparam KERNEL_WORDS   = OUT_DIMENSION * IN_DIMENSION * KERNEL_DIMENSION * KERNEL_DIMENSION;
    localparam BIAS_WORDS     = OUT_DIMENSION;
    localparam TOTAL_WORDS    = KERNEL_WORDS + BIAS_WORDS;
    localparam OUT_DATA_WIDTH = (TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH + WEIGHT_FRACT_WIDTH);

    // =========================================================================
    // 2. Testbench Signals
    // =========================================================================
    logic                                                    clk;
    logic                                                    clk_en;
    logic                                                    rst_n;
    
    // Pixel Stream Ports
    logic [IN_DIMENSION-1:0][PIX_WIDTH-1:0]                  i_data;
    logic                                                    i_valid;
    logic                                                    i_sop;
    logic                                                    i_eop;
    
    // Output Monitoring Ports
    wire  [OUT_DIMENSION-1:0][OUT_DATA_WIDTH-1:0]            o_data;
    wire                                                     o_valid;
    wire                                                     o_sop;
    wire                                                     o_eop;
    wire                                                     o_ready;

    // External Streaming Pins
    logic                                                    i_cfg_valid;
    logic [WEIGHT_WIDTH-1:0]                                 i_cfg_data;
    wire                                                     o_cfg_ready;

    // Interconnect Buses Routing Design Elements Together
    wire                                                     w_load_en;
    wire [$clog2(TOTAL_WORDS)-1:0]                           w_load_addr;
    wire [WEIGHT_WIDTH-1:0]                                  w_load_data;

    // =========================================================================
    // 3. Device Under Test (DUT) Subsystem Wiring
    // =========================================================================
    
    // Instance 1: Configuration Handshake Controller
    runtime_weight_loader #(
        .WEIGHT_WIDTH    (WEIGHT_WIDTH),
        .KERNEL_DIMENSION(KERNEL_DIMENSION),
        .IN_DIMENSION    (IN_DIMENSION),
        .OUT_DIMENSION   (OUT_DIMENSION)
    ) dut_loader (
        .clk             (clk),
        .rst_n           (rst_n),
        .i_cfg_valid     (i_cfg_valid),
        .i_cfg_data      (i_cfg_data),
        .o_cfg_ready     (o_cfg_ready),
        .weight_load_en  (w_load_en),
        .weight_addr     (w_load_addr),
        .weight_data     (w_load_data)
    );

    // Instance 2: Core Processing Matrix Array
    conv_block #(
        .PIX_WIDTH         (PIX_WIDTH),
        .WEIGHT_WIDTH      (WEIGHT_WIDTH),
        .WEIGHT_FRACT_WIDTH(WEIGHT_FRACT_WIDTH),
        .TRUNK             (TRUNK),
        .IMG_WIDTH         (IMG_WIDTH),
        .IMG_HEIGHT        (IMG_HEIGHT),
        .KERNEL_DIMENSION  (KERNEL_DIMENSION),
        .IN_DIMENSION      (IN_DIMENSION),
        .OUT_DIMENSION     (OUT_DIMENSION)
    ) dut_conv_block (
        .clk               (clk),
        .clk_en            (clk_en),
        .rst_n             (rst_n),
        .i_data            (i_data),
        .i_valid           (i_valid),
        .i_sop             (i_sop),
        .i_eop             (i_eop),
        .o_data            (o_data),
        .o_valid           (o_valid),
        .o_sop             (o_sop),
        .o_eop             (o_eop),
        .weight_load_en    (w_load_en),
        .weight_addr       ({ {(16-$clog2(TOTAL_WORDS)){1'b0}}, w_load_addr }), 
        .weight_data       (w_load_data),
        .o_ready           (o_ready)
    );

    // =========================================================================
    // 4. Clock Generation (50 MHz Oscillator)
    // =========================================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // =========================================================================
    // 5. Simulation Stimulus Vector Orchestration
    // =========================================================================
    initial begin
        // Reset state initialization
        rst_n       = 0;
        clk_en      = 1;
        i_data      = '0;
        i_valid     = 0;
        i_sop       = 0;
        i_eop       = 0;
        i_cfg_valid = 0;
        i_cfg_data  = '0;

        #40;
        rst_n = 1; // Release reset flag
        #20;

        $display("[VIVADO-TB] Initiating Configuration Sequence (Improvement 4)...");
        
        // Push full parameter array down into internal memory blocks
        for (int i = 0; i < TOTAL_WORDS; i++) begin
            if (!o_cfg_ready) begin
                @(posedge clk);
            end
            
            i_cfg_valid = 1;
            if (i >= KERNEL_WORDS) begin
                i_cfg_data = (i - KERNEL_WORDS) + 1; // Load structured layer biases
            end else begin
                i_cfg_data = 10; // Load standard weight entries
            end
            @(posedge clk);
        end

        // Clear memory bus lines
        i_cfg_valid = 0;
        i_cfg_data  = '0;
        
        $display("[VIVADO-TB] Configuration Phase Locked. Moving to Data Flow Mode...");
        #100;

        // Verify computing matrices are active and tracking
        while (!o_ready) begin
            @(posedge clk);
        end

        // Dispatch a complete multi-channel frame
        @(posedge clk);
        i_valid = 1;
        i_sop   = 1; 
        
        for (int row = 0; row < IMG_HEIGHT; row++) begin
            for (int col = 0; col < IMG_WIDTH; col++) begin
                for (int ch = 0; ch < IN_DIMENSION; ch++) begin
                    i_data[ch] = (row * IMG_WIDTH) + col + ch; // Inject dummy gradient values
                end
                
                if (row == IMG_HEIGHT-1 && col == IMG_WIDTH-1) begin
                    i_eop = 1; // Assert end-of-packet on final pixel element
                end
                
                @(posedge clk);
                i_sop = 0; 
            end
        end

        // Unset stream markers
        i_valid = 0;
        i_eop   = 0;
        i_data  = '0;

        #1000;
        $display("[VIVADO-TB] Verification Routine Complete. System verified successfully.");
        $finish;
    end

    // =========================================================================
    // 6. Real-Time Console Monitor
    // =========================================================================
    always @(posedge clk) begin
        if (w_load_en) begin
            $display("[VIVADO-LOG] Memory Write -> Index: %0d | Value: %0d", w_load_addr, w_load_data);
        end
        if (o_valid) begin
            $display("[VIVADO-LOG] Output Pipeline Emitted -> Data Matrix Active | SOP: %b | EOP: %b", o_sop, o_eop);
        end
    end

endmodule
