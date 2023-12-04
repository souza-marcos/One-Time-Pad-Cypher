module cypher_tb;
    
    // Inputs
    reg clk;
    reg load;
    reg [`MSG_SIZE -1: 0] msg;
    reg [`KEY_SIZE -1: 0] key;

    // Outputs
    wire [`MSG_SIZE -1: 0] out;

    
    cypher cyph_mod (
        .clk(clk), 
        .load(load), 
        .msg(msg), 
        .key(key),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        load = 0;
        msg = 32'hABCDEF01;
        key = `KEY_SIZE'hA;

        // Add stimulus here
        load = 1;

        #5 load = 0;

        repeat (20) begin
            #10;
        end
        
        $finish;
    end

    always #10 clk = ~clk; // Toggle clock every 10 ns

    // Display the output
    always @(posedge clk) begin
        $display("\nmsg=%h, msg=%b \nkey=%h, key=%b \nout=%h, out=%b\n", msg, msg, key, key, out, out);
    end

endmodule