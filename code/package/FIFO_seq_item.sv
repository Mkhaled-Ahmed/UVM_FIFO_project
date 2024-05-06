package FIFO_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    int WR_EN_ON_DIST=70 ; 
    int RD_EN_ON_DIST=30 ; 

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item);
    
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n,  wr_en, rd_en;
        bit clk ;  
        bit [FIFO_WIDTH-1:0] data_out;
        bit wr_ack, overflow;
        bit full, empty, almostfull, almostempty, underflow; 
            
            constraint rst_con {
            rst_n dist {0:=2 , 1:=98 } ; 	
            }
        
            constraint wr_en_con {
            wr_en dist {1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST } ; 	
            }
    
            constraint rd_en_con {
            rd_en dist {1:=RD_EN_ON_DIST , 0:=100-RD_EN_ON_DIST } ; 	
            }   

        function new(string name = "FIFO_seq_item");
            super.new(name);
        endfunction: new
    
        function string convert2string();
            return $sformatf("%s rst_n=%0d, data_in=%0d, wr_en=%0d, rd_en=%0d, data_out=%0d, wr_ack=%0d, overflow=%0s, full =%0d, empty=%0d, almostfull=%0d,almostempty=%0d,underflow=%0d"
                ,super.convert2string(),rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, full ,empty, almostfull,almostempty,underflow
                );
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n=%0d, data_in=%0d, wr_en=%0d, rd_en=%0d, data_out=%0d, wr_ack=%0d, overflow=%0s, full =%0d,empty=%0d, almostfull=%0d,almostempty=%0d,underflow=%0d",
                rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, full ,empty, almostfull,almostempty,underflow
                );
        endfunction

        
    endclass
endpackage  
