/*
Author: Eoin O'Connell
Email: eoconnell@hmc.edu
Date: Sep. 3, 2025
Module Function: Testbench to test top level module for E155 Lab 2.
*/


module lab2_eo_tb();
    logic clk, reset;
    logic [3:0] s1, s2;
    logic [4:0] led;
    logic [6:0] seg1, seg2;
    logic [18:0] expected; //  14 bits of seven segment display output, 5 bits LED output
    logic [31:0] vectornum, errors;
    logic [26:0] testvectors[10000:0];  //  8 bits of input, 14 bits of seven segment display output, 5 bits LED output

    // instantiate device under test
    lab2_eo dut(s1, s2, seg1, seg2, led);

    // generate clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // at start of test, load vectors and pulse reset
    initial begin
        $readmemb("lab2_eo_tb.tv", testvectors);
		$display("Loaded test vector 0: %b", testvectors[0]);
        vectornum = 0; errors = 0; reset = 1; #22; reset = 0;
    end

    // apply test vectors on rising edge of clk (this will effectively be both edges of divided_clk)
    always @(posedge clk) begin
        $display("%b", testvectors[vectornum]);
		#1; {s1, s2, expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) begin // skip during reset
            if ({seg1, seg2, led} !== expected) begin // check result
                $display("Error: input = %b, %b", s1, s2);
                $display("Output: seg1: %b, seg2: %b, led: %b. (%b expected)", seg1, seg2, led, expected);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 27'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $stop;
            end
        end
endmodule


