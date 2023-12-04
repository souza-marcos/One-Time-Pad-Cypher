// Design:		seq
// File:		sequence.v
// Description: Finite State Machine (FSM) example.
//              Sequence detectors. Mealy and Moore examples
// Author:		Jorge Juan-Chico <jjchico@gmail.com>
// Date: 		27-11-2010 (initial version)

/*
   Lesson 6.4: Finite State Machine (FSM) examples. Sequence detectors.

   Finite State Machines (FSM) produces at each time an output value (z) that
   depends on the applied input (x) and the state of the machine (q). At the
   same time, a next state (Q) is calculated and will be stored at a future
   time. When the output depends directly on the input it is said to be a
   Mealy's machine and when the output only depends directly on the state it is
   a Moore's machine. State machines are conveniently described by state
   diagrams and state tables.

   State machines can be implemented by using digital circuits as follows:

   - Flip-flops are used to store the state of the machine. The input evaluation
     and the state transition is controlled by the active edge of the clock
     signal of the flip-flops.

   - Combinational circuits are used to implement the functions that calculate
     the output and the next state.

   Digital circuits that implement FSM's are a type of "Synchronous Sequential
   Circuits".

                        (Mealy only)
            ,-- -- -- -- -- -- -- -- -- -- --
            |   _______          _______     |    _______
            |  |       |        |       |    |   |       |
      x ----·->|       |   Q    |       |    `-->|       |
               | C.C.  |------->|  FFs. |  q     | C.C.  |-----> z
            q  |       |        |       |----·-->|       |
          ,--->|       |  clk-->|       |    |   |       |
          |    |_______|        |_______|    |   |_______|
          `----------------------------------´

   The most convenient way to describe a FSM in Verilog is to create a block
   (normally a process) for every part of the machine:

   - A combinational process to calculate the next state.
   - A combinational process to calculate the output value.
   - A very simple sequential process that makes the calculated next state to
     be the current state. This process should be triggered by a clock edge and
     will typically include a 'reset' signal to force a known state during
     initialization.

   In this example, a sequential circuit with an input 'x' and an output 'z' is
   described. The purpose of the circuit is to detect a sequence of bits in 'x'
   so that 'z' is activated (1) when the last bits arriving at 'x' are '1001'.
   The detector should detect "overlaping" sequences, that is, the last '1' on
   a detected sequence can also be the first '1' in a following sequence. A
   sample input and corresponding output is:

       x: 00100111000011101001001001010011...
       z: 00000100000000000001001001000010...
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Sequence detector (Mealy)                                            //
//////////////////////////////////////////////////////////////////////////

/*
 * State table
 *
 *         Input (x)
 * State    0     1
 *        -----------
 *   A   | A,0   B,0 |		A: waiting for the first bit
 *   B   | C,0   B,0 |		B: first bit OK (1)
 *   C   | D,0   B,0 |		C: second bit OK (0)
 *   D   | A,0   B,1 |		D: third bit OK (0)
 *        -----------
 *       Next state, z
 *
 * The correct sequence is detected when staying at state D (first three bits
 * correct) a new '1' arrives. In this case, next state is B to consider
 * overlapping. In other case, the sequence is not correct and we return to A.
 */
 module seq_mealy(
     /* Input 'reset' forces the system to a known state (A) when activated.
      * Reset signals are used in most sequential circuits to warranty that
      * the system is at a known state after initialization (turn on). */
    input wire clk,     // clock
    input wire reset,   // reset
    input wire x,       // input
    output reg z        // output
     );

     // State encoding
     /* State encoding is typically done in Verilog by defining named
      * parameters for every state. This way, the synthesis tool can
      * re-define the parameters to find a better encoding if necessary. Here
      * we are using a "highly encoded" alternative: we use the minimum number
      * of bits. Another very common alternative is the one-hot encoding. */
     parameter [1:0]
         A = 2'b00,
         B = 2'b01,
         C = 2'b11,
         D = 2'b10;

    // State and next state variables
    /* 'state' will store the current state while 'next_state' is used to
     * calculate the next state. */
    reg [1:0] state, next_state;

    // State change process (sequential part)
    /* This is the only sequential process in the circuit. If 'reset' is
     * activated the machine goes to state 'A' (the initial state), if not,
     * the the next state calculated in the variable 'next_state' becomes
     * the current state and is stored in varibale 'state'. The next
     * state is calculated in a different process later in the code. The
     * 'posedge clk' condition in the sensitivity list of the process makes
     * the state transition to take place at the active clock edge. */
    always @(posedge clk, posedge reset)
        if (reset)
            state <= A;
        else
            state <= next_state;

    // Next state calculation process (combinational)
    /* This is directly derived from the state table above. Every entry in
     * the 'case' block corresponds to a row in the states table. The next
     * state is selected using an 'if' statement as a function of the input and
     * according to the table. The value of the output for each case could have
     * also been assigned in this process, but we use a three processes style
     * in this description and the output is assigned in a dedicated process. */
    always @* begin
        /* The next state variable should be assigned in every case
         * to assure a combinational operation. Here, 'next_state' is
         * initially assigned an unknown value 'x' so that it is easier
         * to detect a possible miss-assignments during simulation. */
        next_state = 2'bxx;
        case (state)
        A:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        B:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        C:
            if (x == 0)
                next_state = D;
            else
                next_state = B;
        D:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        endcase
    end

    // Output calculation process (combinational)
    /* This is derived from the state table. Any combinational style can
     * be used. Here we have observed that the output is '1' only if we
     * are in state 'D' and the input is '1'. */
    always @* begin
        if (state == D && x == 1)
            z = 1;
        else
            z = 0;
    end
