module block_gen_tb();
reg clk_tb,rst_tb,we_tb,ce_tb;
reg [2:0] address_tb;
reg [7:0] din_tb;
wire [7:0] dout_tb;
block_gen88 dut(clk_tb,rst_tb,we_tb,ce_tb,address_tb,din_tb,dout_tb);
initial begin
{clk_tb,rst_tb,we_tb,ce_tb,address_tb,din_tb}=0;
end
always #5 clk_tb=~clk_tb;
initial begin
rst_tb=1;
#10;
rst_tb=0;
ce_tb=1;
#10;
address_tb=0;din_tb=165;we_tb=1;#10;
address_tb=4;din_tb=91;we_tb=1;#10;
address_tb=7;din_tb=255;we_tb=1;#10;
we_tb=0;
address_tb=0;#10;
address_tb=4;#10;
address_tb=7;#10;
ce_tb=0;
address_tb=0;#10;
end
endmodule
