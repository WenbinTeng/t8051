module rom (
    input           rom_en,
    input   [15:0]  rom_addr,
    output  [ 7:0]  rom_data
);
    
    reg [7:0] rom_array [65535:0];

    initial begin
        
    end

    assign rom_data = rom_en ? rom_array[rom_addr] : 'bz;

endmodule