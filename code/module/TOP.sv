import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;
module TOP;

    bit clk;
    always #5 clk=~clk;

    FIFO_if fifof(clk);

    FIFO dut(fifof);

    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "INTF", fifof);

        run_test("FIFO_test");
    end

endmodule