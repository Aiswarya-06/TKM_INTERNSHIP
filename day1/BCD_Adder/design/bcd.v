
module bcd_add(input [3:0]A,input [3:0]B,inpcin,output cout,output [3:0]s

    );
    wire [9:0]w;
    assign w[8]=1'b0;
    assign w[9]=1'b0;
    and(w[5],w[3],w[2]);
    and(w[4],w[3],w[1]);
    or(w[7],w[6],w[5],w[4]);
    RCA rca1(A,B,cin,w[6],w[3:0]);
    RCA rca2(w[3:0],{w[9],w[7],w[7],w[8]},1'b0,cout,s );
    
endmodule

