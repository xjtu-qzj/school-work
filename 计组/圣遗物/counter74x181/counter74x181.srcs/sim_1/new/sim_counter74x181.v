`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 20:26:13
// Design Name: 
// Module Name: sim_counter74x181
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


module sim_counter74x181();
    parameter N = 8;
    parameter M =16;
    reg CEP, CET, PE, CLK, CR;
    reg[N-1:0] D;
    wire TC;
    wire[N-1:0] Q;
    
    initial begin
        CEP = 0; CET = 0;PE = 1;CLK = 0;CR = 1;D = 8'b0000_1000;
        fork
            forever #10 CLK = ~CLK;
            #28 CEP = 1;#250 CEP = 0;
            #30 CET = 1;#235 CET = 0;
            #25 PE = 0;#35 PE = 1;
            #15 CR = 0;#25 CR = 1;
        join
    end
    
    counter74x181 counter74x181_1(CEP, CET, PE, CLK, CR, D, TC, Q);
endmodule
