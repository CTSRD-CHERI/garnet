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

proc launch_and_wait_on_runs {runs args} {
  set runs_needed [list]
  foreach run $runs {
    if {[get_property NEEDS_REFRESH [get_runs $run]]} {
      puts "INFO: $run is outdated, resetting"
      reset_run $run
    }
    if {[get_property PROGRESS [get_runs $run]] != "100%"} {
      if {[get_property STATUS [get_runs $run]] != "Not started"} {
        puts "INFO: $run has been started before, resetting"
        reset_run $run
      }
      lappend runs_needed $run
    } else {
      puts "INFO: $run is up-to-date, not launching"
    }
  }
  if {[llength $runs_needed] > 0} {
    launch_runs $runs_needed {*}$args
    foreach run $runs_needed {
      wait_on_run $run
    }
  }
  # Check all runs in case we invalidated an up-to-date one
  foreach run $runs {
    if {[get_property PROGRESS [get_runs $run]] != "100%"} {
      error "ERROR: $run failed"
    }
    if {[get_property NEEDS_REFRESH [get_runs $run]]} {
      error "ERROR: $run finished yet needs refresh"
    }
  }
}

open_project empty

update_compile_order -fileset sources_1

launch_and_wait_on_runs synth_1 -jobs 8
launch_and_wait_on_runs impl_1 -jobs 8

open_run impl_1
report_timing_summary -warn_on_violation -file timing_summary.rpt
write_bitstream -force empty.bit
write_cfgmem -force -format MCS -interface SPIx8 -size 64 -loadbit "up 0x0 empty.bit" empty.mcs
update_design -cell partition_wrapper -black_box
lock_design -level routing
write_checkpoint -force shell.dcp
