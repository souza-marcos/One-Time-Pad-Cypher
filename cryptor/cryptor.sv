
`define KEY_SIZE 16
`define MSG_SIZE 240

// Modulo encriptador de um bloco de mensagem (Tamanho da chave = Tamanho da mensagem)
/*
    Encripta utilizando XOR da mensagem com a chave.
*/
module cryptor (
    input wire      clk,                    // clock
    input wire      [(`KEY_SIZE -1): 0] msg,// Mensagem a ser cifrada
    input wire      [(`KEY_SIZE -1): 0] key,// Chave de cifragem
    output wire     [(`KEY_SIZE -1): 0] out // Mensagem cifrada
);

reg [`KEY_SIZE -1: 0] out_reg;              // Registrador de saída

always @(posedge clk) begin
    #2 out_reg <= msg ^ key;                // XOR    
end

assign out = out_reg;

endmodule