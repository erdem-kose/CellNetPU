#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     error_x12_x20_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_error_x12_x20_wrapper
#  Instance error_x12_x20
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_ACLK -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_ARESETN -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_AWADDR -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_AWVALID -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_AWREADY -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_WDATA -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_WSTRB -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_WVALID -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_WREADY -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_BRESP -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_BVALID -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_BREADY -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_ARADDR -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_ARVALID -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_ARREADY -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_RDATA -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_RRESP -into $id
  wave add $tbpath${ps}error_x12_x20${ps}S_AXI_RVALID -into $id
# wave add $tbpath${ps}error_x12_x20${ps}S_AXI_RREADY -into $id
# wave add $tbpath${ps}error_x12_x20${ps}IP2INTC_Irpt -into $id
  wave add $tbpath${ps}error_x12_x20${ps}GPIO_IO_I -into $id
# wave add $tbpath${ps}error_x12_x20${ps}GPIO_IO_O -into $id
# wave add $tbpath${ps}error_x12_x20${ps}GPIO_IO_T -into $id
  wave add $tbpath${ps}error_x12_x20${ps}GPIO2_IO_I -into $id
# wave add $tbpath${ps}error_x12_x20${ps}GPIO2_IO_O -into $id
# wave add $tbpath${ps}error_x12_x20${ps}GPIO2_IO_T -into $id

