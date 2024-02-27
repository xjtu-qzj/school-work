`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:46:23
// Design Name: 
// Module Name: ALUDec
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


module ALUDec(
    input [5:0] Funct,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl);
    
    always@(*)
        case(ALUOp)
            3'b000: ALUControl <= 4'b0101;//add (for lw/sw/addi)
            3'b010: ALUControl <= 4'b0110;//sub (for beq)
            3'b011: ALUControl <= 4'b1011;//liu/slt/sltu
            3'b111: ALUControl <= 4'b1000;//ori
            3'b001: ALUControl <= 4'b0111;//andi
            3'b110: ALUControl <= 4'b1001;//xori
            default :case(Funct)        //R-type Instructions
                6'b100000: ALUControl <= 4'b0101;//add
                6'b100001: ALUControl <= 4'b0101;//addu
                6'b100010: ALUControl <= 4'b0110;//sub
                6'b100011: ALUControl <= 4'b0110;//subu
                6'b100100: ALUControl <= 4'b0111;//and
                6'b100101: ALUControl <= 4'b1000;//or
                6'b100110: ALUControl <= 4'b1001;//xor
                6'b100111: ALUControl <= 4'b1010;//nor
                6'b101010: ALUControl <= 4'b1011;//slt
                6'b101011: ALUControl <= 4'b1100;//sltu
                6'b000000: ALUControl <= 4'b0000;//sll
                6'b000010: ALUControl <= 4'b0010;//srl
                6'b000011: ALUControl <= 4'b0001;//sra
                6'b000100: ALUControl <= 4'b0000;//sllv
                6'b000110: ALUControl <= 4'b0010;//srlv
                6'b000111: ALUControl <= 4'b0001;//srav
                6'b011000: ALUControl <= 4'b0011;//mult
                6'b011001: ALUControl <= 4'b0011;//multu
                6'b011010: ALUControl <= 4'b0100;//div
                6'b011011: ALUControl <= 4'b0100;//divu
                6'b001000: ALUControl <= 4'b0101;//jr
                default:   ALUControl <= 4'bxxxx;//???
            endcase
        endcase  
endmodule
