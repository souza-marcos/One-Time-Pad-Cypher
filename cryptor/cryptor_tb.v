// One time pad encryption/decryption testbench
`include "../constants.vh"

module cryptor_tb;

reg clk;
reg [`KEY_SIZE -1: 0] msg;
reg [`KEY_SIZE -1: 0] key;


wire [`KEY_SIZE -1: 0] out;

cryptor cryptor_mod (
    .clk(clk),
    .msg(msg),
    .key(key),
    .out(out)
);

initial begin

    clk = 0;
    msg = 32'h0000_0000; // 32 0's
    key = 32'hFFFF_FFFF; // 32 1's
    clk = 1;
    display;
    
    clk = 0;
    msg = 32'hFFFF_FFFF; // 32 1's
    clk = 1;
    display;

    clk = 0;
    msg = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
    key = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
    clk = 1;
    display;

    clk = 0;
    msg = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
    clk = 1;
    display;

    clk = 0;
    msg = 32'hFFFF_FFFF; // 32 1's
    key = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
    clk = 1;
    display;

    $finish;
end

task display;
    #10 $display("\nmsg=%b \nkey=%b \nout=%b\n", msg, key, out);
endtask


endmodule