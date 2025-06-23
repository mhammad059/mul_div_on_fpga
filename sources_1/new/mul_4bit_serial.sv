`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 02:20:10 PM
// Design Name: 
// Module Name: mul_4bit_serial
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



module mul_4bit_serial(
    input logic clk, rst, start,
    input logic [3:0] operA,
    input logic [3:0] operB,
    output logic [7:0] result
    );

    typedef enum logic [1:0] { 
        S1, S2, S3 
    } state_t;

    state_t current_state, next_state;

    logic [7:0] regP;
    logic [7:0] shiftregA;
    logic [3:0] shiftregB;
    
    logic enP, enA, enB, Psel;
    logic loadA, loadB;
    logic z;

    always_ff @( posedge clk or posedge rst ) begin : seq_logic
        if (rst) begin
            current_state <= S1;
            regP <= 0;
            shiftregA <= 0;
            shiftregB <= 0;
        end else begin
            current_state <= next_state;
            if(enP) regP <= Psel ? regP + shiftregA : 8'b0; // if Psel is 1 then add A else add '0'
            if(loadA|enA) shiftregA <= ~enA ? {4'b0, operA} : {shiftregA[6:0], 1'b0}; // shift left A or load
            if(loadB|enB) shiftregB <= ~enB ? operB : {1'b0, shiftregB[3:1]}; // shift right B or load
        end
    end

    always_comb begin : control_logic
        case(current_state)
            S1: begin
                loadA = 1'b1; 
                loadB = 1'b1;
                Psel = 1'b0;
                enP = 1'b1;
                enA = 1'b0;
                enB = 1'b0;
                next_state = start ? S2 : S1;
            end
            S2: begin
                loadA = 1'b0; 
                loadB = 1'b0;
                Psel = 1'b1;
                enP = shiftregB[0] ? 1'b1 : 1'b0;
                enA = 1'b1;
                enB = 1'b1;
                next_state = z ? S3 : S2;
            end
            S3: begin
                loadA = 1'b0; 
                loadB = 1'b0;
                Psel = 1'b0;
                enP = 1'b0;
                enA = 1'b0;
                enB = 1'b0;
                next_state = start ? S3 : S1;
            end
            default: begin
                loadA = 1'b0; 
                loadB = 1'b0;
                Psel = 1'b0;
                enP = 1'b0;
                enA = 1'b0;
                enB = 1'b0;
                next_state = S1;
            end
        endcase
    end

    assign z = ~(|shiftregB);
    assign result = regP;

endmodule
