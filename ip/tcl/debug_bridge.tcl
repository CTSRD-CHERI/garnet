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

set ip_name debug_bridge
set ip_vendor xilinx.com
set ip_library ip
set ip_version 3.0
# C_DEBUG_MODE = 1: From BSCAN to DebugHub
# C_DESIGN_TYPE = 1: Reconfigurable region of PR designs
set ip_properties [list \
  CONFIG.C_DEBUG_MODE {1} \
  CONFIG.C_DESIGN_TYPE {1} \
]
