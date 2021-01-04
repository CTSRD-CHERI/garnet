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

if {![info exists garnet_dir]} {
  error "ERROR: Script did not set garnet_dir"
}

if {![info exists project_name]} {
  error "ERROR: Script did not set project_name"
}

if {![info exists partition_module]} {
  error "ERROR: Script did not set partition_module"
}

if {![info exists disable_ddra]} {
  set disable_ddra 0
}

if {![info exists disable_ddrb]} {
  set disable_ddrb 0
}

if {![info exists disable_debug_bridge]} {
  set disable_debug_bridge 0
}

proc garnet_create_synth_project {args} {
  global partition_module
  global garnet_dir
  global disable_ddra
  global disable_ddrb
  global disable_debug_bridge

  create_project -in_memory -part xcvu9p-flga2104-2L-e {*}$args
  set_property board_part xilinx.com:vcu118:part0:2.3 [current_project]

  set config_fd [open garnet_config.vh w]
  puts $config_fd "`ifndef GARNET_CONFIG_SVH"
  puts $config_fd "`define GARNET_CONFIG_SVH"
  puts $config_fd ""
  puts $config_fd "`define PARTITION_MODULE $partition_module"
  if {$disable_ddra} {
    puts $config_fd "`define DISABLE_DDRA"
  } else {
    puts $config_fd "// `undef DISABLE_DDRA"
  }
  if {$disable_ddrb} {
    puts $config_fd "`define DISABLE_DDRB"
  } else {
    puts $config_fd "// `undef DISABLE_DDRB"
  }
  if {$disable_debug_bridge} {
    puts $config_fd "`define DISABLE_DEBUG_BRIDGE"
  } else {
    puts $config_fd "// `undef DISABLE_DEBUG_BRIDGE"
  }
  puts $config_fd ""
  puts $config_fd "`endif"
  close $config_fd

  source "$garnet_dir/tcl/waivers_ip.tcl"

  add_files [list \
    "$garnet_dir/include/partition_ports.vh" \
    "$garnet_dir/include/partition_wrapper_ports.vh" \
    "$garnet_dir/ip/build/axi_clock_converter_ddr4/axi_clock_converter_ddr4.xci" \
    "$garnet_dir/ip/build/ddr4/ddr4.xci" \
    "$garnet_dir/ip/build/debug_bridge/debug_bridge.xci" \
    "$garnet_dir/lib/garnet_ddr.v" \
    "$garnet_dir/lib/garnet_ddrs.v" \
    "$garnet_dir/lib/partition_wrapper.v" \
    "$garnet_dir/lib/pipeline.v" \
    "$garnet_dir/xdc/ddrs.xdc" \
    "$garnet_dir/xdc/timing_ooc.xdc" \
    "garnet_config.vh" \
  ]

  set_property USED_IN {synthesis implementation out_of_context} [get_files timing_ooc.xdc]
  set_property PROCESSING_ORDER EARLY [get_files timing_ooc.xdc]
}

proc garnet_synth_design {args} {
  update_compile_order -fileset sources_1

  # XSDB_SLV_DIS is undocumented but used by the AWS HDK to disable the DDR XSDB
  # calibration slaves, as otherwise the paths between them and the debug hub
  # push the limits at 250 MHz.
  synth_design \
    -top partition_wrapper \
    -verilog_define XSDB_SLV_DIS \
    -mode out_of_context \
    {*}$args
  write_checkpoint -force post_synth.dcp
}

proc garnet_create_impl_project {args} {
  global garnet_dir

  create_project -in_memory -part xcvu9p-flga2104-2L-e {*}$args
  set_property board_part xilinx.com:vcu118:part0:2.3 [current_project]

  source "$garnet_dir/tcl/waivers_ip.tcl"
  source "$garnet_dir/tcl/waivers_shell.tcl"

  add_files [list \
    "$garnet_dir/shell/prebuilt/shell.dcp" \
    "post_synth.dcp" \
  ]

  set_property SCOPED_TO_CELLS partition_wrapper [get_files post_synth.dcp]
}

proc garnet_link_design {args} {
  link_design -top garnet_top -reconfig_partitions partition_wrapper {*}$args
  write_checkpoint -force post_link.dcp
}

proc garnet_opt_design {args} {
  opt_design {*}$args
}

proc garnet_place_design {args} {
  place_design {*}$args
}

proc garnet_phys_opt_design {args} {
  phys_opt_design {*}$args
}

proc garnet_route_design {args} {
  route_design {*}$args
}

proc garnet_post_route_phys_opt_design {args} {
  phys_opt_design {*}$args
}

proc garnet_report_timing {args} {
  report_timing_summary -warn_on_violation -file timing_summary.rpt {*}$args
}

proc garnet_write_artifacts {args} {
  global project_name
  global disable_debug_bridge

  write_checkpoint -force post_route.dcp
  write_bitstream -force $project_name.bit

  if {!$disable_debug_bridge} {
    write_debug_probes -force -no_partial_ltxfile $project_name.ltx
  }
}
