`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/19 09:23:13
// Design Name: 
// Module Name: sim_addr_32bit
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


module sim_addr_32bit();
    reg[31:0] A, B;
    reg C_1;
    wire [31:0]S;
    wire C1;
    
    initial begin
    A = 32'h67ca9a31;B = 32'h334a412a;C_1 = 1;
    end
    addr_32bit addr_32bit0(S, C1, A, B, C_1);
endmodule
