module top (
    inout   [7:0]   p1,     // gpio
    input           rst,    // reset
    inout   [7:0]   p3,     // rxd, txd, int0, int1, t0, t1, wr, rd
    input           xtal2,  // external oscillator signal input
    output          xtal1,  // generated clock signal output
    inout   [7:0]   p2,     // gpio or higher address of additional external memory
    output          psen_n, // program store enable output, active LOW
    input           ale,    // address latch enable or program pulse input
    input           ea_n,   // external access input
    inout   [7:0]   p0      // gpio or lower address of additional external memory
);
    
endmodule