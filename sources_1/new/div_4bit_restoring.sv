`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 06:43:07 PM
// Design Name: 
// Module Name: div_4bit_restoring
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module div_4bit_restoring #(parameter N = 4)(
    input logic clk, rst, start,
    input logic [N-1:0] operA,
    input logic [N-1:0] operB,
    output logic [N-1:0] quotient,
    output logic [N-1:0] remainder
    );

    logic [N-1:0] aluOUT;

    logic [N-1:0] regB;
    logic [N-1:0] shiftregA;
    logic [N-1:0] shiftregR;
    logic [N-1:0] shiftregQ;
    logic [$clog2(N)-1:0] regCount;

    logic enA, enB, enR, enC, enQ;
    logic loadA, loadR, loadC;
    logic Rsel, cout;
    
    typedef enum logic [1:0] { S1, S2, S3, S4 } state_t;

    state_t current_state, next_state;

    // assign aluOUT = shiftregR - regB;
    RCA4 rca4bit (.Cin(1'b1), .operA(shiftregR), .operB(~regB), .resultOUT(aluOUT), .Cout(cout));

    always_ff @ (posedge clk or posedge rst) begin : seq_logic
        if(rst) begin
            current_state <= S1;
            regB <= '0;
            shiftregA <= '0;
            shiftregR <= '0;
            shiftregQ <= '0;
            regCount <= '0;
        end else begin
            current_state <= next_state;
            
            if(loadA|enA) shiftregA <= enA ? {shiftregA[N-2:0], 1'b0} : operA;
            if(enB) regB <= operB;
            if(loadR|enR) shiftregR <= enR ? {shiftregR[N-2:0], shiftregA[N-1]} : (Rsel ? aluOUT : '0);
            if(enQ) shiftregQ <= {shiftregQ[N-2:0], cout};
            if(loadC|enC) regCount <= enC ? regCount - 1 : (N - 1);

        end
    end

    always_comb begin
        Rsel = 1'b0;
        loadC = 1'b0;
        loadR = 1'b0;
        loadA = 1'b0;
        enR = 1'b0;
        enB = 1'b0;
        enA = 1'b0;
        enQ = 1'b0;
        enC = 1'b0;
        case(current_state)
            S1: begin
                loadA = 1'b1;
                enB = 1'b1;
                Rsel = 1'b0;
                loadC = 1'b1;
                loadR = 1'b1;
                next_state = start ? S2 : S1;
            end
            S2: begin
                enR = 1'b1;
                enA = 1'b1;
                next_state = S3;
            end
            S3: begin
                Rsel = 1'b1;
                enQ = 1'b1;
                enC = 1'b1;
                loadR = cout; 
                next_state = z ? S4 : S2;  
            end
            S4: next_state = start ? S4 : S1;
        endcase
    end

    assign z = ~(|regCount);
    assign quotient = shiftregQ;
    assign remainder = shiftregR;

endmodule

//