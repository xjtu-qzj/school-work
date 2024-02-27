`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 19:13:36
// Design Name: 
// Module Name: sim_shift_register
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


module sim_shift_register();
    parameter N = 4;
    reg S1, S0, Dsl, Dsr, CLK, CR;
    reg[N-1:0] D;
    wire[N-1:0] Q;
    
    initial begin
        S0 = 1;S1 = 1;CR = 0;CLK = 0;Dsl = 0;Dsr = 1;D = 4'b0101;
        fork    
            forever #7 CLK = ~CLK;
            begin #10 CR = 1;#20 CR = 0; end
            forever #60 S0 = ~S0; 
            forever #120 S1 = ~S1; 
        join
    end
    
    shift_register shift_register_1(S1, S0, D, Dsl, Dsr, Q, CLK, CR);
endmodule
