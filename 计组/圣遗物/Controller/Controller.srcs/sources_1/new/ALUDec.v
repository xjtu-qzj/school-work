`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 09:00:45
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
    input [5:0] ALUOp,
    output reg [2:0] ALUControl);
    
    always@(*)
        case(ALUOp)
            2'b00: ALUControl <= 3'b010;//add (for lw/sw/addi)
            2'b01: ALUControl <= 3'b110;//sub (for beq)
            default :case(Funct)        //R-type Instructions
                6'b000000: ALUControl <= 3'bxxx;//nop
                6'b100000: ALUControl <= 3'b010;//add
                6'b100010: ALUControl <= 3'b110;//sub
                6'b100100: ALUControl <= 3'b000;//and
                6'b100101: ALUControl <= 3'b001;//or
                6'b101010: ALUControl <= 3'b111;//slt
                default:   ALUControl <= 3'bxxx;//???
            endcase
        endcase  
endmodule
