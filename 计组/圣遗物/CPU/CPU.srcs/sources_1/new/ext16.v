`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 11:13:09
// Design Name: 
// Module Name: ext16
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


module ext16
    #(parameter DEPTH=16)
    (input [DEPTH-1:0] a,
    output reg [31:0] b);

    always@(a) begin
        if(a[DEPTH-1]==1)
        begin
           b[31:0]=32'hffffffff;
           b[DEPTH-1:0]=a[DEPTH-1:0];
        end
        else
        begin
            b[31:0]=32'h00000000;
            b[DEPTH-1:0]=a[DEPTH-1:0];
        end
    end
endmodule