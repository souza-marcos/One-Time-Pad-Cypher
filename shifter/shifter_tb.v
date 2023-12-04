// TestBench for a shifter
`include "../constants.vh"
// `include "shifter.v"

module shifter_tb;

    // Inputs
    reg clk;
    reg load;
    reg [`MSG_SIZE -1: 0] initial_msg;

    // Outputs
    wire [`KEY_SIZE -1: 0] out;

    
    shifter shl_mod (
        .clk(clk), 
        .load(load), 
        .initial_msg(initial_msg), 
        .out(out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        load = 0;
        initial_msg = 32'hABCDEF01;

        // Add stimulus here
        load = 1;

        #10 load = 0;

        repeat (20) begin
            #10;
        end
        
        $finish;
    end

    always #10 clk = ~clk; // Toggle clock every 10 ns

    // Display the output
    always @(posedge clk) begin
        $display("load=%b, out=%h, out=%b, initial_msg=%h, initial_msg=%b", load, out, out, initial_msg, initial_msg);
    end


    // initial begin
    //     $dumpfile("shifter_tb.vcd");
    //     $dumpvars();
    // end

endmodule   