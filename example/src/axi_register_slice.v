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

module axi_register_slice #(
  parameter integer LOG2_DEPTH = 1
) (
  input clk,
  input resetn,

  input [63:0] s_axi_araddr,
  input [1:0] s_axi_arburst,
  input [3:0] s_axi_arcache,
  input [5:0] s_axi_arid,
  input [7:0] s_axi_arlen,
  input [0:0] s_axi_arlock,
  input [2:0] s_axi_arprot,
  input [3:0] s_axi_arqos,
  output s_axi_arready,
  input [3:0] s_axi_arregion,
  input [2:0] s_axi_arsize,
  input s_axi_arvalid,
  input [63:0] s_axi_awaddr,
  input [1:0] s_axi_awburst,
  input [3:0] s_axi_awcache,
  input [5:0] s_axi_awid,
  input [7:0] s_axi_awlen,
  input [0:0] s_axi_awlock,
  input [2:0] s_axi_awprot,
  input [3:0] s_axi_awqos,
  output s_axi_awready,
  input [3:0] s_axi_awregion,
  input [2:0] s_axi_awsize,
  input s_axi_awvalid,
  output [5:0] s_axi_bid,
  input s_axi_bready,
  output [1:0] s_axi_bresp,
  output s_axi_bvalid,
  output [511:0] s_axi_rdata,
  output [5:0] s_axi_rid,
  output s_axi_rlast,
  input s_axi_rready,
  output [1:0] s_axi_rresp,
  output s_axi_rvalid,
  input [511:0] s_axi_wdata,
  input s_axi_wlast,
  output s_axi_wready,
  input [63:0] s_axi_wstrb,
  input s_axi_wvalid,

  output [63:0] m_axi_araddr,
  output [1:0] m_axi_arburst,
  output [3:0] m_axi_arcache,
  output [5:0] m_axi_arid,
  output [7:0] m_axi_arlen,
  output [0:0] m_axi_arlock,
  output [2:0] m_axi_arprot,
  output [3:0] m_axi_arqos,
  input m_axi_arready,
  output [3:0] m_axi_arregion,
  output [2:0] m_axi_arsize,
  output m_axi_arvalid,
  output [63:0] m_axi_awaddr,
  output [1:0] m_axi_awburst,
  output [3:0] m_axi_awcache,
  output [5:0] m_axi_awid,
  output [7:0] m_axi_awlen,
  output [0:0] m_axi_awlock,
  output [2:0] m_axi_awprot,
  output [3:0] m_axi_awqos,
  input m_axi_awready,
  output [3:0] m_axi_awregion,
  output [2:0] m_axi_awsize,
  output m_axi_awvalid,
  input [5:0] m_axi_bid,
  output m_axi_bready,
  input [1:0] m_axi_bresp,
  input m_axi_bvalid,
  input [511:0] m_axi_rdata,
  input [5:0] m_axi_rid,
  input m_axi_rlast,
  output m_axi_rready,
  input [1:0] m_axi_rresp,
  input m_axi_rvalid,
  output [511:0] m_axi_wdata,
  output m_axi_wlast,
  input m_axi_wready,
  output [63:0] m_axi_wstrb,
  output m_axi_wvalid
);

  handshake_register_slice #(
    .DATA_WIDTH(64 + 2 + 4 + 6 + 8 + 1 + 3 + 4 + 4 + 3),
    .LOG2_DEPTH(LOG2_DEPTH)
  ) ar (
    .clk(clk),
    .resetn(resetn),

    .s_valid(s_axi_arvalid),
    .s_ready(s_axi_arready),
    .s_data({
      s_axi_araddr,
      s_axi_arburst,
      s_axi_arcache,
      s_axi_arid,
      s_axi_arlen,
      s_axi_arlock,
      s_axi_arprot,
      s_axi_arqos,
      s_axi_arregion,
      s_axi_arsize
    }),

    .m_valid(m_axi_arvalid),
    .m_ready(m_axi_arready),
    .m_data({
      m_axi_araddr,
      m_axi_arburst,
      m_axi_arcache,
      m_axi_arid,
      m_axi_arlen,
      m_axi_arlock,
      m_axi_arprot,
      m_axi_arqos,
      m_axi_arregion,
      m_axi_arsize
    })
  );

  handshake_register_slice #(
    .DATA_WIDTH(64 + 2 + 4 + 6 + 8 + 1 + 3 + 4 + 4 + 3),
    .LOG2_DEPTH(LOG2_DEPTH)
  ) aw (
    .clk(clk),
    .resetn(resetn),

    .s_valid(s_axi_awvalid),
    .s_ready(s_axi_awready),
    .s_data({
      s_axi_awaddr,
      s_axi_awburst,
      s_axi_awcache,
      s_axi_awid,
      s_axi_awlen,
      s_axi_awlock,
      s_axi_awprot,
      s_axi_awqos,
      s_axi_awregion,
      s_axi_awsize
    }),

    .m_valid(m_axi_awvalid),
    .m_ready(m_axi_awready),
    .m_data({
      m_axi_awaddr,
      m_axi_awburst,
      m_axi_awcache,
      m_axi_awid,
      m_axi_awlen,
      m_axi_awlock,
      m_axi_awprot,
      m_axi_awqos,
      m_axi_awregion,
      m_axi_awsize
    })
  );

  handshake_register_slice #(
    .DATA_WIDTH(6 + 2),
    .LOG2_DEPTH(LOG2_DEPTH)
  ) b (
    .clk(clk),
    .resetn(resetn),

    .s_valid(m_axi_bvalid),
    .s_ready(m_axi_bready),
    .s_data({
      m_axi_bid,
      m_axi_bresp
    }),

    .m_valid(s_axi_bvalid),
    .m_ready(s_axi_bready),
    .m_data({
      s_axi_bid,
      s_axi_bresp
    })
  );

  handshake_register_slice #(
    .DATA_WIDTH(512 + 6 + 1 + 2),
    .LOG2_DEPTH(LOG2_DEPTH)
  ) r (
    .clk(clk),
    .resetn(resetn),

    .s_valid(m_axi_rvalid),
    .s_ready(m_axi_rready),
    .s_data({
      m_axi_rdata,
      m_axi_rid,
      m_axi_rlast,
      m_axi_rresp
    }),

    .m_valid(s_axi_rvalid),
    .m_ready(s_axi_rready),
    .m_data({
      s_axi_rdata,
      s_axi_rid,
      s_axi_rlast,
      s_axi_rresp
    })
  );

  handshake_register_slice #(
    .DATA_WIDTH(512 + 1 + 64),
    .LOG2_DEPTH(LOG2_DEPTH)
  ) w (
    .clk(clk),
    .resetn(resetn),

    .s_valid(s_axi_wvalid),
    .s_ready(s_axi_wready),
    .s_data({
      s_axi_wdata,
      s_axi_wlast,
      s_axi_wstrb
    }),

    .m_valid(m_axi_wvalid),
    .m_ready(m_axi_wready),
    .m_data({
      m_axi_wdata,
      m_axi_wlast,
      m_axi_wstrb
    })
  );

endmodule
