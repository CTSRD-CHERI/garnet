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

set ip_name ddr4
set ip_vendor xilinx.com
set ip_library ip
set ip_version 2.2
set ip_properties [list \
  CONFIG.C0.DDR4_TimePeriod {833} \
  CONFIG.C0.DDR4_InputClockPeriod {4000} \
  CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
  CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-083E} \
  CONFIG.C0.DDR4_DataWidth {64} \
  CONFIG.C0.DDR4_AxiSelection {true} \
  CONFIG.C0.DDR4_CasWriteLatency {12} \
  CONFIG.C0.DDR4_AxiDataWidth {512} \
  CONFIG.C0.DDR4_AxiAddressWidth {31} \
  CONFIG.C0.DDR4_AxiIDWidth {6} \
  CONFIG.C0.BANK_GROUP_WIDTH {1} \
]

# AR# 75583: 2019.1 uninitialised internal state bug
set_msg_config -id {[filemgmt 56-316]} -string {You specified a value of , this is not allowed.} -suppress
