// jts16b_game_sdram.v is automatically generated by JTFRAME
// Do not modify it
// Do not add it to git

`ifndef JTFRAME_COLORW
`define JTFRAME_COLORW 4
`endif

`ifndef JTFRAME_BUTTONS
`define JTFRAME_BUTTONS 2
`endif

module jts16b_game_sdram(
    `include "jtframe_common_ports.inc"
    `include "jtframe_mem_ports.inc"
);

/* verilator lint_off WIDTH */
`ifdef JTFRAME_BA1_START
    localparam [24:0] BA1_START=`JTFRAME_BA1_START;
`endif
`ifdef JTFRAME_BA2_START
    localparam [24:0] BA2_START=`JTFRAME_BA2_START;
`endif
`ifdef JTFRAME_BA3_START
    localparam [24:0] BA3_START=`JTFRAME_BA3_START;
`endif
`ifdef JTFRAME_PROM_START
    localparam [24:0] PROM_START=`JTFRAME_PROM_START;
`endif
/* verilator lint_on WIDTH */


parameter MCU_PROM = `MCU_START;
parameter N7751_PROM = `N7751_START;
parameter KEY_PROM = `MAINKEY_START;
parameter MC8123_PROM = `SNDKEY_START;
parameter FD_PROM = `FD1089_START;
parameter PCM_OFFSET = (`PCM_START-BA1_START)>>1;
parameter VRAM_OFFSET = 22'h10_0000;
parameter SRAM_OFFSET = 22'h18_0000;

`ifndef JTFRAME_IOCTL_RD
wire ioctl_ram = 0;
`endif
// Additional ports
wire  gfx_cs;

// BRAM buses
// SDRAM buses

wire [18:1] xram_addr;
wire [15:0] xram_data;
wire        xram_cs, xram_ok;
wire        xram_we;
wire [15:0] xram_din;
wire [ 1:0] xram_dsn;

wire [18:1] main_addr;
wire [15:0] main_data;
wire        main_cs, main_ok;
wire [15:1] map1_addr;
wire [15:0] map1_data;
wire        map1_cs, map1_ok;
wire [15:1] map2_addr;
wire [15:0] map2_data;
wire        map2_cs, map2_ok;
wire [18:0] snd_addr;
wire [ 7:0] snd_data;
wire        snd_cs, snd_ok;
wire [16:0] pcm_addr;
wire [ 7:0] pcm_data;
wire        pcm_cs, pcm_ok;
wire [19:2] char_addr;
wire [31:0] char_data;
wire        char_cs, char_ok;
wire [19:2] scr1_addr;
wire [31:0] scr1_data;
wire        scr1_cs, scr1_ok;
wire [19:2] scr2_addr;
wire [31:0] scr2_data;
wire        scr2_cs, scr2_ok;
wire [20:1] obj_addr;
wire [15:0] obj_data;
wire        obj_cs, obj_ok;
wire        prom_we, header;
wire [21:0] raw_addr, post_addr;
wire [24:0] pre_addr, dwnld_addr;
wire [ 7:0] post_data;
wire [15:0] raw_data;
wire        pass_io;

assign pass_io = header | ioctl_ram;

