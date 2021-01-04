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

module garnet_ddrs #(
  parameter integer ENABLE_DDRA = 1,
  parameter integer ENABLE_DDRB = 1
) (
  input clk,
  input resetn,

  input ddr4_sdram_c1_sys_clk_n,
  input ddr4_sdram_c1_sys_clk_p,

  output ddr4_sdram_c1_act_n,
  output [16:0] ddr4_sdram_c1_adr,
  output [1:0] ddr4_sdram_c1_ba,
  output ddr4_sdram_c1_bg,
  output ddr4_sdram_c1_ck_n,
  output ddr4_sdram_c1_ck_p,
  output ddr4_sdram_c1_cke,
  output ddr4_sdram_c1_cs_n,
  inout [7:0] ddr4_sdram_c1_dm_dbi_n,
  inout [63:0] ddr4_sdram_c1_dq,
  inout [7:0] ddr4_sdram_c1_dqs_n,
  inout [7:0] ddr4_sdram_c1_dqs_p,
  output ddr4_sdram_c1_odt,
  output ddr4_sdram_c1_reset_n,

  output DDRA_init_calib_complete,

  input [63:0] DDRA_S_AXI_araddr,
  input [1:0] DDRA_S_AXI_arburst,
  input [3:0] DDRA_S_AXI_arcache,
  input [5:0] DDRA_S_AXI_arid,
  input [7:0] DDRA_S_AXI_arlen,
  input [0:0] DDRA_S_AXI_arlock,
  input [2:0] DDRA_S_AXI_arprot,
  input [3:0] DDRA_S_AXI_arqos,
  output DDRA_S_AXI_arready,
  input [3:0] DDRA_S_AXI_arregion,
  input [2:0] DDRA_S_AXI_arsize,
  input DDRA_S_AXI_arvalid,
  input [63:0] DDRA_S_AXI_awaddr,
  input [1:0] DDRA_S_AXI_awburst,
  input [3:0] DDRA_S_AXI_awcache,
  input [5:0] DDRA_S_AXI_awid,
  input [7:0] DDRA_S_AXI_awlen,
  input [0:0] DDRA_S_AXI_awlock,
  input [2:0] DDRA_S_AXI_awprot,
  input [3:0] DDRA_S_AXI_awqos,
  output DDRA_S_AXI_awready,
  input [3:0] DDRA_S_AXI_awregion,
  input [2:0] DDRA_S_AXI_awsize,
  input DDRA_S_AXI_awvalid,
  output [5:0] DDRA_S_AXI_bid,
  input DDRA_S_AXI_bready,
  output [1:0] DDRA_S_AXI_bresp,
  output DDRA_S_AXI_bvalid,
  output [511:0] DDRA_S_AXI_rdata,
  output [5:0] DDRA_S_AXI_rid,
  output DDRA_S_AXI_rlast,
  input DDRA_S_AXI_rready,
  output [1:0] DDRA_S_AXI_rresp,
  output DDRA_S_AXI_rvalid,
  input [511:0] DDRA_S_AXI_wdata,
  input DDRA_S_AXI_wlast,
  output DDRA_S_AXI_wready,
  input [63:0] DDRA_S_AXI_wstrb,
  input DDRA_S_AXI_wvalid,

  input ddr4_sdram_c2_sys_clk_n,
  input ddr4_sdram_c2_sys_clk_p,

  output ddr4_sdram_c2_act_n,
  output [16:0] ddr4_sdram_c2_adr,
  output [1:0] ddr4_sdram_c2_ba,
  output ddr4_sdram_c2_bg,
  output ddr4_sdram_c2_ck_n,
  output ddr4_sdram_c2_ck_p,
  output ddr4_sdram_c2_cke,
  output ddr4_sdram_c2_cs_n,
  inout [7:0] ddr4_sdram_c2_dm_dbi_n,
  inout [63:0] ddr4_sdram_c2_dq,
  inout [7:0] ddr4_sdram_c2_dqs_n,
  inout [7:0] ddr4_sdram_c2_dqs_p,
  output ddr4_sdram_c2_odt,
  output ddr4_sdram_c2_reset_n,

  output DDRB_init_calib_complete,

  input [63:0] DDRB_S_AXI_araddr,
  input [1:0] DDRB_S_AXI_arburst,
  input [3:0] DDRB_S_AXI_arcache,
  input [5:0] DDRB_S_AXI_arid,
  input [7:0] DDRB_S_AXI_arlen,
  input [0:0] DDRB_S_AXI_arlock,
  input [2:0] DDRB_S_AXI_arprot,
  input [3:0] DDRB_S_AXI_arqos,
  output DDRB_S_AXI_arready,
  input [3:0] DDRB_S_AXI_arregion,
  input [2:0] DDRB_S_AXI_arsize,
  input DDRB_S_AXI_arvalid,
  input [63:0] DDRB_S_AXI_awaddr,
  input [1:0] DDRB_S_AXI_awburst,
  input [3:0] DDRB_S_AXI_awcache,
  input [5:0] DDRB_S_AXI_awid,
  input [7:0] DDRB_S_AXI_awlen,
  input [0:0] DDRB_S_AXI_awlock,
  input [2:0] DDRB_S_AXI_awprot,
  input [3:0] DDRB_S_AXI_awqos,
  output DDRB_S_AXI_awready,
  input [3:0] DDRB_S_AXI_awregion,
  input [2:0] DDRB_S_AXI_awsize,
  input DDRB_S_AXI_awvalid,
  output [5:0] DDRB_S_AXI_bid,
  input DDRB_S_AXI_bready,
  output [1:0] DDRB_S_AXI_bresp,
  output DDRB_S_AXI_bvalid,
  output [511:0] DDRB_S_AXI_rdata,
  output [5:0] DDRB_S_AXI_rid,
  output DDRB_S_AXI_rlast,
  input DDRB_S_AXI_rready,
  output [1:0] DDRB_S_AXI_rresp,
  output DDRB_S_AXI_rvalid,
  input [511:0] DDRB_S_AXI_wdata,
  input DDRB_S_AXI_wlast,
  output DDRB_S_AXI_wready,
  input [63:0] DDRB_S_AXI_wstrb,
  input DDRB_S_AXI_wvalid
);

  garnet_ddr #(
    .ENABLE(ENABLE_DDRA)
  ) DDRA (
    .clk(clk),
    .resetn(resetn),

    .ddr4_sdram_sys_clk_n(ddr4_sdram_c1_sys_clk_n),
    .ddr4_sdram_sys_clk_p(ddr4_sdram_c1_sys_clk_p),

    .ddr4_sdram_act_n(ddr4_sdram_c1_act_n),
    .ddr4_sdram_adr(ddr4_sdram_c1_adr),
    .ddr4_sdram_ba(ddr4_sdram_c1_ba),
    .ddr4_sdram_bg(ddr4_sdram_c1_bg),
    .ddr4_sdram_ck_n(ddr4_sdram_c1_ck_n),
    .ddr4_sdram_ck_p(ddr4_sdram_c1_ck_p),
    .ddr4_sdram_cke(ddr4_sdram_c1_cke),
    .ddr4_sdram_cs_n(ddr4_sdram_c1_cs_n),
    .ddr4_sdram_dm_dbi_n(ddr4_sdram_c1_dm_dbi_n),
    .ddr4_sdram_dq(ddr4_sdram_c1_dq),
    .ddr4_sdram_dqs_n(ddr4_sdram_c1_dqs_n),
    .ddr4_sdram_dqs_p(ddr4_sdram_c1_dqs_p),
    .ddr4_sdram_odt(ddr4_sdram_c1_odt),
    .ddr4_sdram_reset_n(ddr4_sdram_c1_reset_n),

    .DDR_init_calib_complete(DDRA_init_calib_complete),

    .DDR_S_AXI_araddr(DDRA_S_AXI_araddr),
    .DDR_S_AXI_arburst(DDRA_S_AXI_arburst),
    .DDR_S_AXI_arcache(DDRA_S_AXI_arcache),
    .DDR_S_AXI_arid(DDRA_S_AXI_arid),
    .DDR_S_AXI_arlen(DDRA_S_AXI_arlen),
    .DDR_S_AXI_arlock(DDRA_S_AXI_arlock),
    .DDR_S_AXI_arprot(DDRA_S_AXI_arprot),
    .DDR_S_AXI_arqos(DDRA_S_AXI_arqos),
    .DDR_S_AXI_arready(DDRA_S_AXI_arready),
    .DDR_S_AXI_arregion(DDRA_S_AXI_arregion),
    .DDR_S_AXI_arsize(DDRA_S_AXI_arsize),
    .DDR_S_AXI_arvalid(DDRA_S_AXI_arvalid),
    .DDR_S_AXI_awaddr(DDRA_S_AXI_awaddr),
    .DDR_S_AXI_awburst(DDRA_S_AXI_awburst),
    .DDR_S_AXI_awcache(DDRA_S_AXI_awcache),
    .DDR_S_AXI_awid(DDRA_S_AXI_awid),
    .DDR_S_AXI_awlen(DDRA_S_AXI_awlen),
    .DDR_S_AXI_awlock(DDRA_S_AXI_awlock),
    .DDR_S_AXI_awprot(DDRA_S_AXI_awprot),
    .DDR_S_AXI_awqos(DDRA_S_AXI_awqos),
    .DDR_S_AXI_awready(DDRA_S_AXI_awready),
    .DDR_S_AXI_awregion(DDRA_S_AXI_awregion),
    .DDR_S_AXI_awsize(DDRA_S_AXI_awsize),
    .DDR_S_AXI_awvalid(DDRA_S_AXI_awvalid),
    .DDR_S_AXI_bid(DDRA_S_AXI_bid),
    .DDR_S_AXI_bready(DDRA_S_AXI_bready),
    .DDR_S_AXI_bresp(DDRA_S_AXI_bresp),
    .DDR_S_AXI_bvalid(DDRA_S_AXI_bvalid),
    .DDR_S_AXI_rdata(DDRA_S_AXI_rdata),
    .DDR_S_AXI_rid(DDRA_S_AXI_rid),
    .DDR_S_AXI_rlast(DDRA_S_AXI_rlast),
    .DDR_S_AXI_rready(DDRA_S_AXI_rready),
    .DDR_S_AXI_rresp(DDRA_S_AXI_rresp),
    .DDR_S_AXI_rvalid(DDRA_S_AXI_rvalid),
    .DDR_S_AXI_wdata(DDRA_S_AXI_wdata),
    .DDR_S_AXI_wlast(DDRA_S_AXI_wlast),
    .DDR_S_AXI_wready(DDRA_S_AXI_wready),
    .DDR_S_AXI_wstrb(DDRA_S_AXI_wstrb),
    .DDR_S_AXI_wvalid(DDRA_S_AXI_wvalid)
  );

  garnet_ddr #(
    .ENABLE(ENABLE_DDRB)
  ) DDRB (
    .clk(clk),
    .resetn(resetn),

    .ddr4_sdram_sys_clk_n(ddr4_sdram_c2_sys_clk_n),
    .ddr4_sdram_sys_clk_p(ddr4_sdram_c2_sys_clk_p),

    .ddr4_sdram_act_n(ddr4_sdram_c2_act_n),
    .ddr4_sdram_adr(ddr4_sdram_c2_adr),
    .ddr4_sdram_ba(ddr4_sdram_c2_ba),
    .ddr4_sdram_bg(ddr4_sdram_c2_bg),
    .ddr4_sdram_ck_n(ddr4_sdram_c2_ck_n),
    .ddr4_sdram_ck_p(ddr4_sdram_c2_ck_p),
    .ddr4_sdram_cke(ddr4_sdram_c2_cke),
    .ddr4_sdram_cs_n(ddr4_sdram_c2_cs_n),
    .ddr4_sdram_dm_dbi_n(ddr4_sdram_c2_dm_dbi_n),
    .ddr4_sdram_dq(ddr4_sdram_c2_dq),
    .ddr4_sdram_dqs_n(ddr4_sdram_c2_dqs_n),
    .ddr4_sdram_dqs_p(ddr4_sdram_c2_dqs_p),
    .ddr4_sdram_odt(ddr4_sdram_c2_odt),
    .ddr4_sdram_reset_n(ddr4_sdram_c2_reset_n),

    .DDR_init_calib_complete(DDRB_init_calib_complete),

    .DDR_S_AXI_araddr(DDRB_S_AXI_araddr),
    .DDR_S_AXI_arburst(DDRB_S_AXI_arburst),
    .DDR_S_AXI_arcache(DDRB_S_AXI_arcache),
    .DDR_S_AXI_arid(DDRB_S_AXI_arid),
    .DDR_S_AXI_arlen(DDRB_S_AXI_arlen),
    .DDR_S_AXI_arlock(DDRB_S_AXI_arlock),
    .DDR_S_AXI_arprot(DDRB_S_AXI_arprot),
    .DDR_S_AXI_arqos(DDRB_S_AXI_arqos),
    .DDR_S_AXI_arready(DDRB_S_AXI_arready),
    .DDR_S_AXI_arregion(DDRB_S_AXI_arregion),
    .DDR_S_AXI_arsize(DDRB_S_AXI_arsize),
    .DDR_S_AXI_arvalid(DDRB_S_AXI_arvalid),
    .DDR_S_AXI_awaddr(DDRB_S_AXI_awaddr),
    .DDR_S_AXI_awburst(DDRB_S_AXI_awburst),
    .DDR_S_AXI_awcache(DDRB_S_AXI_awcache),
    .DDR_S_AXI_awid(DDRB_S_AXI_awid),
    .DDR_S_AXI_awlen(DDRB_S_AXI_awlen),
    .DDR_S_AXI_awlock(DDRB_S_AXI_awlock),
    .DDR_S_AXI_awprot(DDRB_S_AXI_awprot),
    .DDR_S_AXI_awqos(DDRB_S_AXI_awqos),
    .DDR_S_AXI_awready(DDRB_S_AXI_awready),
    .DDR_S_AXI_awregion(DDRB_S_AXI_awregion),
    .DDR_S_AXI_awsize(DDRB_S_AXI_awsize),
    .DDR_S_AXI_awvalid(DDRB_S_AXI_awvalid),
    .DDR_S_AXI_bid(DDRB_S_AXI_bid),
    .DDR_S_AXI_bready(DDRB_S_AXI_bready),
    .DDR_S_AXI_bresp(DDRB_S_AXI_bresp),
    .DDR_S_AXI_bvalid(DDRB_S_AXI_bvalid),
    .DDR_S_AXI_rdata(DDRB_S_AXI_rdata),
    .DDR_S_AXI_rid(DDRB_S_AXI_rid),
    .DDR_S_AXI_rlast(DDRB_S_AXI_rlast),
    .DDR_S_AXI_rready(DDRB_S_AXI_rready),
    .DDR_S_AXI_rresp(DDRB_S_AXI_rresp),
    .DDR_S_AXI_rvalid(DDRB_S_AXI_rvalid),
    .DDR_S_AXI_wdata(DDRB_S_AXI_wdata),
    .DDR_S_AXI_wlast(DDRB_S_AXI_wlast),
    .DDR_S_AXI_wready(DDRB_S_AXI_wready),
    .DDR_S_AXI_wstrb(DDRB_S_AXI_wstrb),
    .DDR_S_AXI_wvalid(DDRB_S_AXI_wvalid)
  );

endmodule
