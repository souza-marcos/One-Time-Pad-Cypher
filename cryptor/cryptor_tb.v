// One time pad encryption/decryption testbench
`define KEY_SIZE 16
`define MSG_SIZE 240

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
    msg = 16'h0000; // 32 0's
    key = 16'hFFFF; // 32 1's
    clk = 1;
    display;
    
    clk = 0;
    msg = 16'hFFFF; // 32 1's
    clk = 1;
    display;

    clk = 0;
    msg = 16'b1010_1010_1010_1010;
    key = 16'b0101_0101_0101_0101;
    clk = 1;
    display;

    clk = 0;
    msg = 16'b0101_0101_0101_0101;
    clk = 1;
    display;

    clk = 0;
    msg = 16'hFFFF; // 32 1's
    key = 16'b0101_0101_0101_0101;
    clk = 1;
    display;

    $finish;
end

task display;
    #10 $display("\nmsg=%b \nkey=%b \nout=%b\n", msg, key, out);
endtask


initial begin
    $dumpfile("cryptor_wave.vcd");
    $dumpvars(0, cryptor_tb);
end


endmodule