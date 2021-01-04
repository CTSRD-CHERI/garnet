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

module example (
  `include "partition_ports.vh"
);

  // CTL and IRQ logic; writes control irq_req, reads see number of irq_ack's

  reg [15:0] rg_irq_req;
  reg [31:0] rg_irq_acks [15:0];

  reg        rg_pending_ctl_rvalid;
  reg [31:0] rg_pending_ctl_rdata;

  reg [3:0] rg_pending_ctl_awaddr_irq;
  reg       rg_pending_ctl_wready;
  reg       rg_pending_ctl_bvalid;

  integer i;
  always @(posedge clk) begin
    if (!resetn) begin
      rg_irq_req <= 16'b0;

      for (i = 0; i < 16; i = i + 1) begin
        rg_irq_acks[i] <= 32'b0;
      end

      rg_pending_ctl_rvalid <= 1'b0;
      rg_pending_ctl_rdata  <= 32'b0;

      rg_pending_ctl_awaddr_irq <= 4'b0;
      rg_pending_ctl_wready     <= 1'b0;
      rg_pending_ctl_bvalid     <= 1'b0;
    end
    else begin
      for (i = 0; i < 16; i = i + 1) begin
        if (irq_ack[i]) begin
          rg_irq_acks[i] <= rg_irq_acks[i] + 1;
        end
      end

      if (CTL_S_AXI_LITE_arvalid && CTL_S_AXI_LITE_arready) begin
        rg_pending_ctl_rvalid <= 1'b1;
        rg_pending_ctl_rdata  <= rg_irq_acks[CTL_S_AXI_LITE_araddr[5:2]];
      end

      if (CTL_S_AXI_LITE_rvalid && CTL_S_AXI_LITE_rready) begin
        rg_pending_ctl_rvalid <= 1'b0;
      end

      if (CTL_S_AXI_LITE_awvalid && CTL_S_AXI_LITE_awready) begin
        rg_pending_ctl_awaddr_irq <= CTL_S_AXI_LITE_awaddr[5:2];
        rg_pending_ctl_wready     <= 1'b1;
      end

      if (CTL_S_AXI_LITE_wvalid && CTL_S_AXI_LITE_wready) begin
        rg_irq_req[rg_pending_ctl_awaddr_irq] <=
          (CTL_S_AXI_LITE_wdata[0] & CTL_S_AXI_LITE_wstrb[0]) |
          (rg_irq_req[rg_pending_ctl_awaddr_irq] & ~CTL_S_AXI_LITE_wstrb[0]);

        rg_pending_ctl_wready <= 1'b0;
        rg_pending_ctl_bvalid <= 1'b1;
      end

      if (CTL_S_AXI_LITE_bvalid && CTL_S_AXI_LITE_bready) begin
        rg_pending_ctl_bvalid <= 1'b0;
      end
    end
  end

  assign CTL_S_AXI_LITE_arready = !rg_pending_ctl_rvalid;

  assign CTL_S_AXI_LITE_rdata = rg_pending_ctl_rdata;
  assign CTL_S_AXI_LITE_rresp = 2'b0;
  assign CTL_S_AXI_LITE_rvalid = rg_pending_ctl_rvalid;

  assign CTL_S_AXI_LITE_awready = !rg_pending_ctl_wready && !rg_pending_ctl_bvalid;

  assign CTL_S_AXI_LITE_wready = rg_pending_ctl_wready;

  assign CTL_S_AXI_LITE_bresp = 2'b0;
  assign CTL_S_AXI_LITE_bvalid = rg_pending_ctl_bvalid;

  assign irq_req = rg_irq_req;

  // Use DDR A for DMA

  wire [5:0] DMA_S_AXI_bid_6;
  wire [5:0] DMA_S_AXI_rid_6;

  assign DMA_S_AXI_bid = DMA_S_AXI_bid_6[3:0];
  assign DMA_S_AXI_rid = DMA_S_AXI_rid_6[3:0];

  axi_register_slice dma_slice (
    .clk(clk),
    .resetn(resetn),

    .s_axi_araddr(DMA_S_AXI_araddr),
    .s_axi_arburst(DMA_S_AXI_arburst),
    .s_axi_arcache(DMA_S_AXI_arcache),
    .s_axi_arid({2'b0, DMA_S_AXI_arid}),
    .s_axi_arlen(DMA_S_AXI_arlen),
    .s_axi_arlock(DMA_S_AXI_arlock),
    .s_axi_arprot(DMA_S_AXI_arprot),
    .s_axi_arqos(4'b0),
    .s_axi_arready(DMA_S_AXI_arready),
    .s_axi_arregion(4'b0),
    .s_axi_arsize(DMA_S_AXI_arsize),
    .s_axi_arvalid(DMA_S_AXI_arvalid),
    .s_axi_awaddr(DMA_S_AXI_awaddr),
    .s_axi_awburst(DMA_S_AXI_awburst),
    .s_axi_awcache(DMA_S_AXI_awcache),
    .s_axi_awid({2'b0, DMA_S_AXI_awid}),
    .s_axi_awlen(DMA_S_AXI_awlen),
    .s_axi_awlock(DMA_S_AXI_awlock),
    .s_axi_awprot(DMA_S_AXI_awprot),
    .s_axi_awqos(4'b0),
    .s_axi_awready(DMA_S_AXI_awready),
    .s_axi_awregion(4'b0),
    .s_axi_awsize(DMA_S_AXI_awsize),
    .s_axi_awvalid(DMA_S_AXI_awvalid),
    .s_axi_bid(DMA_S_AXI_bid_6),
    .s_axi_bready(DMA_S_AXI_bready),
    .s_axi_bresp(DMA_S_AXI_bresp),
    .s_axi_bvalid(DMA_S_AXI_bvalid),
    .s_axi_rdata(DMA_S_AXI_rdata),
    .s_axi_rid(DMA_S_AXI_rid_6),
    .s_axi_rlast(DMA_S_AXI_rlast),
    .s_axi_rready(DMA_S_AXI_rready),
    .s_axi_rresp(DMA_S_AXI_rresp),
    .s_axi_rvalid(DMA_S_AXI_rvalid),
    .s_axi_wdata(DMA_S_AXI_wdata),
    .s_axi_wlast(DMA_S_AXI_wlast),
    .s_axi_wready(DMA_S_AXI_wready),
    .s_axi_wstrb(DMA_S_AXI_wstrb),
    .s_axi_wvalid(DMA_S_AXI_wvalid),

    .m_axi_araddr(DDRA_M_AXI_araddr),
    .m_axi_arburst(DDRA_M_AXI_arburst),
    .m_axi_arcache(DDRA_M_AXI_arcache),
    .m_axi_arid(DDRA_M_AXI_arid),
    .m_axi_arlen(DDRA_M_AXI_arlen),
    .m_axi_arlock(DDRA_M_AXI_arlock),
    .m_axi_arprot(DDRA_M_AXI_arprot),
    .m_axi_arqos(DDRA_M_AXI_arqos),
    .m_axi_arready(DDRA_M_AXI_arready),
    .m_axi_arregion(DDRA_M_AXI_arregion),
    .m_axi_arsize(DDRA_M_AXI_arsize),
    .m_axi_arvalid(DDRA_M_AXI_arvalid),
    .m_axi_awaddr(DDRA_M_AXI_awaddr),
    .m_axi_awburst(DDRA_M_AXI_awburst),
    .m_axi_awcache(DDRA_M_AXI_awcache),
    .m_axi_awid(DDRA_M_AXI_awid),
    .m_axi_awlen(DDRA_M_AXI_awlen),
    .m_axi_awlock(DDRA_M_AXI_awlock),
    .m_axi_awprot(DDRA_M_AXI_awprot),
    .m_axi_awqos(DDRA_M_AXI_awqos),
    .m_axi_awready(DDRA_M_AXI_awready),
    .m_axi_awregion(DDRA_M_AXI_awregion),
    .m_axi_awsize(DDRA_M_AXI_awsize),
    .m_axi_awvalid(DDRA_M_AXI_awvalid),
    .m_axi_bid(DDRA_M_AXI_bid),
    .m_axi_bready(DDRA_M_AXI_bready),
    .m_axi_bresp(DDRA_M_AXI_bresp),
    .m_axi_bvalid(DDRA_M_AXI_bvalid),
    .m_axi_rdata(DDRA_M_AXI_rdata),
    .m_axi_rid(DDRA_M_AXI_rid),
    .m_axi_rlast(DDRA_M_AXI_rlast),
    .m_axi_rready(DDRA_M_AXI_rready),
    .m_axi_rresp(DDRA_M_AXI_rresp),
    .m_axi_rvalid(DDRA_M_AXI_rvalid),
    .m_axi_wdata(DDRA_M_AXI_wdata),
    .m_axi_wlast(DDRA_M_AXI_wlast),
    .m_axi_wready(DDRA_M_AXI_wready),
    .m_axi_wstrb(DDRA_M_AXI_wstrb),
    .m_axi_wvalid(DDRA_M_AXI_wvalid)
  );

endmodule
