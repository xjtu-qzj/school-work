//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Nov  5 09:02:38 2022
//Host        : LAPTOP-R8R2JFH3 running 64-bit major release  (build 9200)
//Command     : generate_target sr.bd
//Design      : sr
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "sr,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=sr,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "sr.hwdef" *) 
module sr
   (C,
    Q,
    R,
    S,
    nQ);
  input C;
  output Q;
  input R;
  input S;
  output nQ;

  wire C_1;
  wire R_1;
  wire S_1;
  wire nand21_0_Y;
  wire nand21_1_Y;
  wire nand21_2_Y;
  wire nand21_3_Y;

  assign C_1 = C;
  assign Q = nand21_1_Y;
  assign R_1 = R;
  assign S_1 = S;
  assign nQ = nand21_3_Y;
  sr_nand21_0_0 nand21_0
       (.D0(S_1),
        .D1(C_1),
        .Y(nand21_0_Y));
  sr_nand21_1_0 nand21_1
       (.D0(nand21_0_Y),
        .D1(nand21_3_Y),
        .Y(nand21_1_Y));
  sr_nand21_2_0 nand21_2
       (.D0(C_1),
        .D1(R_1),
        .Y(nand21_2_Y));
  sr_nand21_3_0 nand21_3
       (.D0(nand21_1_Y),
        .D1(nand21_2_Y),
        .Y(nand21_3_Y));
endmodule
