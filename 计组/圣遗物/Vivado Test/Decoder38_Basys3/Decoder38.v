`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/06 17:19:15
// Design Name: 
// Module Name: gates2
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


module Decoder38(
    input a,
    input b,
    input c,
    output reg [7:0] y,    
    output reg [10:0] display_out);
    
    always@(*) begin
        case({a,b,c})
            3'b000 : begin y = 8'b0000_0001; display_out <= 11'b1011_0000001;end
            3'b001 : begin y = 8'b0000_0010; display_out <= 11'b1011_1001111;end
            3'b010 : begin y = 8'b0000_0100; display_out <= 11'b1011_0010010;end
            3'b011 : begin y = 8'b0000_1000; display_out <= 11'b1011_0000110;end
            3'b100 : begin y = 8'b0001_0000; display_out <= 11'b1011_1001100;end
            3'b101 : begin y = 8'b0010_0000; display_out <= 11'b1011_0100100;end
            3'b110 : begin y = 8'b0100_0000; display_out <= 11'b1011_0100000;end
            3'b111 : begin y = 8'b1000_0000; display_out <= 11'b1011_0001111;end
            default : begin y = 'b1111_1111; display_out <= 11'b1111_1111111;end
        endcase
    end
    
endmodule