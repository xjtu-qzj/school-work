`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/30 15:45:15
// Design Name: 
// Module Name: RAM_256x32bit
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


module RAM_256x32bit(Data, Addr, Rst, R_W, CS, CLK);
    parameter Addr_Width = 8;
    parameter Data_Width = 32;
    parameter SIZE = 2 ** Addr_Width;
    inout [Data_Width-1:0] Data;
    input [Addr_Width-1:0] Addr;
    input Rst, R_W, CS, CLK;
    integer i;
    reg [Data_Width-1:0] Data_i;
    reg [Data_Width-1:0] RAM [SIZE-1:0];
    
    assign Data = (R_W) ? Data_i : 32'bz;
    always@(*)begin
        casex({CS, Rst, R_W})
            4'bx1x: for(i = 0;i <= SIZE-1;i = i+1) RAM[i] = 0; 
            4'b101: Data_i <= RAM[Addr];//¶Á
            4'b100: RAM[Addr] <= Data;//Ð´
            default: Data_i = 32'bz;
        endcase
    end
endmodule