`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 09:06:41
// Design Name: 
// Module Name: encoder83_assign
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


module encoder83_assign(I, Y);
    input I;
    output Y;
    wire [7:0] I;
    reg[3:1] Y;
    
    always @(I) begin
        assign Y = {I[4]|I[5]|I[6]|I[7],I[2]|I[3]|I[6]|I[7],I[1]|I[3]|I[5]|I[7]};
    end
endmodule
