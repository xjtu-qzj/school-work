vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../sr.srcs/sources_1/bd/sr/ipshared/a5d3/sources_1/new/nand21.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_0_0/sim/sr_nand21_0_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_1_0/sim/sr_nand21_1_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_2_0/sim/sr_nand21_2_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/ip/sr_nand21_3_0/sim/sr_nand21_3_0.v" \
"../../../../sr.srcs/sources_1/bd/sr/sim/sr.v" \


vlog -work xil_defaultlib \
"glbl.v"

