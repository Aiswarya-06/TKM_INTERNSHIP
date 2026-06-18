// -----------------------------------------------------------------------------
// Module      : runtime_weight_loader
// Owner       : Member 3 (Multi-Channel Convolution Owner)
// Description : Sequential address counter for loading weights during runtime.
// -----------------------------------------------------------------------------

module runtime_weight_loader #(
    parameter WEIGHT_WIDTH     = 10,
    parameter KERNEL_DIMENSION = 3,
    parameter IN_DIMENSION     = 1,
    parameter OUT_DIMENSION    = 4,
    
    // Total footprint calculation (Kernels + Biases)
    localparam TOTAL_WORDS = (OUT_DIMENSION * IN_DIMENSION * KERNEL_DIMENSION * KERNEL_DIMENSION) + OUT_DIMENSION
) (
    input  logic                         clk,
    input  logic                         rst_n,
    
    // External Configuration Handshake Interface
    input  logic                         i_cfg_valid,   
    input  logic [WEIGHT_WIDTH-1:0]      i_cfg_data,    
    output logic                         o_cfg_ready,   
    
    // Internal Control Signals to kernel_memory
    output logic                         weight_load_en,
    output logic [$clog2(TOTAL_WORDS)-1:0] weight_addr,
    output logic [WEIGHT_WIDTH-1:0]      weight_data
);

    logic [$clog2(TOTAL_WORDS)-1:0] addr_counter;
    logic                           is_loading;

    // Signal routing
    assign o_cfg_ready    = is_loading && (addr_counter < TOTAL_WORDS);
    assign weight_load_en = i_cfg_valid && o_cfg_ready;
    assign weight_addr    = addr_counter;
    assign weight_data    = i_cfg_data;

    // Address tracking logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addr_counter <= '0;
            is_loading   <= 1'b1;
        end else begin
            if (weight_load_en) begin
                if (addr_counter == TOTAL_WORDS - 1) begin
                    is_loading   <= 1'b0; // Memory full, disable loader
                    addr_counter <= '0;
                end else begin
                    addr_counter <= addr_counter + 1'b1;
                end
            end
        end
    end

endmodule
