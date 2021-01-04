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

module handshake_register_slice #(
  parameter integer DATA_WIDTH = 1,
  parameter integer LOG2_DEPTH = 1
) (
  input clk,
  input resetn,

  input s_valid,
  output s_ready,
  input [DATA_WIDTH-1:0] s_data,
  output m_valid,
  input m_ready,
  output [DATA_WIDTH-1:0] m_data
);

  localparam integer DEPTH = 1 << LOG2_DEPTH;

  reg rg_resetting;

  reg [LOG2_DEPTH-1:0] rg_head;
  reg [LOG2_DEPTH-1:0] rg_tail;
  reg rg_full;
  reg rg_empty;
  reg [DATA_WIDTH-1:0] rg_data [DEPTH-1:0];

  // Use wires rather than inlining to force truncation
  wire [LOG2_DEPTH-1:0] w_next_head;
  wire [LOG2_DEPTH-1:0] w_next_tail;

  always @(posedge clk) begin
    if (!resetn) begin
      rg_resetting <= 1'b1;

      rg_head <= {LOG2_DEPTH{1'b0}};
      rg_tail <= {LOG2_DEPTH{1'b0}};
      rg_full <= 1'b0;
      rg_empty <= 1'b1;
    end
    else begin
      rg_resetting <= 1'b0;

      if (s_valid && s_ready) begin
        rg_data[rg_head] <= s_data;
        rg_head <= w_next_head;
        if (!m_valid || !m_ready) begin
          rg_empty <= 1'b0;
          rg_full <= w_next_head == rg_tail;
        end
      end

      if (m_valid && m_ready) begin
        rg_tail <= w_next_tail;
        if (!s_valid || !s_ready) begin
          rg_empty <= rg_head == w_next_tail;
          rg_full <= 1'b0;
        end
      end
    end
  end

  assign w_next_head = rg_head + 1;
  assign w_next_tail = rg_tail + 1;

  assign s_ready = !rg_full && !rg_resetting;
  assign m_valid = !rg_empty;
  assign m_data = rg_data[rg_tail];

endmodule
