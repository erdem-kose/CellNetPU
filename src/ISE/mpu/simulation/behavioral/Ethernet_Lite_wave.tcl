#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     Ethernet_Lite_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_ethernet_lite_wrapper
#  Instance Ethernet_Lite
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ACLK -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARESETN -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}IP2INTC_Irpt -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWID -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWADDR -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWLEN -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWSIZE -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWBURST -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWCACHE -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWVALID -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_AWREADY -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_WDATA -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_WSTRB -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_WLAST -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_WVALID -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_WREADY -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_BID -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_BRESP -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_BVALID -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_BREADY -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARID -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARADDR -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARLEN -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARSIZE -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARBURST -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARCACHE -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARVALID -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_ARREADY -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RID -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RDATA -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RRESP -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RLAST -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RVALID -into $id
# wave add $tbpath${ps}Ethernet_Lite${ps}S_AXI_RREADY -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_tx_clk -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_rx_clk -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_crs -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_dv -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_rx_data -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_col -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_rx_er -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_rst_n -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_tx_en -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_tx_data -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_MDC -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_MDIO_I -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_MDIO_O -into $id
  wave add $tbpath${ps}Ethernet_Lite${ps}PHY_MDIO_T -into $id

