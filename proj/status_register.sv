`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 11:34:42
// Design Name: 
// Module Name: status_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module status_register (
    input  logic clk,
    input  logic rst_n,

    input  logic relu_done,
    input  logic pool_done,
    input  logic fc_done,

    output logic relu_en,
    output logic pool_en,
    output logic fc_en,

    output logic frame_done
);

typedef enum logic [3:0] {
    IDLE  = 4'd0,
    RELU1 = 4'd1,
    POOL1 = 4'd2,
    RELU2 = 4'd3,
    POOL2 = 4'd4,
    FC1   = 4'd5,
    FC2   = 4'd6,
    DONE  = 4'd7
} state_t;

state_t state, next_state;

///////////////////////////////////////////////////////
// STATE REGISTER
///////////////////////////////////////////////////////
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

///////////////////////////////////////////////////////
// NEXT STATE LOGIC
///////////////////////////////////////////////////////
always_comb begin
    next_state = state;

    case (state)
        IDLE  : next_state = RELU1;

        RELU1 : if (relu_done) next_state = POOL1;

        POOL1 : if (pool_done) next_state = RELU2;

        RELU2 : if (relu_done) next_state = POOL2;

        POOL2 : if (pool_done) next_state = FC1;

        FC1   : if (fc_done) next_state = FC2;

        FC2   : if (fc_done) next_state = DONE;

        DONE  : next_state = IDLE; // go back to IDLE after done
    endcase
end

///////////////////////////////////////////////////////
// OUTPUT LOGIC
///////////////////////////////////////////////////////
always_comb begin
    relu_en = 0;
    pool_en = 0;
    fc_en   = 0;

    case (state)
        RELU1, RELU2: relu_en = 1;
        POOL1, POOL2: pool_en = 1;
        FC1, FC2    : fc_en   = 1;
    endcase
end

///////////////////////////////////////////////////////
// FRAME DONE PULSE (1 CLOCK ONLY)
///////////////////////////////////////////////////////
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        frame_done <= 0;
    else if (state == FC2 && fc_done)
        frame_done <= 1;
    else
        frame_done <= 0;
end

endmodule
