module flipflop_d (
    input       clk,
    input       reset,
    input       d,
    output reg  q,
    output      qbar
);

    always @(posedge clk)
    begin
        if (reset) q <= 1'b0;
        else q <= d;
    end

    assign qbar = ~q;

endmodule