module RCA_tb;
reg [3:0]A_tb,B_tb;
reg cin_tb;
wire [3:0]s_tb;
wire cout_tb;
RCA dut(A_tb,B_tb,cin_tb,cout_tb,s_tb);
initial begin
A_tb=4'b0000;B_tb=4'b0000;cin_tb=0;
#10;
A_tb=4'b0001;B_tb=4'b0010;cin_tb=0;
#10;
A_tb=4'b0101;B_tb=4'b0011;cin_tb=0;
#10;
A_tb=4'b1111;B_tb=4'b0001;cin_tb=0;
#10;
A_tb=4'b1010;B_tb=4'b0101;cin_tb=1;
#10;
end
endmodule
