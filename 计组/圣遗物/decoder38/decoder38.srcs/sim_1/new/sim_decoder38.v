`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 10:07:45
// Design Name: 
// Module Name: sim_decoder38
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


module sim_decoder38();
    reg[2:0] x;
    wire[7:0] y;
        
    initial begin 
        for(x = 0; x <= 7; x = x + 1)  #10;
    end
    
    decoder38 decoder38_1(x, y);
endmodule
