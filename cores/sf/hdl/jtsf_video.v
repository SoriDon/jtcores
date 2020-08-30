/*  This file is part of JT_GNG.
    JT_GNG program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    JT_GNG program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with JT_GNG.  If not, see <http://www.gnu.org/licenses/>.

    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 9-8-2020 */

module jtsf_video #(
    parameter CHARW = 17,
    parameter MAP1W = 14,
    parameter MAP2W = 14,
    parameter SCR1W = 17,
    parameter SCR2W = 17,
    parameter OBJW  = 17
)(
    input               rst,
    input               clk,
    input               pxl2_cen,
    input               pxl_cen,
    input               cpu_cen,
    input       [13:1]  cpu_AB,
    input       [ 8:0]  V,
    input       [ 8:0]  H,
    input               RnW,
    input               UDSWn,
    input               LDSWn,
    input               flip,
    input       [15:0]  cpu_dout,
    // Enable bits
    input               charon,
    input               scr1on,
    input               scr2on,
    input               objon,
    // CHAR
    input               char_cs,
    output      [15:0]  char_dout,
    input               char_ok,
    output              char_busy,
    output [CHARW-1:0]  char_addr,
    input       [15:0]  char_data,
    // SCROLL 1 - ROM
    output [SCR1W-1:0]  scr1_addr,
    input       [15:0]  scr1_data,
    input               scr1_ok,
    input       [15:0]  scr1posh,
    output [MAP1W-1:0]  map1_addr,
    input       [31:0]  map1_data,
    input               map1_ok,
    // SCROLL 2 - ROM
    output [SCR2W-1:0]  scr2_addr,
    input       [15:0]  scr2_data,
    input               scr2_ok,
    input       [15:0]  scr2posh,
    output [MAP2W-1:0]  map2_addr,
    input       [31:0]  map2_data,
    input               map2_ok,
    // OBJ
    input               HINIT,
    output      [12:0]  obj_AB,
    input       [15:0]  main_ram,
    input               OKOUT,
    output              bus_req, // Request bus
    input               bus_ack, // bus acknowledge
    output              blcnten, // bus line counter enable
    output  [OBJW-1:0]  obj_addr,
    input       [15:0]  obj_data,
    input               obj_ok,
    // Color Mix
    input               LVBL,
    input               LHBL,
    output              LHBL_dly,
    output              LVBL_dly,
    // Priority PROMs
    // input       [7:0]   prog_addr,
    // input               prom_prio_we,
    // input       [3:0]   prom_din,
    // Palette RAM
    input               col_uw,
    input               col_lw,
    input       [3:0]   gfx_en,
    // Pixel output
    output      [3:0]   red,
    output      [3:0]   green,
    output      [3:0]   blue
);

localparam       LAYOUT      = 9;
localparam       CHRPW       = 6;
localparam       SCRPW       = 8;
localparam       OBJPW       = 8;
localparam       SCR_OFFSET  = 6;
localparam       CHAR_OFFSET = 4;
localparam       OBJ_DLY     = 6;
localparam       BLANK_DLY   = 3;
localparam [9:0] OBJMAX      = 10'h3FF; // DMA buffer 512 bytes = 4*128
localparam [5:0] OBJMAX_LINE = 6'd32;


wire [CHRPW-1:0] char_pxl;
wire [OBJPW-1:0] obj_pxl;
wire [SCRPW-1:0] scr1_pxl, scr2_pxl;
wire [     11:0] obj_ram = main_ram[11:0];


