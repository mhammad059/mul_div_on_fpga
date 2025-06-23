`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 07:07:21 PM
// Design Name: 
// Module Name: RCA4
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


module RCA4 #(parameter N = 4) (
    input logic Cin,
    input logic [N-1:0] operA,
    input logic [N-1:0] operB,
    output logic [N-1:0] resultOUT,
    output logic Cout
    );

    logic [N:0] Couts;
    assign Couts[0] = Cin;
    assign Cout = Couts[N];
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_fa
            assign resultOUT[i] = operA[i] ^ operB[i] ^ Couts[i];
            assign Couts[i+1] = (operA[i] & operB[i]) | (Couts[i] & (operA[i] ^ operB[i]));
        end
    endgenerate

endmodule
