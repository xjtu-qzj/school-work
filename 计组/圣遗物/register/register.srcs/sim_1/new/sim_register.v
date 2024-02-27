`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 11:38:11
// Design Name: 
// Module Name: sim_register
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


module sim_register();
    reg CLK, OE;
    reg[7:0] D;
    wire[7:0] Q;
    
    initial begin 
        OE = 1;CLK = 0;D = 8'b1010_1110; 
        fork
            #20 OE = 0;
            forever #10 CLK = ~CLK;
        join
    end
    
    register register_1(Q, D, OE, CLK);
endmodule