jts16_game u_game(
    .rst        ( rst       ),
    .clk        ( clk       ),
`ifdef JTFRAME_CLK24
    .rst24      ( rst24     ),
    .clk24      ( clk24     ),
`endif
`ifdef JTFRAME_CLK48
    .rst48      ( rst48     ),
    .clk48      ( clk48     ),
`endif
    .pxl2_cen       ( pxl2_cen      ),
    .pxl_cen        ( pxl_cen       ),
    .red            ( red           ),
    .green          ( green         ),
    .blue           ( blue          ),
    .LHBL           ( LHBL          ),
    .LVBL           ( LVBL          ),
    .HS             ( HS            ),
    .VS             ( VS            ),
    // cabinet I/O
    .start_button   ( start_button  ),
    .coin_input     ( coin_input    ),
    .joystick1      ( joystick1     ),
    .joystick2      ( joystick2     ),
    `ifdef JTFRAME_4PLAYERS
    .joystick3      ( joystick3     ),
    .joystick4      ( joystick4     ),
    `endif
`ifdef JTFRAME_ANALOG
    .joyana_l1    ( joyana_l1        ),
    .joyana_l2    ( joyana_l2        ),
    `ifdef JTFRAME_ANALOG_DUAL
        .joyana_r1    ( joyana_r1        ),
        .joyana_r2    ( joyana_r2        ),
    `endif
    `ifdef JTFRAME_4PLAYERS
        .joyana_l3( joyana_l3        ),
        .joyana_l4( joyana_l4        ),
        `ifdef JTFRAME_ANALOG_DUAL
            .joyana_r3( joyana_r3        ),
            .joyana_r4( joyana_r4        ),
        `endif
    `endif
`endif
    // DIP switches
    .status         ( status        ),
    .dipsw          ( dipsw         ),
    .service        ( service       ),
    .tilt           ( tilt          ),
    .dip_pause      ( dip_pause     ),
    .dip_flip       ( dip_flip      ),
    .dip_test       ( dip_test      ),
    .dip_fxlevel    ( dip_fxlevel   ),
    // Sound output
`ifdef JTFRAME_STEREO
    .snd_left       ( snd_left      ),
    .snd_right      ( snd_right     ),
`else
    .snd            ( snd           ),
`endif
    .sample         ( sample        ),
    .game_led       ( game_led      ),
    .enable_psg     ( enable_psg    ),
    .enable_fm      ( enable_fm     ),
    // Ports declared in mem.yaml
    .gfx_cs   ( gfx_cs ),
    // Memory interface - SDRAM
    .xram_addr ( xram_addr ),
    .xram_cs   ( xram_cs   ),
    .xram_ok   ( xram_ok   ),
    .xram_data ( xram_data ),
    .xram_we   ( xram_we   ),
    .xram_dsn  ( xram_dsn  ),
    .xram_din  ( xram_din  ),
    
    .main_addr ( main_addr ),
    .main_cs   ( main_cs   ),
    .main_ok   ( main_ok   ),
    .main_data ( main_data ),
    
    .map1_addr ( map1_addr ),
    .map1_ok   ( map1_ok   ),
    .map1_data ( map1_data ),
    
    .map2_addr ( map2_addr ),
    .map2_ok   ( map2_ok   ),
    .map2_data ( map2_data ),
    
    .snd_addr ( snd_addr ),
    .snd_cs   ( snd_cs   ),
    .snd_ok   ( snd_ok   ),
    .snd_data ( snd_data ),
    
    .pcm_addr ( pcm_addr ),
    .pcm_cs   ( pcm_cs   ),
    .pcm_ok   ( pcm_ok   ),
    .pcm_data ( pcm_data ),
    
    .char_addr ( char_addr ),
    .char_ok   ( char_ok   ),
    .char_data ( char_data ),
    
    .scr1_addr ( scr1_addr ),
    .scr1_ok   ( scr1_ok   ),
    .scr1_data ( scr1_data ),
    
    .scr2_addr ( scr2_addr ),
    .scr2_ok   ( scr2_ok   ),
    .scr2_data ( scr2_data ),
    
    .obj_addr ( obj_addr ),
    .obj_cs   ( obj_cs   ),
    .obj_ok   ( obj_ok   ),
    .obj_data ( obj_data ),
    
    // Memory interface - BRAM
    // PROM writting
    .ioctl_addr   ( ioctl_addr     ),
    .prog_addr    ( pass_io ? ioctl_addr[21:0] : raw_addr      ),
    .prog_data    ( pass_io ? ioctl_dout       : raw_data[7:0] ),
    .prog_we      ( pass_io ? ioctl_wr         : prog_we       ),
    .prog_ba      ( prog_ba        ), // prog_ba supplied in case it helps re-mapping addresses
`ifdef JTFRAME_PROM_START
    .prom_we      ( prom_we        ),
`endif
`ifdef JTFRAME_HEADER
    .header       ( header         ),
`endif
`ifdef JTFRAME_IOCTL_RD
    .ioctl_ram    ( ioctl_ram      ),
    .ioctl_din    ( ioctl_din      ),
`endif
    // Debug  
    .debug_bus    ( debug_bus      ),
    .debug_view   ( debug_view     ),
`ifdef JTFRAME_STATUS
    .st_addr      ( st_addr        ),
    .st_dout      ( st_dout        ),
`endif
`ifdef JTFRAME_LF_BUFFER
    .game_vrender( game_vrender  ),
    .game_hdump  ( game_hdump    ),
    .ln_addr     ( ln_addr       ),
    .ln_data     ( ln_data       ),
    .ln_done     ( ln_done       ),
    .ln_hs       ( ln_hs         ),
    .ln_pxl      ( ln_pxl        ),
    .ln_v        ( ln_v          ),
    .ln_we       ( ln_we         ),
`endif
    .gfx_en      ( gfx_en        )
);

assign dwnld_busy = downloading | prom_we; // prom_we is really just for sims
assign dwnld_addr = ioctl_addr;
assign prog_addr = raw_addr;
assign prog_data = raw_data;

jtframe_dwnld #(
`ifdef JTFRAME_HEADER
    .HEADER    ( `JTFRAME_HEADER   ),
`endif
`ifdef JTFRAME_BA1_START
    .BA1_START ( BA1_START ),
`endif
`ifdef JTFRAME_BA2_START
    .BA2_START ( BA2_START ),
`endif
`ifdef JTFRAME_BA3_START
    .BA3_START ( BA3_START ),
`endif
`ifdef JTFRAME_PROM_START
    .PROM_START( PROM_START ),
`endif
    .SWAB      ( 1         )
) u_dwnld(
    .clk          ( clk            ),
    .downloading  ( downloading & ~ioctl_ram    ),
    .ioctl_addr   ( dwnld_addr     ),
    .ioctl_dout   ( ioctl_dout     ),
    .ioctl_wr     ( ioctl_wr       ),
    .prog_addr    ( raw_addr       ),
    .prog_data    ( raw_data       ),
    .prog_mask    ( prog_mask      ), // active low
    .prog_we      ( prog_we        ),
    .prog_rd      ( prog_rd        ),
    .prog_ba      ( prog_ba        ),
    .prom_we      ( prom_we        ),
    .header       ( header         ),
    .sdram_ack    ( prog_ack       )
);


/* verilator tracing_off */
jtframe_ram1_4slots #(
    // xram
    .SLOT0_AW(18),
    .SLOT0_DW(16), 
    // main
    .SLOT1_AW(18),
    .SLOT1_DW(16), 
    // map1
    .SLOT2_OFFSET(VRAM_OFFSET[21:0]),
    .SLOT2_AW(15),
    .SLOT2_DW(16), 
    // map2
    .SLOT3_OFFSET(VRAM_OFFSET[21:0]),
    .SLOT3_AW(15),
    .SLOT3_DW(16)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT1_DOUBLE(1)
    ,.SLOT2_DOUBLE(1)
    ,.SLOT3_DOUBLE(1)
`endif
) u_bank0(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( xram_addr  ),
    .slot0_wen   ( xram_we    ),
    .slot0_din   ( xram_din   ),
    .slot0_wrmask( xram_dsn   ),
    .slot0_offset( VRAM_OFFSET[21:0] ), 
    .slot0_dout  ( xram_data  ),
    .slot0_cs    ( xram_cs    ),
    .slot0_ok    ( xram_ok    ),
    
    .slot1_addr  ( main_addr  ),
    .slot1_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot1_dout  ( main_data  ),
    .slot1_cs    ( main_cs    ),
    .slot1_ok    ( main_ok    ),
    
    .slot2_addr  ( map1_addr  ),
    .slot2_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot2_dout  ( map1_data  ),
    .slot2_cs    ( gfx_cs    ),
    .slot2_ok    ( map1_ok    ),
    
    .slot3_addr  ( map2_addr  ),
    .slot3_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot3_dout  ( map2_data  ),
    .slot3_cs    ( gfx_cs    ),
    .slot3_ok    ( map2_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[0]  ),
    .sdram_rd    ( ba_rd[0]   ),
    .sdram_addr  ( ba0_addr   ),
    .sdram_wr    ( ba_wr[0]   ),
    .sdram_wrmask( ba0_dsn    ),
    .data_write  ( ba0_din    ),
    .data_dst    ( ba_dst[0]  ),
    .data_rdy    ( ba_rdy[0]  ),
    .data_read   ( data_read  )
);
/* verilator tracing_off */
jtframe_rom_2slots #(
    // snd
    .SLOT0_AW(19),
    .SLOT0_DW( 8), 
    // pcm
    .SLOT1_OFFSET(PCM_OFFSET[21:0]),
    .SLOT1_AW(17),
    .SLOT1_DW( 8)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
    ,.SLOT1_DOUBLE(1)
`endif
) u_bank1(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( snd_addr  ),
    .slot0_dout  ( snd_data  ),
    .slot0_cs    ( snd_cs    ),
    .slot0_ok    ( snd_ok    ),
    
    .slot1_addr  ( pcm_addr  ),
    .slot1_dout  ( pcm_data  ),
    .slot1_cs    ( pcm_cs    ),
    .slot1_ok    ( pcm_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[1]  ),
    .sdram_rd    ( ba_rd[1]   ),
    .sdram_addr  ( ba1_addr   ),
    .data_dst    ( ba_dst[1]  ),
    .data_rdy    ( ba_rdy[1]  ),
    .data_read   ( data_read  )
);
assign ba_wr[1] = 0;
assign ba1_din  = 0;
assign ba1_dsn  = 3;
/* verilator tracing_off */
jtframe_rom_3slots #(
    // char
    .SLOT0_AW(19),
    .SLOT0_DW(32), 
    // scr1
    .SLOT1_AW(19),
    .SLOT1_DW(32), 
    // scr2
    .SLOT2_AW(19),
    .SLOT2_DW(32)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
    ,.SLOT1_DOUBLE(1)
    ,.SLOT2_DOUBLE(1)
