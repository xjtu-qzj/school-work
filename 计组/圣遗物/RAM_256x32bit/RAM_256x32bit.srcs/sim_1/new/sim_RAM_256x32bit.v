`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/30 15:48:27
// Design Name: 
// Module Name: sim_RAM_256x32bit
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


module sim_RAM_256x32bit();
    parameter Addr_Width = 8;
    parameter Data_Width = 32;
    parameter SIZE = 2 ** Addr_Width;
    wire [Data_Width-1:0] Data;
    reg [Addr_Width-1:0] Addr;
    reg Rst, R_W, CS, CLK;
    integer i;
    
    initial begin
        Rst = 0; R_W = 0; CS = 1; CLK = 0;Addr = 8'h00;
    fork
        forever #10 CLK = ~CLK;
        #60 Rst = ~Rst; #120 Rst = ~Rst;
        #120 R_W = ~R_W; #200 R_W = ~R_W; #300 R_W = ~R_W;
        begin 
        #140 Addr = 8'h01; for(i = 0;i < 5;i = i+1) #10 Addr = Addr + 2;
        #10; for(i = 0;i < 5;i = i+1) #10 Addr = Addr - 2;
        end
    join
    end
    assign Data = (R_W) ? 32'bz : 32'hffffffff;
    RAM_256x32bit RAM_256x32bit_1(Data, Addr, Rst, R_W, CS, CLK);
endmodule
