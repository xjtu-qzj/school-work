onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib sr_opt

do {wave.do}

view wave
view structure
view signals

do {sr.udo}

run -all

quit -force
