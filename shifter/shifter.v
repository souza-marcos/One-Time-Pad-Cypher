`include "../constants.vh"

// Shifter module, used to shift the message to the left 4 bits
module shifter (
    input wire  clk,                            // clock
    input wire  load,                           // load bool (1 = must load)
    input wire  [`MSG_SIZE -1: 0] initial_msg,  // msg to be shifted
    output wire [4 -1: 0] out           // shifted msg
);

reg [4 -1: 0] out_reg; 
reg [`MSG_SIZE -1: 0] shift_reg;

always @(posedge clk, posedge load) begin

    if (load) 
    begin 
        out_reg <= initial_msg [`MSG_SIZE -1: `MSG_SIZE -4];
        shift_reg <= initial_msg [(`MSG_SIZE -1): 0];
    end
    else // Shift 4 bits to the left
    begin
        out_reg <= shift_reg [`MSG_SIZE -1: `MSG_SIZE -4];
        shift_reg <= {shift_reg [(`MSG_SIZE -4): 0], 4'b0};
    end
end

assign out = out_reg;

endmodule