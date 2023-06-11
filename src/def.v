// SPECIAL FUNCTION REGISTERS ADDRESS
`define P0      data[8'h80]
`define SP      data[8'h81]
`define DPL     data[8'h82]
`define DPH     data[8'h83]
`define PCON    data[8'h87]
`define TCON    data[8'h88]
`define TMOD    data[8'h89]
`define TL0     data[8'h8a]
`define TL1     data[8'h8b]
`define TH0     data[8'h8c]
`define TH1     data[8'h8d]
`define P1      data[8'h90]
`define SCON    data[8'h98]
`define SBUF    data[8'h99]
`define P2      data[8'ha0]
`define IE      data[8'ha8]
`define P3      data[8'hb0]
`define IP      data[8'hb8]
`define PSW     data[8'hd0]
`define ACC     data[8'he0]
`define B       data[8'hf0]



// ARITHMETIC OPERATIONS
// ADD
function add_a_rn       (input [7:0] i); add_a_rn   = (i[7:3]==5'b00101   ); endfunction
function add_a_di       (input [7:0] i); add_a_di   = (i[7:0]==8'b00100101); endfunction
function add_a_ri       (input [7:0] i); add_a_ri   = (i[7:1]==7'b0010011 ); endfunction
function add_a_da       (input [7:0] i); add_a_da   = (i[7:0]==8'b00100100); endfunction
// ADDC
function addc_a_rn      (input [7:0] i); addc_a_rn  = (i[7:3]==5'b00111   ); endfunction
function addc_a_di      (input [7:0] i); addc_a_di  = (i[7:0]==8'b00110101); endfunction
function addc_a_ri      (input [7:0] i); addc_a_ri  = (i[7:1]==7'b0011011 ); endfunction
function addc_a_da      (input [7:0] i); addc_a_da  = (i[7:0]==8'b00110100); endfunction
// SUBB
function subb_a_rn      (input [7:0] i); subb_a_rn  = (i[7:3]==5'b10011   ); endfunction
function subb_a_di      (input [7:0] i); subb_a_di  = (i[7:0]==8'b10010101); endfunction
function subb_a_ri      (input [7:0] i); subb_a_ri  = (i[7:1]==7'b1001011 ); endfunction
function subb_a_da      (input [7:0] i); subb_a_da  = (i[7:0]==8'b10010100); endfunction
// INC
function inc_a          (input [7:0] i); inc_a      = (i[7:0]==8'b00000100); endfunction
function inc_rn         (input [7:0] i); inc_rn     = (i[7:3]==5'b00001   ); endfunction
function inc_di         (input [7:0] i); inc_di     = (i[7:0]==8'b00000101); endfunction
function inc_ri         (input [7:0] i); inc_ri     = (i[7:1]==7'b0000011 ); endfunction
function inc_dp         (input [7:0] i); inc_dp     = (i[7:0]==8'b10100011); endfunction
// DEC
function dec_a          (input [7:0] i); dec_a      = (i[7:0]==8'b00010100); endfunction
function dec_rn         (input [7:0] i); dec_rn     = (i[7:3]==5'b00011   ); endfunction
function dec_di         (input [7:0] i); dec_di     = (i[7:0]==8'b00010101); endfunction
function dec_ri         (input [7:0] i); dec_ri     = (i[7:1]==7'b0001011 ); endfunction
// MUL
function mul            (input [7:0] i); mul        = (i[7:0]==8'b10100100); endfunction
// DIV
function div            (input [7:0] i); div        = (i[7:0]==8'b10000100); endfunction
// DA
function da             (input [7:0] i); da         = (i[7:0]==8'b11010100); endfunction

// LOGICAL OPERATIONS
// ANL
function anl_a_rn       (input [7:0] i); anl_a_rn   = (i[7:3]==5'b01011   ); endfunction
function anl_a_di       (input [7:0] i); anl_a_di   = (i[7:0]==8'b01010101); endfunction
function anl_a_ri       (input [7:0] i); anl_a_ri   = (i[7:1]==7'b0101011 ); endfunction
function anl_a_da       (input [7:0] i); anl_a_da   = (i[7:0]==8'b01010100); endfunction
function anl_di_a       (input [7:0] i); anl_di_a   = (i[7:0]==8'b01010010); endfunction
function anl_di_da      (input [7:0] i); anl_di_da  = (i[7:0]==8'b01010011); endfunction
// ORL
function orl_a_rn       (input [7:0] i); orl_a_rn   = (i[7:3]==5'b01001   ); endfunction
function orl_a_di       (input [7:0] i); orl_a_di   = (i[7:0]==8'b01000101); endfunction
function orl_a_ri       (input [7:0] i); orl_a_ri   = (i[7:1]==7'b0100011 ); endfunction
function orl_a_da       (input [7:0] i); orl_a_da   = (i[7:0]==8'b01000100); endfunction
function orl_di_a       (input [7:0] i); orl_di_a   = (i[7:0]==8'b01000010); endfunction
function orl_di_da      (input [7:0] i); orl_di_da  = (i[7:0]==8'b01000011); endfunction
// XRL
function xrl_a_rn       (input [7:0] i); xrl_a_rn   = (i[7:3]==5'b01101   ); endfunction
function xrl_a_di       (input [7:0] i); xrl_a_di   = (i[7:0]==8'b01100101); endfunction
function xrl_a_ri       (input [7:0] i); xrl_a_ri   = (i[7:1]==7'b0110011 ); endfunction
function xrl_a_da       (input [7:0] i); xrl_a_da   = (i[7:0]==8'b01100100); endfunction
function xrl_di_a       (input [7:0] i); xrl_di_a   = (i[7:0]==8'b01100010); endfunction
function xrl_di_da      (input [7:0] i); xrl_di_da  = (i[7:0]==8'b01100011); endfunction
// CLR
function clr_a          (input [7:0] i); clr_a      = (i[7:0]==8'b11100100); endfunction
// CPL
function cpl_a          (input [7:0] i); cpl_a      = (i[7:0]==8'b11110100); endfunction
// RL
function rl_a           (input [7:0] i); rl_a       = (i[7:0]==8'b00100011); endfunction
// RLC
function rlc_a          (input [7:0] i); rlc_a      = (i[7:0]==8'b00110011); endfunction
// RR
function rr_a           (input [7:0] i); rr_a       = (i[7:0]==8'b00000011); endfunction
// RRC
function rrc_a          (input [7:0] i); rrc_a      = (i[7:0]==8'b00010011); endfunction
// SWAP
function swap_a         (input [7:0] i); swap_a     = (i[7:0]==8'b11000100); endfunction

// DATA TRANSFER
// MOV
function mov_a_rn       (input [7:0] i); mov_a_rn       = (i[7:3]==5'b11101   ); endfunction
function mov_a_di       (input [7:0] i); mov_a_di       = (i[7:0]==8'b11100101); endfunction
function mov_a_ri       (input [7:0] i); mov_a_ri       = (i[7:1]==7'b1110011 ); endfunction
function mov_a_da       (input [7:0] i); mov_a_da       = (i[7:0]==8'b01110100); endfunction
function mov_rn_a       (input [7:0] i); mov_rn_a       = (i[7:3]==5'b11111   ); endfunction
function mov_rn_di      (input [7:0] i); mov_rn_di      = (i[7:3]==5'b10101   ); endfunction
function mov_rn_da      (input [7:0] i); mov_rn_da      = (i[7:3]==5'b01111   ); endfunction
function mov_di_a       (input [7:0] i); mov_di_a       = (i[7:0]==8'b11110101); endfunction
function mov_di_rn      (input [7:0] i); mov_di_rn      = (i[7:3]==5'b10001   ); endfunction
function mov_di_di      (input [7:0] i); mov_di_di      = (i[7:0]==8'b10000101); endfunction
function mov_di_ri      (input [7:0] i); mov_di_ri      = (i[7:1]==7'b1000011 ); endfunction 
function mov_di_da      (input [7:0] i); mov_di_da      = (i[7:0]==8'b01110101); endfunction
function mov_ri_a       (input [7:0] i); mov_ri_a       = (i[7:1]==7'b1111011 ); endfunction
function mov_ri_di      (input [7:0] i); mov_ri_di      = (i[7:1]==7'b1010011 ); endfunction
function mov_ri_da      (input [7:0] i); mov_ri_da      = (i[7:1]==7'b0111011 ); endfunction
function mov_dp_da      (input [7:0] i); mov_dp_da      = (i[7:0]==8'b10010000); endfunction
// MOVC
function movc_a_dp      (input [7:0] i); movc_a_dp      = (i[7:0]==8'b10010011); endfunction
function movc_a_pc      (input [7:0] i); movc_a_pc      = (i[7:0]==8'b10000011); endfunction
// MOVX
function movx_a_ri      (input [7:0] i); movx_a_ri      = (i[7:1]==7'b1110001 ); endfunction
function movx_a_dp      (input [7:0] i); movx_a_dp      = (i[7:0]==8'b11100000); endfunction
function movx_ri_a      (input [7:0] i); movx_ri_a      = (i[7:1]==7'b1111001 ); endfunction
function movx_dp_a      (input [7:0] i); movx_dp_a      = (i[7:0]==8'b11110000); endfunction
// PUSH
function push           (input [7:0] i); push           = (i[7:0]==8'b11000000); endfunction
// POP
function pop            (input [7:0] i); pop            = (i[7:0]==8'b11010000); endfunction
// XCH
function xch_a_rn       (input [7:0] i); xch_a_rn       = (i[7:3]==5'b11001   ); endfunction
function xch_a_di       (input [7:0] i); xch_a_di       = (i[7:0]==8'b11000101); endfunction
function xch_a_ri       (input [7:0] i); xch_a_ri       = (i[7:1]==7'b1100011 ); endfunction
// XCHD
function xchd_a_ri      (input [7:0] i); xchd_a_ri      = (i[7:1]==7'b1101011 ); endfunction

// BOOLEAN VARIABLE MANIPULATION
// CLR
function clr_c          (input [7:0] i); clr_c          = (i[7:0]==8'b11000011); endfunction
function clr_bit        (input [7:0] i); clr_bit        = (i[7:0]==8'b11000010); endfunction
// SETB
function setb_c         (input [7:0] i); setb_c         = (i[7:0]==8'b11010011); endfunction
function setb_bit       (input [7:0] i); setb_bit       = (i[7:0]==8'b11010010); endfunction
// CPL
function cpl_c          (input [7:0] i); cpl_c          = (i[7:0]==8'b10110011); endfunction
function cpl_bit        (input [7:0] i); cpl_bit        = (i[7:0]==8'b10110010); endfunction
// ANL
function anl_c_bit      (input [7:0] i); anl_c_bit      = (i[7:0]==8'b10000010); endfunction
function anl_c_nbit     (input [7:0] i); anl_c_nbit     = (i[7:0]==8'b10110000); endfunction
// ORL
function orl_c_bit      (input [7:0] i); orl_c_bit      = (i[7:0]==8'b01110010); endfunction
function orl_c_nbit     (input [7:0] i); orl_c_nbit     = (i[7:0]==8'b10100000); endfunction
// MOV
function mov_c_bit      (input [7:0] i); mov_c_bit      = (i[7:0]==8'b10100010); endfunction
function mov_bit_c      (input [7:0] i); mov_bit_c      = (i[7:0]==8'b10010010); endfunction
// JC
function jc             (input [7:0] i); jc             = (i[7:0]==8'b01000000); endfunction
// JNC
function jnc            (input [7:0] i); jnc            = (i[7:0]==8'b01010000); endfunction
// JB
function jb             (input [7:0] i); jb             = (i[7:0]==8'b00100000); endfunction
// JNB
function jnb            (input [7:0] i); jnb            = (i[7:0]==8'b00110000); endfunction
// JBC
function jbc            (input [7:0] i); jbc            = (i[7:0]==8'b00010000); endfunction

// PROGRAM BRANCHING
// ACALL
function acall          (input [7:0] i); acall          = (i[4:0]==5'b10001   ); endfunction
// LCALL
function lcall          (input [7:0] i); lcall          = (i[7:0]==8'b00010010); endfunction
// RET
function ret            (input [7:0] i); ret            = (i[7:0]==8'b00100010); endfunction
// RETI
function reti           (input [7:0] i); reti           = (i[7:0]==8'b00110010); endfunction
// AJMP
function ajmp           (input [7:0] i); ajmp           = (i[4:0]==5'b00001   ); endfunction
// LJMP
function ljmp           (input [7:0] i); ljmp           = (i[7:0]==8'b00000010); endfunction
// SJMP
function sjmp           (input [7:0] i); sjmp           = (i[7:0]==8'b10000000); endfunction
// JMP
function jmp            (input [7:0] i); jmp            = (i[7:0]==8'b01110011); endfunction
// JZ
function jz             (input [7:0] i); jz             = (i[7:0]==8'b01100000); endfunction
// JNZ
function jnz            (input [7:0] i); jnz            = (i[7:0]==8'b01110000); endfunction
// CJNE
function cjne_a_di      (input [7:0] i); cjne_a_di      = (i[7:0]==8'b10110101); endfunction
function cjne_a_da      (input [7:0] i); cjne_a_da      = (i[7:0]==8'b10110100); endfunction
function cjne_rn_da     (input [7:0] i); cjne_rn_da     = (i[7:3]==5'b10111   ); endfunction
function cjne_ri_da     (input [7:0] i); cjne_ri_da     = (i[7:1]==7'b1011011 ); endfunction
// DJNZ
function djnz_rn        (input [7:0] i); djnz_rn        = (i[7:3]==5'b11011   ); endfunction
function djnz_di        (input [7:0] i); djnz_di        = (i[7:0]==8'b11010101); endfunction
// NOP
function nop            (input [7:0] i); nop            = (i[7:0]==8'b00000000); endfunction

// CHECK INSTRUCTION LENGTH
function length3 (input [7:0] i);
    length3 = anl_di_da(i)|orl_di_da(i)|xrl_di_da(i)|mov_di_di(i)|mov_di_da(i)|mov_dp_da(i)|jb(i)|jnb(i)|jbc(i)|acall(i)|lcall(i)|ret(i)|reti(i)|ljmp(i)|cjne_a_di(i)|cjne_a_da(i)|cjne_rn_da(i)|cjne_ri_da(i)|djnz_di(i);
endfunction
function length2 (input [7:0] i);
    length2 = add_a_di(i)|add_a_da(i)|addc_a_di(i)|addc_a_da(i)|subb_a_di(i)|subb_a_da(i)|inc_di(i)|dec_di(i)|anl_a_di(i)|anl_a_da(i)|anl_di_a(i)|orl_a_di(i)|orl_a_da(i)|orl_di_a(i)|xrl_a_di(i)|xrl_a_da(i)|xrl_di_a(i)|mov_a_di(i)|mov_a_da(i)|mov_rn_di(i)|mov_rn_da(i)|mov_di_a(i)|mov_di_rn(i)|mov_di_ri(i)|mov_ri_di(i)|mov_ri_da(i)|push(i)|pop(i)|xch_a_di(i)|clr_bit(i)|setb_bit(i)|cpl_bit(i)|anl_c_bit(i)|anl_c_nbit(i)|orl_c_bit(i)|orl_c_nbit(i)|mov_c_bit(i)|mov_bit_c(i)|jc(i)|jnc(i)|ajmp(i)|sjmp(i)|jz(i)|jnz(i)|djnz_rn(i)|
              movc_a_dp(i)|movc_a_pc(i)|
              movx_a_ri(i)|movx_a_dp(i);
endfunction
function length1 (input [7:0] i);
    length1 = add_a_rn(i)|addc_a_rn(i)|subb_a_rn(i)|inc_a(i)|inc_rn(i)|inc_dp(i)|dec_a(i)|dec_rn(i)|mul(i)|div(i)|da(i)|anl_a_rn(i)|orl_a_rn(i)|xrl_a_rn(i)|clr_a(i)|cpl_a(i)|rl_a(i)|rlc_a(i)|rr_a(i)|rrc_a(i)|swap_a(i)|mov_a_rn(i)|mov_rn_a(i)|mov_ri_a(i)|movx_ri_a(i)|movx_dp_a(i)|xch_a_rn(i)|clr_c(i)|setb_c(i)|cpl_c(i)|jmp(i)|add_a_ri(i)|addc_a_ri(i)|subb_a_ri(i)|inc_ri(i)|dec_ri(i)|anl_a_ri(i)|orl_a_ri(i)|xrl_a_ri(i)|mov_a_ri(i)|xch_a_ri(i)|xchd_a_ri(i);
endfunction

// TODO: MUL FUNC
function [15:0] fmul (input [7:0] a, b); fmul = a * b; endfunction
// TODO: DIV FUNC
function [15:0] fdiv (input [7:0] a, b); fdiv = {a % b, a / b}; endfunction