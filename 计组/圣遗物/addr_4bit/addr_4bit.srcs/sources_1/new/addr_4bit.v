`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:09:33
// Design Name: 
// Module Name: addr_4bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module addr_4bit(S, C3, A, B, C_1);
    input [3:0]A, B;
    input C_1;
    output [3:0]S;
    output C3;
    wire C0, C1, C2;
    
    fulladder  FA0(S[0], C0, A[0], B[0], C_1),
               FA1(S[1], C1, A[1], B[1], C0),
               FA2(S[2], C2, A[2], B[2], C1),
               FA3(S[3], C3, A[3], B[3], C2);
endmodule
