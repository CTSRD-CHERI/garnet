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

module pipeline #(
  parameter integer WIDTH = 1,
  parameter integer DEPTH = 1
) (
  input clk,
  input resetn,

  input [WIDTH-1:0] reset_data,

  input [WIDTH-1:0] in_data,
  output [WIDTH-1:0] out_data
);

  (* SHREG_EXTRACT = "NO" *)
  reg [WIDTH-1:0] rg_data [DEPTH-1:0];

  integer i;

  always @(posedge clk) begin
    if (!resetn) begin
      for (i = 0; i < DEPTH; i = i + 1)
        rg_data[i] <= reset_data;
    end
    else begin
      rg_data[0] <= in_data;

      for (i = 1; i < DEPTH; i = i + 1)
        rg_data[i] <= rg_data[i-1];
    end
  end

  assign out_data = rg_data[DEPTH-1];

endmodule
