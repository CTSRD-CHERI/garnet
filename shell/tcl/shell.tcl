
################################################################
# This is a generated script based on design: shell
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source shell_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_firewall_auto_unblocker, axi_firewall_auto_unblocker, decouple_pipeline, decouple_pipeline, decouple_pipeline, decouple_pipeline, irq_shim

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flga2104-2L-e
   set_property BOARD_PART xilinx.com:vcu118:part0:2.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name shell

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_firewall:1.0\
xilinx.com:ip:debug_bridge:3.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:pr_decoupler:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axi_firewall_auto_unblocker\
axi_firewall_auto_unblocker\
decouple_pipeline\
decouple_pipeline\
decouple_pipeline\
decouple_pipeline\
irq_shim\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: shim
proc create_hier_cell_shim { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shim() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CTL_M_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTL_S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DMA_M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DMA_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m_bscan


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I decouple_control
  create_bd_pin -dir I -from 15 -to 0 m_irq_ack
  create_bd_pin -dir O -from 15 -to 0 m_irq_req
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir O -from 15 -to 0 s_irq_ack
  create_bd_pin -dir I -from 15 -to 0 s_irq_req

  # Create instance: axi_register_slice_CTL, and set properties
  set axi_register_slice_CTL [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_CTL ]

  # Create instance: axi_register_slice_DMA, and set properties
  set axi_register_slice_DMA [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_DMA ]

  # Create instance: debug_bridge_bscan, and set properties
  set debug_bridge_bscan [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_bscan ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_MODE {7} \
   CONFIG.C_NUM_BS_MASTER {1} \
 ] $debug_bridge_bscan

  # Create instance: decouple_pipeline_CTL, and set properties
  set block_name decouple_pipeline
  set block_cell_name decouple_pipeline_CTL
  if { [catch {set decouple_pipeline_CTL [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decouple_pipeline_CTL eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
   CONFIG.ASSOCIATED_BUSIF {decouple_control:decouple_status} \
 ] [get_bd_pins /shim/decouple_pipeline_CTL/clk]

  # Create instance: decouple_pipeline_DMA, and set properties
  set block_name decouple_pipeline
  set block_cell_name decouple_pipeline_DMA
  if { [catch {set decouple_pipeline_DMA [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decouple_pipeline_DMA eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
   CONFIG.ASSOCIATED_BUSIF {decouple_control:decouple_status} \
 ] [get_bd_pins /shim/decouple_pipeline_DMA/clk]

  # Create instance: decouple_pipeline_irq, and set properties
  set block_name decouple_pipeline
  set block_cell_name decouple_pipeline_irq
  if { [catch {set decouple_pipeline_irq [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decouple_pipeline_irq eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
   CONFIG.ASSOCIATED_BUSIF {decouple_control:decouple_status} \
 ] [get_bd_pins /shim/decouple_pipeline_irq/clk]

  # Create instance: irq_shim, and set properties
  set block_name irq_shim
  set block_cell_name irq_shim
  if { [catch {set irq_shim [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $irq_shim eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
   CONFIG.ASSOCIATED_BUSIF {s_irq_req:m_irq_ack:s_irq_ack:m_irq_req:decouple_control:decouple_status} \
 ] [get_bd_pins /shim/irq_shim/clk]

  # Create instance: pr_decoupler_CTL, and set properties
  set pr_decoupler_CTL [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_decoupler:1.0 pr_decoupler_CTL ]
  set_property -dict [ list \
   CONFIG.ALL_PARAMS {INTF {CTL_AXI_LITE {ID 0 VLNV xilinx.com:interface:aximm_rtl:1.0 MODE slave PROTOCOL axi4lite SIGNALS {ARVALID {PRESENT 1 WIDTH 1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1 WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT 1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY {PRESENT 1 WIDTH 1} AWADDR {PRESENT 1 WIDTH 32} AWLEN {PRESENT 0 WIDTH 8} AWSIZE {PRESENT 0 WIDTH 3} AWBURST {PRESENT 0 WIDTH 2} AWLOCK {PRESENT 0 WIDTH 1} AWCACHE {PRESENT 0 WIDTH 4} AWPROT {PRESENT 1 WIDTH 3} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1 WIDTH 4} WLAST {PRESENT 0 WIDTH 1} BRESP {PRESENT 1 WIDTH 2} ARADDR {PRESENT 1 WIDTH 32} ARLEN {PRESENT 0 WIDTH 8} ARSIZE {PRESENT 0 WIDTH 3} ARBURST {PRESENT 0 WIDTH 2} ARLOCK {PRESENT 0 WIDTH 1} ARCACHE {PRESENT 0 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 0 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0 WIDTH 0} WID {PRESENT 0 WIDTH 0} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0 WIDTH 0} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0 WIDTH 0} ARREGION {PRESENT 1 WIDTH 4} ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0} RUSER {PRESENT 0 WIDTH 0}}}} HAS_SIGNAL_STATUS 1 IPI_PROP_COUNT 4} \
   CONFIG.GUI_HAS_SIGNAL_STATUS {1} \
   CONFIG.GUI_INTERFACE_NAME {CTL_AXI_LITE} \
   CONFIG.GUI_INTERFACE_PROTOCOL {axi4lite} \
   CONFIG.GUI_SELECT_INTERFACE {0} \
   CONFIG.GUI_SELECT_MODE {slave} \
   CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_0 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_1 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_2 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_3 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_4 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_5 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_6 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_7 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_8 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_9 {true} \
   CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} \
   CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} \
   CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} \
   CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} \
   CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} \
   CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} \
   CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} \
   CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} \
   CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} \
   CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} \
 ] $pr_decoupler_CTL

  # Create instance: pr_decoupler_DMA, and set properties
  set pr_decoupler_DMA [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_decoupler:1.0 pr_decoupler_DMA ]
  set_property -dict [ list \
   CONFIG.ALL_PARAMS {INTF {DMA_AXI {ID 0 VLNV xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH 1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1 WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT 1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY {PRESENT 1 WIDTH 1} AWID {PRESENT 1 WIDTH 4} AWADDR {PRESENT 1 WIDTH 64} AWLEN {PRESENT 1 WIDTH 8} AWSIZE {PRESENT 1 WIDTH 3} AWBURST {PRESENT 1 WIDTH 2} AWLOCK {PRESENT 1 WIDTH 1} AWCACHE {PRESENT 1 WIDTH 4} AWPROT {PRESENT 1 WIDTH 3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0 WIDTH 0} WID {PRESENT 1 WIDTH 4} WDATA {PRESENT 1 WIDTH 512} WSTRB {PRESENT 1 WIDTH 64} WLAST {PRESENT 1 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 1 WIDTH 4} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 1 WIDTH 4} ARADDR {PRESENT 1 WIDTH 64} ARLEN {PRESENT 1 WIDTH 8} ARSIZE {PRESENT 1 WIDTH 3} ARBURST {PRESENT 1 WIDTH 2} ARLOCK {PRESENT 1 WIDTH 1} ARCACHE {PRESENT 1 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4} ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 1 WIDTH 4} RDATA {PRESENT 1 WIDTH 512} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 1 WIDTH 1} RUSER {PRESENT 0 WIDTH 0}}}} HAS_SIGNAL_STATUS 1 IPI_PROP_COUNT 4} \
   CONFIG.GUI_HAS_SIGNAL_STATUS {1} \
   CONFIG.GUI_INTERFACE_NAME {DMA_AXI} \
   CONFIG.GUI_INTERFACE_PROTOCOL {axi4} \
   CONFIG.GUI_SELECT_INTERFACE {0} \
   CONFIG.GUI_SELECT_MODE {slave} \
   CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_0 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_1 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_2 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_3 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_4 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_5 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_6 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_7 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_8 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_9 {true} \
   CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} \
   CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} \
   CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} \
   CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} \
   CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} \
   CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} \
   CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} \
   CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} \
   CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} \
   CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} \
 ] $pr_decoupler_DMA

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $proc_sys_reset

  # Create interface connections
  connect_bd_intf_net -intf_net CTL_S_AXI_LITE_1 [get_bd_intf_pins CTL_S_AXI_LITE] [get_bd_intf_pins pr_decoupler_CTL/s_CTL_AXI_LITE]
  connect_bd_intf_net -intf_net DMA_S_AXI_1 [get_bd_intf_pins DMA_S_AXI] [get_bd_intf_pins pr_decoupler_DMA/s_DMA_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_CTL_M_AXI [get_bd_intf_pins CTL_M_AXI_LITE] [get_bd_intf_pins axi_register_slice_CTL/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_DMA_M_AXI [get_bd_intf_pins DMA_M_AXI] [get_bd_intf_pins axi_register_slice_DMA/M_AXI]
  connect_bd_intf_net -intf_net debug_bridge_bscan_m0_bscan [get_bd_intf_pins m_bscan] [get_bd_intf_pins debug_bridge_bscan/m0_bscan]
  connect_bd_intf_net -intf_net pr_decoupler_CTL_rp_CTL_AXI_LITE [get_bd_intf_pins axi_register_slice_CTL/S_AXI] [get_bd_intf_pins pr_decoupler_CTL/rp_CTL_AXI_LITE]
  connect_bd_intf_net -intf_net pr_decoupler_DMA_rp_DMA_AXI [get_bd_intf_pins axi_register_slice_DMA/S_AXI] [get_bd_intf_pins pr_decoupler_DMA/rp_DMA_AXI]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins axi_register_slice_CTL/aclk] [get_bd_pins axi_register_slice_DMA/aclk] [get_bd_pins decouple_pipeline_CTL/clk] [get_bd_pins decouple_pipeline_DMA/clk] [get_bd_pins decouple_pipeline_irq/clk] [get_bd_pins irq_shim/clk] [get_bd_pins proc_sys_reset/slowest_sync_clk]
  connect_bd_net -net decouple_control_1 [get_bd_pins decouple_control] [get_bd_pins decouple_pipeline_CTL/decouple_control] [get_bd_pins decouple_pipeline_DMA/decouple_control] [get_bd_pins decouple_pipeline_irq/decouple_control] [get_bd_pins proc_sys_reset/aux_reset_in]
  connect_bd_net -net decouple_pipeline_CTL_decouple_status [get_bd_pins decouple_pipeline_CTL/decouple_status] [get_bd_pins pr_decoupler_CTL/decouple]
  connect_bd_net -net decouple_pipeline_DMA_decouple_status [get_bd_pins decouple_pipeline_DMA/decouple_status] [get_bd_pins pr_decoupler_DMA/decouple]
  connect_bd_net -net decouple_pipeline_irq_decouple_status [get_bd_pins decouple_pipeline_irq/decouple_status] [get_bd_pins irq_shim/decouple_control]
  connect_bd_net -net irq_shim_m_irq_req [get_bd_pins m_irq_req] [get_bd_pins irq_shim/m_irq_req]
  connect_bd_net -net irq_shim_s_irq_ack [get_bd_pins s_irq_ack] [get_bd_pins irq_shim/s_irq_ack]
  connect_bd_net -net m_irq_ack_1 [get_bd_pins m_irq_ack] [get_bd_pins irq_shim/m_irq_ack]
  connect_bd_net -net proc_sys_reset_interconnect_aresetn [get_bd_pins axi_register_slice_CTL/aresetn] [get_bd_pins axi_register_slice_DMA/aresetn] [get_bd_pins proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net resetn_1 [get_bd_pins resetn] [get_bd_pins decouple_pipeline_CTL/resetn] [get_bd_pins decouple_pipeline_DMA/resetn] [get_bd_pins decouple_pipeline_irq/resetn] [get_bd_pins irq_shim/resetn] [get_bd_pins proc_sys_reset/ext_reset_in]
  connect_bd_net -net s_irq_req_1 [get_bd_pins s_irq_req] [get_bd_pins irq_shim/s_irq_req]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PCI_DMA
proc create_hier_cell_PCI_DMA { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_PCI_DMA() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CTL_M_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DMA_M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x16

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk


  # Create pins
  create_bd_pin -dir O -type rst aresetn
  create_bd_pin -dir O -type clk clk
  create_bd_pin -dir O -from 0 -to 0 decouple_status
  create_bd_pin -dir O -from 15 -to 0 irq_ack
  create_bd_pin -dir I -from 15 -to 0 irq_req
  create_bd_pin -dir I -type rst pcie_perstn

  # Create instance: axi_firewall_CTL, and set properties
  set axi_firewall_CTL [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_firewall:1.0 axi_firewall_CTL ]

  # Create instance: axi_firewall_DMA, and set properties
  set axi_firewall_DMA [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_firewall:1.0 axi_firewall_DMA ]

  # Create instance: axi_firewall_auto_un_CTL, and set properties
  set block_name axi_firewall_auto_unblocker
  set block_cell_name axi_firewall_auto_un_CTL
  if { [catch {set axi_firewall_auto_un_CTL [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_firewall_auto_un_CTL eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
 ] [get_bd_pins /PCI_DMA/axi_firewall_auto_un_CTL/aclk]

  # Create instance: axi_firewall_auto_un_DMA, and set properties
  set block_name axi_firewall_auto_unblocker
  set block_cell_name axi_firewall_auto_un_DMA
  if { [catch {set axi_firewall_auto_un_DMA [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_firewall_auto_un_DMA eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
 ] [get_bd_pins /PCI_DMA/axi_firewall_auto_un_DMA/aclk]

  # Create instance: debug_bridge_pci, and set properties
  set debug_bridge_pci [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_pci ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_MODE {5} \
   CONFIG.C_NUM_BS_MASTER {0} \
 ] $debug_bridge_pci

  # Create instance: decouple_pipeline, and set properties
  set block_name decouple_pipeline
  set block_cell_name decouple_pipeline
  if { [catch {set decouple_pipeline [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decouple_pipeline eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.CLK_DOMAIN {shell_xdma_0_axi_aclk} \
   CONFIG.ASSOCIATED_BUSIF {decouple_control:decouple_status} \
 ] [get_bd_pins /PCI_DMA/decouple_pipeline/clk]

  # Create instance: util_ds_buf_pcie_refclk, and set properties
  set util_ds_buf_pcie_refclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_pcie_refclk ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $util_ds_buf_pcie_refclk

  # Create instance: util_vector_logic_switch, and set properties
  set util_vector_logic_switch [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_switch ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_switch

  # Create instance: xdma, and set properties
  set xdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma ]
  set_property -dict [ list \
   CONFIG.PCIE_BOARD_INTERFACE {pci_express_x16} \
   CONFIG.PF0_DEVICE_ID_mqdma {903F} \
   CONFIG.PF2_DEVICE_ID_mqdma {903F} \
   CONFIG.PF3_DEVICE_ID_mqdma {903F} \
   CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
   CONFIG.axi_data_width {512_bit} \
   CONFIG.axi_id_width {4} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axilite_master_size {64} \
   CONFIG.axist_bypass_en {false} \
   CONFIG.axisten_freq {250} \
   CONFIG.cfg_ext_if {true} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.coreclk_freq {500} \
   CONFIG.dma_reset_source_sel {User_Reset} \
   CONFIG.drp_clk_sel {Internal} \
   CONFIG.en_gt_selection {true} \
   CONFIG.ext_xvc_vsec_enable {false} \
   CONFIG.gtcom_in_core_usp {2} \
   CONFIG.gtwiz_in_core_usp {1} \
   CONFIG.mcap_enablement {PR_over_PCIe} \
   CONFIG.mcap_fpga_bitstream_version {00000001} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.pcie_blk_locn {X1Y2} \
   CONFIG.pcie_extended_tag {false} \
   CONFIG.pf0_Use_Class_Code_Lookup_Assistant {true} \
   CONFIG.pf0_device_id {903F} \
   CONFIG.pf0_interrupt_pin {NONE} \
   CONFIG.pf0_link_status_slot_clock_config {true} \
   CONFIG.pf0_msi_enabled {false} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_1} \
   CONFIG.pf0_msix_cap_pba_offset {00008FE0} \
   CONFIG.pf0_msix_cap_table_bir {BAR_1} \
   CONFIG.pf0_msix_cap_table_offset {00008000} \
   CONFIG.pf0_msix_cap_table_size {01F} \
   CONFIG.pf0_msix_enabled {true} \
   CONFIG.pipe_sim {false} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X16} \
   CONFIG.plltype {QPLL1} \
   CONFIG.ref_clk_freq {100_MHz} \
   CONFIG.select_quad {GTY_Quad_227} \
   CONFIG.xdma_num_usr_irq {16} \
   CONFIG.xdma_rnum_chnl {1} \
   CONFIG.xdma_rnum_rids {8} \
   CONFIG.xdma_wnum_chnl {1} \
   CONFIG.xdma_wnum_rids {8} \
 ] $xdma

  # Create interface connections
  connect_bd_intf_net -intf_net axi_firewall_CTL_M_AXI [get_bd_intf_pins CTL_M_AXI_LITE] [get_bd_intf_pins axi_firewall_CTL/M_AXI]
  connect_bd_intf_net -intf_net axi_firewall_DMA_M_AXI [get_bd_intf_pins DMA_M_AXI] [get_bd_intf_pins axi_firewall_DMA/M_AXI]
  connect_bd_intf_net -intf_net axi_firewall_auto_un_CTL_M_AXI_CTL [get_bd_intf_pins axi_firewall_CTL/S_AXI_CTL] [get_bd_intf_pins axi_firewall_auto_un_CTL/M_AXI_CTL]
  connect_bd_intf_net -intf_net axi_firewall_auto_un_DMA_M_AXI_CTL [get_bd_intf_pins axi_firewall_DMA/S_AXI_CTL] [get_bd_intf_pins axi_firewall_auto_un_DMA/M_AXI_CTL]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_pins pcie_refclk] [get_bd_intf_pins util_ds_buf_pcie_refclk/CLK_IN_D]
  connect_bd_intf_net -intf_net xdma_M_AXI [get_bd_intf_pins axi_firewall_DMA/S_AXI] [get_bd_intf_pins xdma/M_AXI]
  connect_bd_intf_net -intf_net xdma_M_AXI_LITE [get_bd_intf_pins axi_firewall_CTL/S_AXI] [get_bd_intf_pins xdma/M_AXI_LITE]
  connect_bd_intf_net -intf_net xdma_pcie_cfg_ext [get_bd_intf_pins debug_bridge_pci/pcie3_cfg_ext] [get_bd_intf_pins xdma/pcie_cfg_ext]
  connect_bd_intf_net -intf_net xdma_pcie_mgt [get_bd_intf_pins pci_express_x16] [get_bd_intf_pins xdma/pcie_mgt]

  # Create port connections
  connect_bd_net -net axi_firewall_CTL_mi_r_error [get_bd_pins axi_firewall_CTL/mi_r_error] [get_bd_pins axi_firewall_auto_un_CTL/mi_r_error]
  connect_bd_net -net axi_firewall_CTL_mi_w_error [get_bd_pins axi_firewall_CTL/mi_w_error] [get_bd_pins axi_firewall_auto_un_CTL/mi_w_error]
  connect_bd_net -net axi_firewall_DMA_mi_r_error [get_bd_pins axi_firewall_DMA/mi_r_error] [get_bd_pins axi_firewall_auto_un_DMA/mi_r_error]
  connect_bd_net -net axi_firewall_DMA_mi_w_error [get_bd_pins axi_firewall_DMA/mi_w_error] [get_bd_pins axi_firewall_auto_un_DMA/mi_w_error]
  connect_bd_net -net decouple_pipeline_decouple_status [get_bd_pins decouple_status] [get_bd_pins decouple_pipeline/decouple_status]
  connect_bd_net -net irq_req_1 [get_bd_pins irq_req] [get_bd_pins xdma/usr_irq_req]
  connect_bd_net -net pcie_perstn_1 [get_bd_pins pcie_perstn] [get_bd_pins xdma/sys_rst_n]
  connect_bd_net -net util_ds_buf_pcie_refclk_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_pcie_refclk/IBUF_DS_ODIV2] [get_bd_pins xdma/sys_clk]
  connect_bd_net -net util_ds_buf_pcie_refclk_IBUF_OUT [get_bd_pins util_ds_buf_pcie_refclk/IBUF_OUT] [get_bd_pins xdma/sys_clk_gt]
  connect_bd_net -net util_vector_logic_switch_Res [get_bd_pins decouple_pipeline/decouple_control] [get_bd_pins util_vector_logic_switch/Res]
  connect_bd_net -net xdma_axi_aclk [get_bd_pins clk] [get_bd_pins axi_firewall_CTL/aclk] [get_bd_pins axi_firewall_DMA/aclk] [get_bd_pins axi_firewall_auto_un_CTL/aclk] [get_bd_pins axi_firewall_auto_un_DMA/aclk] [get_bd_pins debug_bridge_pci/clk] [get_bd_pins decouple_pipeline/clk] [get_bd_pins xdma/axi_aclk]
  connect_bd_net -net xdma_axi_aresetn [get_bd_pins aresetn] [get_bd_pins axi_firewall_CTL/aresetn] [get_bd_pins axi_firewall_DMA/aresetn] [get_bd_pins axi_firewall_auto_un_CTL/aresetn] [get_bd_pins axi_firewall_auto_un_DMA/aresetn] [get_bd_pins decouple_pipeline/resetn] [get_bd_pins xdma/axi_aresetn]
  connect_bd_net -net xdma_mcap_design_switch [get_bd_pins util_vector_logic_switch/Op1] [get_bd_pins xdma/mcap_design_switch]
  connect_bd_net -net xdma_usr_irq_ack [get_bd_pins irq_ack] [get_bd_pins xdma/usr_irq_ack]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CTL_M_AXI_LITE [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CTL_M_AXI_LITE ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $CTL_M_AXI_LITE

  set DMA_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DMA_M_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.PROTOCOL {AXI4} \
   ] $DMA_M_AXI

  set m_bscan [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m_bscan ]

  set pci_express_x16 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x16 ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_refclk


  # Create ports
  set aresetn [ create_bd_port -dir O -from 0 -to 0 -type rst aresetn ]
  set clk [ create_bd_port -dir O -type clk clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {DMA_M_AXI:CTL_M_AXI_LITE} \
   CONFIG.ASSOCIATED_RESET {aresetn} \
 ] $clk
  set irq_ack [ create_bd_port -dir O -from 15 -to 0 irq_ack ]
  set irq_req [ create_bd_port -dir I -from 15 -to 0 irq_req ]
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_perstn

  # Create instance: PCI_DMA
  create_hier_cell_PCI_DMA [current_bd_instance .] PCI_DMA

  # Create instance: shim
  create_hier_cell_shim [current_bd_instance .] shim

  # Create interface connections
  connect_bd_intf_net -intf_net DMA_S_AXI_1 [get_bd_intf_pins PCI_DMA/DMA_M_AXI] [get_bd_intf_pins shim/DMA_S_AXI]
  connect_bd_intf_net -intf_net PCI_DMA_CTL_M_AXI_LITE [get_bd_intf_pins PCI_DMA/CTL_M_AXI_LITE] [get_bd_intf_pins shim/CTL_S_AXI_LITE]
  connect_bd_intf_net -intf_net PCI_DMA_pci_express_x16 [get_bd_intf_ports pci_express_x16] [get_bd_intf_pins PCI_DMA/pci_express_x16]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins PCI_DMA/pcie_refclk]
  connect_bd_intf_net -intf_net shim_CTL_M_AXI_LITE [get_bd_intf_ports CTL_M_AXI_LITE] [get_bd_intf_pins shim/CTL_M_AXI_LITE]
  connect_bd_intf_net -intf_net shim_DMA_M_AXI [get_bd_intf_ports DMA_M_AXI] [get_bd_intf_pins shim/DMA_M_AXI]
  connect_bd_intf_net -intf_net shim_m_bscan [get_bd_intf_ports m_bscan] [get_bd_intf_pins shim/m_bscan]

  # Create port connections
  connect_bd_net -net PCI_DMA_aresetn [get_bd_pins PCI_DMA/aresetn] [get_bd_pins shim/resetn]
  connect_bd_net -net PCI_DMA_clk [get_bd_ports clk] [get_bd_pins PCI_DMA/clk] [get_bd_pins shim/clk]
  connect_bd_net -net PCI_DMA_decouple_status [get_bd_pins PCI_DMA/decouple_status] [get_bd_pins shim/decouple_control]
  connect_bd_net -net PCI_DMA_irq_ack [get_bd_pins PCI_DMA/irq_ack] [get_bd_pins shim/m_irq_ack]
  connect_bd_net -net irq_req_1 [get_bd_ports irq_req] [get_bd_pins shim/s_irq_req]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_perstn] [get_bd_pins PCI_DMA/pcie_perstn]
  connect_bd_net -net shim_m_irq_req [get_bd_pins PCI_DMA/irq_req] [get_bd_pins shim/m_irq_req]
  connect_bd_net -net shim_peripheral_aresetn [get_bd_ports aresetn] [get_bd_pins shim/peripheral_aresetn]
  connect_bd_net -net shim_s_irq_ack [get_bd_ports irq_ack] [get_bd_pins shim/s_irq_ack]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces PCI_DMA/axi_firewall_auto_un_CTL/M_AXI_CTL] [get_bd_addr_segs PCI_DMA/axi_firewall_CTL/S_AXI_CTL/Control] SEG_axi_firewall_CTL_Control
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces PCI_DMA/axi_firewall_auto_un_DMA/M_AXI_CTL] [get_bd_addr_segs PCI_DMA/axi_firewall_DMA/S_AXI_CTL/Control] SEG_axi_firewall_DMA_Control
  create_bd_addr_seg -range 0x02000000 -offset 0x00000000 [get_bd_addr_spaces PCI_DMA/xdma/M_AXI_LITE] [get_bd_addr_segs CTL_M_AXI_LITE/Reg] SEG_CTL_M_AXI_LITE_Reg
  create_bd_addr_seg -range 0x00010000000000000000 -offset 0x00000000 [get_bd_addr_spaces PCI_DMA/xdma/M_AXI] [get_bd_addr_segs DMA_M_AXI/Reg] SEG_DMA_M_AXI_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


