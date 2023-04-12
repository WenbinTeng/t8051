module ram (
    input           clk,

    input           ram_rd_en,
    input   [15:0]  ram_rd_addr,
    output  [ 7:0]  ram_rd_data,

    input           ram_wr_en,
    input   [15:0]  ram_wr_addr,
    input   [ 7:0]  ram_wr_data
);

    reg [7:0] xdata [65535:0];

    always @(posedge clk) begin
        if (ram_wr_en)
            xdata[ram_wr_addr] <= ram_wr_data;
    end

    assign ram_rd_data = ram_rd_en ? ram_wr_en && (ram_rd_addr == ram_wr_addr) ? ram_wr_data : xdata[ram_rd_addr] : 'bz;

endmodule