module runtime_weight_loader #(
    parameter WEIGHT_WIDTH     = 10,
    parameter KERNEL_DIMENSION = 3,
    parameter IN_DIMENSION     = 1,
    parameter OUT_DIMENSION    = 4,
    
    // Total calculation limits
    localparam TOTAL_WORDS = (OUT_DIMENSION * IN_DIMENSION * KERNEL_DIMENSION * KERNEL_DIMENSION) + OUT_DIMENSION
) (
    input  logic                         clk,
    input  logic                         rst_n,
    
    // Control handshakes from outside the chip
    input  logic                         i_cfg_valid,   // External data is ready
    input  logic [WEIGHT_WIDTH-1:0]      i_cfg_data,    // Incoming weight word
    output logic                         o_cfg_ready,   // Tell outside world we can accept data
    
    // Internal connections down to your kernel_memory module
    output logic                         weight_load_en,
    output logic [$clog2(TOTAL_WORDS)-1:0] weight_addr,
    output logic [WEIGHT_WIDTH-1:0]      weight_data
);

    // Track where to place the next weight using an address counter
    logic [$clog2(TOTAL_WORDS)-1:0] addr_counter;
    logic                           is_loading;

    // Ready signal logic
    assign o_cfg_ready = is_loading && (addr_counter < TOTAL_WORDS);

    // Drive configuration signals down to the memory array block
    assign weight_load_en = i_cfg_valid && o_cfg_ready;
    assign weight_addr    = addr_counter;
    assign weight_data    = i_cfg_data;

    // Sequentially monitor state shifts and addresses
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addr_counter <= '0;
            is_loading   <= 1'b1;
        end else begin
            if (weight_load_en) begin
                if (addr_counter == TOTAL_WORDS - 1) begin
                    is_loading   <= 1'b0; // Memory warehouse is packed full! Turn off loader
                    addr_counter <= '0;
                end else begin
                    addr_counter <= addr_counter + 1'b1;
                end
            end
        end
    end

endmodule
