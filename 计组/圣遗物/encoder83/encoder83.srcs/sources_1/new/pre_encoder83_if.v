`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 09:22:53
// Design Name: 
// Module Name: pre_encoder83_if
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


module pre_encoder83_if(I, Y);
    input I;
    output Y;
    wire [7:0] I;
    reg[3:1] Y;
    
    always @(*) begin
        if(I[7] == 1) Y = 3'b111;
        else if(I[6] == 1) Y = 3'b110;
        else if(I[5] == 1) Y = 3'b101;
        else if(I[4] == 1) Y = 3'b100;
        else if(I[3] == 1) Y = 3'b011;
        else if(I[2] == 1) Y = 3'b010;
        else if(I[1] == 1) Y = 3'b001;
        else if(I[0] == 1) Y = 3'b000;
        else Y = 3'b000;
    end
endmodule
