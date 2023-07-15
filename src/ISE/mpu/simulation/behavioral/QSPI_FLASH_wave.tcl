#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     QSPI_FLASH_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_qspi_flash_wrapper
#  Instance QSPI_FLASH
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

  wave add $tbpath${ps}QSPI_FLASH${ps}EXT_SPI_CLK -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_ACLK -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_ARESETN -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ACLK -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARESETN -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_AWADDR -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_AWVALID -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_AWREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_WDATA -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_WSTRB -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_WVALID -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_WREADY -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_BRESP -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_BVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_BREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_ARADDR -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_ARVALID -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_ARREADY -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_RDATA -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_RRESP -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_RVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI_RREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWADDR -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWLEN -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWSIZE -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWBURST -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWLOCK -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWCACHE -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWPROT -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_AWREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_WDATA -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_WSTRB -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_WLAST -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_WVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_WREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_BID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_BRESP -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_BVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_BREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARADDR -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARLEN -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARSIZE -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARBURST -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARLOCK -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARCACHE -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARPROT -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_ARREADY -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RDATA -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RRESP -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RLAST -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RVALID -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}S_AXI4_RREADY -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SCK_I -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SCK_O -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SCK_T -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SS_I -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SS_O -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SS_T -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}SPISEL -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}IP2INTC_Irpt -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO0_I -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO0_O -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO0_T -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO1_I -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO1_O -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO1_T -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO2_I -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}IO2_O -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}IO2_T -into $id
  wave add $tbpath${ps}QSPI_FLASH${ps}IO3_I -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}IO3_O -into $id
# wave add $tbpath${ps}QSPI_FLASH${ps}IO3_T -into $id

