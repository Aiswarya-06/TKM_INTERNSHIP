module RCA(input [3:0]A,input [3:0]B,input cin,output cout,output [3:0]s);
wire w0,w1,w2;
fulladd FA1(A[0],B[0],cin,s[0],w0);
fulladd FA2(A[1],B[1],w0,s[1],w1);
fulladd FA3(A[2],B[2],w1,s[2],w2);
fulladd FA4(A[3],B[3],w2,s[3],cout);
endmodule
