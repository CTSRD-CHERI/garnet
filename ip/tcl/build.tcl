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

set source_dir ".."
set garnet_dir "$source_dir/../"

if {[llength $argv] != 1} {
  error "Usage: $argv0 <ip>"
}

set ip_module_name [lindex $argv 0]

create_project -in_memory -part xcvu9p-flga2104-2L-e
set_property board_part xilinx.com:vcu118:part0:2.3 [current_project]

source "$source_dir/tcl/$ip_module_name.tcl"

create_ip \
  -name $ip_name \
  -vendor $ip_vendor \
  -library $ip_library \
  -version $ip_version \
  -module_name $ip_module_name \
  -dir . \
  -force

set ip [get_ips $ip_module_name]

set_property -dict $ip_properties $ip

# XSDB_SLV_DIS is undocumented but used by the AWS HDK to disable the DDR XSDB
# calibration slaves, as otherwise the paths between them and the debug hub
# push the limits at 250 MHz. We need to set it at synthesis time, and synth_ip
# has no equivalent to synth_design's -verilog_define, so don't do OOC IP
# synthesis. We could do it for the non-DDR components but consistency is
# simpler.
set_property GENERATE_SYNTH_CHECKPOINT FALSE [get_files [get_property IP_FILE $ip]]

generate_target -force all $ip
