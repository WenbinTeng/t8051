module top (
    input           clk,    // clock
    input           rst,    // reset
    inout   [7:0]   p0,     // gpio or lower address of additional external memory
    inout   [7:0]   p1,     // gpio
    inout   [7:0]   p2,     // gpio or higher address of additional external memory
    inout   [7:0]   p3,     // rxd, txd, int0, int1, t0, t1, wr, rd
    output          psen_n, // program store enable output, active LOW
    output          ale,    // address latch enable or program pulse input
    input           ea_n    // external access input, active LOW
);
    wire            rom_en;
    wire    [15:0]  rom_addr;
    wire    [ 7:0]  rom_data;

    wire            ram_rd_en;
    wire    [15:0]  ram_rd_addr;
    wire    [ 7:0]  ram_rd_data;

    wire            ram_wr_en;
    wire    [15:0]  ram_wr_addr;
    wire    [ 7:0]  ram_wr_data;

    core u_core (
        .clk            (clk),
        .rst            (rst),

        .p0             (p0),
        .p1             (p1),
        .p2             (p2),
        .p3             (p3),

        .rom_en         (rom_en),
        .rom_addr       (rom_addr),
        .rom_data       (rom_data),

        .ram_rd_en      (ram_rd_en),
        .ram_rd_addr    (ram_rd_addr),
        .ram_rd_data    (ram_rd_data),

        .ram_wr_en      (ram_wr_en),
        .ram_wr_addr    (ram_wr_addr),
        .ram_wr_data    (ram_wr_data)
    );

    ram u_ram (
        .clk            (clk),

        .ram_rd_en      (ram_rd_en),
        .ram_rd_addr    (ram_rd_addr),
        .ram_rd_data    (ram_rd_data),

        .ram_wr_en      (ram_wr_en),
        .ram_wr_addr    (ram_wr_addr),
        .ram_wr_data    (ram_wr_data)
    );

    rom u_rom (
        .rom_en         (rom_en),
        .rom_addr       (rom_addr),
        .rom_data       (rom_data)
    );

endmodule