`ifndef NOCHAR
jtgng_char #(
    .HOFFSET ( CHAR_OFFSET ),
    .ROM_AW  ( CHARW       ),
    .VFLIP   (  3          ),
    .HFLIP   (  2          ),
    .LAYOUT  (  LAYOUT     )
) u_char (
    .clk        ( clk           ),
    .pxl_cen    ( pxl_cen       ),
    .cpu_cen    ( cpu_cen       ),
    .AB         ( cpu_AB[11:1]  ),
    .V          ( V[7:0]        ),
    .H          ( H             ),
    .flip       ( flip          ),
    .din        ( cpu_dout      ),
    .dout       ( char_dout     ),
    // Bus arbitrion
    .char_cs    ( char_cs       ),
    .wr_n       ( RnW           ),
    .dseln      ( {UDSWn, LDSWn}),
    .busy       ( char_busy     ),
    // Pause screen
    .pause      ( 1'b0          ),
    .scan       (               ),
    .msg_low    ( 8'd0          ),
    .msg_high   ( 8'd0          ),
    // ROM
    .char_addr  ( char_addr     ),
    .rom_data   ( char_data     ),
    .rom_ok     ( char_ok       ),
    // Pixel output
    .char_on    ( charon        ),
    .char_pxl   ( char_pxl      ),
    // unused
    .prog_addr  (               ),
    .prog_din   (               ),
    .prom_we    (               )
);
`else
assign char_pxl  = {CHRPW{1'b1}};
assign char_mrdy = 1;
`endif

`ifndef NOSCR
jtsf_scroll #(
    .ROM_AW     ( SCR1W       ),
    .HOFFSET    ( SCR_OFFSET  )
) u_scroll1 (
    .rst          ( rst           ),
    .clk          ( clk           ),
    .pxl2_cen     ( pxl2_cen      ),
    .V            ( V[7:0]        ),
    .H            ( H             ),
    .SCxON        ( scr1on        ),
    .hpos         ( scr1posh      ),
    .flip         ( flip          ),
    // ROM
    .map_addr     ( map1_addr     ),
    .map_data     ( map1_data     ),
    .map_ok       ( map1_ok       ),
    .scr_addr     ( scr1_addr     ),
    .scr_data     ( scr1_data     ),
    .scr_ok       ( scr1_ok       ),
    .scr_pxl      ( scr1_pxl      )
);

jtsf_scroll #(
    .ROM_AW     ( SCR2W       ),
    .HOFFSET    ( SCR_OFFSET  )
) u_scroll2 (
    .rst          ( rst           ),
    .clk          ( clk           ),
    .pxl2_cen     ( pxl2_cen      ),
    .V            ( V[7:0]        ),
    .H            ( H             ),
    .SCxON        ( scr2on        ),
    .hpos         ( scr2posh      ),
    .flip         ( flip          ),
    // ROM
    .map_addr     ( map2_addr     ),
    .map_data     ( map2_data     ),
    .map_ok       ( map2_ok       ),
    .scr_addr     ( scr2_addr     ),
    .scr_data     ( scr2_data     ),
    .scr_ok       ( scr2_ok       ),
    .scr_pxl      ( scr2_pxl      )
);
`else
assign scr1_pxl  = {SCRPW{1'b0}};
assign scr2_pxl  = {SCRPW{1'b0}};
assign map1_addr = {MAP2W{1'b0}};
assign map2_addr = {MAP2W{1'b0}};
assign scr1_addr = {SCR2W{1'b0}};
assign scr2_addr = {SCR2W{1'b0}};
`endif

wire [9:0] raw_addr;

//assign obj_AB = { raw_addr[9:2], 3'b111, raw_addr[1:0] }; // 12 bits
//assign obj_AB = { raw_addr[9:2], 3'b110, raw_addr[1:0] }; // 12 bits
//assign obj_AB = { raw_addr[9:2], 3'b101, raw_addr[1:0] }; // 12 bits

//assign obj_AB = { raw_addr[9:2], 3'b100, raw_addr[1:0] }; // 12 bits
//assign obj_AB = { raw_addr[9:2], 3'b011, raw_addr[1:0] }; // 12 bits
assign obj_AB = { 2'b10, raw_addr[9:3], 1'b0, raw_addr[2:0] }; // 12 bits

