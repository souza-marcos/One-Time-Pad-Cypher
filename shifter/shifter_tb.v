// TestBench for a shifter
`include "../constants.vh"
// `include "shifter.v"

module shifter_tb;

    // Inputs
    reg clk;
    reg enable;
    reg [`MSG_SIZE -1: 0] initial_msg;

    // Outputs
    wire [`KEY_SIZE -1: 0] out;

    
    shifter shl_mod (
        .clk(clk), 
        .enable(enable), 
        .initial_msg(initial_msg), 
        .out(out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        enable = 0;         //   48656C6C6F20576F726C6421204120736563726574206D65737361676521
        initial_msg = `MSG_SIZE'hABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF012345;

        // Add stimulus here
        enable = 1;

        repeat (40) begin
            #10;
        end
        
        $finish;
    end

    always #10 clk = ~clk; // Toggle clock every 10 ns

    // Display the output
    always @(posedge clk) begin
        $display("enable=%b, out=%h, initial_msg=%h", enable, out, initial_msg);
    end


    initial begin
        $dumpfile("shifter_wave.vcd");
        $dumpvars();
    end

endmodule   