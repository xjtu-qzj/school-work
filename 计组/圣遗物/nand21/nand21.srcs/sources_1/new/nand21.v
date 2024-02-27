`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/04 16:44:07
// Design Name: 
// Module Name: nand21
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


module nand21(D0, D1, Y); //二输入与非门
    input D0;
    input D1;
    output Y;
    wire D0, D1, Y;
    
    assign Y = ~(D0 & D1);

endmodule
