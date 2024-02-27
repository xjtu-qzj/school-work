`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 10:45:01
// Design Name: 
// Module Name: SLT
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


module SLT(F, A, B, EN);
    parameter N = 32;
    input EN;
    input [N-1:0] A, B;
    output reg [N-1:0] F;
    
    always @(A, B, EN) begin
        if(EN == 0) F <= A < B;
        else F <= 32'bz;
    end
endmodule
