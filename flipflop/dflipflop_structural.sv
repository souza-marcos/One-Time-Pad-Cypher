
module latch_sr(
    input wire s,               // Set bit -> 1,   (1 = set) 
    input wire r,               // Reset bit -> 0, (1 = reset)
    output q,                   // Output q - bit stored
    output qbar                 
);

    assign q    = ~(qbar | s);
    assign qbar = ~(q    | r);

endmodule

module latch_d(
    input wire  clk,            // Clock
    input wire  d,              // Data bit
    output      q,              // Output q - bit stored
    output      qbar
);
        
    wire r;
    wire s;

    assign r = clk & ~d;
    assign s = clk &  d;

    latch_sr lsr(
        .s(s),
        .r(r),
        .q(q),
        .qbar(qbar)
    );

endmodule

module flipflop_d (
    input       clk,            // Clock
    input       reset,          // Reset bit
    input       d,              // Data bit
    output      q,              // Output q - bit stored
    output      qbar
);
    wire data;
    wire clk_bar = ~clk;
    wire n1;

    assign data = d & ~reset;

    latch_d master_latch(
        .clk(clk_bar),
        .d(data),
        .q(n1),
        .qbar()
    );

    latch_d slave_latch(
        .clk(clk),
        .d(n1),
        .q(q),
        .qbar(qbar)
    );

endmodule