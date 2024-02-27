`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/04 16:06:17
// Design Name: 
// Module Name: sim_and21
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


module sim_and21;
    reg D0 , D1;
    wire Y;
    
    initial begin
        D0 = 0; D1 = 0;
        #10 D0 = 1; D1 = 0;
        #10 D0 = 0; D1 = 1;
        #10 D0 = 1; D1 = 1;
        #10 D0 = 0; D1 = 0;
    end
    
    and21 and21t(D0, D1, Y);
endmodule
