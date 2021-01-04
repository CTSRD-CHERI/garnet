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

FILENAMES=	empty.bit empty_pblock_partition_partial.bit empty_primary.mcs empty_secondary.mcs shell.dcp
PREBUILT_FILES=	$(addprefix prebuilt/,$(FILENAMES))
BUILD_FILES=	$(addprefix build/,$(FILENAMES))

.DELETE_ON_ERROR:
.PRECIOUS: $(PREBUILT_FILES)

.PHONY: all
all: $(PREBUILT_FILES)

.PHONY: project
project: build/empty.xpr

.PHONY: clean
clean:
	rm -rf build

build prebuilt: %:
	mkdir -p $@

build/empty.xpr: | build
	cd build && vivado -mode batch -source ../tcl/empty/project.tcl

# Replace .INTERMEDIATE with grouped targets once GNU Make 4.3 is widespread
.INTERMEDIATE: build.intermediate
$(BUILD_FILES): build.intermediate ;
build.intermediate: build/empty.xpr
	cd build && vivado -mode batch -source ../tcl/empty/build.tcl

$(PREBUILT_FILES): prebuilt/%: build/% | prebuilt
	cp $< $@
