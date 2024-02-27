`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/26 10:41:18
// Design Name: 
// Module Name: RAM_4Kx32_inout
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


module RAM_4Kx32_inout
    #(parameter Addr_Width = 12,
                 Data_Width = 32)
    (inout [Data_Width-1:0] Data,
    input [Addr_Width-1:0] Addr,
    input Rst,
    input R_W,
    input CS,
    input CLK);
    wire [3:0] CS_i;
    
    Decoder24 DEcoder24_1(CS_i, Addr[Addr_Width-1:Addr_Width-2]);
    RAM_1Kx16_inout CS0_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[0], CLK),
                    CS0_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[0], CLK);
    RAM_1Kx16_inout CS1_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[1], CLK),
                    CS1_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[1], CLK);
    RAM_1Kx16_inout CS2_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[2], CLK),
                    CS2_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[2], CLK);                                       
    RAM_1Kx16_inout CS3_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[3], CLK),
                    CS3_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[3], CLK);  
endmodule
