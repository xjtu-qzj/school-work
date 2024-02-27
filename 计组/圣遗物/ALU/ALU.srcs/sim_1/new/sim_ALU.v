`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/20 22:29:47
// Design Name: 
// Module Name: sim_ALU
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


module sim_ALU();
    parameter SIZE = 32;
    reg [3:0] OP;
    reg [SIZE:1] A;
    reg [SIZE:1] B;
    wire [SIZE:1] F;
    wire ZF, CF, OF, SF, PF;
    
    initial begin
    A = 32;B = 16;OP = 4'b0000;
    fork
        forever 
        if(OP <= 4'b0111) #10 OP = OP + 1;
        else OP = 4'b0000;
    join
    end
    
    ALU ALU1(OP, A, B, F, ZF, CF, OF, SF, PF);
endmodule
