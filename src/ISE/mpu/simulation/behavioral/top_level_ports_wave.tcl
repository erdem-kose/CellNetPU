#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     top_level_ports_wave.tcl (Thu Jan 26 13:03:09 2017)
#
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

wave add $tbpath${ps}zio -into $id 
wave add $tbpath${ps}rzq -into $id 
wave add $tbpath${ps}mcbx_dram_we_n -into $id 
wave add $tbpath${ps}mcbx_dram_udqs_n -into $id 
wave add $tbpath${ps}mcbx_dram_udqs -into $id 
wave add $tbpath${ps}mcbx_dram_udm -into $id 
wave add $tbpath${ps}mcbx_dram_ras_n -into $id 
wave add $tbpath${ps}mcbx_dram_odt -into $id 
wave add $tbpath${ps}mcbx_dram_ldm -into $id 
wave add $tbpath${ps}mcbx_dram_dqs_n -into $id 
wave add $tbpath${ps}mcbx_dram_dqs -into $id 
wave add $tbpath${ps}mcbx_dram_dq -into $id 
wave add $tbpath${ps}mcbx_dram_clk_n -into $id 
wave add $tbpath${ps}mcbx_dram_clk -into $id 
wave add $tbpath${ps}mcbx_dram_cke -into $id 
wave add $tbpath${ps}mcbx_dram_cas_n -into $id 
wave add $tbpath${ps}mcbx_dram_ba -into $id 
wave add $tbpath${ps}mcbx_dram_addr -into $id 
wave add $tbpath${ps}RESET -into $id 
wave add $tbpath${ps}QSPI_FLASH_SS -into $id 
wave add $tbpath${ps}QSPI_FLASH_SCLK -into $id 
wave add $tbpath${ps}QSPI_FLASH_IO1 -into $id 
wave add $tbpath${ps}QSPI_FLASH_IO0 -into $id 
wave add $tbpath${ps}GCLK -into $id 
wave add $tbpath${ps}Ethernet_Lite_TX_EN -into $id 
wave add $tbpath${ps}Ethernet_Lite_TX_CLK -into $id 
wave add $tbpath${ps}Ethernet_Lite_TXD -into $id 
wave add $tbpath${ps}Ethernet_Lite_RX_ER -into $id 
wave add $tbpath${ps}Ethernet_Lite_RX_DV -into $id 
wave add $tbpath${ps}Ethernet_Lite_RX_CLK -into $id 
wave add $tbpath${ps}Ethernet_Lite_RXD -into $id 
wave add $tbpath${ps}Ethernet_Lite_PHY_RST_N -into $id 
wave add $tbpath${ps}Ethernet_Lite_MDIO -into $id 
wave add $tbpath${ps}Ethernet_Lite_MDC -into $id 
wave add $tbpath${ps}Ethernet_Lite_CRS -into $id 
wave add $tbpath${ps}Ethernet_Lite_COL -into $id 
wave add $tbpath${ps}iomodule_0_UART_Rx -into $id 
wave add $tbpath${ps}iomodule_0_UART_Tx -into $id 
wave add $tbpath${ps}iomodule_0_GPO1 -into $id 
wave add $tbpath${ps}iomodule_0_GPO2 -into $id 
wave add $tbpath${ps}iomodule_0_GPO3 -into $id 
wave add $tbpath${ps}iomodule_0_GPI1 -into $id 
wave add $tbpath${ps}iomodule_0_GPI2 -into $id 
wave add $tbpath${ps}error_i -into $id 
wave add $tbpath${ps}error_u00 -into $id 
wave add $tbpath${ps}error_u01 -into $id 
wave add $tbpath${ps}error_u02 -into $id 
wave add $tbpath${ps}error_u10 -into $id 
wave add $tbpath${ps}error_u12 -into $id 
wave add $tbpath${ps}error_u11 -into $id 
wave add $tbpath${ps}error_u20 -into $id 
wave add $tbpath${ps}error_u21 -into $id 
wave add $tbpath${ps}error_u22 -into $id 
wave add $tbpath${ps}error_x00 -into $id 
wave add $tbpath${ps}error_x02 -into $id 
wave add $tbpath${ps}error_x01 -into $id 
wave add $tbpath${ps}error_x11 -into $id 
wave add $tbpath${ps}error_x10 -into $id 
wave add $tbpath${ps}error_x12 -into $id 
wave add $tbpath${ps}error_x20 -into $id 
wave add $tbpath${ps}error_x22 -into $id 
wave add $tbpath${ps}error_x21 -into $id 

