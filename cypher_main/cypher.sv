// Code your design here
`define KEY_SIZE 16
`define MSG_SIZE 240

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

reg first = 1;

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


// Modulo Cifrador da mensagem (Shifter + Cryptor)
/*
    Consome uma mensagem de `MSG_SIZE bits e 
    uma chave de `KEY_SIZE bits e produz uma
    mensagem cifrada de `MSG_SIZE bits.

    Importante: A mensagem cifrada é produzida
    a cada `MSG_SIZE / `KEY_SIZE ciclos do clock.
*/
module cypher (
    input wire      clk,                    // clock
    input wire      enable,                   // load bool (1 = Carregar mensagem inicial)
    input wire      [(`MSG_SIZE -1): 0] msg,// Mensagem inicial a ser cifrada
    input wire      [(`KEY_SIZE -1): 0] key,// Chave de cifragem
    output wire     [(`MSG_SIZE -1): 0] out // Mensagem cifrada
);

wire [(`KEY_SIZE -1): 0] stream_msg;        // Bloco da mensagem a ser cifrada
wire [(`KEY_SIZE -1): 0] stream_crypto_msg; // Bloco da mensagem cifrada

// Instanciação dos módulos
shifter shl (
    .clk(clk), 
    .enable(enable), 
    .initial_msg(msg), 
    .out(stream_msg)
);

cryptor crypt (
    .clk(clk),
    .msg(stream_msg),
    .key(key),
    .out(stream_crypto_msg)
);

reg [`MSG_SIZE -1: 0] out_reg;              // Registrador de saída
reg [`MSG_SIZE -1: 0] outaux_reg;           // Registrador auxiliar de saída

always @(posedge clk) begin
    if (!enable) 
        out_reg <= out_reg;
    else
        #3 out_reg <= {out_reg[`MSG_SIZE -`KEY_SIZE: 0], stream_crypto_msg}; // "Shift" da stream anterior e concatena com a stream cifrada 
end

always @(out_reg[`MSG_SIZE -1])begin
    #1 outaux_reg <= out_reg;
end

assign out = outaux_reg;

endmodule