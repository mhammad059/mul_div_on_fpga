`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2025 04:03:33 PM
// Design Name: 
// Module Name: tb_mul_4bit_serial
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


module tb_mul_4bit_serial;
    
    logic clk, rst, start;
    logic [3:0] operA;
    logic [3:0] operB;
    logic [7:0] result;

    mul_4bit_serial dut(.*);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        operA = 4;
        operB = 2;
        
        #20 rst = 0;

        #20 start = 1;

        #100 start = 0;
        operA = 3;
        operB = 5;
        #20 start = 1;

        #100;
        $finish;

    end

endmodule
