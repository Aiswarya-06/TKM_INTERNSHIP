module fulladd(input A,B,Cin,output sum,carry);
wire w1,w2,w3;
and(w1,A,B);
and(w2,B,Cin);
and(w3,A,Cin);
xor(sum,A,B,Cin);
or(carry,w1,w2,w3);
endmodule
