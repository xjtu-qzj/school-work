`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/26 13:05:37
// Design Name: 
// Module Name: sim_RAM_4Kx32_inout
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


module sim_RAM_4Kx32_inout();
    parameter Addr_Width = 12,Data_Width = 32;
    reg [Data_Width-1:0] Data;
    reg [Addr_Width-1:0] Addr;
    reg Rst, R_W, CS, CLK;
    
    initial begin
    CLK = 0;Rst = 0;CS = 1;R_W = 0;
        fork
            #10 CLK = ~CLK;
        join
    end
    
endmodule
