package FIFO_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import FIFO_seq_item_pkg::*;

    class FIFO_scoreboard extends uvm_scoreboard;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);
        
        `uvm_component_utils(FIFO_scoreboard)
        uvm_analysis_export #(FIFO_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
        FIFO_seq_item seq_item_sb;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        

        logic [FIFO_WIDTH-1:0] fifo_mem [FIFO_DEPTH-1:0];

        logic [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
        logic [max_fifo_addr:0] count_ref;

        int error_count = 0;
        int correct_count = 0;
    
        function new(string name = "FIFO_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction
    
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
    
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                if(seq_item_sb.data_out !== data_out_ref ) begin
                    `uvm_error("uvm_test_top", $sformatf("Comparison failed! Transaction received by the DUT differs from the reference output: %0s \n while the ref_out: out_exp =%0d", seq_item_sb.convert2string(),data_out_ref));
                    error_count++;
                end 
                else begin
                    `uvm_info("uvm_test_top", $sformatf("Correct FIFO output: %s ", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
        endtask

        task ref_model(FIFO_seq_item seq_item_chk);
            if (!seq_item_chk.rst_n) begin
                rd_ptr_ref = 0;
                wr_ptr_ref = 0;
                data_out_ref=0;
                count_ref = 0;
                // overflow_ref=0;
                // underflow_ref=0;
                // wr_ack_ref=0;
            end
            else begin
                if (seq_item_chk.rd_en && count_ref!=0) begin
                    data_out_ref=fifo_mem[rd_ptr_ref];
                    rd_ptr_ref++;
                end
                if (seq_item_chk.wr_en&& count_ref !=FIFO_DEPTH) begin
                    fifo_mem[wr_ptr_ref]=seq_item_chk.data_in;
                    wr_ptr_ref++;
                end
                if(seq_item_chk.wr_en && !seq_item_chk.rd_en &&count_ref !=FIFO_DEPTH) count_ref++;
                if(!seq_item_chk.wr_en && seq_item_chk.rd_en &&count_ref !=0) count_ref--;
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed transactions: %d", error_count), UVM_MEDIUM);
        endfunction
        
        endclass
    
endpackage