#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     MCB_DDR2_wave.tcl (Thu Jan 26 13:03:10 2017)
#
#  Module   mpu_mcb_ddr2_wrapper
#  Instance MCB_DDR2
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

  wave add $tbpath${ps}MCB_DDR2${ps}sysclk_2x -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}sysclk_2x_180 -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}pll_ce_0 -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}pll_ce_90 -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}pll_lock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}pll_lock_bufpll_o -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}sysclk_2x_bufpll_o -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}sysclk_2x_180_bufpll_o -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}pll_ce_0_bufpll_o -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}pll_ce_90_bufpll_o -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}sys_rst -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_addr -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_ba -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_ras_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_cas_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_we_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_cke -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_clk -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_clk_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_dq -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_dqs -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_dqs_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_udqs -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_udqs_n -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_udm -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_ldm -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_odt -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}mcbx_dram_ddr3_rst -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}rzq -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}zio -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}ui_clk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}uo_done_cal -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awvalid -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_wvalid -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_wready -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_bid -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_bresp -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arvalid -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_arready -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rid -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rdata -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rresp -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rlast -into $id
  wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s0_axi_rready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_wvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_wready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_bid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_bresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_arready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s1_axi_rready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_wvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_wready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_bid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_bresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_arready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s2_axi_rready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_wvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_wready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_bid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_bresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_arready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s3_axi_rready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_wvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_wready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_bid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_bresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_arready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s4_axi_rready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_aclk -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_aresetn -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awaddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_awready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_wdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_wstrb -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_wlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_wvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_wready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_bid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_bresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_bvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_bready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_araddr -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arlen -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arsize -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arburst -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arlock -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arcache -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arprot -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arqos -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_arready -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rdata -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rresp -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rlast -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rvalid -into $id
# wave add $tbpath${ps}MCB_DDR2${ps}s5_axi_rready -into $id

