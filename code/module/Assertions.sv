module Assertions(FIFO_if intf,
    input logic [3:0] count,
    input logic [2:0]wr_ptr,rd_ptr
    );
	localparam  FIFO_WIDTH = intf.FIFO_WIDTH;
	localparam FIFO_DEPTH = intf.FIFO_DEPTH;

    logic [FIFO_WIDTH-1:0] data_in;
	logic clk, rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;
// ! input
	assign data_in=intf.data_in;
	assign clk=intf.clk;
	assign rst_n=intf.rst_n;
	assign wr_en=intf.wr_en;
	assign rd_en=intf.rd_en;
	//___________________________
	// ! output
	assign data_out=intf.data_out;
	assign wr_ack=intf.wr_ack;
	assign overflow=intf.overflow;
	assign full=intf.full;
	assign empty=intf.empty;
	assign almostfull=intf.almostfull;
	assign almostempty=intf.almostempty;
	assign underflow=intf.underflow;




	
		rd_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&!wr_en&&count!=0) |=>($past(count)-1'b1==count));
		wr_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (!rd_en&&wr_en&&count!=FIFO_DEPTH) |=>($past(count)+1'b1==count));
		rd_wr_count_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&wr_en&&count!=0&&count!=FIFO_DEPTH) |=>($past(count)==count));
		
		rd_ptr_assert:assert property (@(posedge clk) disable iff(!rst_n) (rd_en&&count!=0) |=>($past(rd_ptr)+1'b1==rd_ptr));
		wr_ptr_assert:assert property (@(posedge clk) disable iff(!rst_n) (wr_en&&count!=FIFO_DEPTH) |=>($past(wr_ptr)+1'b1==wr_ptr));
	
		overflow_assert:assert property (@(posedge clk) disable iff(!rst_n) ((count==FIFO_DEPTH)&&wr_en) |=>(overflow));
		underflow_assert:assert property (@(posedge clk) disable iff(!rst_n) ((count==0)&&rd_en) |=>(underflow));
		wr_ack_assert:assert property (@(posedge clk) disable iff(!rst_n) ((count!=FIFO_DEPTH)&&wr_en) |=>(wr_ack));
	
		rd_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&!wr_en&&count!=0) |=>($past(count)-1'b1==count));
		wr_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (!rd_en&&wr_en&&count!=FIFO_DEPTH) |=>($past(count)+1'b1==count));
		rd_wr_count_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&wr_en&&count!=0&&count!=FIFO_DEPTH) |=>($past(count)==count));
		
		rd_ptr_cover:cover property (@(posedge clk) disable iff(!rst_n) (rd_en&&count!=0) |=>($past(rd_ptr)+1'b1==rd_ptr));
		wr_ptr_cover:cover property (@(posedge clk) disable iff(!rst_n) (wr_en&&count!=FIFO_DEPTH) |=>($past(wr_ptr)+1'b1==wr_ptr));
	
		overflow_cover:cover property (@(posedge clk) disable iff(!rst_n) ((count==FIFO_DEPTH)&&wr_en) |=>(overflow));
		underflow_cover:cover property (@(posedge clk) disable iff(!rst_n) ((count==0)&&rd_en) |=>(underflow));
		wr_ack_cover:cover property (@(posedge clk) disable iff(!rst_n) ((count!=FIFO_DEPTH)&&wr_en) |=>(wr_ack));
	
		always_comb begin  
			if(!rst_n)begin
			rst_count_assert:assert final (count==0);
			rst_rd_ptr_assert:assert final (rd_ptr==0);
			rst_wr_ptr_assert:assert final (wr_ptr==0);
			rst_full_assert:assert final (full==0);
			rst_empty_assert:assert final (empty==0);
			rst_almostfull_assert:assert final (almostfull==0);
			rst_almostempty_assert:assert final (almostempty==0);
			rst_data_out_assert:assert final (data_out==0);
			rst_overflow_assert:assert final (overflow==0);
			rst_underflow_assert:assert final (underflow==0);
			rst_wr_ack_assert:assert final (wr_ack==0);
			end
	else begin
			if(count==0)begin
				empty_assert:assert final(empty==1);
			end
	
			if (count==1) begin
				almostempty_assert:assert final(almostempty==1);
			end
	
			if (count==FIFO_DEPTH-1) begin
				almostfull_assert:assert final(almostfull==1);
			end
	
			if(count==FIFO_DEPTH)begin
				full_assert:assert final(full==1);
			end
		end
	end
endmodule