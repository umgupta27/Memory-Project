vlib work
vlog memtb1.v
vsim tb
add wave -position insertpoint sim:/tb/dut/*
#do wave.do
run -all
