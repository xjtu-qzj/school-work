`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 11:02:04
// Design Name: 
// Module Name: sim_ALU_8
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


module sim_ALU_8();
    parameter SIZE = 32;
    reg [3:0] OP;
    reg [SIZE:1] A;
    reg [SIZE:1] B;
    wire [SIZE:1] F;
    wire CF;
    
    initial begin
    A = 32;B = 16;OP = 4'b0000;
    fork
        forever 
        if(OP <= 4'b0111) #10 OP = OP + 1;
        else OP = 4'b0000;
    join
    end
    
    ALU_8 ALU_8_1(F, CF, A, B, OP);
endmodule
