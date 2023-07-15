#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     mpu_wave.tcl (Thu Jan 26 13:03:09 2017)
#
#  ISE Simulator Trace Script File
#
#  Trace script files specify signals to save for later
#  display when viewing results of the simulation a graphic
#  format. Comment or uncomment commands to change the set of
#  signals viewed.
#
puts  "Setting up signal tracing ..."

if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

#
#  Trace top-level ports
#
set id [group add "Top level ports"]
source top_level_ports_wave.tcl


#
#  Trace Bus signal ports
#
set id [group add "Bus signal ports" ]
source microblaze_0_ilmb_wave.tcl

source microblaze_0_dlmb_wave.tcl

source axi4lite_0_wave.tcl

source axi4_0_wave.tcl

#
#  Trace Processor ports
#
set id [group add "Processor ports" ]
source microblaze_0_wave.tcl

#
#  Trace processor registers
#

set id [group add "Processor registers"]
#  Processor registers cannot be displayed for:
#  Module   mpu_microblaze_0_wrapper
#  Instance microblaze_0
#
#  Trace IP and peripheral ports
#
set id [group add "IP and peripheral ports" ]
source proc_sys_reset_0_wave.tcl

source microblaze_0_intc_wave.tcl

source microblaze_0_i_bram_ctrl_wave.tcl

source microblaze_0_d_bram_ctrl_wave.tcl

source microblaze_0_bram_block_wave.tcl

source iomodule_0_wave.tcl

source error_x12_x20_wave.tcl

source error_x10_x11_wave.tcl

source error_x01_x02_wave.tcl

source error_u22_x00_wave.tcl

source error_u20_u21_wave.tcl

source error_u11_u12_wave.tcl

source error_u02_u10_wave.tcl

source error_u00_u01_wave.tcl

source error_i_base_wave.tcl

source debug_module_wave.tcl

source clock_generator_0_wave.tcl

source error_x21_x22_wave.tcl

source QSPI_FLASH_wave.tcl

source MCB_DDR2_wave.tcl

source Ethernet_Lite_wave.tcl

#
#  Trace setup complete. Start tracing the signals.
#

puts  "Signal tracing setup completed."

puts  "Simulate the design with the 'run' command."
