`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 10:39:16
// Design Name: 
// Module Name: SUB
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


module SUB(F, CF, A, B, EN);
    parameter N = 32;
    input EN;
    input [N-1:0] A, B;
    output reg [N-1:0] F;
    output reg CF;
    
    always @(A, B, EN) begin
        if(EN == 0) begin {CF, F} <= A - B; end
        else begin F <= 32'bz; CF = 0; end
    end
endmodule
