
class fifo_transaction;
rand bit [7:0] data_in;
rand bit wrenb, rdenb, rst;
bit [7:0] data_out;
bit full, empty = 1;
constraint valid_ctrl { !(wrenb && rdenb); }
constraint valid_rst  { if(rst) { wrenb == 0; rdenb == 0; } }
function void display();
$display("din:%h wr:%b rd:%b rst:%b dout:%h f:%b e:%b", data_in, wrenb, rdenb, rst, data_out, full, empty);
endfunction
endclass

module tb_transaction;
fifo_transaction t;
initial begin
t = new(); t.wrenb = 1; t.rdenb = 0; t.data_in = 8'hAB; t.display();
t = new(); t.wrenb = 0; t.rdenb = 1; t.data_out = 8'hAB; t.display();
t = new(); t.rst = 1; t.wrenb = 0; t.rdenb = 0; t.display();
t = new(); void'(t.randomize()); t.display();
$finish();
end
endmodule
