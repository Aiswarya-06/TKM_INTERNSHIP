module Enc4_2_tb();
reg [3:0]i_tb;
wire [1:0]b_tb;
Enc4_2 dut(i_tb,b_tb);//instantiate
initial
begin
{i_tb}=0;
end
initial
begin
#1;
i_tb=0001;
#1;
i_tb=0010;
#1;
i_tb=0100;
#1;
i_tb=1000;
$monitor("the value of b_tb is %b",b_tb);
end
endmodule
