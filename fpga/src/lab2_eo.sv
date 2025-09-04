/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Sep. 3, 2025
Module Function: This is the top level module for E155 Lab 2. It performs 2 main functions:
1. Controls two seven segment display as a function of two different 4 input dip switches.
2. Controls 5 led lights that display the binary sum of the two hex digits.
*/
module lab2_eo(
	input  logic reset,
	input  logic [3:0] s1,
	input  logic [3:0] s2,
	output logic [6:0] seg1,
	output logic [6:0] seg2,
	output logic [4:0] led
);

	logic clk, divided_clk;
	logic [3:0] display_input;
	logic [6:0] display_output;
	
	// Internal high-speed oscillator (outputs 48 Mhz clk)
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Initialize clock divider (Divides by 4800, dividing 48 MHz to 10 kHz)
    divider #(.TOGGLE_COUNT(2400)) div	(.clk(clk), .reset(reset), .divided_clk(divided_clk));

	// Seven segment display Input Mux
	assign display_input = divided_clk ? s1 : s2;

	// Seven segment display Output Demux
	assign seg1 = divided_clk ? display_output : 7'b1111111;
	assign seg2 = divided_clk ? 7'b1111111 : display_output;

    // Initialize single seven segment display
    display dis (.s(display_input), .seg(display_output));

	// Assign the 5 LEDs to the sum of the 4-bit hex digits
    assign led = s1 + s2;

endmodule