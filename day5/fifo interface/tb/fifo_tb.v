`timescale 1ns / 1ps
interface fifo_if;
logic clk, rst_n, wr_en, rd_en;
logic [7:0] data_in, data_out;
logic full, empty;
endinterface
module fifo (fifo_if io);
logic [7:0] mem [0:7];
logic [2:0] wptr = 0;
logic [2:0] rptr = 0;
logic [3:0] count = 0;
assign io.full = (count == 8);
assign io.empty = (count == 0);
always_ff @(posedge io.clk or negedge io.rst_n) begin
if (!io.rst_n) begin
wptr <= 0; rptr <= 0; count <= 0; io.data_out <= 0;
end else begin
if (io.wr_en && !io.full) begin
mem[wptr] <= io.data_in;
wptr <= wptr + 1;
count <= count + 1;
end
if (io.rd_en && !io.empty) begin
io.data_out <= mem[rptr];
rptr <= rptr + 1;
count <= count - 1;
end
end
end
endmodule
module fifo_tb();
fifo_if fif();
fifo dut (.io(fif));
always #5 fif.clk = ~fif.clk;
initial begin
fif.clk = 0; fif.rst_n = 0; fif.wr_en = 0; fif.rd_en = 0; fif.data_in = 0;
#15; fif.rst_n = 1;
#10; fif.wr_en = 1; fif.data_in = 8'hAA;
#10; fif.data_in = 8'hBB;
#10; fif.data_in = 8'hCC;
#10; fif.wr_en = 0;
#10; fif.rd_en = 1;
#30; fif.rd_en = 0;
#20; $finish();
end
initial begin
$monitor("Time=%0t | wr=%b din=%h | rd=%b dout=%h | full=%b empty=%b", $time, fif.wr_en, fif.data_in, fif.rd_en, fif.data_out, fif.full, fif.empty);
end
endmodule