endmodule // seq_mealy

//////////////////////////////////////////////////////////////////////////
// Sequence detector (Moore)                                            //
//////////////////////////////////////////////////////////////////////////

/*
 * Moore's state table is very similar to Mealy's. Moore's table includes and
 * additional state E that sets the output to '1' when the right sequence is
 * detected. The additional state is necessary because Moore's machines cannot
 * produce different output values while in the same state.
 *
 *        Input (x)
 * State    0    1    Output (z)
 *        ----------
 *   A   |  A    B  |   0		A: waiting for the first bit
 *   B   |  C    B  |   0		B: first bit OK (1)
 *   C   |  D    B  |   0		C: second bit OK (0)
 *   D   |  A    E  |   0		D: third bit OK (0)
 *   E   |  C    B  |   1		E: sequence detected
 *        ----------
 *        Next state
 */
 module seq_moore(
     input wire clk,    // clock
     input wire reset,  // reset
    input wire x,       // input
     output reg z       // output
     );

     // State coding
     /* This time we use a one-hot encoding style. This encoding uses more
      * flip-flops but reduces the complexity of the combinational part and
      * produces more efficient circuits. This is the encoding style normally
      * used by automatic synthesis tools in the absence of restrictions on
      * the number of flip-flops. */
     parameter [4:0]
         A = 5'b00001,
         B = 5'b00010,
         C = 5'b00100,
         D = 5'b01000,
         E = 5'b10000;

    // State and next state variables
    reg [4:0] state, next_state;

    // State change process (sequential)
    /* The state change process is identical to the Mealy version. */
    always @(posedge clk, posedge reset)
        if (reset)
            state <= A;
        else
            state <= next_state;

    // Next state calculation process (combinational)
    /* Like Mealy's but including state E. */
    always @* begin
        next_state = 2'bxx;
        case (state)
        A:
            if (x == 0)
                next_state = A;
            else
                next_state = B;
        B:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        C:
            if (x == 0)
                next_state = D;
            else
                next_state = B;
        D:
            if (x == 0)
                next_state = A;
            else
                next_state = E;
        E:
            if (x == 0)
                next_state = C;
            else
                next_state = B;
        endcase
    end

    // Output calculation process (combinational)
    /* In Moore's state machines the output is only associated to the
     * state so the output calculation is simplified. In our example the
     * output is '1' only when in state E. */
    always @* begin
        if (state == E)
            z = 1;
        else
            z = 0;
    end
endmodule // seq_moore

/*
   (This lesson continues in 'sequence_tb.v'.)
*/
