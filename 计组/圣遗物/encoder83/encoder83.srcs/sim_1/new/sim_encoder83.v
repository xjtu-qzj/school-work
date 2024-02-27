`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 09:26:23
// Design Name: 
// Module Name: sim_encoder83
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


module sim_encoder83();
    reg[7:0] x;
    wire[2:0] y_assign, y_case, y_pre_case, y_pre_if;
    integer i;
    
    initial begin 
        x = 1;
        for(i = 0; i < 7; i = i + 1)  #10 x = x * 2;
        #10 x = 128;
        while(x > 0) #5 x = x - 1;
    end
    
    encoder83_assign encoder83_assign_1(x, y_assign);
    encoder83_case encoder83_case_1(x, y_case);
    pre_encoder83_case pre_encoder83_case_1(.I(x), .Y(y_pre_case));
    pre_encoder83_if pre_encoder83_if_1(.I(x), .Y(y_pre_if));
endmodule
