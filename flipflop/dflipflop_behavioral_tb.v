// Testbench for dflipflop.sv

// `include "dflipflop_behavioral.sv"

module dflipflop_testbench;
	
	reg clk;
	reg reset;
	reg d;
	wire q;
	wire qbar;

  	flipflop_d dff(clk, reset, d, q, qbar);

  	initial begin
		reset = 0;
		clk = 0;
		d = 0;
		display;

		d = 1;
		display; 

		clk = 1;
		display;
		
		d = 0;
		clk = 0;
		display;

		clk = 1;
		display;

		$finish;
	end

	task display;
		#10 $display("clk=%b, d=%b, q=%b, qbar=%b", clk, d, q, qbar);
	endtask

	initial begin
		$dumpfile("dflipflopbehavioral_wave.vcd");
		$dumpvars(0, dflipflop_testbench);
	end

endmodule
