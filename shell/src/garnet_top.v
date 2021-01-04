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

module garnet_top (
  input pcie_perstn,
  input pcie_refclk_clk_n,
  input pcie_refclk_clk_p,

  input [15:0] pci_express_x16_rxn,
  input [15:0] pci_express_x16_rxp,
  output [15:0] pci_express_x16_txn,
  output [15:0] pci_express_x16_txp,

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
  output ddr4_sdram_c2_reset_n
);

  wire clk;
  wire aresetn;

  wire [31:0] CTL_AXI_LITE_araddr;
  wire [2:0] CTL_AXI_LITE_arprot;
  wire CTL_AXI_LITE_arready;
  wire CTL_AXI_LITE_arvalid;
  wire [31:0] CTL_AXI_LITE_awaddr;
  wire [2:0] CTL_AXI_LITE_awprot;
  wire CTL_AXI_LITE_awready;
  wire CTL_AXI_LITE_awvalid;
  wire CTL_AXI_LITE_bready;
  wire [1:0] CTL_AXI_LITE_bresp;
  wire CTL_AXI_LITE_bvalid;
  wire [31:0] CTL_AXI_LITE_rdata;
  wire CTL_AXI_LITE_rready;
  wire [1:0] CTL_AXI_LITE_rresp;
  wire CTL_AXI_LITE_rvalid;
  wire [31:0] CTL_AXI_LITE_wdata;
  wire CTL_AXI_LITE_wready;
  wire [3:0] CTL_AXI_LITE_wstrb;
  wire CTL_AXI_LITE_wvalid;

  wire [63:0] DMA_AXI_araddr;
  wire [1:0] DMA_AXI_arburst;
  wire [3:0] DMA_AXI_arcache;
  wire [3:0] DMA_AXI_arid;
  wire [7:0] DMA_AXI_arlen;
  wire DMA_AXI_arlock;
  wire [2:0] DMA_AXI_arprot;
  wire DMA_AXI_arready;
  wire [2:0] DMA_AXI_arsize;
  wire DMA_AXI_arvalid;
  wire [63:0] DMA_AXI_awaddr;
  wire [1:0] DMA_AXI_awburst;
  wire [3:0] DMA_AXI_awcache;
  wire [3:0] DMA_AXI_awid;
  wire [7:0] DMA_AXI_awlen;
  wire DMA_AXI_awlock;
  wire [2:0] DMA_AXI_awprot;
  wire DMA_AXI_awready;
  wire [2:0] DMA_AXI_awsize;
  wire DMA_AXI_awvalid;
  wire [3:0] DMA_AXI_bid;
  wire DMA_AXI_bready;
  wire [1:0] DMA_AXI_bresp;
  wire DMA_AXI_bvalid;
  wire [511:0] DMA_AXI_rdata;
  wire [3:0] DMA_AXI_rid;
  wire DMA_AXI_rlast;
  wire DMA_AXI_rready;
  wire [1:0] DMA_AXI_rresp;
  wire DMA_AXI_rvalid;
  wire [511:0] DMA_AXI_wdata;
  wire DMA_AXI_wlast;
  wire DMA_AXI_wready;
  wire [63:0] DMA_AXI_wstrb;
  wire DMA_AXI_wvalid;

  wire [15:0] irq_ack;
  wire [15:0] irq_req;

  wire drck;
  wire shift;
  wire tdi;
  wire update;
  wire sel;
  wire tdo;
  wire tms;
  wire tck;
  wire runtest;
  wire reset;
  wire capture;
  wire bscanid_en;

  shell shell (
    .clk(clk),
    .aresetn(aresetn),

    .CTL_M_AXI_LITE_araddr(CTL_AXI_LITE_araddr),
    .CTL_M_AXI_LITE_arprot(CTL_AXI_LITE_arprot),
    .CTL_M_AXI_LITE_arready(CTL_AXI_LITE_arready),
    .CTL_M_AXI_LITE_arvalid(CTL_AXI_LITE_arvalid),
    .CTL_M_AXI_LITE_awaddr(CTL_AXI_LITE_awaddr),
    .CTL_M_AXI_LITE_awprot(CTL_AXI_LITE_awprot),
    .CTL_M_AXI_LITE_awready(CTL_AXI_LITE_awready),
    .CTL_M_AXI_LITE_awvalid(CTL_AXI_LITE_awvalid),
    .CTL_M_AXI_LITE_bready(CTL_AXI_LITE_bready),
    .CTL_M_AXI_LITE_bresp(CTL_AXI_LITE_bresp),
    .CTL_M_AXI_LITE_bvalid(CTL_AXI_LITE_bvalid),
    .CTL_M_AXI_LITE_rdata(CTL_AXI_LITE_rdata),
    .CTL_M_AXI_LITE_rready(CTL_AXI_LITE_rready),
    .CTL_M_AXI_LITE_rresp(CTL_AXI_LITE_rresp),
    .CTL_M_AXI_LITE_rvalid(CTL_AXI_LITE_rvalid),
    .CTL_M_AXI_LITE_wdata(CTL_AXI_LITE_wdata),
    .CTL_M_AXI_LITE_wready(CTL_AXI_LITE_wready),
    .CTL_M_AXI_LITE_wstrb(CTL_AXI_LITE_wstrb),
    .CTL_M_AXI_LITE_wvalid(CTL_AXI_LITE_wvalid),

    .DMA_M_AXI_araddr(DMA_AXI_araddr),
    .DMA_M_AXI_arburst(DMA_AXI_arburst),
    .DMA_M_AXI_arcache(DMA_AXI_arcache),
    .DMA_M_AXI_arid(DMA_AXI_arid),
    .DMA_M_AXI_arlen(DMA_AXI_arlen),
    .DMA_M_AXI_arlock(DMA_AXI_arlock),
    .DMA_M_AXI_arprot(DMA_AXI_arprot),
    .DMA_M_AXI_arready(DMA_AXI_arready),
    .DMA_M_AXI_arsize(DMA_AXI_arsize),
    .DMA_M_AXI_arvalid(DMA_AXI_arvalid),
    .DMA_M_AXI_awaddr(DMA_AXI_awaddr),
    .DMA_M_AXI_awburst(DMA_AXI_awburst),
    .DMA_M_AXI_awcache(DMA_AXI_awcache),
    .DMA_M_AXI_awid(DMA_AXI_awid),
    .DMA_M_AXI_awlen(DMA_AXI_awlen),
    .DMA_M_AXI_awlock(DMA_AXI_awlock),
    .DMA_M_AXI_awprot(DMA_AXI_awprot),
    .DMA_M_AXI_awready(DMA_AXI_awready),
    .DMA_M_AXI_awsize(DMA_AXI_awsize),
    .DMA_M_AXI_awvalid(DMA_AXI_awvalid),
    .DMA_M_AXI_bid(DMA_AXI_bid),
    .DMA_M_AXI_bready(DMA_AXI_bready),
    .DMA_M_AXI_bresp(DMA_AXI_bresp),
    .DMA_M_AXI_bvalid(DMA_AXI_bvalid),
    .DMA_M_AXI_rdata(DMA_AXI_rdata),
    .DMA_M_AXI_rid(DMA_AXI_rid),
    .DMA_M_AXI_rlast(DMA_AXI_rlast),
    .DMA_M_AXI_rready(DMA_AXI_rready),
    .DMA_M_AXI_rresp(DMA_AXI_rresp),
    .DMA_M_AXI_rvalid(DMA_AXI_rvalid),
    .DMA_M_AXI_wdata(DMA_AXI_wdata),
    .DMA_M_AXI_wlast(DMA_AXI_wlast),
    .DMA_M_AXI_wready(DMA_AXI_wready),
    .DMA_M_AXI_wstrb(DMA_AXI_wstrb),
    .DMA_M_AXI_wvalid(DMA_AXI_wvalid),

    .irq_ack(irq_ack),
    .irq_req(irq_req),

    .m_bscan_drck(drck),
    .m_bscan_shift(shift),
    .m_bscan_tdi(tdi),
    .m_bscan_update(update),
    .m_bscan_sel(sel),
    .m_bscan_tdo(tdo),
    .m_bscan_tms(tms),
    .m_bscan_tck(tck),
    .m_bscan_runtest(runtest),
    .m_bscan_reset(reset),
    .m_bscan_capture(capture),
    .m_bscan_bscanid_en(bscanid_en),

    .pcie_perstn(pcie_perstn),
    .pcie_refclk_clk_n(pcie_refclk_clk_n),
    .pcie_refclk_clk_p(pcie_refclk_clk_p),

    .pci_express_x16_rxn(pci_express_x16_rxn),
    .pci_express_x16_rxp(pci_express_x16_rxp),
    .pci_express_x16_txn(pci_express_x16_txn),
    .pci_express_x16_txp(pci_express_x16_txp)
  );

  partition_wrapper partition_wrapper (
    .clk(clk),
    .aresetn(aresetn),

    .CTL_S_AXI_LITE_araddr(CTL_AXI_LITE_araddr),
    .CTL_S_AXI_LITE_arprot(CTL_AXI_LITE_arprot),
    .CTL_S_AXI_LITE_arready(CTL_AXI_LITE_arready),
    .CTL_S_AXI_LITE_arvalid(CTL_AXI_LITE_arvalid),
    .CTL_S_AXI_LITE_awaddr(CTL_AXI_LITE_awaddr),
    .CTL_S_AXI_LITE_awprot(CTL_AXI_LITE_awprot),
    .CTL_S_AXI_LITE_awready(CTL_AXI_LITE_awready),
    .CTL_S_AXI_LITE_awvalid(CTL_AXI_LITE_awvalid),
    .CTL_S_AXI_LITE_bready(CTL_AXI_LITE_bready),
    .CTL_S_AXI_LITE_bresp(CTL_AXI_LITE_bresp),
    .CTL_S_AXI_LITE_bvalid(CTL_AXI_LITE_bvalid),
    .CTL_S_AXI_LITE_rdata(CTL_AXI_LITE_rdata),
    .CTL_S_AXI_LITE_rready(CTL_AXI_LITE_rready),
    .CTL_S_AXI_LITE_rresp(CTL_AXI_LITE_rresp),
    .CTL_S_AXI_LITE_rvalid(CTL_AXI_LITE_rvalid),
    .CTL_S_AXI_LITE_wdata(CTL_AXI_LITE_wdata),
    .CTL_S_AXI_LITE_wready(CTL_AXI_LITE_wready),
    .CTL_S_AXI_LITE_wstrb(CTL_AXI_LITE_wstrb),
    .CTL_S_AXI_LITE_wvalid(CTL_AXI_LITE_wvalid),

    .DMA_S_AXI_araddr(DMA_AXI_araddr),
    .DMA_S_AXI_arburst(DMA_AXI_arburst),
    .DMA_S_AXI_arcache(DMA_AXI_arcache),
    .DMA_S_AXI_arid(DMA_AXI_arid),
    .DMA_S_AXI_arlen(DMA_AXI_arlen),
    .DMA_S_AXI_arlock(DMA_AXI_arlock),
    .DMA_S_AXI_arprot(DMA_AXI_arprot),
    .DMA_S_AXI_arready(DMA_AXI_arready),
    .DMA_S_AXI_arsize(DMA_AXI_arsize),
    .DMA_S_AXI_arvalid(DMA_AXI_arvalid),
    .DMA_S_AXI_awaddr(DMA_AXI_awaddr),
    .DMA_S_AXI_awburst(DMA_AXI_awburst),
    .DMA_S_AXI_awcache(DMA_AXI_awcache),
    .DMA_S_AXI_awid(DMA_AXI_awid),
    .DMA_S_AXI_awlen(DMA_AXI_awlen),
    .DMA_S_AXI_awlock(DMA_AXI_awlock),
    .DMA_S_AXI_awprot(DMA_AXI_awprot),
    .DMA_S_AXI_awready(DMA_AXI_awready),
    .DMA_S_AXI_awsize(DMA_AXI_awsize),
    .DMA_S_AXI_awvalid(DMA_AXI_awvalid),
    .DMA_S_AXI_bid(DMA_AXI_bid),
    .DMA_S_AXI_bready(DMA_AXI_bready),
    .DMA_S_AXI_bresp(DMA_AXI_bresp),
    .DMA_S_AXI_bvalid(DMA_AXI_bvalid),
    .DMA_S_AXI_rdata(DMA_AXI_rdata),
    .DMA_S_AXI_rid(DMA_AXI_rid),
    .DMA_S_AXI_rlast(DMA_AXI_rlast),
    .DMA_S_AXI_rready(DMA_AXI_rready),
    .DMA_S_AXI_rresp(DMA_AXI_rresp),
    .DMA_S_AXI_rvalid(DMA_AXI_rvalid),
    .DMA_S_AXI_wdata(DMA_AXI_wdata),
    .DMA_S_AXI_wlast(DMA_AXI_wlast),
    .DMA_S_AXI_wready(DMA_AXI_wready),
    .DMA_S_AXI_wstrb(DMA_AXI_wstrb),
    .DMA_S_AXI_wvalid(DMA_AXI_wvalid),

    .irq_ack(irq_ack),
    .irq_req(irq_req),

    .ddr4_sdram_c1_sys_clk_n(ddr4_sdram_c1_sys_clk_n),
    .ddr4_sdram_c1_sys_clk_p(ddr4_sdram_c1_sys_clk_p),

    .ddr4_sdram_c1_act_n(ddr4_sdram_c1_act_n),
    .ddr4_sdram_c1_adr(ddr4_sdram_c1_adr),
    .ddr4_sdram_c1_ba(ddr4_sdram_c1_ba),
    .ddr4_sdram_c1_bg(ddr4_sdram_c1_bg),
    .ddr4_sdram_c1_ck_n(ddr4_sdram_c1_ck_n),
    .ddr4_sdram_c1_ck_p(ddr4_sdram_c1_ck_p),
    .ddr4_sdram_c1_cke(ddr4_sdram_c1_cke),
    .ddr4_sdram_c1_cs_n(ddr4_sdram_c1_cs_n),
    .ddr4_sdram_c1_dm_dbi_n(ddr4_sdram_c1_dm_dbi_n),
    .ddr4_sdram_c1_dq(ddr4_sdram_c1_dq),
    .ddr4_sdram_c1_dqs_n(ddr4_sdram_c1_dqs_n),
    .ddr4_sdram_c1_dqs_p(ddr4_sdram_c1_dqs_p),
    .ddr4_sdram_c1_odt(ddr4_sdram_c1_odt),
    .ddr4_sdram_c1_reset_n(ddr4_sdram_c1_reset_n),

    .ddr4_sdram_c2_sys_clk_n(ddr4_sdram_c2_sys_clk_n),
    .ddr4_sdram_c2_sys_clk_p(ddr4_sdram_c2_sys_clk_p),

    .ddr4_sdram_c2_act_n(ddr4_sdram_c2_act_n),
    .ddr4_sdram_c2_adr(ddr4_sdram_c2_adr),
    .ddr4_sdram_c2_ba(ddr4_sdram_c2_ba),
    .ddr4_sdram_c2_bg(ddr4_sdram_c2_bg),
    .ddr4_sdram_c2_ck_n(ddr4_sdram_c2_ck_n),
    .ddr4_sdram_c2_ck_p(ddr4_sdram_c2_ck_p),
    .ddr4_sdram_c2_cke(ddr4_sdram_c2_cke),
    .ddr4_sdram_c2_cs_n(ddr4_sdram_c2_cs_n),
    .ddr4_sdram_c2_dm_dbi_n(ddr4_sdram_c2_dm_dbi_n),
    .ddr4_sdram_c2_dq(ddr4_sdram_c2_dq),
    .ddr4_sdram_c2_dqs_n(ddr4_sdram_c2_dqs_n),
    .ddr4_sdram_c2_dqs_p(ddr4_sdram_c2_dqs_p),
    .ddr4_sdram_c2_odt(ddr4_sdram_c2_odt),
    .ddr4_sdram_c2_reset_n(ddr4_sdram_c2_reset_n),

    .drck(drck),
    .shift(shift),
    .tdi(tdi),
    .update(update),
    .sel(sel),
    .tdo(tdo),
    .tms(tms),
    .tck(tck),
    .runtest(runtest),
    .reset(reset),
    .capture(capture),
    .bscanid_en(bscanid_en)
  );

endmodule
