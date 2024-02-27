`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:51:36
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


module ALU(OP, A, B, F, ZF, CF, OF, SF, PF);
    parameter SIZE = 32;
    input [3:0] OP;
    input [SIZE:1] A;
    input [SIZE:1] B;
    output reg [SIZE:1] F;
    output ZF, CF, OF, SF, PF;
    reg C, ZF, CF, OF, SF, PF;
    
    always @(*)
    begin
        C = 0;
        case(OP)
            4'b0000: begin F = A & B; end
            4'b0001: begin F = A | B; end
            4'b0010: begin F = A ^ B; end
            4'b0011: begin F = ~(A | B); end
            4'b0100: begin {C, F} = A + B; end
            4'b0101: begin {C, F} = A - B; end
            4'b0110: begin F = A < B; end
            4'b0111: begin F = B << A; end
        endcase
        ZF = F === 0;
        CF = C;
        OF = A[SIZE]^B[SIZE]^F[SIZE]^C;
        SF = F[SIZE];
        PF = ~^F;
    end
endmodule
