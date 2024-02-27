`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:36:29
// Design Name: 
// Module Name: sim_addr_4bit
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


module sim_addr_4bit();
    reg[3:0] A, B;
    reg C_1;
    wire [3:0]S;
    wire C3;
    
    initial begin
    A = 4'b0010;B = 4'b0100;C_1 = 1;
    end
    addr_4bit addr_4bit0(S, C3, A, B, C_1);
endmodule
