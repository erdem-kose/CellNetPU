#  Simulation Model Generator
#  Xilinx EDK 14.5 EDK_P.58f
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     iomodule_0_wave.tcl (Sat Apr 08 23:18:00 2017)
#
#  Module   mpu_iomodule_0_wrapper
#  Instance iomodule_0
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}mpu_tb${ps}dut" }

  wave add $tbpath${ps}iomodule_0${ps}CLK -into $id
  wave add $tbpath${ps}iomodule_0${ps}Rst -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Addr_Strobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Read_Strobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Write_Strobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Address -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Byte_Enable -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Write_Data -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Read_Data -into $id
# wave add $tbpath${ps}iomodule_0${ps}IO_Ready -into $id
  wave add $tbpath${ps}iomodule_0${ps}UART_Rx -into $id
  wave add $tbpath${ps}iomodule_0${ps}UART_Tx -into $id
# wave add $tbpath${ps}iomodule_0${ps}UART_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT1_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT1_Toggle -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT2_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT2_Toggle -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT3_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT3_Toggle -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT4_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}FIT4_Toggle -into $id
  wave add $tbpath${ps}iomodule_0${ps}PIT1_Enable -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT1_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT1_Toggle -into $id
  wave add $tbpath${ps}iomodule_0${ps}PIT2_Enable -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT2_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT2_Toggle -into $id
  wave add $tbpath${ps}iomodule_0${ps}PIT3_Enable -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT3_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT3_Toggle -into $id
  wave add $tbpath${ps}iomodule_0${ps}PIT4_Enable -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT4_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}PIT4_Toggle -into $id
  wave add $tbpath${ps}iomodule_0${ps}GPO1 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPO2 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPO3 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPO4 -into $id
  wave add $tbpath${ps}iomodule_0${ps}GPI1 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPI1_Interrupt -into $id
  wave add $tbpath${ps}iomodule_0${ps}GPI2 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPI2_Interrupt -into $id
  wave add $tbpath${ps}iomodule_0${ps}GPI3 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPI3_Interrupt -into $id
  wave add $tbpath${ps}iomodule_0${ps}GPI4 -into $id
# wave add $tbpath${ps}iomodule_0${ps}GPI4_Interrupt -into $id
  wave add $tbpath${ps}iomodule_0${ps}INTC_Interrupt -into $id
# wave add $tbpath${ps}iomodule_0${ps}INTC_IRQ -into $id
# wave add $tbpath${ps}iomodule_0${ps}INTC_Processor_Ack -into $id
# wave add $tbpath${ps}iomodule_0${ps}INTC_Interrupt_Address -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_ABus -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_WriteDBus -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_AddrStrobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_ReadStrobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_WriteStrobe -into $id
# wave add $tbpath${ps}iomodule_0${ps}LMB_BE -into $id
  wave add $tbpath${ps}iomodule_0${ps}Sl_DBus -into $id
  wave add $tbpath${ps}iomodule_0${ps}Sl_Ready -into $id
  wave add $tbpath${ps}iomodule_0${ps}Sl_Wait -into $id
  wave add $tbpath${ps}iomodule_0${ps}Sl_UE -into $id
  wave add $tbpath${ps}iomodule_0${ps}Sl_CE -into $id

