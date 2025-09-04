# Author: Eoin O'Connell
# Email: eoconnell@hmc.edu
# Date: Sep. 4, 2025
# Python Function: This file generates test vectors for lab2_eo_tb.tv automatically (because there are 256 lines). If something is wrong, it is very easy to quickly change this and rerun script.

# 7-seg encoding for hex digits 0-F (abcdefg, active low example from your table)
seg_table = {
    0x0: "1000000",
    0x1: "1111001",
    0x2: "0100100",
    0x3: "0110000",
    0x4: "0011001",
    0x5: "0010010",
    0x6: "0000010",
    0x7: "1111000",
    0x8: "0000000",
    0x9: "0011000",
    0xA: "0001000",
    0xB: "0000011",
    0xC: "1000110",
    0xD: "0100001",
    0xE: "0000110",
    0xF: "0001110",
}

# Append to .tv file (raw binary with underscores for $readmemb)
with open("lab2_eo_tb.tv", "a") as f_bin:
    for s1 in range(16):
        for s2 in range(16):
            seg1 = seg_table[s1]
            seg2 = seg_table[s2]
            led = format(s1 + s2, "05b")  # 5-bit sum

            # Underscore-separated vector
            full_vector = f"{s1:04b}_{s2:04b}_{seg1}_{seg2}_{led}"
            f_bin.write(full_vector + "\n")

