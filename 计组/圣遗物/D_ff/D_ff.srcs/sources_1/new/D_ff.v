`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 16:52:54
// Design Name: 
// Module Name: D_ff
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


module D_ff(Q, QN, D, EN, RST, CLK);
    output reg Q, QN;
    input D, EN, RST, CLK;
    always @(posedge CLK) begin
        if(RST) begin
            Q <= 0;
            QN <= 1;
        end
        else if(EN) begin
            Q <= D;
            QN <= ~D;
        end
    end
endmodule
