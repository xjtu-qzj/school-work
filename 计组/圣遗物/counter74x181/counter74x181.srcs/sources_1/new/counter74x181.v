`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 20:11:56
// Design Name: 
// Module Name: counter74x181
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


module counter74x181(CEP, CET, PE, CLK, CR, D, TC, Q);
    parameter N = 8;
    parameter M = 18;
    input CEP, CET, PE, CLK, CR;
    input[N-1:0] D;
    output reg TC;
    output reg[N-1:0] Q;
    
    wire CE;
    assign CE = CEP & CET;
    always @(posedge CLK, negedge CR)
        if(~CR) begin Q <= 0;TC = 0;end
        else if(~PE) Q <= D;
        else if(CE) begin
            if(Q == M - 1) begin
                TC <= 1;
                Q <= 0;
            end
            else Q <= Q + 1;
        end
        else Q <= Q;
endmodule
