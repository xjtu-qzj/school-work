`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 10:06:13
// Design Name: 
// Module Name: sim_Decoder
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

module sim_Decoder();
    reg a, b, c;
    wire[7:0] y;
    
    Decoder38 test(a,b,c,y);
    
    initial begin
        {a,b,c} = 3'b000; #20;
        {a,b,c} = 3'b001; #20;
        {a,b,c} = 3'b010; #20;
        {a,b,c} = 3'b011; #20;
        {a,b,c} = 3'b100; #20;
        {a,b,c} = 3'b101; #20;
        {a,b,c} = 3'b110; #20;
        {a,b,c} = 3'b111; #20;
    end
endmodule
