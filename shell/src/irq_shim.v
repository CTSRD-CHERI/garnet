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

// Presents an edge-triggered interrupt interface wrapper for the Xilinx
// DMA/Bridge Subsystem for PCI Express v4.1 (PG195), simplifying the
// requirements for the reconfigurable partition and supporting decoupling.
//
// This module relies on MSI-X interrupts so that the interrupts can be
// immediately deasserted on ACK without complex driver handshaking needed
// (the XDMA driver unfortunately uses a single MSI vector for all IRQs,
// requiring the interrupt to remain asserted after the ACK until the driver
// itself has read the IRQ Block User Interrupt Request register and seen the
// relevant bit set).
module irq_shim #(
  parameter integer IRQ_NUM = 16
) (
  input [IRQ_NUM-1:0] s_irq_req,
  output [IRQ_NUM-1:0] s_irq_ack,

  output [IRQ_NUM-1:0] m_irq_req,
  input [IRQ_NUM-1:0] m_irq_ack,

  input clk,
  input resetn,

  input decouple_control,
  output decouple_status
);

  reg [IRQ_NUM-1:0] rg_pend_req;
  reg [IRQ_NUM-1:0] rg_pend_ack;

  // If an interrupt is requested, the partition is decoupled, reconfiguration
  // is performed and another interrupt is requested all before seeing the ACK
  // from the first interrupt, this will temporarily record the need to issue
  // an interrupt after the ACK.
  reg [IRQ_NUM-1:0] rg_saved_req;

  reg [IRQ_NUM-1:0] rg_prev_irq_req;
  reg [IRQ_NUM-1:0] rg_prev_pend_ack;

  integer i;
  always @(posedge clk) begin
    for (i = 0; i < IRQ_NUM; i = i + 1) begin
      if (!resetn) begin
        rg_pend_req[i] <= 1'b0;
        rg_pend_ack[i] <= 1'b0;

        rg_saved_req[i] <= 1'b0;

        rg_prev_irq_req[i] <= 1'b0;
        rg_prev_pend_ack[i] <= 1'b0;
      end
      else begin
        if (!decouple_control) begin
          if (m_irq_ack[i] && rg_pend_req[i]) begin
            rg_pend_req[i] <= 1'b0;
            rg_pend_ack[i] <= 1'b0;
          end

          if ((!rg_prev_irq_req[i] && s_irq_req[i]) || rg_saved_req[i]) begin
            if (!rg_pend_req[i]) begin
              rg_pend_req[i] <= 1'b1;
              rg_pend_ack[i] <= 1'b1;

              rg_saved_req[i] <= 1'b0;
            end
            else if (!rg_pend_ack[i]) begin
              // We can only have a pending request but no pending ACK if
              // decoupled since issuing the request, so this is a legitimate
              // request from the new partition that we must delay until we
              // see the ACK for the old request.
              rg_saved_req[i] <= 1'b1;
            end
          end

          rg_prev_irq_req[i]  <= s_irq_req[i];
          rg_prev_pend_ack[i] <= rg_pend_ack[i];
        end
        else begin
          if (m_irq_ack[i])
            rg_pend_req[i] <= 1'b0;

          rg_pend_ack[i] <= 1'b0;

          rg_saved_req[i] <= 1'b0;

          rg_prev_irq_req[i]  <= 1'b0;
          rg_prev_pend_ack[i] <= 1'b0;
        end
      end
    end
  end

  assign s_irq_ack = rg_prev_pend_ack & ~rg_pend_ack;

  assign m_irq_req = rg_pend_req;

  assign decouple_status = decouple_control;

endmodule
