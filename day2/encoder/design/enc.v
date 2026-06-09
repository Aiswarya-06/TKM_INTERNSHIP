
module Enc4_2(input [3:0]i,output reg [1:0]b);
always@(*)
begin
if(i[0])
b=2'b00;
else if(i[1])
b=2'b01;
else if(i[2])
b=2'b10;
else if(i[3])
b=2'b11;
else
b=2'b00;
end
endmodule
