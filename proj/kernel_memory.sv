// -----------------------------------------------------------------------------
// Module      : kernel_memory
// Owner       : Member 3 (Multi-Channel Convolution Owner)
// Description : BRAM-synthesizable configuration storage array for kernels/biases.
// -----------------------------------------------------------------------------

module kernel_memory #(
    parameter WEIGHT_WIDTH     = 10,
    parameter KERNEL_DIMENSION = 3,
    parameter IN_DIMENSION     = 1,
    parameter OUT_DIMENSION    = 4,
    
    localparam KERNEL_WORDS    = OUT_DIMENSION * IN_DIMENSION * KERNEL_DIMENSION * KERNEL_DIMENSION,
    localparam BIAS_WORDS      = OUT_DIMENSION,
    localparam TOTAL_WORDS     = KERNEL_WORDS + BIAS_WORDS
) (
    input  logic                                                                              clk,
    input  logic                                                                              rst_n,
    
    // Interface links from runtime_weight_loader
    input  logic                                                                              weight_load_en,
    input  logic [$clog2(TOTAL_WORDS)-1:0]                                                    weight_addr,
    input  logic [WEIGHT_WIDTH-1:0]                                                           weight_data,
    
    // Output parameters mapped to computational structures
    output logic [OUT_DIMENSION-1:0][IN_DIMENSION-1:0][KERNEL_DIMENSION-1:0][KERNEL_DIMENSION-1:0][WEIGHT_WIDTH-1:0] o_kernel,
    output logic [OUT_DIMENSION-1:0][WEIGHT_WIDTH-1:0]                                        o_bias
);

    // Continuous flat memory grid
    logic [TOTAL_WORDS-1:0][WEIGHT_WIDTH-1:0] memory_array;

    // Extract structured parallel interfaces out of flat memory array
    assign {o_bias, o_kernel} = memory_array;

    // Memory write array loop
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            memory_array <= '0;
        end else if (weight_load_en) begin
            memory_array[weight_addr] <= weight_data;
        end
    end

endmodule
