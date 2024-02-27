//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Nov  5 09:02:38 2022
//Host        : LAPTOP-R8R2JFH3 running 64-bit major release  (build 9200)
//Command     : generate_target sr_wrapper.bd
//Design      : sr_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module sr_wrapper
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

  wire C;
  wire Q;
  wire R;
  wire S;
  wire nQ;

  sr sr_i
       (.C(C),
        .Q(Q),
        .R(R),
        .S(S),
        .nQ(nQ));
endmodule
