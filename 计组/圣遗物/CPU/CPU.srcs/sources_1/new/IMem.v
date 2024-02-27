`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 10:49:11
// Design Name: 
// Module Name: IMem
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
module IMem(
    input [5:0] Addr,
    output [`DATA_WIDTH-1:0] RD);//ָ��
    
    parameter IMEM_SIZE = 64;  //һ�δ��ļ��пɶ�ȡ��ָ������������Addr^2���
    reg [`DATA_WIDTH-1:0] RAM [IMEM_SIZE-1:0];
    initial begin
        $readmemh("D:/Desktop/experiment/CPU/CPU.srcs/sources_1/new/mips2.txt",RAM);
    end
    assign RD = RAM[Addr];
endmodule
