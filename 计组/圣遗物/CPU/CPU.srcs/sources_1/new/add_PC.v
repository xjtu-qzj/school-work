`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/02 15:40:00
// Design Name: 
// Module Name: add_PC
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


module add_PC(
    input [31:0] pc_in,
    output [31:0] pc_out);
    assign pc_out = pc_in + 32'd4;    //pc=pc+4
endmodule
