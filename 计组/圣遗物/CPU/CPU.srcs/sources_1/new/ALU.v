`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/26 19:33:54
// Design Name: 
// Module Name: ALU
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


module ALU(OP, A, B, F, zero);
    parameter SIZE = 32;
    input [3:0] OP;
    input [SIZE:1] A;
    input [SIZE:1] B;
    output reg [SIZE:1] F;
    output reg zero;
    
    always @(*)
    begin
        case(OP)
            4'b0000: begin F = A << B; end
            4'b0001: begin F = A >>> B; end
            4'b0010: begin F = A >> B; end
            4'b0011: begin F = A * B; end   
            4'b0100: begin F = A / B; end
            4'b0101: begin F = A + B; end
            4'b0110: begin F = A - B; end
            4'b0111: begin F = A & B; end
            4'b1000: begin F = A | B; end
            4'b1001: begin F = A^B; end //??
            4'b1010: begin F = ~(A | B); end
            4'b1011: begin 
            if(A[SIZE-1]==0 && B[SIZE-1]==1) F = 0;
            else if(A[SIZE-1]==1 && B[SIZE-1]==0) F = 1;
            else if(A[SIZE-1]==0 && B[SIZE-1]==0) F = A < B; 
            else  F = ~(A < B);   
            end
            4'b1100: begin F = A < B; end
        endcase
        zero = F ? 0 : 1;
    end
endmodule
