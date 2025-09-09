# E155 Lab 2

This repo contains all my code for lab 2 of E155 Microprocessors: design and application.

The file `lab2_eo.sv` performs multiple functions to work on the concept of clock multiplexing. 
1. Controls two seven segment display as a function of two different 4 input dip switches.
2. Controls 5 led lights that display the binary sum of the two hex digits.

This top level module instantiates multiple other modules in this repo, and the repo includes test benches and test vectors for all modules.