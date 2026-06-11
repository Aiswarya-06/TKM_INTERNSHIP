
module mod_out(input clk,input [7:0]d_in,output reg [7:0]d_out);
 reg [1:0]state;
 parameter idle = 2'b00,
              S1   = 2'b01,
              S2   = 2'b10;
              
reg [7:0]temp;
initial
begin
state = idle;
d_out = 8'b0;
end
    
always @(posedge clk)
begin
case(state)
idle:begin
temp <= d_in;
state <= S1;
end
S1:
begin
state <= S2;
end
S2:
begin 
d_out <= temp;
state <= idle;
end
endcase
end
endmodule