// Memories on B board (object generator)
// 4x TMM2015 together = 4 x 1 kB = 4 kB or 2 kWord = full obj table
// 2x TMM2015 together = 2 x 1 kB = 2 kB or 1kWord = line obj table
// 2x TMM2018 together = 2 x 2 kB = 4 kB = line buffers
// DMAW = 2 kWord = 11 bits
// 8MHz read/write clock, 16 pixel objects -> max 32 objects
// OBJ ROM size < 2 MB = 2^14 OBJ --> probably DMA DW is 14 (Bionic Commando was 12)

`ifndef NOOBJ
jtgng_obj #(
    .ROM_AW       ( OBJW        ),
    .DMA_AW       ( 10          ),
    .DMA_DW       ( 16          ),
    .PALW         ( OBJPW-4     ),
    .PXL_DLY      ( OBJ_DLY     ),
    .LAYOUT       ( LAYOUT      ),
    // Same as Tiger Road
    .OBJMAX       ( OBJMAX      ),
    .OBJMAX_LINE  ( OBJMAX_LINE )
) u_obj (
    .rst        ( rst         ),
    .clk        ( clk         ),
    .draw_cen   ( pxl2_cen    ),
    .dma_cen    ( pxl_cen     ),
    .pxl_cen    ( pxl_cen     ),
    // CPU bus
    .AB         ( raw_addr    ),
    .DB         ( main_ram    ),
    .OKOUT      ( OKOUT       ),
    .bus_req    ( bus_req     ),
    .bus_ack    ( bus_ack     ),
    .blen       ( blcnten     ),
    .LHBL       ( LHBL        ),
    .LVBL       ( LVBL        ),
    .LVBL_obj   ( LVBL        ),
    .HINIT      ( HINIT       ),
    .flip       ( flip        ),
    .V          ( V[7:0]      ),
    .H          ( H           ),
    .OBJON      ( objon       ),
    // avatar display
    .pause      ( 1'b0        ),
    .avatar_idx (             ),
    // SDRAM interface
    .obj_addr   ( obj_addr    ),
    .obj_data   ( obj_data    ),
    .rom_ok     ( obj_ok      ),
    // pixel data
    .obj_pxl    ( obj_pxl     ),
    // unused
    .prog_addr  (             ),
    .prog_din   (             ),
    .prom_hi_we ( 1'b0        ),
    .prom_lo_we ( 1'b0        )
);
`else
assign blcnten = 1'b0;
assign bus_req = 1'b0;
assign obj_pxl = {OBJPW{1'b1}};
`endif

`ifndef NOCOLMIX
jtsf_colmix #(
    .CHRPW     ( CHRPW     ),
    .SCRPW     ( SCRPW     ),
    .OBJPW     ( OBJPW     ),
    .BLANK_DLY ( BLANK_DLY )
)
u_colmix (
    .rst          ( rst           ),
    .clk          ( clk           ),
    .pxl_cen      ( pxl_cen       ),
    .cpu_cen      ( cpu_cen       ),

    .char_pxl     ( char_pxl      ),
    .scr1_pxl     ( scr1_pxl      ),
    .scr2_pxl     ( scr2_pxl      ),
    .obj_pxl      ( obj_pxl       ),
    .LVBL         ( LVBL          ),
    .LHBL         ( LHBL          ),
    .LHBL_dly     ( LHBL_dly      ),
    .LVBL_dly     ( LVBL_dly      ),

    // Enable bits
    // .charon       ( charon        ),
    // .scr1on       ( scr1on        ),
    // .scr2on       ( scr2on        ),
    // .objon        ( objon         ),

    // DEBUG
    .gfx_en       ( gfx_en        ),

    // CPU interface
    .AB           ( cpu_AB[10:1]  ),
    .col_uw       ( col_uw        ),
    .col_lw       ( col_lw        ),
    .DB           ( cpu_dout      ),

    // colour output
    .red          ( red           ),
    .green        ( green         ),
    .blue         ( blue          )
);
`else
assign  red = 4'd0;
assign blue = 4'd0;
assign green= 4'd0;
`endif

endmodule