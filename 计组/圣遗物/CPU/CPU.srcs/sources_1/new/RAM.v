`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:39:18
// Design Name: 
// Module Name: RAM
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


module RAM(WriteData, ReadData, Addr, Rst, R_W, CS, CLK);
    parameter Addr_Width = 10;
    parameter Data_Width = 32;
    parameter SIZE = 2 ** Addr_Width;
    input [Data_Width-1:0] WriteData;
    output reg [Data_Width-1:0] ReadData;
    input [Addr_Width-1:0] Addr;
    input Rst, R_W, CS, CLK;
    integer i;
    reg [Data_Width-1:0] Data_i;
    reg [Data_Width-1:0] RAM [SIZE-1:0];
    
    initial
    begin
        $readmemh("D:/Desktop/experiment/CPU/CPU.srcs/sources_1/new/ram.txt",RAM);
    end

    //assign Data = (R_W) ? Data_i : 32'bz;
    always@(*)begin
        casex({CS, Rst, R_W})
            //3'bx1x: for(i = 0;i <= SIZE-1;i = i+1) RAM[i] = 0;
            3'b101: ReadData <= RAM[Addr];//¶Á
            3'b100: RAM[Addr] <= WriteData;//Ð´
            //default: Data_i = 32'bz;
        endcase
    end
endmodule
