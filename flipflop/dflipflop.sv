module DFF (
    input       clk,
    input       reset,
    input       d,
    output      out
);

    reg q;

    always @(posedge clk, posedge reset)
    begin
        if (reset) q <= 1'b0;
        else q <= d;
    end

    assign out = q;

endmodule