`include "../constants.vh"
`include "../cryptor/cryptor.v"
`include "../shifter/shifter.v"

module cypher (
    input wire      clk,
    input wire      load,
    input wire      [(`MSG_SIZE -1): 0] msg,
    input wire      [(`KEY_SIZE -1): 0] key,
    output wire     [(`MSG_SIZE -1): 0] out
);

wire [(`KEY_SIZE -1): 0] blocks_msg;
wire [(`KEY_SIZE -1): 0] blocks_crypto_msg;

shifter shl (
    .clk(clk), 
    .load(load), 
    .initial_msg(msg), 
    .out(blocks_msg)
);

cryptor crypt (
    .clk(clk),
    .msg(blocks_msg),
    .key(key),
    .out(blocks_crypto_msg)
);

reg [`MSG_SIZE -1: 0] out_reg;

always @(posedge clk) begin
    if (load) 
        #5 out_reg <= `MSG_SIZE'h0;
    else
        #5 out_reg <= {out_reg << `KEY_SIZE, blocks_crypto_msg};
end

assign out = out_reg;

endmodule