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

.PHONY: all clean
all clean: %: shell-% ip-%

.PHONY: shell shell-all shell-project shell-clean
shell: shell-all
shell-all shell-project shell-clean: shell-%:
	$(MAKE) -C shell $*

.PHONY: ip ip-all ip-clean
ip: ip-all
ip-all ip-clean: ip-%:
	$(MAKE) -C ip $*
