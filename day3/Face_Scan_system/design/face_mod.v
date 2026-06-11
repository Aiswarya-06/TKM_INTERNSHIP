module face_Mod(input clk,input [7:0]s_in ,output reg [7:0]s_out);
always @(posedge clk)
s_out<=s_in;
endmodule
