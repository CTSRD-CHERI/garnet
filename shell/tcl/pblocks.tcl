#-
# Copyright (c) 2020-2021 Jessica Clarke
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

# --- Define pblocks

create_pblock pblock_partition

create_pblock pblock_shell
create_pblock pblock_shim
create_pblock pblock_shim_0
set_property PARENT pblock_shim [get_pblocks pblock_shim_0]
create_pblock pblock_shim_1
set_property PARENT pblock_shim [get_pblocks pblock_shim_1]
create_pblock pblock_shim_2
set_property PARENT pblock_shim [get_pblocks pblock_shim_2]
create_pblock pblock_shim_3
set_property PARENT pblock_shim [get_pblocks pblock_shim_3]
create_pblock pblock_shim_4
set_property PARENT pblock_shim [get_pblocks pblock_shim_4]

# --- Resize pblocks

resize_pblock pblock_partition -add CLOCKREGION_X0Y0:CLOCKREGION_X5Y14

proc assign_to_shell_pblock {pblock region} {
  resize_pblock pblock_partition -remove $region
  while {$pblock != {ROOT}} {
    resize_pblock $pblock -add $region
    set pblock [get_property PARENT [get_pblocks $pblock]]
  }
}

assign_to_shell_pblock pblock_shell CLOCKREGION_X4Y5:CLOCKREGION_X5Y9
assign_to_shell_pblock pblock_shim_0 SLICE_X108Y300:SLICE_X111Y359
assign_to_shell_pblock pblock_shim_1 SLICE_X108Y360:SLICE_X111Y419
assign_to_shell_pblock pblock_shim_2 SLICE_X108Y420:SLICE_X111Y479
assign_to_shell_pblock pblock_shim_3 SLICE_X108Y480:SLICE_X111Y539
assign_to_shell_pblock pblock_shim_4 SLICE_X108Y540:SLICE_X111Y599

# --- Assign cells to pblocks

add_cells_to_pblock pblock_partition [get_cells partition_wrapper]

add_cells_to_pblock pblock_shell [get_cells shell]
add_cells_to_pblock pblock_shim [get_cells shell/shim]

add_cells_to_pblock pblock_shim_0 [get_cells {shell/shim/axi_register_slice_CTL/inst/aw.aw_pipe}]
add_cells_to_pblock pblock_shim_0 [get_cells {shell/shim/axi_register_slice_CTL/inst/w.w_pipe}]
add_cells_to_pblock pblock_shim_0 [get_cells {shell/shim/axi_register_slice_CTL/inst/b.b_pipe}]
add_cells_to_pblock pblock_shim_0 [get_cells {shell/shim/axi_register_slice_CTL/inst/ar.ar_pipe}]
add_cells_to_pblock pblock_shim_0 [get_cells {shell/shim/axi_register_slice_CTL/inst/r.r_pipe}]

add_cells_to_pblock pblock_shim_1 [get_cells shell/shim/irq_shim]

add_cells_to_pblock pblock_shim_2 [get_cells shell/shim/debug_bridge_bscan]
add_cells_to_pblock pblock_shim_2 [get_cells shell/shim/proc_sys_reset]

add_cells_to_pblock pblock_shim_3 [get_cells {shell/shim/axi_register_slice_DMA/inst/aw.aw_pipe}]
add_cells_to_pblock pblock_shim_3 [get_cells {shell/shim/axi_register_slice_DMA/inst/w.w_pipe}]
add_cells_to_pblock pblock_shim_3 [get_cells {shell/shim/axi_register_slice_DMA/inst/b.b_pipe}]

add_cells_to_pblock pblock_shim_4 [get_cells {shell/shim/axi_register_slice_DMA/inst/ar.ar_pipe}]
add_cells_to_pblock pblock_shim_4 [get_cells {shell/shim/axi_register_slice_DMA/inst/r.r_pipe}]
