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
    Date: 20-5-2021 */

module jtsf_mcu(
    input                rst,
    input                clk,       // 24MHz
    input                rst_cpu,
    input                clk_cpu,
    input                clk_rom,
    // Main CPU interface
    input        [15:0]  mcu_din,
    output       [15:0]  mcu_dout,
    output               mcu_wr,
    output       [15:1]  mcu_addr,
    output               mcu_sel, // 1 for RAM, 0 for cabinet I/O
    output               mcu_brn,   // RQBSQn
    input                mcu_DMAONn,
    output               mcu_ds,
    input                ram_ok,
    // ROM programming
    input        [11:0]  prog_addr,
    input        [ 7:0]  prom_din,
    input                prom_we
);

wire [15:0] ext_addr;
wire [ 7:0] mcu_dout8;
reg  [ 7:0] mcu_din8;

wire [ 7:0] p1_o, p2_o, p3_o;
reg         int0n;
assign      mcu_ds = p3_o[4];

// interface with main CPU
wire [7:0] p3_os;
assign mcu_addr = ext_addr[14:0];
assign mcu_brn  = int0n;
assign mcu_dout = {2{mcu_dout8}};
reg    last_mcu_DMAONn;

reg [5:0] cencnt=1;
// If the original was 8MHz, the cen should be about 8/12=24/cen -> cen ~ 36
wire cen1 = (mcu_sel & ~mcu_brn & ~ram_ok) ? 0 : cencnt==0;

assign mcu_sel = ext_addr[15];

// Clock enable for 8MHz, like MAME. I need to measure it on the PCB
// The current i8751 softcore isn't cycle accurate, so it isn't
// really relevant now
always @(posedge clk) cencnt <= cencnt==35 ? 0 : cencnt+1'd1;

jtframe_sync #(.W(8)) u_p3sync(
    .clk    ( clk_cpu   ),
    .raw    ( p3_o      ),
    .sync   ( p3_os     )
);

wire int0n_mcu;

jtframe_sync #(.W(8)) u_intsync(
    .clk    ( clk_cpu   ),
    .raw    ( int0n     ),
    .sync   ( int0n_mcu )
);

always @(posedge clk_cpu, posedge rst_cpu) begin
    if( rst_cpu ) begin
        int0n <= 1;
        last_mcu_DMAONn <= 1;
    end else begin
        last_mcu_DMAONn <= mcu_DMAONn;
        if( !p3_os[1] ) // CLR
            int0n <= 1;
        else if( mcu_DMAONn && !last_mcu_DMAONn )
            int0n <= 0;
    end
end



wire [15:0] mcu_din_s;

always @(*)
    mcu_din8 = !mcu_ds ? mcu_din_s[15:8] : mcu_din_s[7:0];

jtframe_sync #(.W(16)) u_sync(
    .clk    ( clk       ),
    .raw    ( mcu_din   ),
    .sync   ( mcu_din_s )
);

jtframe_8751mcu #(.SINC_XDATA(1)) u_mcu(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .cen        ( cen1      ),

    .int0n      ( int0n_mcu ),
    .int1n      ( 1'b1      ),

    .p0_i       ( p0_o      ),
    .p0_o       ( p0_o      ),

    .p1_i       ( p1_o      ),
    .p1_o       ( p1_o      ),

    .p2_i       ( p2_o      ),
    .p2_o       ( p2_o      ),

    .p3_i       ( p3_i      ),
    .p3_o       ( p3_o      ),

    // external memory
    .x_din      ( mcu_din8  ),
    .x_dout     ( mcu_dout8 ),
    .x_addr     ( ext_addr  ),
    .x_wr       ( mcu_wr    ),

    // ROM programming
    .clk_rom    ( clk_rom   ),
    .prog_addr  ( prog_addr ),
    .prom_din   ( prom_din  ),
    .prom_we    ( prom_we   )
);

`ifdef SIMULATION
always @(negedge int0n)
    $display ("MCU: int0n edge - main CPU");
`endif
endmodule