`include "../constants.vh"

// Modulo Shifter
/*
    Consome uma mensagem de `MSG_SIZE bits e 
    a desloca `KEY_SIZE bits para a esquerda 
    a cada borda ascendente do clock.
*/
module shifter (
    input wire  clk,                            // clock
    input wire  enable,                           // enable bool (1 = Carregar mensagem inicial)
    input wire  [`MSG_SIZE -1: 0] initial_msg,  // Mensagem inicial
    output wire [`KEY_SIZE -1: 0] out           // Mensagem deslocada do tamanho da chave
);

reg [`KEY_SIZE -1: 0] out_reg;                  // Registrador de saída
reg [`MSG_SIZE -1: 0] shift_reg;                // Registrador de deslocamento 

logic first = 1;

always @(posedge clk) begin

    if (enable) // Shift `KEY_SIZE bits para a esquerda
    begin
        if(first == 1)begin
            #1 out_reg <= initial_msg [`MSG_SIZE -1: `MSG_SIZE -`KEY_SIZE];
            #1 shift_reg <= initial_msg << `KEY_SIZE;
            first = 0;
        end
        else begin
            #1 out_reg <= shift_reg [`MSG_SIZE -1: `MSG_SIZE -`KEY_SIZE];
            #5 shift_reg <= shift_reg << `KEY_SIZE;
        end
    end
end

assign out = out_reg;

endmodule