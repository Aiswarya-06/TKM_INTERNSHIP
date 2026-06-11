module top(
    input clk,
    input rst,
    input [7:0] s_in,
    output [7:0] d_out
);

wire [7:0] face_out;
wire [7:0] fifo_out;

wire full,empty;

face_Mod f1(clk, s_in, face_out);
fifo ff1(clk, rst, 1'b1, 1'b1, face_out, fifo_out, full, empty);
mod_out m1(clk, fifo_out, d_out);

endmodule
