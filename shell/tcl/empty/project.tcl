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

set garnet_shell_dir ".."
set garnet_dir "$garnet_shell_dir/.."
set project_name "project"

create_project -force empty -part xcvu9p-flga2104-2L-e
set_property board_part xilinx.com:vcu118:part0:2.3 [current_project]

source "$garnet_dir/tcl/waivers_ip.tcl"
source "$garnet_dir/tcl/waivers_shell.tcl"

set_property PR_FLOW 1 [current_project]

add_files [list \
  "$garnet_shell_dir/src/axi_firewall_auto_unblocker.v" \
  "$garnet_shell_dir/src/decouple_pipeline.v" \
  "$garnet_shell_dir/src/irq_shim.v" \
]

source "$garnet_shell_dir/tcl/shell.tcl"

add_files [list \
  "$garnet_dir/include/partition_ports.vh" \
  "$garnet_dir/include/partition_wrapper_ports.vh" \
  "$garnet_dir/lib/garnet_ddr.v" \
  "$garnet_dir/lib/garnet_ddrs.v" \
  "$garnet_dir/lib/partition_wrapper.v" \
  "$garnet_dir/lib/pipeline.v" \
  "$garnet_shell_dir/src/empty.v" \
  "$garnet_shell_dir/src/garnet_top.v" \
  "$garnet_shell_dir/include/garnet_config.vh" \
]

set_property TOP garnet_top [get_filesets sources_1]

update_compile_order -fileset sources_1

create_partition_def -name partition_def -module partition_wrapper
create_reconfig_module -name partition_rm -partition_def [get_partition_defs partition_def] -define_from partition_wrapper
create_pr_configuration -name config_empty -partitions [list partition_wrapper:partition_rm]
set_property PR_CONFIGURATION config_empty [get_runs impl_1]

add_files -fileset constrs_1 [list \
  "$garnet_shell_dir/tcl/pblocks.tcl" \
  "$garnet_shell_dir/xdc/bitstreams.xdc" \
  "$garnet_dir/xdc/ddrs.xdc" \
]

set_property USED_IN {implementation} [get_files pblocks.tcl]

set_property USED_IN {synthesis implementation} [get_files ddrs.xdc]
set_property SCOPED_TO_CELLS {partition_wrapper} [get_files ddrs.xdc]

launch_runs synth_1 -scripts_only

set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE AlternateRoutability [get_runs shell_xdma_0_synth_1]

set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE AltSpreadLogic_low [get_runs impl_1]
set_property {STEPS.PLACE_DESIGN.ARGS.MORE OPTIONS} -value {-timing_summary} -objects [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
set_property {STEPS.ROUTE_DESIGN.ARGS.MORE OPTIONS} -value {-timing_summary} -objects [get_runs impl_1]

reset_runs [get_runs]

# We generated the scripts above so we could change the synth_design directive
# for the XDMA block, but Vivado doesn't like that the IP files are missing
set_msg_config -id {[IP_Flow 19-3664]} -suppress
# Locking shell requires LOC constraints on global clock buffers
set_msg_config -id {[Constraints 18-4434]} -suppress
