`timescale 1ns / 1ps


`define DATA_WIDTH 32
`define instruction_width 32
`define RAM_Addr_Width 10
module CPU(
    input CLK,
    input Rst,
    input wire [`instruction_width-1:0] RD, //指令
    output [`DATA_WIDTH-1:0] PC_Addr,
    output wire [`DATA_WIDTH-1:0] RegWriteData,
    input wire [`DATA_WIDTH-1:0] RegReadData1, RegReadData2,
    output wire [`DATA_WIDTH-1:0] RAM_WriteData,
    input wire [`DATA_WIDTH-1:0] RAM_ReadData,
    output wire [`RAM_Addr_Width-1:0] RAM_Addr,
    output RAM_CS,
    output RAM_R_W,
    output wire [`DATA_WIDTH-1:0] ALUResult,
    output wire [3:0] ALUControl);

    wire PCSrc,Zero,MemToReg, MemWrite, ALUSrc, RegDst, RegWrite, Jump, C1;
    wire [`DATA_WIDTH-1:0] ext16_out;
    wire [4:0] RegWriteAddr;
    //wire [3:0] ALUControl;
    wire [`DATA_WIDTH-1:0] ALU_A, ALU_B;
    wire [`DATA_WIDTH-1:0] add_PC;
    wire [`DATA_WIDTH-1:0] pcbranch, pcnextbr, pcnext;
    
    mux pcbrmux(add_PC, ({ext16_out[29:0], 2'b00} + add_PC), PCSrc, pcnextbr);
    mux pcmux(pcnextbr, {add_PC[31:28], RD[25:0], 2'b00}, Jump, pcnext);
    PC PC_1(CLK, Rst, pcnext, PC_Addr);
    add_PC add_PC_1(PC_Addr, add_PC);
    IMem IMem_1(PC_Addr[7:2], RD);
    //Controller([5:0] Op, Funct,Zero,MemToReg, MemWrite,PCSrc, ALUSrc,RegDst, RegWrite,Jump,[3:0] ALUControl);
    Controller Controller_1(RD[`instruction_width-1:`instruction_width-6], RD[5:0], Zero,
    MemToReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite, Jump, ALUControl);
    //RegFile(CLK, Reg_WE, RegReadAddr1, RegReadAddr2, RegWriteAddr, RegWriteData, RegReadData1, RegReadData2);
    RegFile RegFile_1(CLK, RegWrite, RD[25:21], RD[20:16], RegWriteAddr, RegWriteData, RegReadData1, RegReadData2);
    mux5 wrmux(RD[20:16], RD[15:11], RegDst, RegWriteAddr);
    ext16 cpu_ext16(RD[15:0], ext16_out);
    ALU ALU_1(ALUControl, RegReadData1, ALU_B, ALUResult, Zero);
    mux srcbmux(RegReadData2, ext16_out, ALUSrc, ALU_B);
    //addr_32bit addr_32bit_1(pcbranch, C1, (ext16_out<<2), add_PC, 0);
    //RAM(WriteData, ReadData,  Addr,  Rst,  R_W,  CS,  CLK) R_W 1 read   
    RAM RAM_1(RAM_WriteData, RAM_ReadData, RAM_Addr, Rst, RAM_R_W, RAM_CS, CLK);
    assign RAM_WriteData = RegReadData2;
    assign RAM_Addr = ALUResult[11:2];
    assign RAM_R_W = ~MemWrite;
    assign RAM_CS = (RAM_Addr) ? 1 : 0;
    mux resmux(ALUResult, RAM_ReadData, MemToReg, RegWriteData);
endmodule
    
    
    
    
    /*initial begin
        if(RegWrite == 1 && RegDst == 1)//R型指令
            begin 
            RegReadAddr1 = RD[10:6];
            ALU_A = RegReadData1;
            RegReadAddr2 = RD[15:11];
            ALU_B = RegReadData2;end
        else if(Jump == 1)//J型指令
            begin
            
            end
        else//I型指令
            begin
            RegReadAddr1 = RD[10:6];
            ALU_A = RegReadData1;
            ALU_B = {16'h0000, RD[`DATA_WIDTH-1:15]};end
    end
    initial begin
        if(RegWrite == 1 && RegDst == 1)//R型指令
            begin 
            Reg_WE = 1;
            RegWriteAddr = RD[20:16];
            RegWriteData = ALUResult;
            Reg_WE = 0;end
        else if(Jump == 1)//J型指令
            begin
            
            end
        else//I型指令
            begin
            Reg_WE = 1;
            RegWriteAddr = RD[15:11];
            RegWriteData = ALUResult;
            Reg_WE = 0;end
    end*/
