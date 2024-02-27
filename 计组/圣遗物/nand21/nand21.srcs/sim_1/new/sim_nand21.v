`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/04 16:45:59
// Design Name: 
// Module Name: sim_nand21
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


module sim_nand21;
   reg D0 , D1;
   wire Y;
   
   initial begin
       D0 = 0; D1 = 0;
       #10 D0 = 1; D1 = 0;
       #10 D0 = 0; D1 = 1;
       #10 D0 = 1; D1 = 1;
       #10 D0 = 0; D1 = 0;
   end
   
   nand21 nand21t(D0, D1, Y);
endmodule
