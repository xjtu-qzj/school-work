`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:03:58
// Design Name: 
// Module Name: addr_32bit
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


module addr_32bit(S, C1, A, B, C_1);
    input [31:0]A, B;
    input C_1;
    output [31:0]S;
    output C1;
    wire C0;
    
    addr_16bit  addr_16bit0(S[15:0], C0, A[15:0], B[15:0], C_1),
                addr_16bit1(S[31:16], C1, A[31:16], B[31:16], C0);
endmodule
