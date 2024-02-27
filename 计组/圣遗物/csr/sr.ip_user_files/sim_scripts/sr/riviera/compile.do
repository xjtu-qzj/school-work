vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../sr.srcs/sources_1/bd/sr/ipshared/a5d3/sources_1/new/nand21.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_0_0/sim/sr_nand21_0_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_1_0/sim/sr_nand21_1_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_2_0/sim/sr_nand21_2_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_3_0/sim/sr_nand21_3_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/sim/sr.v" \


vlog -work xil_defaultlib \
"glbl.v"

