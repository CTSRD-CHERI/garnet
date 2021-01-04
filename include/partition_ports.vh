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

`include "garnet_config.vh"

  input clk,
  input resetn,

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
  output [15:0] irq_req

`ifndef DISABLE_DDRA
, input DDRA_init_calib_complete,

  output [63:0] DDRA_M_AXI_araddr,
  output [1:0] DDRA_M_AXI_arburst,
  output [3:0] DDRA_M_AXI_arcache,
  output [5:0] DDRA_M_AXI_arid,
  output [7:0] DDRA_M_AXI_arlen,
  output [0:0] DDRA_M_AXI_arlock,
  output [2:0] DDRA_M_AXI_arprot,
  output [3:0] DDRA_M_AXI_arqos,
  input DDRA_M_AXI_arready,
  output [3:0] DDRA_M_AXI_arregion,
  output [2:0] DDRA_M_AXI_arsize,
  output DDRA_M_AXI_arvalid,
  output [63:0] DDRA_M_AXI_awaddr,
  output [1:0] DDRA_M_AXI_awburst,
  output [3:0] DDRA_M_AXI_awcache,
  output [5:0] DDRA_M_AXI_awid,
  output [7:0] DDRA_M_AXI_awlen,
  output [0:0] DDRA_M_AXI_awlock,
  output [2:0] DDRA_M_AXI_awprot,
  output [3:0] DDRA_M_AXI_awqos,
  input DDRA_M_AXI_awready,
  output [3:0] DDRA_M_AXI_awregion,
  output [2:0] DDRA_M_AXI_awsize,
  output DDRA_M_AXI_awvalid,
  input [5:0] DDRA_M_AXI_bid,
  output DDRA_M_AXI_bready,
  input [1:0] DDRA_M_AXI_bresp,
  input DDRA_M_AXI_bvalid,
  input [511:0] DDRA_M_AXI_rdata,
  input [5:0] DDRA_M_AXI_rid,
  input DDRA_M_AXI_rlast,
  output DDRA_M_AXI_rready,
  input [1:0] DDRA_M_AXI_rresp,
  input DDRA_M_AXI_rvalid,
  output [511:0] DDRA_M_AXI_wdata,
  output DDRA_M_AXI_wlast,
  input DDRA_M_AXI_wready,
  output [63:0] DDRA_M_AXI_wstrb,
  output DDRA_M_AXI_wvalid
`endif

`ifndef DISABLE_DDRB
, input DDRB_init_calib_complete,

  output [63:0] DDRB_M_AXI_araddr,
  output [1:0] DDRB_M_AXI_arburst,
  output [3:0] DDRB_M_AXI_arcache,
  output [5:0] DDRB_M_AXI_arid,
  output [7:0] DDRB_M_AXI_arlen,
  output [0:0] DDRB_M_AXI_arlock,
  output [2:0] DDRB_M_AXI_arprot,
  output [3:0] DDRB_M_AXI_arqos,
  input DDRB_M_AXI_arready,
  output [3:0] DDRB_M_AXI_arregion,
  output [2:0] DDRB_M_AXI_arsize,
  output DDRB_M_AXI_arvalid,
  output [63:0] DDRB_M_AXI_awaddr,
  output [1:0] DDRB_M_AXI_awburst,
  output [3:0] DDRB_M_AXI_awcache,
  output [5:0] DDRB_M_AXI_awid,
  output [7:0] DDRB_M_AXI_awlen,
  output [0:0] DDRB_M_AXI_awlock,
  output [2:0] DDRB_M_AXI_awprot,
  output [3:0] DDRB_M_AXI_awqos,
  input DDRB_M_AXI_awready,
  output [3:0] DDRB_M_AXI_awregion,
  output [2:0] DDRB_M_AXI_awsize,
  output DDRB_M_AXI_awvalid,
  input [5:0] DDRB_M_AXI_bid,
  output DDRB_M_AXI_bready,
  input [1:0] DDRB_M_AXI_bresp,
  input DDRB_M_AXI_bvalid,
  input [511:0] DDRB_M_AXI_rdata,
  input [5:0] DDRB_M_AXI_rid,
  input DDRB_M_AXI_rlast,
  output DDRB_M_AXI_rready,
  input [1:0] DDRB_M_AXI_rresp,
  input DDRB_M_AXI_rvalid,
  output [511:0] DDRB_M_AXI_wdata,
  output DDRB_M_AXI_wlast,
  input DDRB_M_AXI_wready,
  output [63:0] DDRB_M_AXI_wstrb,
  output DDRB_M_AXI_wvalid
`endif
