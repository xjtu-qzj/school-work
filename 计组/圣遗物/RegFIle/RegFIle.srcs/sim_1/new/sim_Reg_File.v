`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 00:00:53
// Design Name: 
// Module Name: sim_Reg_File
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


`define DATA_WIDTH 32
module sim_Reg_File();
    parameter ADDR_SIZE = 4;
    reg CLK, WE3;
    reg[ADDR_SIZE-1:0] RA1, RA2, WA3;
    reg [`DATA_WIDTH-1:0] WD3;
    wire [`DATA_WIDTH-1:0] RD1, RD2;
    
    initial begin
        RA1 = 4'b0001; RA2 = 4'b0010;WA3 = 4'b0001;
        WD3 = 32'h24b8ac03;
        CLK = 0;WE3 = 1;
    fork
        forever #10 CLK = ~CLK;
        forever #50 WE3 = ~WE3;
        #50 WD3 = WD3 << 4;#50 WA3 = WA3 << 1;
    join
    end
    
    Reg_File Reg_File_1(CLK, WE3, RA1, RA2, WA3, WD3, RD1, RD2);
endmodule
