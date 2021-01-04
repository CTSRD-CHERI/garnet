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

  input clk,
  input aresetn,

  input [31:0] CTL_S_AXI_LITE_araddr,
  input [2:0] CTL_S_AXI_LITE_arprot,
  output CTL_S_AXI_LITE_arready,
  input CTL_S_AXI_LITE_arvalid,
  input [31:0] CTL_S_AXI_LITE_awaddr,
  input [2:0] CTL_S_AXI_LITE_awprot,
  output CTL_S_AXI_LITE_awready,
  input CTL_S_AXI_LITE_awvalid,
  input CTL_S_AXI_LITE_bready,
  output [1:0] CTL_S_AXI_LITE_bresp,
  output CTL_S_AXI_LITE_bvalid,
  output [31:0] CTL_S_AXI_LITE_rdata,
  input CTL_S_AXI_LITE_rready,
  output [1:0] CTL_S_AXI_LITE_rresp,
  output CTL_S_AXI_LITE_rvalid,
  input [31:0] CTL_S_AXI_LITE_wdata,
  output CTL_S_AXI_LITE_wready,
  input [3:0] CTL_S_AXI_LITE_wstrb,
  input CTL_S_AXI_LITE_wvalid,

  input [63:0] DMA_S_AXI_araddr,
  input [1:0] DMA_S_AXI_arburst,
  input [3:0] DMA_S_AXI_arcache,
  input [3:0] DMA_S_AXI_arid,
  input [7:0] DMA_S_AXI_arlen,
  input DMA_S_AXI_arlock,
  input [2:0] DMA_S_AXI_arprot,
  output DMA_S_AXI_arready,
  input [2:0] DMA_S_AXI_arsize,
  input DMA_S_AXI_arvalid,
  input [63:0] DMA_S_AXI_awaddr,
  input [1:0] DMA_S_AXI_awburst,
  input [3:0] DMA_S_AXI_awcache,
  input [3:0] DMA_S_AXI_awid,
  input [7:0] DMA_S_AXI_awlen,
  input DMA_S_AXI_awlock,
  input [2:0] DMA_S_AXI_awprot,
  output DMA_S_AXI_awready,
  input [2:0] DMA_S_AXI_awsize,
  input DMA_S_AXI_awvalid,
  output [3:0] DMA_S_AXI_bid,
  input DMA_S_AXI_bready,
  output [1:0] DMA_S_AXI_bresp,
  output DMA_S_AXI_bvalid,
  output [511:0] DMA_S_AXI_rdata,
  output [3:0] DMA_S_AXI_rid,
  output DMA_S_AXI_rlast,
  input DMA_S_AXI_rready,
  output [1:0] DMA_S_AXI_rresp,
  output DMA_S_AXI_rvalid,
  input [511:0] DMA_S_AXI_wdata,
  input DMA_S_AXI_wlast,
  output DMA_S_AXI_wready,
  input [63:0] DMA_S_AXI_wstrb,
  input DMA_S_AXI_wvalid,

  input [15:0] irq_ack,
  output [15:0] irq_req,

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

  input drck,
  input shift,
  input tdi,
  input update,
  input sel,
  output tdo,
  input tms,
  input tck,
  input runtest,
  input reset,
  input capture,
  input bscanid_en
