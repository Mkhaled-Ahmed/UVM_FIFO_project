package FIFO_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
        
    import FIFO_env_pkg::*;
    import FIFO_config_pkg::*;
    import FIFO_read_only_sequence_pkg::*;
    import FIFO_write_only_sequence_pkg::*;
    import FIFO_write_read_sequence_pkg::*;
    import FIFO_reset_sequence_pkg::*;

    
    
    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)

        FIFO_env env;
        FIFO_config fifo_cgf;
        FIFO_reset_sequence reset_seq;
        FIFO_write_only_sequence write_seq;
        FIFO_read_only_sequence read_seq;
        FIFO_write_read_sequence write_read_seq;


        function new(string name = "FIFO_test",uvm_component parent =null);
            super.new(name,parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=FIFO_env::type_id::create("env",this);
            fifo_cgf=FIFO_config::type_id::create("fifo_cgf",this);
            reset_seq=FIFO_reset_sequence::type_id::create("reset_seq",this);
            write_seq=FIFO_write_only_sequence::type_id::create("write_seq",this);
            read_seq=FIFO_read_only_sequence::type_id::create("read_seq",this);
            write_read_seq=FIFO_write_read_sequence::type_id::create("write_read_seq",this);
        
            if(!uvm_config_db#(virtual FIFO_if)::get(this, "", "INTF", fifo_cgf.fifo_vif))
            `uvm_fatal("build_phase", "error");
            
            uvm_config_db#(FIFO_config)::set(this, "*", "CFG", fifo_cgf);

        endfunction: build_phase
        
        task run_phase(uvm_phase phase);

            super.run_phase(phase);
            
            phase.raise_objection(this);
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "reset asserted", UVM_LOW)

            `uvm_info("run_phase", "stimulus Genration Started", UVM_LOW)
            write_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus Genration ended", UVM_LOW)

            `uvm_info("run_phase", "stimulus Genration Started", UVM_LOW)
            read_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus Genration ended", UVM_LOW)

            `uvm_info("run_phase", "stimulus Genration Started", UVM_LOW)
            write_read_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus Genration ended", UVM_LOW)

            phase.drop_objection(this);


        endtask: run_phase
        

    endclass
endpackage
