vlib work
vlog -f UVM_FIFO_project/code/file_list.list -mfcu +define+SIM 
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all
#coverage save fiforpt.ucdb -onexit -du work.top
#add wave *
run -all
#quit -sim
#vcover report fiforpt.ucdb -details -annotate -all -output fiforpt.txt
