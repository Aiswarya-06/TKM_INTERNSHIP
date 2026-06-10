

module sequence_detect_1110(input clk,rst,din,output reg detected

    );
    parameter idle=2'b00;
    parameter s1=2'b01;
    parameter s2=2'b10;
    parameter s3=2'b11;
    reg [1:0]ps,ns;
    always @(posedge clk)
    begin
    if(rst)begin    
    ps<=idle;
    end
    else
    ps<=ns;
    end
    always @(*)begin
    detected=0;
    case(ps)
    idle:begin
    if(din==0)
    ns=idle;
    else
    ns=s1;
    end
    s1:begin
    if(din==0)
    ns=idle;
    else
    ns=s2;
    end    
    s2:begin
    if(din==0)
    ns=idle;
    else
    ns=s3;
    end
    s3:begin
    if(din==0)begin
    ns=idle;
    detected=1;
    end
    else
    ns=s1;
    end
    endcase
  end
endmodule
   
