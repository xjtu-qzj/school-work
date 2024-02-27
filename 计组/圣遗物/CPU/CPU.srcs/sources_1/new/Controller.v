`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:46:52
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [5:0] Op, Funct,
    input Zero,
    output MemToReg, MemWrite,
    output PCSrc, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [3:0] ALUControl);

    wire [1:0] ALUOp;
    wire Branch;
    
    MainDec MainDec_1(Op, MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, ALUOp);
    ALUDec ALUDec_1(Funct, ALUOp, ALUControl);
    assign PCSrc = Branch & Zero;
endmodule
