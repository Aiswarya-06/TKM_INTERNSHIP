module d_ff_tb();
reg d_tb;
reg clk_tb;
wire q_tb;
integer m;
d_flip dut(d_tb,clk_tb,q_tb);//instantiate
initial
begin
{d_tb,clk_tb}=0;
end
always #5 clk_tb=~clk_tb;
initial
begin
for(m=0;m<4;m=m+1)begin
{d_tb}=m;
#10;
end
$monitor("the value of q_tb is %b",q_tb);
end
endmodule
