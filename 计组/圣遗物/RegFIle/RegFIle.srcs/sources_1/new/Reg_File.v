`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 11:25:02
// Design Name: 
// Module Name: Reg_File
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
module Reg_File
    #(parameter ADDR_SIZE = 5)
    (input CLK, WE3, 
    input [ADDR_SIZE-1:0] RA1, RA2, WA3,
    input [`DATA_WIDTH-1:0] WD3,
    output [`DATA_WIDTH-1:0] RD1, RD2);
    
    reg [`DATA_WIDTH-1:0] rf [2 ** ADDR_SIZE-1:0];
    always@(posedge CLK)
        if(WE3) rf[WA3] <= WD3; 
    assign RD1 = (RA1 != 0) ? rf[RA1] : 0; 
    assign RD2 = (RA2 != 0) ? rf[RA2] : 0; 
endmodule
