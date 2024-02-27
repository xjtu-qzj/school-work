`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:41:14
// Design Name: 
// Module Name: sim_addr_16bit
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


module sim_addr_16bit();
    reg[15:0] A, B;
    reg C_1;
    wire [15:0]S;
    wire C3;
    
    initial begin
    A = 16'h1111;B = 16'h1111;C_1 = 1;
    end
    addr_16bit addr_16bit0(S, C3, A, B, C_1);
endmodule
