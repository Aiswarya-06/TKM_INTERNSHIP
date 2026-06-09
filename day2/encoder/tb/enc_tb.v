module Enc4_2_tb();
reg [3:0]i_tb;
wire [1:0]b_tb;
mux2_1_if dut(i_tb,b_tb);//instantiate
initial
begin
{i_tb,b_tb}=0;
end
initial
begin
#1;
i=0001;
#1;
i=0010;
#1;
i=0100;
#1;
i=1000;
end
$monitor("the value of b_tb is %b",b_tb);
end
endmodule
