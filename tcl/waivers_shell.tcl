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

# PCIe block isn't warning-clean
set_msg_config -id {[Constraints 18-633]} -string {shell/PCI_DMA/xdma/inst/pcie4_ip_i} -suppress
set_msg_config -id {[DRC REQP-1858]}      -string {shell/PCI_DMA/xdma/inst/pcie4_ip_i} -suppress
set_msg_config -id {[Timing 38-3]}        -string {shell/PCI_DMA/xdma/inst/pcie4_ip_i} -suppress
set_msg_config -id {[Vivado 12-508]}      -string {shell/PCI_DMA/xdma/inst/pcie4_ip_i} -suppress
set_msg_config -id {[Vivado_Tcl 4-939]}   -string {shell_xdma_0}                       -suppress
