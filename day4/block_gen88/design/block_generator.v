

module block_gen88(
input clk,rst,we,ce,
input [2:0] address,
input [7:0] din,
output reg [7:0] dout);
reg [7:0] ram_block[7:0];
integer i;
always@(posedge clk)begin
if(rst)begin
dout<=0;
for(i=0;i<8;i=i+1)
ram_block[i]<=0;
end
else if(ce)begin
if(we)begin
ram_block[address]<=din;
end
else begin
dout<=ram_block[address];
end
end
end
endmodule
