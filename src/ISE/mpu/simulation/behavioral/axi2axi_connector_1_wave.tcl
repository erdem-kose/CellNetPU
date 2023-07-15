#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     axi2axi_connector_1_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_axi2axi_connector_1_wrapper
#  Instance axi2axi_connector_1
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

# wave add $tbpath${ps}axi2axi_connector_1${ps}ACLK -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}ARESETN -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWADDR -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWLEN -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWSIZE -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWBURST -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWLOCK -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWCACHE -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWPROT -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWREGION -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWQOS -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWUSER -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWVALID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_AWREADY -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WDATA -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WSTRB -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WLAST -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WUSER -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WVALID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_WREADY -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_BID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_BRESP -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_BUSER -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_BVALID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_BREADY -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARADDR -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARLEN -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARSIZE -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARBURST -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARLOCK -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARCACHE -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARPROT -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARREGION -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARQOS -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARUSER -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARVALID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_ARREADY -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RDATA -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RRESP -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RLAST -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RUSER -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RVALID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}S_AXI_RREADY -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWADDR -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWLEN -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWSIZE -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWBURST -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWLOCK -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWCACHE -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWPROT -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWREGION -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWQOS -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWUSER -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWVALID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_AWREADY -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WDATA -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WSTRB -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WLAST -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WUSER -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WVALID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_WREADY -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_BID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_BRESP -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_BUSER -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_BVALID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_BREADY -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARADDR -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARLEN -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARSIZE -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARBURST -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARLOCK -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARCACHE -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARPROT -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARREGION -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARQOS -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARUSER -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARVALID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_ARREADY -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RID -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RDATA -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RRESP -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RLAST -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RUSER -into $id
# wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RVALID -into $id
  wave add $tbpath${ps}axi2axi_connector_1${ps}M_AXI_RREADY -into $id

