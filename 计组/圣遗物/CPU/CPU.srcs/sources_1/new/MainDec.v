`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:45:39
// Design Name: 
// Module Name: MainDec
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


module MainDec(
    input [5:0] Op,
    output MemToReg, MemWrite,
    output Branch, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [2:0] ALUOp);
    
    reg [8:0] Controls;
    
    assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = Controls;
    always@(*)
        case(Op)
            6'b000000: Controls <= 9'b1100000100;//register-type 
            6'b001000: Controls <= 9'b1010000000;//addi
            6'b001001: Controls <= 9'b1010000000;//addiu
            6'b001100: Controls <= 9'b1010000001;//andi
            6'b001101: Controls <= 9'b1010000111;//ori
            6'b100000: Controls <= 9'b1010010000;//lb
            6'b100001: Controls <= 9'b1010010000;//lbu
            6'b100001: Controls <= 9'b1010010000;//lh
            6'b100101: Controls <= 9'b1010010000;//lhu
            6'b100011: Controls <= 9'b1010010000;//lw
            6'b101011: Controls <= 9'b0010100000;//sw
            6'b000100: Controls <= 9'b0001000010;//beq
            6'b000101: Controls <= 9'b0001000010;//bne
            6'b001110: Controls <= 9'b1010000110;//xori
            6'b001111: Controls <= 9'b1010000011;//liu
            6'b001010: Controls <= 9'b1010000011;//slti
            6'b001011: Controls <= 9'b1010000011;//sltiu
            6'b000010: Controls <= 9'b0000001000;//j
            6'b000011: Controls <= 9'b0000001000;//jal
            6'b101000: Controls <= 9'b0110101000;//sb
            6'b101001: Controls <= 9'b0110101000;//sh
            default:   Controls <= 9'bxxxxxxxxx;//illegal Op
        endcase 
endmodule
