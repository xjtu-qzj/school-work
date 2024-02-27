`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 15:46:29
// Design Name: 
// Module Name: sim_CPU
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


module sim_CPU();
    reg CLK;
    reg Rst;
    wire [31:0]PC;
    wire [31:0]RD;
    wire [`DATA_WIDTH-1:0] RegWriteData;
    wire [`DATA_WIDTH-1:0] RegReadData1, RegReadData2;
    wire [9:0] RAM_Addr;
    wire [31:0] RAM_WriteData;
    wire [31:0] RAM_ReadData;
    wire RAM_CS;
    wire RAM_R_W;
    wire [31:0] ALUResult;
    wire [3:0] ALUControl;

    initial 
    begin
        CLK = 0;#50
        forever #50 CLK = ~CLK;
        #2000 $stop(0);
    end
    initial
    begin
        Rst = 0;
        #50 Rst=1;
        #10 Rst=0;
    end
    CPU CPU_1(CLK, Rst, RD, PC, RegWriteData, RegReadData1, RegReadData2, RAM_WriteData, RAM_ReadData, RAM_Addr, RAM_CS, RAM_R_W, ALUResult, ALUControl);
endmodule
