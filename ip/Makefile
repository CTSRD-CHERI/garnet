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

IPS=	axi_clock_converter_ddr4 ddr4 debug_bridge

BUILD_FILES=	$(foreach ip,$(IPS),build/$(ip)/$(ip).xci)

.PNONY: all
all: $(BUILD_FILES)

.PHONY: clean
clean:
	rm -rf build

build:
	mkdir -p $@

# Replace .INTERMEDIATE with grouped targets once GNU Make 4.3 is widespread
define make-ip-target
.INTERMEDIATE: $1.intermediate
build/$1/$1.dcp build/$1/$1.xci: $1.intermediate ;
$1.intermediate: tcl/build.tcl tcl/$1.tcl | build
	cd build && vivado -mode batch -source ../tcl/build.tcl -tclargs $1

endef

$(eval $(foreach ip,$(IPS),$(call make-ip-target,$(ip))))
