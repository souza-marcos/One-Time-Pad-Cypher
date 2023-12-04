
`include "../constants.vh"

module cryptor (
    input wire      clk,
    input wire      [(`KEY_SIZE -1): 0] msg,
    input wire      [(`KEY_SIZE -1): 0] key,
    output wire     [(`KEY_SIZE -1): 0] out
);

reg [`KEY_SIZE -1: 0] out_reg;

always @(posedge clk) begin
    out_reg <= msg ^ key;           // XOR    
end

assign out = out_reg;

endmodule