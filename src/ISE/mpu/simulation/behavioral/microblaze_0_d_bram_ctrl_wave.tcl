#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     microblaze_0_d_bram_ctrl_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_microblaze_0_d_bram_ctrl_wrapper
#  Instance microblaze_0_d_bram_ctrl
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_Clk -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_Rst -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_ABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_WriteDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_AddrStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_ReadStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_WriteStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB_BE -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl_DBus -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl_Ready -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl_Wait -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl_UE -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl_CE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_ABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_WriteDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_AddrStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_ReadStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_WriteStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB1_BE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl1_DBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl1_Ready -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl1_Wait -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl1_UE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl1_CE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_ABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_WriteDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_AddrStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_ReadStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_WriteStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB2_BE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl2_DBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl2_Ready -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl2_Wait -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl2_UE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl2_CE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_ABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_WriteDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_AddrStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_ReadStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_WriteStrobe -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}LMB3_BE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl3_DBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl3_Ready -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl3_Wait -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl3_UE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Sl3_CE -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_Rst_A -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_Clk_A -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_EN_A -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_WEN_A -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_Addr_A -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_Din_A -into $id
  wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}BRAM_Dout_A -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}Interrupt -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}UE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}CE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_ABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_PAValid -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_masterID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_RNW -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_BE -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_size -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_type -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_wrDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_addrAck -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_SSize -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_wait -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rearbitrate -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_wrDAck -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_wrComp -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rdDBus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rdDAck -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rdComp -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_MBusy -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_MWrErr -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_MRdErr -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_UABus -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_SAValid -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_rdPrim -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_wrPrim -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_abort -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_busLock -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_MSize -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_lockErr -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_wrBurst -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_rdBurst -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_wrPendReq -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_rdPendReq -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_wrPendPri -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_rdPendPri -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_reqPri -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_PLB_TAttribute -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_wrBTerm -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rdWdAddr -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_rdBTerm -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}SPLB_CTRL_Sl_MIRQ -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_ACLK -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_ARESETN -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_AWADDR -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_AWVALID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_AWREADY -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_WDATA -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_WSTRB -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_WVALID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_WREADY -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_BRESP -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_BVALID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_BREADY -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_ARADDR -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_ARVALID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_ARREADY -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_RDATA -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_RRESP -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_RVALID -into $id
# wave add $tbpath${ps}microblaze_0_d_bram_ctrl${ps}S_AXI_CTRL_RREADY -into $id

