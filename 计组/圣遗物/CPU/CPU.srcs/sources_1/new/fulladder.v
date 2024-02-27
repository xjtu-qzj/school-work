`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 08:54:40
// Design Name: 
// Module Name: fulladder
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


module fulladder(S, Co, A, B, Ci);
    input A, B, Ci;
    output S, Co;
    wire S1, D1, D2;
    halfadder HA1(S1, D1, A, B);
    halfadder HA2(.A(S1), .B(Ci), .S(S), .C(D2));
    or G1(Co, D2, D1);
endmodule
