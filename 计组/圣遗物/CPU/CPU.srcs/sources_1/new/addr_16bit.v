`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:16:54
// Design Name: 
// Module Name: addr_16bit
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


module addr_16bit(S, C3, A, B, C_1);
    input [15:0]A, B;
    input C_1;
    output [15:0]S;
    output C3;
    wire C0, C1, C2;
    
    addr_4bit  addr_4bit0(S[3:0], C0, A[3:0], B[3:0], C_1),
               addr_4bit1(S[7:4], C1, A[7:4], B[7:4], C0),
               addr_4bit2(S[11:8], C2, A[11:8], B[11:8], C1),
               addr_4bit3(S[15:12], C3, A[15:12], B[15:12], C2);
endmodule
