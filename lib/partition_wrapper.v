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

`ifndef DISABLE_DDRA
`define IF_ELSE_DDRA(x, y) x
`else
`define IF_ELSE_DDRA(x, y) y
`endif

`ifndef DISABLE_DDRB
`define IF_ELSE_DDRB(x, y) x
`else
`define IF_ELSE_DDRB(x, y) y
`endif

`define IF_DDRA(x) `IF_ELSE_DDRA(x, )
`define IF_DDRB(x) `IF_ELSE_DDRB(x, )

module partition_wrapper (
  `include "partition_wrapper_ports.vh"
);

`ifndef DISABLE_DDRA
  wire DDRA_init_calib_complete;

  wire [63:0] DDRA_M_AXI_araddr;
  wire [1:0] DDRA_M_AXI_arburst;
  wire [3:0] DDRA_M_AXI_arcache;
  wire [5:0] DDRA_M_AXI_arid;
  wire [7:0] DDRA_M_AXI_arlen;
  wire [0:0] DDRA_M_AXI_arlock;
  wire [2:0] DDRA_M_AXI_arprot;
  wire [3:0] DDRA_M_AXI_arqos;
  wire DDRA_M_AXI_arready;
  wire [3:0] DDRA_M_AXI_arregion;
  wire [2:0] DDRA_M_AXI_arsize;
  wire DDRA_M_AXI_arvalid;
  wire [63:0] DDRA_M_AXI_awaddr;
  wire [1:0] DDRA_M_AXI_awburst;
  wire [3:0] DDRA_M_AXI_awcache;
  wire [5:0] DDRA_M_AXI_awid;
  wire [7:0] DDRA_M_AXI_awlen;
  wire [0:0] DDRA_M_AXI_awlock;
  wire [2:0] DDRA_M_AXI_awprot;
  wire [3:0] DDRA_M_AXI_awqos;
  wire DDRA_M_AXI_awready;
  wire [3:0] DDRA_M_AXI_awregion;
  wire [2:0] DDRA_M_AXI_awsize;
  wire DDRA_M_AXI_awvalid;
  wire [5:0] DDRA_M_AXI_bid;
  wire DDRA_M_AXI_bready;
  wire [1:0] DDRA_M_AXI_bresp;
  wire DDRA_M_AXI_bvalid;
  wire [511:0] DDRA_M_AXI_rdata;
  wire [5:0] DDRA_M_AXI_rid;
  wire DDRA_M_AXI_rlast;
  wire DDRA_M_AXI_rready;
  wire [1:0] DDRA_M_AXI_rresp;
  wire DDRA_M_AXI_rvalid;
  wire [511:0] DDRA_M_AXI_wdata;
  wire DDRA_M_AXI_wlast;
  wire DDRA_M_AXI_wready;
  wire [63:0] DDRA_M_AXI_wstrb;
  wire DDRA_M_AXI_wvalid;
`endif

`ifndef DISABLE_DDRB
  wire DDRB_init_calib_complete;

  wire [30:0] DDRB_M_AXI_araddr;
  wire [1:0] DDRB_M_AXI_arburst;
  wire [3:0] DDRB_M_AXI_arcache;
  wire [5:0] DDRB_M_AXI_arid;
  wire [7:0] DDRB_M_AXI_arlen;
  wire [0:0] DDRB_M_AXI_arlock;
  wire [2:0] DDRB_M_AXI_arprot;
  wire [3:0] DDRB_M_AXI_arqos;
  wire DDRB_M_AXI_arready;
  wire [3:0] DDRB_M_AXI_arregion;
  wire [2:0] DDRB_M_AXI_arsize;
  wire DDRB_M_AXI_arvalid;
  wire [30:0] DDRB_M_AXI_awaddr;
  wire [1:0] DDRB_M_AXI_awburst;
  wire [3:0] DDRB_M_AXI_awcache;
  wire [5:0] DDRB_M_AXI_awid;
  wire [7:0] DDRB_M_AXI_awlen;
  wire [0:0] DDRB_M_AXI_awlock;
  wire [2:0] DDRB_M_AXI_awprot;
  wire [3:0] DDRB_M_AXI_awqos;
  wire DDRB_M_AXI_awready;
  wire [3:0] DDRB_M_AXI_awregion;
  wire [2:0] DDRB_M_AXI_awsize;
  wire DDRB_M_AXI_awvalid;
  wire [5:0] DDRB_M_AXI_bid;
  wire DDRB_M_AXI_bready;
  wire [1:0] DDRB_M_AXI_bresp;
  wire DDRB_M_AXI_bvalid;
  wire [511:0] DDRB_M_AXI_rdata;
  wire [5:0] DDRB_M_AXI_rid;
  wire DDRB_M_AXI_rlast;
  wire DDRB_M_AXI_rready;
  wire [1:0] DDRB_M_AXI_rresp;
  wire DDRB_M_AXI_rvalid;
  wire [511:0] DDRB_M_AXI_wdata;
  wire DDRB_M_AXI_wlast;
  wire DDRB_M_AXI_wready;
  wire [63:0] DDRB_M_AXI_wstrb;
  wire DDRB_M_AXI_wvalid;
`endif

  // Synchronise reset

  (* ASYNC_REG = "TRUE" *)
  reg resetn_meta;
  (* ASYNC_REG = "TRUE" *)
  reg resetn_sync;

  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      resetn_meta <= 0;
      resetn_sync <= 0;
    end
    else begin
      resetn_meta <= 1;
      resetn_sync <= resetn_meta;
    end
  end

  // Pipeline reset to user partition

  (* DONT_TOUCH = "TRUE" *)
  wire resetn_partition;

  pipeline #(
    .WIDTH(1),
    .DEPTH(4)
  ) pipeline_resetn_partition (
    .clk(clk),
    .resetn(1'b1),

    .reset_data(1'b0),

    .in_data(resetn_sync),
    .out_data(resetn_partition)
  );

  // Instantiate user partition

  `PARTITION_MODULE partition (
    .clk(clk),
    .resetn(resetn_partition),

    .CTL_S_AXI_LITE_araddr(CTL_S_AXI_LITE_araddr),
    .CTL_S_AXI_LITE_arprot(CTL_S_AXI_LITE_arprot),
    .CTL_S_AXI_LITE_arready(CTL_S_AXI_LITE_arready),
    .CTL_S_AXI_LITE_arvalid(CTL_S_AXI_LITE_arvalid),
    .CTL_S_AXI_LITE_awaddr(CTL_S_AXI_LITE_awaddr),
    .CTL_S_AXI_LITE_awprot(CTL_S_AXI_LITE_awprot),
    .CTL_S_AXI_LITE_awready(CTL_S_AXI_LITE_awready),
    .CTL_S_AXI_LITE_awvalid(CTL_S_AXI_LITE_awvalid),
    .CTL_S_AXI_LITE_bready(CTL_S_AXI_LITE_bready),
    .CTL_S_AXI_LITE_bresp(CTL_S_AXI_LITE_bresp),
    .CTL_S_AXI_LITE_bvalid(CTL_S_AXI_LITE_bvalid),
    .CTL_S_AXI_LITE_rdata(CTL_S_AXI_LITE_rdata),
    .CTL_S_AXI_LITE_rready(CTL_S_AXI_LITE_rready),
    .CTL_S_AXI_LITE_rresp(CTL_S_AXI_LITE_rresp),
    .CTL_S_AXI_LITE_rvalid(CTL_S_AXI_LITE_rvalid),
    .CTL_S_AXI_LITE_wdata(CTL_S_AXI_LITE_wdata),
    .CTL_S_AXI_LITE_wready(CTL_S_AXI_LITE_wready),
    .CTL_S_AXI_LITE_wstrb(CTL_S_AXI_LITE_wstrb),
    .CTL_S_AXI_LITE_wvalid(CTL_S_AXI_LITE_wvalid),

    .DMA_S_AXI_araddr(DMA_S_AXI_araddr),
    .DMA_S_AXI_arburst(DMA_S_AXI_arburst),
    .DMA_S_AXI_arcache(DMA_S_AXI_arcache),
    .DMA_S_AXI_arid(DMA_S_AXI_arid),
    .DMA_S_AXI_arlen(DMA_S_AXI_arlen),
    .DMA_S_AXI_arlock(DMA_S_AXI_arlock),
    .DMA_S_AXI_arprot(DMA_S_AXI_arprot),
    .DMA_S_AXI_arready(DMA_S_AXI_arready),
    .DMA_S_AXI_arsize(DMA_S_AXI_arsize),
    .DMA_S_AXI_arvalid(DMA_S_AXI_arvalid),
    .DMA_S_AXI_awaddr(DMA_S_AXI_awaddr),
    .DMA_S_AXI_awburst(DMA_S_AXI_awburst),
    .DMA_S_AXI_awcache(DMA_S_AXI_awcache),
    .DMA_S_AXI_awid(DMA_S_AXI_awid),
    .DMA_S_AXI_awlen(DMA_S_AXI_awlen),
    .DMA_S_AXI_awlock(DMA_S_AXI_awlock),
    .DMA_S_AXI_awprot(DMA_S_AXI_awprot),
    .DMA_S_AXI_awready(DMA_S_AXI_awready),
    .DMA_S_AXI_awsize(DMA_S_AXI_awsize),
    .DMA_S_AXI_awvalid(DMA_S_AXI_awvalid),
    .DMA_S_AXI_bid(DMA_S_AXI_bid),
    .DMA_S_AXI_bready(DMA_S_AXI_bready),
    .DMA_S_AXI_bresp(DMA_S_AXI_bresp),
    .DMA_S_AXI_bvalid(DMA_S_AXI_bvalid),
    .DMA_S_AXI_rdata(DMA_S_AXI_rdata),
    .DMA_S_AXI_rid(DMA_S_AXI_rid),
    .DMA_S_AXI_rlast(DMA_S_AXI_rlast),
    .DMA_S_AXI_rready(DMA_S_AXI_rready),
    .DMA_S_AXI_rresp(DMA_S_AXI_rresp),
    .DMA_S_AXI_rvalid(DMA_S_AXI_rvalid),
    .DMA_S_AXI_wdata(DMA_S_AXI_wdata),
    .DMA_S_AXI_wlast(DMA_S_AXI_wlast),
    .DMA_S_AXI_wready(DMA_S_AXI_wready),
    .DMA_S_AXI_wstrb(DMA_S_AXI_wstrb),
    .DMA_S_AXI_wvalid(DMA_S_AXI_wvalid),

    .irq_ack(irq_ack),
    .irq_req(irq_req)

`ifndef DISABLE_DDRA
  , .DDRA_init_calib_complete(DDRA_init_calib_complete),

    .DDRA_M_AXI_araddr(DDRA_M_AXI_araddr),
    .DDRA_M_AXI_arburst(DDRA_M_AXI_arburst),
    .DDRA_M_AXI_arcache(DDRA_M_AXI_arcache),
    .DDRA_M_AXI_arid(DDRA_M_AXI_arid),
    .DDRA_M_AXI_arlen(DDRA_M_AXI_arlen),
    .DDRA_M_AXI_arlock(DDRA_M_AXI_arlock),
    .DDRA_M_AXI_arprot(DDRA_M_AXI_arprot),
    .DDRA_M_AXI_arqos(DDRA_M_AXI_arqos),
    .DDRA_M_AXI_arready(DDRA_M_AXI_arready),
    .DDRA_M_AXI_arregion(DDRA_M_AXI_arregion),
    .DDRA_M_AXI_arsize(DDRA_M_AXI_arsize),
    .DDRA_M_AXI_arvalid(DDRA_M_AXI_arvalid),
    .DDRA_M_AXI_awaddr(DDRA_M_AXI_awaddr),
    .DDRA_M_AXI_awburst(DDRA_M_AXI_awburst),
    .DDRA_M_AXI_awcache(DDRA_M_AXI_awcache),
    .DDRA_M_AXI_awid(DDRA_M_AXI_awid),
    .DDRA_M_AXI_awlen(DDRA_M_AXI_awlen),
    .DDRA_M_AXI_awlock(DDRA_M_AXI_awlock),
    .DDRA_M_AXI_awprot(DDRA_M_AXI_awprot),
    .DDRA_M_AXI_awqos(DDRA_M_AXI_awqos),
    .DDRA_M_AXI_awready(DDRA_M_AXI_awready),
    .DDRA_M_AXI_awregion(DDRA_M_AXI_awregion),
    .DDRA_M_AXI_awsize(DDRA_M_AXI_awsize),
    .DDRA_M_AXI_awvalid(DDRA_M_AXI_awvalid),
    .DDRA_M_AXI_bid(DDRA_M_AXI_bid),
    .DDRA_M_AXI_bready(DDRA_M_AXI_bready),
    .DDRA_M_AXI_bresp(DDRA_M_AXI_bresp),
    .DDRA_M_AXI_bvalid(DDRA_M_AXI_bvalid),
    .DDRA_M_AXI_rdata(DDRA_M_AXI_rdata),
    .DDRA_M_AXI_rid(DDRA_M_AXI_rid),
    .DDRA_M_AXI_rlast(DDRA_M_AXI_rlast),
    .DDRA_M_AXI_rready(DDRA_M_AXI_rready),
    .DDRA_M_AXI_rresp(DDRA_M_AXI_rresp),
    .DDRA_M_AXI_rvalid(DDRA_M_AXI_rvalid),
    .DDRA_M_AXI_wdata(DDRA_M_AXI_wdata),
    .DDRA_M_AXI_wlast(DDRA_M_AXI_wlast),
    .DDRA_M_AXI_wready(DDRA_M_AXI_wready),
    .DDRA_M_AXI_wstrb(DDRA_M_AXI_wstrb),
    .DDRA_M_AXI_wvalid(DDRA_M_AXI_wvalid)
`endif

`ifndef DISABLE_DDRB
  , .DDRB_init_calib_complete(DDRB_init_calib_complete),

    .DDRB_M_AXI_araddr(DDRB_M_AXI_araddr),
    .DDRB_M_AXI_arburst(DDRB_M_AXI_arburst),
    .DDRB_M_AXI_arcache(DDRB_M_AXI_arcache),
    .DDRB_M_AXI_arid(DDRB_M_AXI_arid),
    .DDRB_M_AXI_arlen(DDRB_M_AXI_arlen),
    .DDRB_M_AXI_arlock(DDRB_M_AXI_arlock),
    .DDRB_M_AXI_arprot(DDRB_M_AXI_arprot),
    .DDRB_M_AXI_arqos(DDRB_M_AXI_arqos),
    .DDRB_M_AXI_arready(DDRB_M_AXI_arready),
    .DDRB_M_AXI_arregion(DDRB_M_AXI_arregion),
    .DDRB_M_AXI_arsize(DDRB_M_AXI_arsize),
    .DDRB_M_AXI_arvalid(DDRB_M_AXI_arvalid),
    .DDRB_M_AXI_awaddr(DDRB_M_AXI_awaddr),
    .DDRB_M_AXI_awburst(DDRB_M_AXI_awburst),
    .DDRB_M_AXI_awcache(DDRB_M_AXI_awcache),
    .DDRB_M_AXI_awid(DDRB_M_AXI_awid),
    .DDRB_M_AXI_awlen(DDRB_M_AXI_awlen),
    .DDRB_M_AXI_awlock(DDRB_M_AXI_awlock),
    .DDRB_M_AXI_awprot(DDRB_M_AXI_awprot),
    .DDRB_M_AXI_awqos(DDRB_M_AXI_awqos),
    .DDRB_M_AXI_awready(DDRB_M_AXI_awready),
    .DDRB_M_AXI_awregion(DDRB_M_AXI_awregion),
    .DDRB_M_AXI_awsize(DDRB_M_AXI_awsize),
    .DDRB_M_AXI_awvalid(DDRB_M_AXI_awvalid),
    .DDRB_M_AXI_bid(DDRB_M_AXI_bid),
    .DDRB_M_AXI_bready(DDRB_M_AXI_bready),
    .DDRB_M_AXI_bresp(DDRB_M_AXI_bresp),
    .DDRB_M_AXI_bvalid(DDRB_M_AXI_bvalid),
    .DDRB_M_AXI_rdata(DDRB_M_AXI_rdata),
    .DDRB_M_AXI_rid(DDRB_M_AXI_rid),
    .DDRB_M_AXI_rlast(DDRB_M_AXI_rlast),
    .DDRB_M_AXI_rready(DDRB_M_AXI_rready),
    .DDRB_M_AXI_rresp(DDRB_M_AXI_rresp),
    .DDRB_M_AXI_rvalid(DDRB_M_AXI_rvalid),
    .DDRB_M_AXI_wdata(DDRB_M_AXI_wdata),
    .DDRB_M_AXI_wlast(DDRB_M_AXI_wlast),
    .DDRB_M_AXI_wready(DDRB_M_AXI_wready),
    .DDRB_M_AXI_wstrb(DDRB_M_AXI_wstrb),
    .DDRB_M_AXI_wvalid(DDRB_M_AXI_wvalid)
`endif
  );

  // Pipeline reset to DDRs

  (* DONT_TOUCH = "TRUE" *)
  wire resetn_ddrs;

  pipeline #(
    .WIDTH(1),
    .DEPTH(4)
  ) pipeline_resetn_ddrs (
    .clk(clk),
    .resetn(1'b1),

    .reset_data(1'b0),

    .in_data(resetn_sync),
    .out_data(resetn_ddrs)
  );

  // Instantiate DDRs

  garnet_ddrs #(
    .ENABLE_DDRA(`IF_ELSE_DDRA(1, 0)),
    .ENABLE_DDRB(`IF_ELSE_DDRB(1, 0))
  ) ddrs (
    .clk(clk),
    .resetn(resetn_ddrs),

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

    .DDRA_init_calib_complete(`IF_DDRA(DDRA_init_calib_complete)),

    .DDRA_S_AXI_araddr(`IF_DDRA(DDRA_M_AXI_araddr)),
    .DDRA_S_AXI_arburst(`IF_DDRA(DDRA_M_AXI_arburst)),
    .DDRA_S_AXI_arcache(`IF_DDRA(DDRA_M_AXI_arcache)),
    .DDRA_S_AXI_arid(`IF_DDRA(DDRA_M_AXI_arid)),
    .DDRA_S_AXI_arlen(`IF_DDRA(DDRA_M_AXI_arlen)),
    .DDRA_S_AXI_arlock(`IF_DDRA(DDRA_M_AXI_arlock)),
    .DDRA_S_AXI_arprot(`IF_DDRA(DDRA_M_AXI_arprot)),
    .DDRA_S_AXI_arqos(`IF_DDRA(DDRA_M_AXI_arqos)),
    .DDRA_S_AXI_arready(`IF_DDRA(DDRA_M_AXI_arready)),
    .DDRA_S_AXI_arregion(`IF_DDRA(DDRA_M_AXI_arregion)),
    .DDRA_S_AXI_arsize(`IF_DDRA(DDRA_M_AXI_arsize)),
    .DDRA_S_AXI_arvalid(`IF_DDRA(DDRA_M_AXI_arvalid)),
    .DDRA_S_AXI_awaddr(`IF_DDRA(DDRA_M_AXI_awaddr)),
    .DDRA_S_AXI_awburst(`IF_DDRA(DDRA_M_AXI_awburst)),
    .DDRA_S_AXI_awcache(`IF_DDRA(DDRA_M_AXI_awcache)),
    .DDRA_S_AXI_awid(`IF_DDRA(DDRA_M_AXI_awid)),
    .DDRA_S_AXI_awlen(`IF_DDRA(DDRA_M_AXI_awlen)),
    .DDRA_S_AXI_awlock(`IF_DDRA(DDRA_M_AXI_awlock)),
    .DDRA_S_AXI_awprot(`IF_DDRA(DDRA_M_AXI_awprot)),
    .DDRA_S_AXI_awqos(`IF_DDRA(DDRA_M_AXI_awqos)),
    .DDRA_S_AXI_awready(`IF_DDRA(DDRA_M_AXI_awready)),
    .DDRA_S_AXI_awregion(`IF_DDRA(DDRA_M_AXI_awregion)),
    .DDRA_S_AXI_awsize(`IF_DDRA(DDRA_M_AXI_awsize)),
    .DDRA_S_AXI_awvalid(`IF_DDRA(DDRA_M_AXI_awvalid)),
    .DDRA_S_AXI_bid(`IF_DDRA(DDRA_M_AXI_bid)),
    .DDRA_S_AXI_bready(`IF_DDRA(DDRA_M_AXI_bready)),
    .DDRA_S_AXI_bresp(`IF_DDRA(DDRA_M_AXI_bresp)),
    .DDRA_S_AXI_bvalid(`IF_DDRA(DDRA_M_AXI_bvalid)),
    .DDRA_S_AXI_rdata(`IF_DDRA(DDRA_M_AXI_rdata)),
    .DDRA_S_AXI_rid(`IF_DDRA(DDRA_M_AXI_rid)),
    .DDRA_S_AXI_rlast(`IF_DDRA(DDRA_M_AXI_rlast)),
    .DDRA_S_AXI_rready(`IF_DDRA(DDRA_M_AXI_rready)),
    .DDRA_S_AXI_rresp(`IF_DDRA(DDRA_M_AXI_rresp)),
    .DDRA_S_AXI_rvalid(`IF_DDRA(DDRA_M_AXI_rvalid)),
    .DDRA_S_AXI_wdata(`IF_DDRA(DDRA_M_AXI_wdata)),
    .DDRA_S_AXI_wlast(`IF_DDRA(DDRA_M_AXI_wlast)),
    .DDRA_S_AXI_wready(`IF_DDRA(DDRA_M_AXI_wready)),
    .DDRA_S_AXI_wstrb(`IF_DDRA(DDRA_M_AXI_wstrb)),
    .DDRA_S_AXI_wvalid(`IF_DDRA(DDRA_M_AXI_wvalid)),

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

    .DDRB_init_calib_complete(`IF_DDRB(DDRB_init_calib_complete)),

    .DDRB_S_AXI_araddr(`IF_DDRB(DDRB_M_AXI_araddr)),
    .DDRB_S_AXI_arburst(`IF_DDRB(DDRB_M_AXI_arburst)),
    .DDRB_S_AXI_arcache(`IF_DDRB(DDRB_M_AXI_arcache)),
    .DDRB_S_AXI_arid(`IF_DDRB(DDRB_M_AXI_arid)),
    .DDRB_S_AXI_arlen(`IF_DDRB(DDRB_M_AXI_arlen)),
    .DDRB_S_AXI_arlock(`IF_DDRB(DDRB_M_AXI_arlock)),
    .DDRB_S_AXI_arprot(`IF_DDRB(DDRB_M_AXI_arprot)),
    .DDRB_S_AXI_arqos(`IF_DDRB(DDRB_M_AXI_arqos)),
    .DDRB_S_AXI_arready(`IF_DDRB(DDRB_M_AXI_arready)),
    .DDRB_S_AXI_arregion(`IF_DDRB(DDRB_M_AXI_arregion)),
    .DDRB_S_AXI_arsize(`IF_DDRB(DDRB_M_AXI_arsize)),
    .DDRB_S_AXI_arvalid(`IF_DDRB(DDRB_M_AXI_arvalid)),
    .DDRB_S_AXI_awaddr(`IF_DDRB(DDRB_M_AXI_awaddr)),
    .DDRB_S_AXI_awburst(`IF_DDRB(DDRB_M_AXI_awburst)),
    .DDRB_S_AXI_awcache(`IF_DDRB(DDRB_M_AXI_awcache)),
    .DDRB_S_AXI_awid(`IF_DDRB(DDRB_M_AXI_awid)),
    .DDRB_S_AXI_awlen(`IF_DDRB(DDRB_M_AXI_awlen)),
    .DDRB_S_AXI_awlock(`IF_DDRB(DDRB_M_AXI_awlock)),
    .DDRB_S_AXI_awprot(`IF_DDRB(DDRB_M_AXI_awprot)),
    .DDRB_S_AXI_awqos(`IF_DDRB(DDRB_M_AXI_awqos)),
    .DDRB_S_AXI_awready(`IF_DDRB(DDRB_M_AXI_awready)),
    .DDRB_S_AXI_awregion(`IF_DDRB(DDRB_M_AXI_awregion)),
    .DDRB_S_AXI_awsize(`IF_DDRB(DDRB_M_AXI_awsize)),
    .DDRB_S_AXI_awvalid(`IF_DDRB(DDRB_M_AXI_awvalid)),
    .DDRB_S_AXI_bid(`IF_DDRB(DDRB_M_AXI_bid)),
    .DDRB_S_AXI_bready(`IF_DDRB(DDRB_M_AXI_bready)),
    .DDRB_S_AXI_bresp(`IF_DDRB(DDRB_M_AXI_bresp)),
    .DDRB_S_AXI_bvalid(`IF_DDRB(DDRB_M_AXI_bvalid)),
    .DDRB_S_AXI_rdata(`IF_DDRB(DDRB_M_AXI_rdata)),
    .DDRB_S_AXI_rid(`IF_DDRB(DDRB_M_AXI_rid)),
    .DDRB_S_AXI_rlast(`IF_DDRB(DDRB_M_AXI_rlast)),
    .DDRB_S_AXI_rready(`IF_DDRB(DDRB_M_AXI_rready)),
    .DDRB_S_AXI_rresp(`IF_DDRB(DDRB_M_AXI_rresp)),
    .DDRB_S_AXI_rvalid(`IF_DDRB(DDRB_M_AXI_rvalid)),
    .DDRB_S_AXI_wdata(`IF_DDRB(DDRB_M_AXI_wdata)),
    .DDRB_S_AXI_wlast(`IF_DDRB(DDRB_M_AXI_wlast)),
    .DDRB_S_AXI_wready(`IF_DDRB(DDRB_M_AXI_wready)),
    .DDRB_S_AXI_wstrb(`IF_DDRB(DDRB_M_AXI_wstrb)),
    .DDRB_S_AXI_wvalid(`IF_DDRB(DDRB_M_AXI_wvalid))
  );

`ifndef DISABLE_DEBUG_BRIDGE
  debug_bridge debug_bridge (
    .clk(clk),
    .S_BSCAN_drck(drck),
    .S_BSCAN_shift(shift),
    .S_BSCAN_tdi(tdi),
    .S_BSCAN_update(update),
    .S_BSCAN_sel(sel),
    .S_BSCAN_tdo(tdo),
    .S_BSCAN_tms(tms),
    .S_BSCAN_tck(tck),
    .S_BSCAN_runtest(runtest),
    .S_BSCAN_reset(reset),
    .S_BSCAN_capture(capture),
    .S_BSCAN_bscanid_en(bscanid_en)
  );
`endif

endmodule
