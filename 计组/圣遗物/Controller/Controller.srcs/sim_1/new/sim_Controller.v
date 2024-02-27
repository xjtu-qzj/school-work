`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/12 14:18:20
// Design Name: 
// Module Name: sim_Controller
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


module sim_Controller();
    reg [5:0] Op, Funct;
    reg Zero;
    wire MemToReg, MemWrite;
    wire PCSrc, ALUSrc;
    wire RegDst, RegWrite;
    wire Jump;
    wire [2:0] ALUControl;
    
    initial begin
        Op = 6'b000000;Funct = 6'b000000;
        fork 
            begin
                Op = 6'b000000;//register-type
                Funct = 6'b000000;//nop
                #10 Funct = 6'b100000;//add
                #10 Funct = 6'b100010;//sub
                #10 Funct = 6'b100100;//and
                #10 Funct = 6'b100101;//or
                #10 Funct = 6'b101010;//slt
                Op = 6'b000000;//register-type
                #10 Op = 6'b100011;//LW
                #10 Op = 6'b101011;//SW
                #10 Op = 6'b000100;//BEQ
                #10 Op = 6'b001000;//ADDI
                #10 Op = 6'b001101;//ORI
                #10 Op = 6'b001111;//LUI
                #10 Op = 6'b000010;//J
            end
        join
    end
    Controller Controller_1(Op, Funct, Zero, MemToReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite, Jump, ALUControl);
endmodule
