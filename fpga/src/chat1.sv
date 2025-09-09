module time_mux_seven_segment_decoder (
    input logic clk,                // Clock input for time multiplexing
    input logic rst_n,              // Active-low reset
    input logic [3:0] input_1,      // 4-bit input for the first display
    input logic [3:0] input_2,      // 4-bit input for the second display
    output logic [6:0] seg1,        // 7-segment display for input_1
    output logic [6:0] seg2,        // 7-segment display for input_2
    output logic an1,               // Active-low for common anode display 1
    output logic an2                // Active-low for common anode display 2
);

    // Internal register for multiplexing control
    logic mux_select;   // Mux control signal to switch between input_1 and input_2
    logic [6:0] seg_decoded_1, seg_decoded_2;  // Decoded segment outputs for each input
    logic [31:0] counter;   // A simple counter to create multiplexing timing
    parameter MAX_COUNT = 50000000;  // Adjust this for multiplexing rate (e.g., 50ms)

    // Seven-segment decoding logic for common anode
    function [6:0] seven_segment_decoder(input logic [3:0] bin);
        case (bin)
            4'b0000: seven_segment_decoder = 7'b1111110; // 0
            4'b0001: seven_segment_decoder = 7'b0110000; // 1
            4'b0010: seven_segment_decoder = 7'b1101101; // 2
            4'b0011: seven_segment_decoder = 7'b1111001; // 3
            4'b0100: seven_segment_decoder = 7'b0110011; // 4
            4'b0101: seven_segment_decoder = 7'b1011011; // 5
            4'b0110: seven_segment_decoder = 7'b1011111; // 6
            4'b0111: seven_segment_decoder = 7'b1110000; // 7
            4'b1000: seven_segment_decoder = 7'b1111111; // 8
            4'b1001: seven_segment_decoder = 7'b1111011; // 9
            4'b1010: seven_segment_decoder = 7'b1110111; // A
            4'b1011: seven_segment_decoder = 7'b0011111; // b
            4'b1100: seven_segment_decoder = 7'b1001110; // C
            4'b1101: seven_segment_decoder = 7'b0111101; // d
            4'b1110: seven_segment_decoder = 7'b1001111; // E
            4'b1111: seven_segment_decoder = 7'b1000111; // F
            default: seven_segment_decoder = 7'b0000000; // Invalid input
        endcase
    endfunction

    // Multiplexer control logic for multiplexing
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mux_select <= 1'b0;  // Start by displaying input_1
        end else begin
            // Time-multiplex with a counter to switch between inputs
            if (counter == MAX_COUNT) begin
                mux_select <= ~mux_select;  // Toggle mux_select every time count reaches MAX_COUNT
                counter <= 32'b0;  // Reset counter
            end else begin
                counter <= counter + 1;  // Increment counter
            end
        end
    end

    // Decode input_1 and input_2 using the 7-segment decoder function
    assign seg_decoded_1 = seven_segment_decoder(input_1);
    assign seg_decoded_2 = seven_segment_decoder(input_2);

    // Output the appropriate segments and enable/disable displays based on multiplexing
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            seg1 <= 7'b0000000;
            seg2 <= 7'b0000000;
            an1 <= 1'b1;  // Disable display 1 initially
            an2 <= 1'b1;  // Disable display 2 initially
        end else begin
            if (mux_select) begin
                seg1 <= 7'b0000000;  // Turn off seg1 when displaying input_2
                seg2 <= seg_decoded_2;  // Display input_2
                an1 <= 1'b1;  // Disable display 1
                an2 <= 1'b0;  // Enable display 2
            end else begin
                seg1 <= seg_decoded_1;  // Display input_1
                seg2 <= 7'b0000000;  // Turn off seg2 when displaying input_1
                an1 <= 1'b0;  // Enable display 1
                an2 <= 1'b1;  // Disable display 2
            end
        end
    end

endmodule
