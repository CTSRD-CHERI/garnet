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

module axi_firewall_auto_unblocker (
  output [11:0] M_AXI_CTL_araddr,
  input M_AXI_CTL_arready,
  output M_AXI_CTL_arvalid,
  output [11:0] M_AXI_CTL_awaddr,
  input M_AXI_CTL_awready,
  output M_AXI_CTL_awvalid,
  output M_AXI_CTL_bready,
  input [1:0] M_AXI_CTL_bresp,
  input M_AXI_CTL_bvalid,
  input [31:0] M_AXI_CTL_rdata,
  output M_AXI_CTL_rready,
  input [1:0] M_AXI_CTL_rresp,
  input M_AXI_CTL_rvalid,
  output [31:0] M_AXI_CTL_wdata,
  input M_AXI_CTL_wready,
  output [3:0] M_AXI_CTL_wstrb,
  output M_AXI_CTL_wvalid,

  input aclk,
  input aresetn,

  input mi_w_error,
  input mi_r_error
);

  // AXI Protocol Firewall IP v1.0 (PG293) is very light on details about the
  // exact order in which unblocking happens when using the AXI4-Lite
  // interface. It's unclear exactly when in the sequence the write response
  // comes back. Thus, be extremely cautious and track write response
  // completion independently from the unblock actually completing.
  reg rg_pending_write;
  reg rg_pending_unblock;

  reg rg_awvalid;
  reg rg_wvalid;

  initial begin
    rg_pending_write   = 1'b0;
    rg_pending_unblock = 1'b0;

    rg_awvalid = 1'b0;
    rg_wvalid  = 1'b0;
  end

  always @(posedge aclk) begin
    if (!aresetn) begin
      rg_pending_write   <= 1'b0;
      rg_pending_unblock <= 1'b0;

      rg_awvalid <= 1'b0;
      rg_wvalid  <= 1'b0;
    end
    else begin
      // Stall error detection until we're sure this is a new error and any
      // previous unblocking has been completed fully. The mi_*_error signals
      // are sticky so this is safe to do.
      if ((mi_w_error || mi_r_error) && !(rg_pending_write || rg_pending_unblock)) begin
        rg_pending_write   <= 1'b1;
        rg_pending_unblock <= 1'b1;

        rg_awvalid <= 1'b1;
        rg_wvalid  <= 1'b1;
      end

      if (M_AXI_CTL_awvalid && M_AXI_CTL_awready) begin
        rg_awvalid <= 1'b0;
      end

      if (M_AXI_CTL_wvalid && M_AXI_CTL_wready) begin
        rg_wvalid <= 1'b0;
      end

      if (M_AXI_CTL_bvalid && M_AXI_CTL_bready) begin
        rg_pending_write <= 1'b0;
      end

      if (rg_pending_unblock && !(mi_w_error || mi_r_error)) begin
        rg_pending_unblock <= 1'b0;
      end
    end
  end

  assign M_AXI_CTL_araddr = 12'b0;
  assign M_AXI_CTL_arvalid = 1'b0;

  // MI Unblock Control Register
  assign M_AXI_CTL_awaddr = 12'h8;
  assign M_AXI_CTL_awvalid = rg_awvalid;

  // Unblock request is bit 0
  assign M_AXI_CTL_wdata = 32'b1;
  assign M_AXI_CTL_wstrb = 4'b1;
  assign M_AXI_CTL_wvalid = rg_wvalid;

  assign M_AXI_CTL_rready = 1'b0;

  assign M_AXI_CTL_bready = 1'b1;

endmodule
