
module fifo(input clk,rst,wrenb,rdenb,
input [7:0]data_in,
output reg [7:0] data_out,
output reg full,empty
    );
    reg [7:0]mem[7:0];
    reg [2:0]wr_ptr=0;
    reg [2:0]rd_ptr=0;
    integer i;
    always @(posedge clk)
    begin
    if(rst)begin
    for(i=0;i<8;i=i+1)
    mem[i]<=0;
    end
    else if(wrenb==1 && full==0)begin
    mem[wr_ptr]<=data_in;
    wr_ptr<=wr_ptr+3'b001;
    end
    else if(rdenb==1 && empty==0)begin
    data_out=mem[rd_ptr];
    rd_ptr<=rd_ptr+3'b001;
    end
    assign full=((wr_ptr+1)==rd_ptr)?1'b1:1'b0;
    assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
    end
endmodule
