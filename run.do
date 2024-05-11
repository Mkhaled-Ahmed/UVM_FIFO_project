vlib work
vlog -f UVM_FIFO_project/code/file_list.list -mfcu +cover
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all -cover
coverage save fiforpt.ucdb -onexit -du work.TOP
add wave -position insertpoint sim:/TOP/dut/*
run -all
coverage report -detail -cvg -directive -comments -output fcover_report.txt /FIFO_coverage_pkg/FIFO_coverage/cvr_grp
quit -sim
vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt