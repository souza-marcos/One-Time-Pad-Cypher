module cypher_tb;
    
    // Inputs
    reg clk;
    reg enable_encoder;
    reg enable_decoder;

    reg [`MSG_SIZE -1: 0] msg;
    reg [`KEY_SIZE -1: 0] key;

    wire [`MSG_SIZE -1: 0] out_encoder;
    wire [`MSG_SIZE -1: 0] out_decoder;
    
    cypher encoder (
        .clk(clk), 
        .enable(enable_encoder), 
        .msg(msg), 
        .key(key),
        .out(out_encoder)
    );
    
    cypher decoder (
        .clk(clk), 
        .enable(enable_decoder), 
        .msg(out_encoder), 
        .key(key),
        .out(out_decoder)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        enable_encoder = 0;
        enable_decoder = 0;
        msg = `MSG_SIZE'h48656C6C6F20576F726C6421204120736563726574206D65737361676521;

        key = `KEY_SIZE'h0123;

        // Add stimulus here
        enable_encoder = 1;
    end

    always #10 clk = ~clk; // Toggle clock every 10 ns

    // Display the out_encoderput
    always @(out_encoder) begin
        $display("\nENCODING: \nmsg = \t\t%s \nkey = \t\t%s \nciphertext = \t%s\n", msg, key, out_encoder);
        #10 enable_decoder = 1;
    end

    always @(out_decoder) begin
        $display("\nDECODING: \nciphertext = \t%s \nkey = \t\t%s \nmsg = \t\t%s\n", out_encoder, key, out_decoder);
        #1000$finish;
    end

    initial begin
        $dumpfile("cypher_wave.vcd");
        $dumpvars(0, cypher_tb);
    end

endmodule