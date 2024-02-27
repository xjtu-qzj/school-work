`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 17:23:21
// Design Name: 
// Module Name: sim_D_ff
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


module sim_D_ff();
    reg D, EN, RST, CLK;
    wire Q, QN;
    
    initial begin
        D = 1;EN = 0; RST = 0;CLK = 0;
        fork
            forever #20 D = ~D;
            forever #25 CLK = ~CLK;
            begin #10 RST = 1; #40 RST = 0;  end
            forever #55 EN = ~EN;
        join   
    end 
        
    D_ff D_ff_1(Q, QN, D, EN, RST, CLK);
endmodule
