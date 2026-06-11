
module face_detect_tb;

reg clk_tb;
reg rst_tb;
reg [7:0] s_in_tb;
wire [7:0] d_out_tb;

top dut(clk_tb,rst_tb,s_in_tb,d_out_tb);

initial
begin
clk_tb=0;
forever #5 clk_tb=~clk_tb;
end
initial
begin
rst_tb=1;
s_in_tb=8'h00;
#20;
rst_tb=0;

#10 s_in_tb=8'h12;
#10 s_in_tb=8'h34;
#10 s_in_tb=8'h56;
#10 s_in_tb=8'h78;

#50;
end

endmodule
