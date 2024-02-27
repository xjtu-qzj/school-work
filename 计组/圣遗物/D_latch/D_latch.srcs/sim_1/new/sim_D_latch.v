`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 10:38:48
// Design Name: 
// Module Name: sim_D_latch
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


module sim_D_latch();
    reg D, EN, RST;
    wire Q, QN;
    
    initial begin
        D = 1;EN = 0; RST = 0;
        fork
            forever #20 D = ~D;
            begin #10 RST = 1; #40 RST = 0;  end
            begin #55 EN = 1; #55 EN = 0;  end
        join   
    end 
        
    D_latch D_latch_1(Q, QN, D, EN, RST);
endmodule
