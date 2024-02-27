`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/26 11:46:46
// Design Name: 
// Module Name: decoder24
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


module decoder24(A, Y);
    input [1:0] Y;
    output [3:0] A;
    reg A;
    
    always @(Y) begin
        case(Y)
            2'b00: A <=4'b1110;
            2'b01: A <=4'b1101;
            2'b10: A <=4'b1011;
            2'b11: A <=4'b0111;
            default:  A <=4'bz;
        endcase 
    end
endmodule
