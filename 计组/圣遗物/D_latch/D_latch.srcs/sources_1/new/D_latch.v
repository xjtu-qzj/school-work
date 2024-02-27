`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 10:31:58
// Design Name: 
// Module Name: D_latch
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


module D_latch(Q, QN, D, EN, RST);
    output reg Q, QN;
    input D, EN, RST;
    
    always @(D, EN, RST) begin
        if(RST) begin
            Q = 0;
            QN = 1;
        end
        else if(EN) begin
            Q <= D;
            QN <= ~D;
        end
    end
endmodule
