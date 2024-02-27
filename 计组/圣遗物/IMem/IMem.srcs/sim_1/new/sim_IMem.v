`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 16:11:30
// Design Name: 
// Module Name: sim_IMem
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


module sim_IMem();
    reg [5:0] Addr;
    wire [31:0] RD;
    
    initial begin
        Addr <= 5'b00000;
        #10 Addr <= 5'b00001;
        #10 Addr <= 5'd2;
        #10 Addr <= 5'd3;
        #10 Addr <= 5'd4;
        #10 Addr <= 5'd5;     
    end
    
    IMem IMem1(Addr, RD);
endmodule
