// Testbench for dflipflop.sv

`include "dflipflop.sv"

module dflipflop_testbench;
	
	reg clk;
	reg reset;
	reg d;
	wire out;

  	DFF dff(clk, reset, d, out);

  	initial begin
		clk = 0;
		d = 0;
		display;

		#10 d = 1;
		display;

		clk = 1;
		display;

		d = 0;
		display;

		#10 d = 1;
		display;
	end

	task display;
		$display("clk=%b, d=%b, out=%b", clk, d, out);
	endtask

endmodule
