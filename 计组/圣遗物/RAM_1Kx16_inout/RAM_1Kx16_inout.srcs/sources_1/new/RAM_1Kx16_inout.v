`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/26 10:26:31
// Design Name: 
// Module Name: RAM_1Kx16_inout
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


module RAM_1Kx16_inout(Data, Addr, Rst, R_W, CS, CLK);
    parameter Addr_Width = 10;
    parameter Data_Width = 16;
    parameter SIZE = 2 ** Addr_Width;
    inout [Data_Width-1:0] Data;
    inout [Addr_Width-1:0] Addr;
    input Rst, R_W, CS, CLK;
    integer i;
    reg [Data_Width-1:0] Data_i;
    reg [Data_Width-1:0] RAM [SIZE-1:0];
    
    assign Data = (R_W) ? Data_i : 16'bz;
    always@(*)begin
        casex({CS, Rst, R_W})
            3'bx1x: for(i = 0;i <= SIZE-1;i = i+1) RAM[i] = 0;
            3'b101: Data_i <= RAM[Addr];//¶Á
            3'b100: RAM[Addr] <= Data;//Ð´
            default: Data_i = 16'bz;
        endcase
    end
endmodule
