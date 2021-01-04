//-
// Copyright (c) 2020-2021 Jessica Clarke
//
// @BERI_LICENSE_HEADER_START@
//
// Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  BERI licenses this
// file to you under the BERI Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.beri-open-systems.org/legal/license-1-0.txt
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @BERI_LICENSE_HEADER_END@
//

module garnet_ddr #(
  parameter integer ENABLE = 1
) (
  input clk,
  input resetn,

  input ddr4_sdram_sys_clk_n,
  input ddr4_sdram_sys_clk_p,

  output ddr4_sdram_act_n,
  output [16:0] ddr4_sdram_adr,
  output [1:0] ddr4_sdram_ba,
  output ddr4_sdram_bg,
  output ddr4_sdram_ck_n,
  output ddr4_sdram_ck_p,
  output ddr4_sdram_cke,
  output ddr4_sdram_cs_n,
  inout [7:0] ddr4_sdram_dm_dbi_n,
  inout [63:0] ddr4_sdram_dq,
  inout [7:0] ddr4_sdram_dqs_n,
  inout [7:0] ddr4_sdram_dqs_p,
  output ddr4_sdram_odt,
  output ddr4_sdram_reset_n,

  output DDR_init_calib_complete,

  input [63:0] DDR_S_AXI_araddr,
  input [1:0] DDR_S_AXI_arburst,
  input [3:0] DDR_S_AXI_arcache,
  input [5:0] DDR_S_AXI_arid,
  input [7:0] DDR_S_AXI_arlen,
  input [0:0] DDR_S_AXI_arlock,
  input [2:0] DDR_S_AXI_arprot,
  input [3:0] DDR_S_AXI_arqos,
  output DDR_S_AXI_arready,
  input [3:0] DDR_S_AXI_arregion,
  input [2:0] DDR_S_AXI_arsize,
  input DDR_S_AXI_arvalid,
  input [63:0] DDR_S_AXI_awaddr,
  input [1:0] DDR_S_AXI_awburst,
  input [3:0] DDR_S_AXI_awcache,
  input [5:0] DDR_S_AXI_awid,
  input [7:0] DDR_S_AXI_awlen,
  input [0:0] DDR_S_AXI_awlock,
  input [2:0] DDR_S_AXI_awprot,
  input [3:0] DDR_S_AXI_awqos,
  output DDR_S_AXI_awready,
  input [3:0] DDR_S_AXI_awregion,
  input [2:0] DDR_S_AXI_awsize,
  input DDR_S_AXI_awvalid,
  output [5:0] DDR_S_AXI_bid,
  input DDR_S_AXI_bready,
  output [1:0] DDR_S_AXI_bresp,
  output DDR_S_AXI_bvalid,
  output [511:0] DDR_S_AXI_rdata,
  output [5:0] DDR_S_AXI_rid,
  output DDR_S_AXI_rlast,
  input DDR_S_AXI_rready,
  output [1:0] DDR_S_AXI_rresp,
  output DDR_S_AXI_rvalid,
  input [511:0] DDR_S_AXI_wdata,
  input DDR_S_AXI_wlast,
  output DDR_S_AXI_wready,
  input [63:0] DDR_S_AXI_wstrb,
  input DDR_S_AXI_wvalid
);

  genvar i;
  generate
    if (ENABLE) begin
      wire DDR_ui_clk;
      wire DDR_ui_clk_sync_reset;

      wire c0_init_calib_complete;

      // Pipeline reset

      (* DONT_TOUCH = "TRUE" *)
      wire resetn_pipe;

      pipeline #(
        .WIDTH(1),
        .DEPTH(4)
      ) pipeline_resetn (
        .clk(clk),
        .resetn(1'b1),

        .reset_data(1'b0),

        .in_data(resetn),
        .out_data(resetn_pipe)
      );

      // Synchronise calibration complete to main clock

      (* ASYNC_REG = "TRUE" *)
      reg c0_init_calib_complete_meta;
      (* ASYNC_REG = "TRUE" *)
      reg c0_init_calib_complete_sync;

      always @(posedge clk) begin
        c0_init_calib_complete_meta <= c0_init_calib_complete;
        c0_init_calib_complete_sync <= c0_init_calib_complete_meta;
      end

      // Pipeline calibration complete

      (* DONT_TOUCH = "TRUE" *)
      wire c0_init_calib_complete_pipe;

      pipeline #(
        .WIDTH(1),
        .DEPTH(4)
      ) pipeline_init_calib_complete (
        .clk(clk),
        .resetn(1'b1),

        .reset_data(1'b0),

        .in_data(c0_init_calib_complete_sync),
        .out_data(c0_init_calib_complete_pipe)
      );

      assign DDR_init_calib_complete = c0_init_calib_complete_pipe;

      // Convert AXI interface to DDR clock

      wire [30:0] DDR_M_AXI_araddr;
      wire [1:0] DDR_M_AXI_arburst;
      wire [3:0] DDR_M_AXI_arcache;
      wire [5:0] DDR_M_AXI_arid;
      wire [7:0] DDR_M_AXI_arlen;
      wire [0:0] DDR_M_AXI_arlock;
      wire [2:0] DDR_M_AXI_arprot;
      wire [3:0] DDR_M_AXI_arqos;
      wire DDR_M_AXI_arready;
      wire [3:0] DDR_M_AXI_arregion;
      wire [2:0] DDR_M_AXI_arsize;
      wire DDR_M_AXI_arvalid;
      wire [30:0] DDR_M_AXI_awaddr;
      wire [1:0] DDR_M_AXI_awburst;
      wire [3:0] DDR_M_AXI_awcache;
      wire [5:0] DDR_M_AXI_awid;
      wire [7:0] DDR_M_AXI_awlen;
      wire [0:0] DDR_M_AXI_awlock;
      wire [2:0] DDR_M_AXI_awprot;
      wire [3:0] DDR_M_AXI_awqos;
      wire DDR_M_AXI_awready;
      wire [3:0] DDR_M_AXI_awregion;
      wire [2:0] DDR_M_AXI_awsize;
      wire DDR_M_AXI_awvalid;
      wire [5:0] DDR_M_AXI_bid;
      wire DDR_M_AXI_bready;
      wire [1:0] DDR_M_AXI_bresp;
      wire DDR_M_AXI_bvalid;
      wire [511:0] DDR_M_AXI_rdata;
      wire [5:0] DDR_M_AXI_rid;
      wire DDR_M_AXI_rlast;
      wire DDR_M_AXI_rready;
      wire [1:0] DDR_M_AXI_rresp;
      wire DDR_M_AXI_rvalid;
      wire [511:0] DDR_M_AXI_wdata;
      wire DDR_M_AXI_wlast;
      wire DDR_M_AXI_wready;
      wire [63:0] DDR_M_AXI_wstrb;
      wire DDR_M_AXI_wvalid;

      axi_clock_converter_ddr4 DDR_axi_clock_converter (
        .s_axi_aclk(clk),
        .s_axi_aresetn(resetn_pipe),

        .s_axi_awid(DDR_S_AXI_awid),
        .s_axi_awaddr(DDR_S_AXI_awaddr[30:0]),
        .s_axi_awlen(DDR_S_AXI_awlen),
        .s_axi_awsize(DDR_S_AXI_awsize),
        .s_axi_awburst(DDR_S_AXI_awburst),
        .s_axi_awlock(DDR_S_AXI_awlock),
        .s_axi_awcache(DDR_S_AXI_awcache),
        .s_axi_awprot(DDR_S_AXI_awprot),
        .s_axi_awregion(DDR_S_AXI_awregion),
        .s_axi_awqos(DDR_S_AXI_awqos),
        .s_axi_awvalid(DDR_S_AXI_awvalid),
        .s_axi_awready(DDR_S_AXI_awready),
        .s_axi_wdata(DDR_S_AXI_wdata),
        .s_axi_wstrb(DDR_S_AXI_wstrb),
        .s_axi_wlast(DDR_S_AXI_wlast),
        .s_axi_wvalid(DDR_S_AXI_wvalid),
        .s_axi_wready(DDR_S_AXI_wready),
        .s_axi_bid(DDR_S_AXI_bid),
        .s_axi_bresp(DDR_S_AXI_bresp),
        .s_axi_bvalid(DDR_S_AXI_bvalid),
        .s_axi_bready(DDR_S_AXI_bready),
        .s_axi_arid(DDR_S_AXI_arid),
        .s_axi_araddr(DDR_S_AXI_araddr[30:0]),
        .s_axi_arlen(DDR_S_AXI_arlen),
        .s_axi_arsize(DDR_S_AXI_arsize),
        .s_axi_arburst(DDR_S_AXI_arburst),
        .s_axi_arlock(DDR_S_AXI_arlock),
        .s_axi_arcache(DDR_S_AXI_arcache),
        .s_axi_arprot(DDR_S_AXI_arprot),
        .s_axi_arregion(DDR_S_AXI_arregion),
        .s_axi_arqos(DDR_S_AXI_arqos),
        .s_axi_arvalid(DDR_S_AXI_arvalid),
        .s_axi_arready(DDR_S_AXI_arready),
        .s_axi_rid(DDR_S_AXI_rid),
        .s_axi_rdata(DDR_S_AXI_rdata),
        .s_axi_rresp(DDR_S_AXI_rresp),
        .s_axi_rlast(DDR_S_AXI_rlast),
        .s_axi_rvalid(DDR_S_AXI_rvalid),
        .s_axi_rready(DDR_S_AXI_rready),

        .m_axi_aclk(DDR_ui_clk),
        .m_axi_aresetn(!DDR_ui_clk_sync_reset),

        .m_axi_awid(DDR_M_AXI_awid),
        .m_axi_awaddr(DDR_M_AXI_awaddr),
        .m_axi_awlen(DDR_M_AXI_awlen),
        .m_axi_awsize(DDR_M_AXI_awsize),
        .m_axi_awburst(DDR_M_AXI_awburst),
        .m_axi_awlock(DDR_M_AXI_awlock),
        .m_axi_awcache(DDR_M_AXI_awcache),
        .m_axi_awprot(DDR_M_AXI_awprot),
        .m_axi_awregion(DDR_M_AXI_awregion),
        .m_axi_awqos(DDR_M_AXI_awqos),
        .m_axi_awvalid(DDR_M_AXI_awvalid),
        .m_axi_awready(DDR_M_AXI_awready),
        .m_axi_wdata(DDR_M_AXI_wdata),
        .m_axi_wstrb(DDR_M_AXI_wstrb),
        .m_axi_wlast(DDR_M_AXI_wlast),
        .m_axi_wvalid(DDR_M_AXI_wvalid),
        .m_axi_wready(DDR_M_AXI_wready),
        .m_axi_bid(DDR_M_AXI_bid),
        .m_axi_bresp(DDR_M_AXI_bresp),
        .m_axi_bvalid(DDR_M_AXI_bvalid),
        .m_axi_bready(DDR_M_AXI_bready),
        .m_axi_arid(DDR_M_AXI_arid),
        .m_axi_araddr(DDR_M_AXI_araddr),
        .m_axi_arlen(DDR_M_AXI_arlen),
        .m_axi_arsize(DDR_M_AXI_arsize),
        .m_axi_arburst(DDR_M_AXI_arburst),
        .m_axi_arlock(DDR_M_AXI_arlock),
        .m_axi_arcache(DDR_M_AXI_arcache),
        .m_axi_arprot(DDR_M_AXI_arprot),
        .m_axi_arregion(DDR_M_AXI_arregion),
        .m_axi_arqos(DDR_M_AXI_arqos),
        .m_axi_arvalid(DDR_M_AXI_arvalid),
        .m_axi_arready(DDR_M_AXI_arready),
        .m_axi_rid(DDR_M_AXI_rid),
        .m_axi_rdata(DDR_M_AXI_rdata),
        .m_axi_rresp(DDR_M_AXI_rresp),
        .m_axi_rlast(DDR_M_AXI_rlast),
        .m_axi_rvalid(DDR_M_AXI_rvalid),
        .m_axi_rready(DDR_M_AXI_rready)
      );

      // Instantiate DDR

      ddr4 DDR (
        .c0_sys_clk_p(ddr4_sdram_sys_clk_p),
        .c0_sys_clk_n(ddr4_sdram_sys_clk_n),

        .c0_init_calib_complete(c0_init_calib_complete),

        .dbg_clk(),
        .dbg_bus(),

        .c0_ddr4_adr(ddr4_sdram_adr),
        .c0_ddr4_ba(ddr4_sdram_ba),
        .c0_ddr4_cke(ddr4_sdram_cke),
        .c0_ddr4_cs_n(ddr4_sdram_cs_n),
        .c0_ddr4_dm_dbi_n(ddr4_sdram_dm_dbi_n),
        .c0_ddr4_dq(ddr4_sdram_dq),
        .c0_ddr4_dqs_c(ddr4_sdram_dqs_n),
        .c0_ddr4_dqs_t(ddr4_sdram_dqs_p),
        .c0_ddr4_odt(ddr4_sdram_odt),
        .c0_ddr4_bg(ddr4_sdram_bg),
        .c0_ddr4_reset_n(ddr4_sdram_reset_n),
        .c0_ddr4_act_n(ddr4_sdram_act_n),
        .c0_ddr4_ck_c(ddr4_sdram_ck_n),
        .c0_ddr4_ck_t(ddr4_sdram_ck_p),

        .c0_ddr4_ui_clk(DDR_ui_clk),
        .c0_ddr4_ui_clk_sync_rst(DDR_ui_clk_sync_reset),
        .c0_ddr4_aresetn(1'b1),

        .c0_ddr4_s_axi_awid(DDR_M_AXI_awid),
        .c0_ddr4_s_axi_awaddr(DDR_M_AXI_awaddr),
        .c0_ddr4_s_axi_awlen(DDR_M_AXI_awlen),
        .c0_ddr4_s_axi_awsize(DDR_M_AXI_awsize),
        .c0_ddr4_s_axi_awburst(DDR_M_AXI_awburst),
        .c0_ddr4_s_axi_awlock(DDR_M_AXI_awlock),
        .c0_ddr4_s_axi_awcache(DDR_M_AXI_awcache),
        .c0_ddr4_s_axi_awprot(DDR_M_AXI_awprot),
        .c0_ddr4_s_axi_awqos(DDR_M_AXI_awqos),
        .c0_ddr4_s_axi_awvalid(DDR_M_AXI_awvalid),
        .c0_ddr4_s_axi_awready(DDR_M_AXI_awready),
        .c0_ddr4_s_axi_wdata(DDR_M_AXI_wdata),
        .c0_ddr4_s_axi_wstrb(DDR_M_AXI_wstrb),
        .c0_ddr4_s_axi_wlast(DDR_M_AXI_wlast),
        .c0_ddr4_s_axi_wvalid(DDR_M_AXI_wvalid),
        .c0_ddr4_s_axi_wready(DDR_M_AXI_wready),
        .c0_ddr4_s_axi_bready(DDR_M_AXI_bready),
        .c0_ddr4_s_axi_bid(DDR_M_AXI_bid),
        .c0_ddr4_s_axi_bresp(DDR_M_AXI_bresp),
        .c0_ddr4_s_axi_bvalid(DDR_M_AXI_bvalid),
        .c0_ddr4_s_axi_arid(DDR_M_AXI_arid),
        .c0_ddr4_s_axi_araddr(DDR_M_AXI_araddr),
        .c0_ddr4_s_axi_arlen(DDR_M_AXI_arlen),
        .c0_ddr4_s_axi_arsize(DDR_M_AXI_arsize),
        .c0_ddr4_s_axi_arburst(DDR_M_AXI_arburst),
        .c0_ddr4_s_axi_arlock(DDR_M_AXI_arlock),
        .c0_ddr4_s_axi_arcache(DDR_M_AXI_arcache),
        .c0_ddr4_s_axi_arprot(DDR_M_AXI_arprot),
        .c0_ddr4_s_axi_arqos(DDR_M_AXI_arqos),
        .c0_ddr4_s_axi_arvalid(DDR_M_AXI_arvalid),
        .c0_ddr4_s_axi_arready(DDR_M_AXI_arready),
        .c0_ddr4_s_axi_rready(DDR_M_AXI_rready),
        .c0_ddr4_s_axi_rlast(DDR_M_AXI_rlast),
        .c0_ddr4_s_axi_rvalid(DDR_M_AXI_rvalid),
        .c0_ddr4_s_axi_rresp(DDR_M_AXI_rresp),
        .c0_ddr4_s_axi_rid(DDR_M_AXI_rid),
        .c0_ddr4_s_axi_rdata(DDR_M_AXI_rdata),

        .sys_rst(!resetn_pipe)
      );
    end
    else begin
      (* DONT_TOUCH = "TRUE" *)
      IBUFDS tie_off_sys_clk (.O(), .I(ddr4_sdram_sys_clk_p), .IB(ddr4_sdram_sys_clk_n));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_act_n (.I(1'b1), .O(ddr4_sdram_act_n));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_adr [16:0] (.I(17'b0), .O(ddr4_sdram_adr));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_ba [1:0] (.I(2'b0), .O(ddr4_sdram_ba));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_bg (.I(1'b0), .O(ddr4_sdram_bg));
      (* DONT_TOUCH = "TRUE" *)
      OBUFDS tie_off_ck (.I(1'b0), .O(ddr4_sdram_ck_p), .OB(ddr4_sdram_ck_n));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_cke (.I(1'b0), .O(ddr4_sdram_cke));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_cs_n (.I(1'b0), .O(ddr4_sdram_cs_n));
      (* DONT_TOUCH = "TRUE" *)
      IOBUF tie_off_dm_dbi_n [7:0] (.O(), .I(8'b0), .IO(ddr4_sdram_dm_dbi_n), .T(8'b1));
      (* DONT_TOUCH = "TRUE" *)
      IOBUF tie_off_dq [63:0] (.O(), .I(64'b0), .IO(ddr4_sdram_dq), .T(64'b1));
      (* DONT_TOUCH = "TRUE" *)
      IOBUFDS tie_off_dqs [7:0] (.O(), .I(8'b0), .IO(ddr4_sdram_dqs_p), .IOB(ddr4_sdram_dqs_n), .T(8'b1));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_odt (.I(1'b0), .O(ddr4_sdram_odt));
      (* DONT_TOUCH = "TRUE" *)
      OBUF tie_off_reset_n (.I(1'b1), .O(ddr4_sdram_reset_n));

      assign DDR_init_calib_complete = 1'b0;

      assign DDR_S_AXI_arready = 1'b0;
      assign DDR_S_AXI_awready = 1'b0;
      assign DDR_S_AXI_bid = {6{1'bx}};
      assign DDR_S_AXI_bresp = {2{1'bx}};
      assign DDR_S_AXI_bvalid = 1'b0;
      assign DDR_S_AXI_rdata = {512{1'bx}};
      assign DDR_S_AXI_rid = {6{1'bx}};
      assign DDR_S_AXI_rlast = 1'bx;
      assign DDR_S_AXI_rresp = {2{1'bx}};
      assign DDR_S_AXI_rvalid = 1'b0;
      assign DDR_S_AXI_wready = 1'b0;
    end
  endgenerate

endmodule
