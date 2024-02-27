`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/05 08:56:25
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


module sim_sr;
    reg S, R, C;
    wire Q, nQ;
    initial begin
        {S, R, C} = 3'b011;
        #10 {S, R, C} = 3'b101;
        #10 {S, R, C} = 3'b010;
        #10 {S, R, C} = 3'b111;
        #10 {S, R, C} = 3'b001;
        #10 {S, R, C} = 3'b010;
        #10 {S, R, C} = 3'b100;
        #10 {S, R, C} = 3'b110;
    end
    sr srt(C, Q, R, S, nQ);
endmodule
