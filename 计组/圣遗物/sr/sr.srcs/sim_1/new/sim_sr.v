`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 10:22:14
// Design Name: 
// Module Name: sim_sr
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


module sim_sr();
    reg S, R;
    wire Q, nQ;
    
    initial begin
        {S, R} = 2'b01;
        #10 {S, R} = 2'b11;
        #10 {S, R} = 2'b10;
        #10 {S, R} = 2'b00;
    end
    
    sr sr_1(S, R, Q, nQ);
endmodule
