/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Sep. 3, 2025
Module Function: This is the top level module for E155 Lab 2. It performs 2 main functions:
1. Controls two seven segment display as a function of two different 4 input dip switches.
2. Controls 5 led lights that display the binary sum of the two hex digits.
*/
module lab2_eo(
	input  logic [3:0] s1,
	input  logic [3:0] s2,
	output logic [6:0] seg1,
	output logic [6:0] seg2,
	output logic [4:0] led
);

	logic clk, divided_clk;
	
	// Internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Initialize clock divider (outputs 2.4 Hz)
    divider div (.clk(clk), .divided_clk(divided_clk));

    // Initialize seven segment display
    display dis (.s(s), .seg(seg));

    assign led = {divided_clk, s[3] & s[2], s[1] ^ s[0]};

endmodule