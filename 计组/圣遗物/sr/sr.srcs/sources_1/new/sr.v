`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 10:10:13
// Design Name: 
// Module Name: sr
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


module sr(S, R, Q, nQ);
    input S, R;
    output reg Q, nQ;
    
    always @(S, R) begin
        if({S, R} == 2'b01)      {Q, nQ} = 2'b01;
        else if({S, R} == 2'b10) {Q, nQ} = 2'b10;
        else if({S, R} == 2'b11) {Q, nQ} = 2'b00;
        else if({S, R} == 2'b00) ;
        else {Q, nQ} = 2'b00;
    end
endmodule
