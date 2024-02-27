`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 16:10:28
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
    output [`DATA_WIDTH-1:0] RD);//指令
    
    parameter IMEM_SIZE = 64;  //一次从文件中可读取的指令总条数，与Addr^2相等
    reg [`DATA_WIDTH-1:0] RAM [63:0];
    initial begin
        $readmemh("D:/Desktop/experiment/IMem/IMem.srcs/sources_1/new/MIPS1.txt",RAM);
        RAM[0] = 32'd1;
    end
    assign RD = RAM[Addr];
endmodule
