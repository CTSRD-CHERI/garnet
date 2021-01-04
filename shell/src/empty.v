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

module empty_partition (
  `include "partition_ports.vh"
);

  assign CTL_S_AXI_LITE_arready = 1'b0;
  assign CTL_S_AXI_LITE_awready = 1'b0;
  assign CTL_S_AXI_LITE_bresp = {2{1'bx}};
  assign CTL_S_AXI_LITE_bvalid = 1'b0;
  assign CTL_S_AXI_LITE_rdata = {32{1'bx}};
  assign CTL_S_AXI_LITE_rresp = {2{1'bx}};
  assign CTL_S_AXI_LITE_rvalid = 1'b0;
  assign CTL_S_AXI_LITE_wready = 1'b0;

  assign DMA_S_AXI_arready = 1'b0;
  assign DMA_S_AXI_awready = 1'b0;
  assign DMA_S_AXI_bid = {6{1'bx}};
  assign DMA_S_AXI_bresp = {2{1'bx}};
  assign DMA_S_AXI_bvalid = 1'b0;
  assign DMA_S_AXI_rdata = {512{1'bx}};
  assign DMA_S_AXI_rid = {6{1'bx}};
  assign DMA_S_AXI_rlast = 1'bx;
  assign DMA_S_AXI_rresp = {2{1'bx}};
  assign DMA_S_AXI_rvalid = 1'b0;
  assign DMA_S_AXI_wready = 1'b0;

  assign irq_req = {16{1'b0}};

endmodule
