package FIFO_write_read_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import FIFO_seq_item_pkg::*;
    class FIFO_write_read_sequence extends uvm_sequence#(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_read_sequence);
        FIFO_seq_item write_read_item;
    
        function new (string name = "FIFO_write_read_sequence");
            super.new(name);
        endfunction
    
        task body;
            for(int i = 0 ;i<50;i++) begin
                write_read_item = FIFO_seq_item::type_id::create("write_read_item");
                start_item(write_read_item);
                assert(write_read_item.randomize());
                finish_item(write_read_item);
                //@(posedge seq_item.clk);
            end
        endtask
    endclass
    
endpackage