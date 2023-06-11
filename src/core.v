module core (
    input           clk,
    input           rst,

    inout   [7:0]   p0,
    inout   [7:0]   p1,
    inout   [7:0]   p2,
    inout   [7:0]   p3,

    output          rom_en,
    output  [15:0]  rom_addr,
    input   [ 7:0]  rom_data,

    output          ram_rd_en,
    output  [15:0]  ram_rd_addr,
    input   [ 7:0]  ram_rd_data,

    output          ram_wr_en,
    output  [15:0]  ram_wr_addr,
    output  [ 7:0]  ram_wr_data
);

    `include "def.v"    

    reg [7:0] inst_reg1;
    always @(posedge clk or negedge rst) begin
        if      (~rst)                                 inst_reg1 <= 8'b0;
        else if (first_byte[0] && movx_a_ri(rom_data)) inst_reg1 <= ram_rd_data;
        else if (first_byte[0] && movx_a_dp(rom_data)) inst_reg1 <= ram_rd_data;
        else                                           inst_reg1 <= rom_data;
    end

    reg [7:0] inst_reg2;
    always @(posedge clk or negedge rst) begin
        if      (~rst) inst_reg2 <= 8'b0;
        else           inst_reg2 <= inst_reg1;
    end

    wire clr_1 = 
        (first_byte[2] && ret   (inst_reg2)) ||
        (first_byte[2] && reti  (inst_reg2)) ||
        (first_byte[2] && jmp   (inst_reg2))
        ;
    wire clr_0 = 
        (first_byte[2] && jc    (inst_reg2) &&  `PSW[7]) ||
        (first_byte[2] && jnc   (inst_reg2) && ~`PSW[7]) ||
        (first_byte[2] && jz    (inst_reg2) && (`ACC=='b0)) ||
        (first_byte[2] && jnz   (inst_reg2) && (`ACC!='b0)) ||
        (first_byte[2] && ret   (inst_reg2)) ||
        (first_byte[2] && reti  (inst_reg2)) ||
        (first_byte[2] && acall (inst_reg2)) ||
        (first_byte[2] && jmp   (inst_reg2)) ||
        (first_byte[2] && ajmp  (inst_reg2)) ||
        (first_byte[2] && sjmp  (inst_reg2))
        ;
    reg [2:0] first_byte;
    always @(posedge clk or negedge rst) begin
        if      (~rst) first_byte <= 'b0;
        else           first_byte <= {
            first_byte[1] & ~clr_1,
            first_byte[0] & ~clr_0,
            ~(
                first_byte[2] && length3(inst_reg2) ||
                first_byte[1] && length2(inst_reg1)
            )
        };
    end

    reg [15:0] program_counter;
    always @(posedge clk or negedge rst) begin
        if (~rst)
            program_counter <= 'b0;
        else if (first_byte[2]) begin
            if      (jc         (inst_reg2) &&  `PSW[7])                        program_counter <= program_counter + inst_reg1;
            else if (jnc        (inst_reg2) && ~`PSW[7])                        program_counter <= program_counter + inst_reg1;
            else if (jb         (inst_reg2) &&  data[addr_reg][inst_reg1[2:0]]) program_counter <= program_counter + rom_data + 'b1;
            else if (jnb        (inst_reg2) && ~data[addr_reg][inst_reg1[2:0]]) program_counter <= program_counter + rom_data + 'b1;
            else if (jbc        (inst_reg2) &&  data[addr_reg][inst_reg1[2:0]]) program_counter <= program_counter + rom_data + 'b1;
            else if (acall      (inst_reg2))                                    program_counter[10:0] <= {inst_reg2[7:4], inst_reg1};
            else if (ajmp       (inst_reg2))                                    program_counter[10:0] <= {inst_reg2[7:4], inst_reg1};
            else if (lcall      (inst_reg2))                                    program_counter <= {inst_reg2, inst_reg1};
            else if (ljmp       (inst_reg2))                                    program_counter <= {inst_reg2, inst_reg1};
            else if (ret        (inst_reg2))                                    program_counter <= {data[`SP], data[`SP-'b1]};
            else if (reti       (inst_reg2))                                    program_counter <= {data[`SP], data[`SP-'b1]};
            else if (sjmp       (inst_reg2))                                    program_counter <= program_counter + inst_reg1;
            else if (jmp        (inst_reg2))                                    program_counter <= {`DPH, `DPL} + `ACC;
            else if (jz         (inst_reg2) && (`ACC=='b0))                     program_counter <= program_counter + inst_reg1;
            else if (jnz        (inst_reg2) && (`ACC!='b0))                     program_counter <= program_counter + inst_reg1;
            else if (cjne_a_di  (inst_reg2) && (`ACC!=data_reg ))               program_counter <= program_counter + rom_data + 'b1;
            else if (cjne_a_da  (inst_reg2) && (`ACC!=inst_reg1))               program_counter <= program_counter + rom_data + 'b1;
            else if (cjne_rn_da (inst_reg2) && (data_reg!=inst_reg1))           program_counter <= program_counter + rom_data + 'b1;
            else if (cjne_ri_da (inst_reg2) && (data_reg!=inst_reg1))           program_counter <= program_counter + rom_data + 'b1;
            else if (djnz_rn    (inst_reg2) && (data_reg!='b0))                 program_counter <= program_counter + inst_reg1;
            else if (djnz_di    (inst_reg2) && (data_reg!='b0))                 program_counter <= program_counter + inst_reg1;
        end
        else if (first_byte[0] && (
            movc_a_dp(rom_data) || movc_a_pc(rom_data) ||
            movx_a_ri(rom_data) || movx_a_dp(rom_data)
        ));
        else                                                                    program_counter <= program_counter + 'b1;
    end

    reg [7:0] addr_gen;
    always @(*) begin
        if      (~rst) addr_gen = 8'b0;
        else if (first_byte[1] && (
            add_a_rn    (inst_reg1) || addc_a_rn   (inst_reg1) || subb_a_rn   (inst_reg1) ||
            anl_a_rn    (inst_reg1) || orl_a_rn    (inst_reg1) || xrl_a_rn    (inst_reg1) ||
            inc_rn      (inst_reg1) || dec_rn      (inst_reg1) ||
            mov_a_rn    (inst_reg1) || mov_di_rn   (inst_reg1) ||
            xch_a_rn    (inst_reg1) ||
            cjne_rn_da  (inst_reg1) ||
            djnz_rn     (inst_reg1)
        ))
            addr_gen = {3'b0, `PSW[4:3], inst_reg1[2:0]};
        else if (first_byte[1] && (
            add_a_di    (inst_reg1) || addc_a_di   (inst_reg1) || subb_a_di   (inst_reg1) ||
            anl_a_di    (inst_reg1) || anl_di_a    (inst_reg1) || anl_di_da   (inst_reg1) ||
            orl_a_di    (inst_reg1) || orl_di_a    (inst_reg1) || orl_di_da   (inst_reg1) ||
            xrl_a_di    (inst_reg1) || xrl_di_a    (inst_reg1) || xrl_di_da   (inst_reg1) ||
            xch_a_di    (inst_reg1) || xch_a_ri    (inst_reg1) || xchd_a_ri   (inst_reg1) ||
            inc_di      (inst_reg1) || dec_di      (inst_reg1) ||
            mov_a_di    (inst_reg1) || mov_rn_di   (inst_reg1) ||
            mov_ri_di   (inst_reg1) || mov_di_di   (inst_reg1) ||
            push        (inst_reg1) ||
            cjne_a_di   (inst_reg1) ||
            djnz_di     (inst_reg1)
        ))
            addr_gen = rom_data;
        else if (first_byte[1] && (
            add_a_ri    (inst_reg1) || addc_a_ri   (inst_reg1) || subb_a_ri   (inst_reg1) ||
            anl_a_ri    (inst_reg1) || orl_a_ri    (inst_reg1) || xrl_a_ri    (inst_reg1) ||
            inc_ri      (inst_reg1) || dec_ri      (inst_reg1) ||
            mov_a_ri    (inst_reg1) || mov_di_ri   (inst_reg1) ||
            cjne_ri_da  (inst_reg1)
        ))
            addr_gen = data[{3'b0, `PSW[4:3], 2'b0, inst_reg1[0]}];
        else if (first_byte[1] && (
            pop(inst_reg1)
        ))
            addr_gen = `SP;
        else
            addr_gen = 8'b0;
    end

    reg [7:0] addr_reg;
    always @(posedge clk or negedge rst) begin
        if (~rst) addr_reg <= 'b0;
        else if (first_byte[1] && (
            mov_rn_a    (inst_reg1) || mov_rn_di   (inst_reg1) || mov_rn_da   (inst_reg1)
        ))
            addr_reg <= {3'b0, `PSW[4:3], inst_reg1[2:0]};
        else if (first_byte[1] && (
            mov_di_rn   (inst_reg1) || mov_di_ri   (inst_reg1) || mov_di_da   (inst_reg1) ||
            mov_di_a    (inst_reg1) ||
            pop(inst_reg1)
        ))
            addr_reg <= rom_data;
        else if (first_byte[1] && (
            mov_ri_a    (inst_reg1) || mov_ri_di   (inst_reg1) || mov_ri_da   (inst_reg1)
        ))
            addr_reg <= data[{3'b0, `PSW[4:3], 2'b0, inst_reg1[0]}];
        else if (first_byte[1] && (
            clr_bit     (inst_reg1) || setb_bit    (inst_reg1) || cpl_bit     (inst_reg1) ||
            anl_c_bit   (inst_reg1) || anl_c_nbit  (inst_reg1) ||
            orl_c_bit   (inst_reg1) || orl_c_nbit  (inst_reg1) ||
            mov_c_bit   (inst_reg1) || mov_bit_c   (inst_reg1) ||
            jb          (inst_reg1) || jnb         (inst_reg1) || jbc         (inst_reg1)
        ))
            addr_reg <= rom_data[7] ? {1'b1, rom_data[6:3], 3'b0} : {4'b0010, rom_data[6:3]};
        else if (first_byte[1] && (
            push(inst_reg1)
        ))
            addr_reg <= `SP;
        else
            addr_reg <= addr_gen;
    end

    reg [7:0] data_reg;
    always @(posedge clk or negedge rst) begin
        if      (~rst) data_reg <= 'b0;
        else           data_reg <= data[addr_gen];
    end

    reg [7:0] data [255:0];
    always @(posedge clk) begin
        if (~rst) begin
                                                                                                 `ACC <= 8'h00;
                                                                                                 `B   <= 8'h00;
                                                                                                 `PSW <= 8'h00;
                                                                                                 `SP  <= 8'h07;
                                                                                                 `DPL <= 8'h00;
                                                                                                 `DPH <= 8'h00;
                                                                                                 `P0  <= 8'hff;
                                                                                                 `P1  <= 8'hff;
                                                                                                 `P2  <= 8'hff;
                                                                                                 `P3  <= 8'hff;
        end
        else if (first_byte[2]) begin
            if      (add_a_rn   (inst_reg2) || add_a_di   (inst_reg2) || add_a_ri   (inst_reg2)) `ACC <= `ACC + data_reg;
            else if (add_a_da   (inst_reg2))                                                     `ACC <= `ACC + inst_reg1;
            else if (addc_a_rn  (inst_reg2) || addc_a_di  (inst_reg2) || addc_a_ri  (inst_reg2)) `ACC <= `ACC + data_reg + `PSW[7];
            else if (addc_a_da  (inst_reg2))                                                     `ACC <= `ACC + inst_reg1 + `PSW[7];
            else if (subb_a_rn  (inst_reg2) || subb_a_di  (inst_reg2) || subb_a_ri  (inst_reg2)) `ACC <= `ACC - data_reg - `PSW[7];
            else if (subb_a_da  (inst_reg2))                                                     `ACC <= `ACC - inst_reg1 - `PSW[7];
            else if (inc_a      (inst_reg2))                                                     `ACC <= `ACC + 'b1;
            else if (inc_rn     (inst_reg2) || inc_di     (inst_reg2) || inc_ri     (inst_reg2)) data[addr_reg] <= data_reg + 'b1;
            else if (inc_dp     (inst_reg2))                                                     {`DPH, `DPL} <= {`DPH, `DPL} + 'b1;
            else if (dec_a      (inst_reg2))                                                     `ACC <= `ACC - 'b1;
            else if (dec_rn     (inst_reg2) || dec_di     (inst_reg2) || dec_ri     (inst_reg2)) data[addr_reg] <= data_reg - 'b1;
            else if (mul        (inst_reg2))                                                     {`B, `ACC} <= fmul(`ACC, `B);
            else if (div        (inst_reg2))                                                     {`B, `ACC} <= fdiv(`ACC, `B);
            else if (da         (inst_reg2))                                                     `ACC <= {`PSW[6]||(`ACC[3:0]>4'd9)?`ACC[3:0]+4'd6:`ACC[3:0], `PSW[7]||(`ACC[7:4]>4'd9)?`ACC[7:4]+4'd6:`ACC[7:4]};
            else if (anl_a_rn   (inst_reg2) || anl_a_di   (inst_reg2) || anl_a_ri   (inst_reg2)) `ACC <= `ACC & data_reg;
            else if (anl_a_da   (inst_reg2))                                                     `ACC <= `ACC & inst_reg1;
            else if (orl_a_rn   (inst_reg2) || orl_a_di   (inst_reg2) || orl_a_ri   (inst_reg2)) `ACC <= `ACC | data_reg;
            else if (orl_a_da   (inst_reg2))                                                     `ACC <= `ACC | inst_reg1;
            else if (xrl_a_rn   (inst_reg2) || xrl_a_di   (inst_reg2) || xrl_a_ri   (inst_reg2)) `ACC <= `ACC ^ data_reg;
            else if (xrl_a_da   (inst_reg2))                                                     `ACC <= `ACC ^ inst_reg1;
            else if (clr_a      (inst_reg2))                                                     `ACC <= 'b0;
            else if (cpl_a      (inst_reg2))                                                     `ACC <= ~`ACC;
            else if (rl_a       (inst_reg2))                                                     `ACC <= {`ACC[6:0], `ACC[7]};
            else if (rlc_a      (inst_reg2))                                                      {`PSW[7], `ACC} <= {`ACC, `PSW[7]};
            else if (rr_a       (inst_reg2))                                                     `ACC <= {`ACC[0], `ACC[7:1]};
            else if (rrc_a      (inst_reg2))                                                      {`PSW[7], `ACC} <= {`ACC[0], `PSW[7], `ACC[7:1]};
            else if (swap_a     (inst_reg2))                                                     `ACC <= {`ACC[3:0], `ACC[7:4]};
            else if (mov_a_rn   (inst_reg2) || mov_a_di   (inst_reg2) || mov_a_ri   (inst_reg2)) `ACC <= data_reg;
            else if (mov_a_da   (inst_reg2))                                                     `ACC <= inst_reg1;
            else if (mov_rn_a   (inst_reg2) || mov_di_a   (inst_reg2) || mov_ri_a   (inst_reg2)) data[addr_reg] <= `ACC;
            else if (mov_rn_di  (inst_reg2) || mov_di_rn  (inst_reg2) || mov_ri_di  (inst_reg2)) data[addr_reg] <= data_reg;
            else if (mov_rn_da  (inst_reg2) || mov_di_da  (inst_reg2) || mov_ri_da  (inst_reg2)) data[addr_reg] <= inst_reg1;
            else if (mov_di_ri  (inst_reg2))                                                     data[addr_reg] <= data_reg;
            else if (mov_di_di  (inst_reg2))                                                     data[rom_data] <= data_reg;
            else if (mov_dp_da  (inst_reg2))                                                     {`DPH, `DPL} <= {inst_reg1, rom_data};
            else if (movc_a_dp  (inst_reg2) || movc_a_pc  (inst_reg2))                           `ACC <= inst_reg1;
            else if (movx_a_dp  (inst_reg2) || movx_a_dp  (inst_reg2))                           `ACC <= inst_reg1;
            else if (push       (inst_reg2) || pop        (inst_reg2))                           data[addr_reg] <= data_reg;
            else if (xch_a_rn   (inst_reg2) || xch_a_di   (inst_reg2) || xch_a_ri   (inst_reg2)) {data[addr_reg], `ACC} <= {`ACC, data_reg};
            else if (xchd_a_ri  (inst_reg2))                                                     {data[addr_reg][3:0], `ACC[3:0]} <= {`ACC[3:0], data_reg[3:0]};
            else if (clr_c      (inst_reg2))                                                     `PSW[7] <= 1'b0;
            else if (clr_bit    (inst_reg2))                                                     data[addr_reg][inst_reg1[2:0]] <= 1'b0;
            else if (setb_c     (inst_reg2))                                                     `PSW[7] <= 1'b1;
            else if (setb_bit   (inst_reg2))                                                     data[addr_reg][inst_reg1[2:0]] <= 1'b1;
            else if (cpl_c      (inst_reg2))                                                     `PSW[7] <= ~`PSW[7];
            else if (cpl_bit    (inst_reg2))                                                     data[addr_reg][inst_reg1[2:0]] <= ~data[addr_reg][inst_reg1[2:0]];
            else if (anl_c_bit  (inst_reg2))                                                     `PSW[7] <= `PSW[7] & data[addr_reg][inst_reg1[2:0]];
            else if (anl_c_nbit (inst_reg2))                                                     `PSW[7] <= `PSW[7] & ~data[addr_reg][inst_reg1[2:0]];
            else if (orl_c_bit  (inst_reg2))                                                     `PSW[7] <= `PSW[7] | data[addr_reg][inst_reg1[2:0]];
            else if (orl_c_nbit (inst_reg2))                                                     `PSW[7] <= `PSW[7] | ~data[addr_reg][inst_reg1[2:0]];
            else if (mov_c_bit  (inst_reg2))                                                     `PSW[7] <= data[addr_reg][inst_reg1[2:0]];
            else if (mov_bit_c  (inst_reg2))                                                     data[addr_reg][inst_reg1[2:0]] <= `PSW[7];
            else if (jbc        (inst_reg2) && data[addr_reg][inst_reg1[2:0]])                   data[addr_reg][inst_reg1[2:0]] <= 1'b0;
            else if (acall      (inst_reg2))                                                     begin {data[`SP+'h2], data[`SP+'h1]} <= program_counter;       `SP <= `SP + 'h2; end
            else if (lcall      (inst_reg2))                                                     begin {data[`SP+'h2], data[`SP+'h1]} <= program_counter + 'h1; `SP <= `SP + 'h2; end
            else if (ret        (inst_reg2))                                                     `SP <= `SP -'h2;
            else if (reti       (inst_reg2))                                                     `SP <= `SP -'h2;
            else if (cjne_a_di  (inst_reg2))                                                     `PSW[7] <= `ACC < data_reg;
            else if (cjne_a_da  (inst_reg2))                                                     `PSW[7] <= `ACC < inst_reg1;
            else if (cjne_rn_da (inst_reg2))                                                     `PSW[7] <= data_reg < inst_reg1;
            else if (cjne_ri_da (inst_reg2))                                                     `PSW[7] <= data_reg < inst_reg1;
            else if (djnz_rn    (inst_reg2))                                                     data[addr_reg] <= data_reg - 'b1;
            else if (djnz_di    (inst_reg2))                                                     data[addr_reg] <= data_reg - 'b1;
        end
    end

    assign rom_en = 'b1;

    reg [15:0] rom_addr_signal;
    always @(*) begin
        if      (~rst)                                 rom_addr_signal = 8'b0;
        else if (first_byte[0] && movc_a_dp(rom_data)) rom_addr_signal = `ACC + {`DPH, `DPL};
        else if (first_byte[0] && movc_a_pc(rom_data)) rom_addr_signal = `ACC + program_counter + 'b1;
        else                                           rom_addr_signal = program_counter;
    end
    assign rom_addr = rom_addr_signal;

    assign ram_rd_en = first_byte[0] && (movx_a_ri(rom_data) || movx_a_dp(rom_data));

    reg [15:0] ram_rd_addr_signal;
    always @(*) begin
        if      (~rst)                                 ram_rd_addr_signal = 8'b0;
        else if (first_byte[0] && movx_a_ri(rom_data)) ram_rd_addr_signal = {8'b0, data[{3'b0, `PSW[4:3], 2'b0, rom_data[0]}]};
        else if (first_byte[0] && movx_a_dp(rom_data)) ram_rd_addr_signal = {`DPH, `DPL};
        else                                           ram_rd_addr_signal = 8'b0;
    end
    assign ram_rd_addr = ram_rd_addr_signal;

    assign ram_wr_en = first_byte[0] && (movx_ri_a(rom_data) || movx_dp_a(rom_data));

    reg [15:0] ram_wr_addr_signal;
    always @(*) begin
        if      (~rst)                                 ram_wr_addr_signal = 8'b0;
        else if (first_byte[0] && movx_ri_a(rom_data)) ram_wr_addr_signal = {8'b0, data[{3'b0, `PSW[4:3], 2'b0, rom_data[0]}]};
        else if (first_byte[0] && movx_dp_a(rom_data)) ram_wr_addr_signal = {`DPH, `DPL};
        else                                           ram_wr_addr_signal = 8'b0;
    end
    assign ram_wr_addr = ram_wr_addr_signal;

    reg [15:0] ram_wr_data_signal;
    always @(*) begin
        if      (~rst)                                 ram_wr_data_signal = 8'b0;
        else if (first_byte[0] && movx_ri_a(rom_data)) ram_wr_data_signal = `ACC;
        else if (first_byte[0] && movx_dp_a(rom_data)) ram_wr_data_signal = `ACC;
        else                                           ram_wr_data_signal = 8'b0;
    end
    assign ram_wr_data = ram_wr_data_signal;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign p0[i] = data[8'hf8][i] ? `P0[i] : 1'bz;
            assign p1[i] = data[8'hf9][i] ? `P1[i] : 1'bz;
            assign p2[i] = data[8'hfa][i] ? `P2[i] : 1'bz;
            assign p3[i] = data[8'hfb][i] ? `P3[i] : 1'bz;
        end
    endgenerate

endmodule