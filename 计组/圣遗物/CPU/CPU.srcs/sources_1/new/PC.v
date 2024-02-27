`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 11:14:13
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK, Rst, 
    input [31:0] add_PC,
    output reg [31:0] Address);  

    always @(posedge CLK, posedge Rst)  
    begin  
        if (Rst)
            Address <= 32'b0;  
        else
            Address <= add_PC;  // 跳转到下一指令
    end  
endmodule
