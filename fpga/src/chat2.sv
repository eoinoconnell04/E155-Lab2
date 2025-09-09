/*
Author: Eoin O'Connell
Date: Sep. 9, 2025
Module: Time-multiplexed dual seven segment display
*/

module multiplex_display (
    input  logic [3:0] s1,     // first nibble to display
    input  logic [3:0] s2,     // second nibble to display
    output logic [6:0] seg,    // seven segment outputs (shared)
    output logic an1,          // enable for digit 1 (active low for common anode)
    output logic an2           // enable for digit 2 (active low for common anode)
);

    // Oscillator signal
    logic clk;

    // Divider signal (slower clock for multiplexing)
    logic slow_clk;

    // HSOSC primitive instantiation
    HSOSC hf_osc (
        .CLKHFPU(1'b1),   // Power up
        .CLKHFEN(1'b1),   // Enable
        .CLKHF(clk)       // Oscillator output
    );

    // Divider instantiation (adjust divisor as needed for ~1kHz multiplexing)
    divider #(.N(14)) u_div (
        .clk_in(clk),
        .clk_out(slow_clk)
    );

    // Selected input for display
    logic [3:0] mux_in;

    // State toggle
    logic toggle;

    always_ff @(posedge slow_clk) begin
        toggle <= ~toggle;
    end

    always_comb begin
        if (toggle) begin
            mux_in = s1;
            an1    = 1'b0;   // enable digit 1 (active low)
            an2    = 1'b1;   // disable digit 2
        end else begin
            mux_in = s2;
            an1    = 1'b1;   // disable digit 1
            an2    = 1'b0;   // enable digit 2
        end
    end

    // Seven segment decoder instantiation
    display u_display (
        .in(mux_in),
        .out(seg)
    );

endmodule
