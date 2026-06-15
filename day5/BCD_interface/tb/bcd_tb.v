interface bcd_if;
logic [3:0] A;
logic [3:0] B;
logic cin;
logic [3:0] sum_bcd;
logic cout_bcd;
endinterface
module BCD (bcd_if io);
logic [3:0] S1;
logic cout1;
assign {cout1, S1} = io.A + io.B + io.cin; 
assign io.cout_bcd = cout1 | (S1[3] & S1[2]) | (S1[3] & S1[1]);
assign io.sum_bcd = io.cout_bcd ? (S1 + 4'b0110) : S1;
endmodule
module BCD_tb();
bcd_if bif();
BCD dut (.io(bif));
initial begin 
bif.A = 4'b0000;
bif.B = 4'b0000;
bif.cin = 1'b0;
end
initial begin
#1;
bif.A = 4'd3; bif.B = 4'd4; bif.cin = 1'b0;
#1;
bif.A = 4'd5; bif.B = 4'd6; bif.cin = 1'b0;
#1;
bif.A = 4'd8; bif.B = 4'd7; bif.cin = 1'b1;
#1;
bif.A = 4'd9; bif.B = 4'd9; bif.cin = 1'b1;
#1;
$finish();
end
initial begin 
$monitor("Time=%0dt: A=%d, B=%d, cin=%b -> S=%d, cout=%b", $time, bif.A, bif.B, bif.cin, bif.sum_bcd, bif.cout_bcd);
end
endmodule