`endif
) u_bank2(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( { char_addr, 1'b0 } ),
    .slot0_dout  ( char_data  ),
    .slot0_cs    ( gfx_cs    ),
    .slot0_ok    ( char_ok    ),
    
    .slot1_addr  ( { scr1_addr, 1'b0 } ),
    .slot1_dout  ( scr1_data  ),
    .slot1_cs    ( gfx_cs    ),
    .slot1_ok    ( scr1_ok    ),
    
    .slot2_addr  ( { scr2_addr, 1'b0 } ),
    .slot2_dout  ( scr2_data  ),
    .slot2_cs    ( gfx_cs    ),
    .slot2_ok    ( scr2_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[2]  ),
    .sdram_rd    ( ba_rd[2]   ),
    .sdram_addr  ( ba2_addr   ),
    .data_dst    ( ba_dst[2]  ),
    .data_rdy    ( ba_rdy[2]  ),
    .data_read   ( data_read  )
);
assign ba_wr[2] = 0;
assign ba2_din  = 0;
assign ba2_dsn  = 3;
/* verilator tracing_off */
jtframe_rom_1slot #(
    // obj
    .SLOT0_AW(20),
    .SLOT0_DW(16)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
`endif
) u_bank3(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( obj_addr  ),
    .slot0_dout  ( obj_data  ),
    .slot0_cs    ( obj_cs    ),
    .slot0_ok    ( obj_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[3]  ),
    .sdram_rd    ( ba_rd[3]   ),
    .sdram_addr  ( ba3_addr   ),
    .data_dst    ( ba_dst[3]  ),
    .data_rdy    ( ba_rdy[3]  ),
    .data_read   ( data_read  )
);
assign ba_wr[3] = 0;
assign ba3_din  = 0;
assign ba3_dsn  = 3;


endmodule