`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_conv
// Description: Advanced SystemVerilog Testbench for 2D Convolution Engine Core
//////////////////////////////////////////////////////////////////////////////////

module tb_conv();

    // -------------------------------------------------------------------------
    // Design Configuration Parameters
    // -------------------------------------------------------------------------
    parameter int PIX_WIDTH          = 8;
    parameter int WEIGHT_WIDTH       = 10;
    parameter int WEIGHT_FRACT_WIDTH = 5;
    parameter int KERNEL_DIMENSION   = 3;
    parameter string TRUNK           = "TRUE";
    parameter bit [11:0] IMG_WIDTH   = 28;
    parameter bit [11:0] IMG_HEIGHT  = 28;

    // Derived width parameter checking matching output logic definitions
    localparam int O_DATA_WIDTH = (TRUNK == "TRUE") ? PIX_WIDTH : (PIX_WIDTH + WEIGHT_FRACT_WIDTH);

    // -------------------------------------------------------------------------
    // Signal Interface Declarations
    // -------------------------------------------------------------------------
    logic                        clk;
    logic                        clk_en;
    logic                        rst_n;
    
    // Pixel Input Bus Signals
    logic [PIX_WIDTH-1:0]        i_data;
    logic                        i_valid;
    logic                        i_sop;
    logic                        i_eop;
    
    // Output Monitoring Bus Signals
    logic [O_DATA_WIDTH-1:0]     o_data;
    logic                        o_valid;
    logic                        o_sop;
    logic                        o_eop;
    
    // Native Multi-Dimensional Packed Matrix matching the Core Engine Port Map
    logic signed [WEIGHT_WIDTH-1:0] kernel [0:KERNEL_DIMENSION-1][0:KERNEL_DIMENSION-1];
    
    logic                        ready;
    logic [11:0]                 cols_cntr;
    logic [11:0]                 rows_cntr;

    // -------------------------------------------------------------------------
    // Device Under Test (DUT) Instantiation
    // -------------------------------------------------------------------------
    conv #(
        .PIX_WIDTH(PIX_WIDTH), 
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .WEIGHT_FRACT_WIDTH(WEIGHT_FRACT_WIDTH), 
        .KERNEL_DIMENSION(KERNEL_DIMENSION),
        .TRUNK(TRUNK), 
        .img_width(IMG_WIDTH), 
        .img_height(IMG_HEIGHT)
    ) dut (
        .* // SystemVerilog wildcard shorthand connects identical matching signal names
    );

    // -------------------------------------------------------------------------
    // Clock Tree Generation Block (50 MHz Frame Rate Simulation Clock)
    // -------------------------------------------------------------------------
    always #10 clk = ~clk;

    // Emulated Frame Buffer Array Container
    logic [PIX_WIDTH-1:0] mock_image [0:IMG_HEIGHT-1][0:IMG_WIDTH-1];

    // -------------------------------------------------------------------------
    // Stimulus Pattern Injection Sequence
    // -------------------------------------------------------------------------
    initial begin
        // 1. Force Safe Initialization Conditions
        clk     = 1'b0; 
        clk_en  = 1'b0; 
        rst_n   = 1'b0;
        i_data  = '0; 
        i_valid = 1'b0; 
        i_sop   = 1'b0; 
        i_eop   = 1'b0;

        // 2. Load 2D Matrix Values Directly (Example: Sobel Horizontal Edge Filter Matrix)
        kernel = '{
            '{10'sh3E0, 10'sh000, 10'sh020},  // Row 0: Real values [-1,  0, +1]
            '{10'sh3C0, 10'sh000, 10'sh040},  // Row 1: Real values [-2,  0, +2]
            '{10'sh3E0, 10'sh000, 10'sh020}   // Row 2: Real values [-1,  0, +1]
        };

        // 3. Construct synthetic input canvas (Vertical Contrast Line split at column 14)
        for (int r = 0; r < IMG_HEIGHT; r++) begin
            for (int c = 0; c < IMG_WIDTH; c++) begin
                mock_image[r][c] = (c < 14) ? 8'd0 : 8'd255;
            end
        end

        // 4. Global Hard Asynchronous Reset Cycle Execution
        #40; 
        rst_n = 1'b1; // Release reset line
        #20; 
        clk_en = 1'b1; // Trigger global system clock enable signal
        #20;

        $display("[STATUS] Commencing SystemVerilog Streaming Pixel Frame Pipeline...");
        
        // 5. Pixel Stream Execution Nested Loops
        for (int r = 0; r < IMG_HEIGHT; r++) begin
            for (int c = 0; c < IMG_WIDTH; c++) begin
                
                // FIXED: Safe dynamic backpressure monitor synced to clock edge
                // If DUT is not ready, drop valid, wait for ready, then proceed
                if (!ready) begin
                    i_valid = 1'b0;
                    while (!ready) @(posedge clk);
                end

                // Inject stream bus contents on active clock window
                i_data  = mock_image[r][c];
                i_valid = 1'b1;
                i_sop   = (r == 0 && c == 0); 
                i_eop   = (r == IMG_HEIGHT-1 && c == IMG_WIDTH-1); 
                
                @(posedge clk);
            end
        end

        // 6. Return bus values back to zero state
        i_valid = 1'b0; 
        i_data  = '0; 
        i_sop   = 1'b0; 
        i_eop   = 1'b0;
        
        // Allow downstream pipeline to flush out
        #1000;
        $display("[STATUS] Simulation validation completed successfully.");
        $finish;
    end

    // -------------------------------------------------------------------------
    // Hardware Simulation Data Output Logger Monitor
    // -------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (clk_en && o_valid) begin
            $display("[DATA_OUT] Convolved Pixel: %d at [Row: %d, Col: %d]", o_data, rows_cntr, cols_cntr);
            
            if (o_sop) $display(" >>> [INFO] Start of Packet (SOP) Detected.");
            if (o_eop) $display(" >>> [INFO] End of Packet (EOP) Detected.");
        end
    end

endmodule
