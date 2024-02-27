`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:28:59
// Design Name: 
// Module Name: RegFile
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
module RegFile
    #(parameter ADDR_SIZE = 5)
    (input CLK, WE, 
    input [ADDR_SIZE-1:0] RA1, RA2, WA,
    input [`DATA_WIDTH-1:0] WD, 
    output [`DATA_WIDTH-1:0] RD1, RD2);
    
    integer i;
    reg [`DATA_WIDTH-1:0] rf [2 ** ADDR_SIZE-1:0];
    initial begin
        for(i = 0;i <= 2 ** ADDR_SIZE-1;i = i+1) rf[i] = 0;
        rf[28] = 32'h10008000;
        rf[29] = 32'h7fffeffc;
    end
    
    always@(posedge CLK)
        if(WE) rf[WA] <= WD; 
    assign RD1 = (RA1 != 0) ? rf[RA1] : 0;  
    assign RD2 = (RA2 != 0) ? rf[RA2] : 0;  
endmodule
