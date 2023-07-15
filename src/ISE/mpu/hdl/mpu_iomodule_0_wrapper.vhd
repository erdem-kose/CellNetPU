-------------------------------------------------------------------------------
-- mpu_iomodule_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library iomodule_v1_03_a;
use iomodule_v1_03_a.all;

entity mpu_iomodule_0_wrapper is
  port (
    CLK : in std_logic;
    Rst : in std_logic;
    IO_Addr_Strobe : out std_logic;
    IO_Read_Strobe : out std_logic;
    IO_Write_Strobe : out std_logic;
    IO_Address : out std_logic_vector(31 downto 0);
    IO_Byte_Enable : out std_logic_vector(3 downto 0);
    IO_Write_Data : out std_logic_vector(31 downto 0);
    IO_Read_Data : in std_logic_vector(31 downto 0);
    IO_Ready : in std_logic;
    UART_Rx : in std_logic;
    UART_Tx : out std_logic;
    UART_Interrupt : out std_logic;
    FIT1_Interrupt : out std_logic;
    FIT1_Toggle : out std_logic;
    FIT2_Interrupt : out std_logic;
    FIT2_Toggle : out std_logic;
    FIT3_Interrupt : out std_logic;
    FIT3_Toggle : out std_logic;
    FIT4_Interrupt : out std_logic;
    FIT4_Toggle : out std_logic;
    PIT1_Enable : in std_logic;
    PIT1_Interrupt : out std_logic;
    PIT1_Toggle : out std_logic;
    PIT2_Enable : in std_logic;
    PIT2_Interrupt : out std_logic;
    PIT2_Toggle : out std_logic;
    PIT3_Enable : in std_logic;
    PIT3_Interrupt : out std_logic;
    PIT3_Toggle : out std_logic;
    PIT4_Enable : in std_logic;
    PIT4_Interrupt : out std_logic;
    PIT4_Toggle : out std_logic;
    GPO1 : out std_logic_vector(31 downto 0);
    GPO2 : out std_logic_vector(31 downto 0);
    GPO3 : out std_logic_vector(31 downto 0);
    GPO4 : out std_logic_vector(31 downto 0);
    GPI1 : in std_logic_vector(31 downto 0);
    GPI1_Interrupt : out std_logic;
    GPI2 : in std_logic_vector(31 downto 0);
    GPI2_Interrupt : out std_logic;
    GPI3 : in std_logic_vector(31 downto 0);
    GPI3_Interrupt : out std_logic;
    GPI4 : in std_logic_vector(31 downto 0);
    GPI4_Interrupt : out std_logic;
    INTC_Interrupt : in std_logic_vector(0 downto 0);
    INTC_IRQ : out std_logic;
    INTC_Processor_Ack : in std_logic_vector(1 downto 0);
    INTC_Interrupt_Address : out std_logic_vector(31 downto 0);
    LMB_ABus : in std_logic_vector(0 to 31);
    LMB_WriteDBus : in std_logic_vector(0 to 31);
    LMB_AddrStrobe : in std_logic;
    LMB_ReadStrobe : in std_logic;
    LMB_WriteStrobe : in std_logic;
    LMB_BE : in std_logic_vector(0 to 3);
    Sl_DBus : out std_logic_vector(0 to 31);
    Sl_Ready : out std_logic;
    Sl_Wait : out std_logic;
    Sl_UE : out std_logic;
    Sl_CE : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of mpu_iomodule_0_wrapper : entity is "iomodule_v1_03_a";

end mpu_iomodule_0_wrapper;

architecture STRUCTURE of mpu_iomodule_0_wrapper is

  component iomodule is
    generic (
      C_FAMILY : string;
      C_FREQ : integer;
      C_INSTANCE : string;
      C_BASEADDR : std_logic_vector(0 to 31);
      C_HIGHADDR : std_logic_vector(0 to 31);
      C_MASK : std_logic_vector(0 to 31);
      C_IO_BASEADDR : std_logic_vector(0 to 31);
      C_IO_HIGHADDR : std_logic_vector(0 to 31);
      C_IO_MASK : std_logic_vector(0 to 31);
      C_LMB_AWIDTH : integer;
      C_LMB_DWIDTH : integer;
      C_USE_IO_BUS : integer;
      C_USE_UART_RX : integer;
      C_USE_UART_TX : integer;
      C_UART_BAUDRATE : integer;
      C_UART_DATA_BITS : integer;
      C_UART_USE_PARITY : integer;
      C_UART_ODD_PARITY : integer;
      C_UART_RX_INTERRUPT : integer;
      C_UART_TX_INTERRUPT : integer;
      C_UART_ERROR_INTERRUPT : integer;
      C_UART_PROG_BAUDRATE : integer;
      C_USE_FIT1 : integer;
      C_FIT1_No_CLOCKS : integer;
      C_FIT1_INTERRUPT : integer;
      C_USE_FIT2 : integer;
      C_FIT2_No_CLOCKS : integer;
      C_FIT2_INTERRUPT : integer;
      C_USE_FIT3 : integer;
      C_FIT3_No_CLOCKS : integer;
      C_FIT3_INTERRUPT : integer;
      C_USE_FIT4 : integer;
      C_FIT4_No_CLOCKS : integer;
      C_FIT4_INTERRUPT : integer;
      C_USE_PIT1 : integer;
      C_PIT1_SIZE : integer;
      C_PIT1_READABLE : integer;
      C_PIT1_PRESCALER : integer;
      C_PIT1_INTERRUPT : integer;
      C_USE_PIT2 : integer;
      C_PIT2_SIZE : integer;
      C_PIT2_READABLE : integer;
      C_PIT2_PRESCALER : integer;
      C_PIT2_INTERRUPT : integer;
      C_USE_PIT3 : integer;
      C_PIT3_SIZE : integer;
      C_PIT3_READABLE : integer;
      C_PIT3_PRESCALER : integer;
      C_PIT3_INTERRUPT : integer;
      C_USE_PIT4 : integer;
      C_PIT4_SIZE : integer;
      C_PIT4_READABLE : integer;
      C_PIT4_PRESCALER : integer;
      C_PIT4_INTERRUPT : integer;
      C_USE_GPO1 : integer;
      C_GPO1_SIZE : integer;
      C_GPO1_INIT : std_logic_vector(31 downto 0);
      C_USE_GPO2 : integer;
      C_GPO2_SIZE : integer;
      C_GPO2_INIT : std_logic_vector(31 downto 0);
      C_USE_GPO3 : integer;
      C_GPO3_SIZE : integer;
      C_GPO3_INIT : std_logic_vector(31 downto 0);
      C_USE_GPO4 : integer;
      C_GPO4_SIZE : integer;
      C_GPO4_INIT : std_logic_vector(31 downto 0);
      C_USE_GPI1 : integer;
      C_GPI1_SIZE : integer;
      C_GPI1_INTERRUPT : integer;
      C_USE_GPI2 : integer;
      C_GPI2_SIZE : integer;
      C_GPI2_INTERRUPT : integer;
      C_USE_GPI3 : integer;
      C_GPI3_SIZE : integer;
      C_GPI3_INTERRUPT : integer;
      C_USE_GPI4 : integer;
      C_GPI4_SIZE : integer;
      C_GPI4_INTERRUPT : integer;
      C_INTC_USE_EXT_INTR : integer;
      C_INTC_INTR_SIZE : integer;
      C_INTC_LEVEL_EDGE : std_logic_vector(15 downto 0);
      C_INTC_POSITIVE : std_logic_vector(15 downto 0);
      C_INTC_HAS_FAST : integer;
      C_INTC_ADDR_WIDTH : integer;
      C_INTC_BASE_VECTORS : std_logic_vector
    );
    port (
      CLK : in std_logic;
      Rst : in std_logic;
      IO_Addr_Strobe : out std_logic;
      IO_Read_Strobe : out std_logic;
      IO_Write_Strobe : out std_logic;
      IO_Address : out std_logic_vector(C_LMB_AWIDTH-1 downto 0);
      IO_Byte_Enable : out std_logic_vector(C_LMB_DWIDTH/8-1 downto 0);
      IO_Write_Data : out std_logic_vector(C_LMB_DWIDTH-1 downto 0);
      IO_Read_Data : in std_logic_vector(C_LMB_DWIDTH-1 downto 0);
      IO_Ready : in std_logic;
      UART_Rx : in std_logic;
      UART_Tx : out std_logic;
      UART_Interrupt : out std_logic;
      FIT1_Interrupt : out std_logic;
      FIT1_Toggle : out std_logic;
      FIT2_Interrupt : out std_logic;
      FIT2_Toggle : out std_logic;
      FIT3_Interrupt : out std_logic;
      FIT3_Toggle : out std_logic;
      FIT4_Interrupt : out std_logic;
      FIT4_Toggle : out std_logic;
      PIT1_Enable : in std_logic;
      PIT1_Interrupt : out std_logic;
      PIT1_Toggle : out std_logic;
      PIT2_Enable : in std_logic;
      PIT2_Interrupt : out std_logic;
      PIT2_Toggle : out std_logic;
      PIT3_Enable : in std_logic;
      PIT3_Interrupt : out std_logic;
      PIT3_Toggle : out std_logic;
      PIT4_Enable : in std_logic;
      PIT4_Interrupt : out std_logic;
      PIT4_Toggle : out std_logic;
      GPO1 : out std_logic_vector(C_GPO1_SIZE-1 downto 0);
      GPO2 : out std_logic_vector(C_GPO2_SIZE-1 downto 0);
      GPO3 : out std_logic_vector(C_GPO3_SIZE-1 downto 0);
      GPO4 : out std_logic_vector(C_GPO4_SIZE-1 downto 0);
      GPI1 : in std_logic_vector(C_GPI1_SIZE-1 downto 0);
      GPI1_Interrupt : out std_logic;
      GPI2 : in std_logic_vector(C_GPI2_SIZE-1 downto 0);
      GPI2_Interrupt : out std_logic;
      GPI3 : in std_logic_vector(C_GPI3_SIZE-1 downto 0);
      GPI3_Interrupt : out std_logic;
      GPI4 : in std_logic_vector(C_GPI4_SIZE-1 downto 0);
      GPI4_Interrupt : out std_logic;
      INTC_Interrupt : in std_logic_vector((C_INTC_INTR_SIZE-1) downto 0);
      INTC_IRQ : out std_logic;
      INTC_Processor_Ack : in std_logic_vector(1 downto 0);
      INTC_Interrupt_Address : out std_logic_vector(31 downto 0);
      LMB_ABus : in std_logic_vector(0 to C_LMB_AWIDTH-1);
      LMB_WriteDBus : in std_logic_vector(0 to C_LMB_DWIDTH-1);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to C_LMB_DWIDTH/8-1);
      Sl_DBus : out std_logic_vector(0 to C_LMB_DWIDTH-1);
      Sl_Ready : out std_logic;
      Sl_Wait : out std_logic;
      Sl_UE : out std_logic;
      Sl_CE : out std_logic
    );
  end component;

begin

  iomodule_0 : iomodule
    generic map (
      C_FAMILY => "spartan6",
      C_FREQ => 100000000,
      C_INSTANCE => "iomodule_0",
      C_BASEADDR => X"80000000",
      C_HIGHADDR => X"8000007f",
      C_MASK => X"d0000000",
      C_IO_BASEADDR => X"FFFFFFFF",
      C_IO_HIGHADDR => X"00000000",
      C_IO_MASK => X"d0000000",
      C_LMB_AWIDTH => 32,
      C_LMB_DWIDTH => 32,
      C_USE_IO_BUS => 0,
      C_USE_UART_RX => 1,
      C_USE_UART_TX => 1,
      C_UART_BAUDRATE => 921600,
      C_UART_DATA_BITS => 8,
      C_UART_USE_PARITY => 0,
      C_UART_ODD_PARITY => 0,
      C_UART_RX_INTERRUPT => 0,
      C_UART_TX_INTERRUPT => 0,
      C_UART_ERROR_INTERRUPT => 0,
      C_UART_PROG_BAUDRATE => 1,
      C_USE_FIT1 => 0,
      C_FIT1_No_CLOCKS => 6216,
      C_FIT1_INTERRUPT => 0,
      C_USE_FIT2 => 0,
      C_FIT2_No_CLOCKS => 6216,
      C_FIT2_INTERRUPT => 0,
      C_USE_FIT3 => 0,
      C_FIT3_No_CLOCKS => 6216,
      C_FIT3_INTERRUPT => 0,
      C_USE_FIT4 => 0,
      C_FIT4_No_CLOCKS => 6216,
      C_FIT4_INTERRUPT => 0,
      C_USE_PIT1 => 0,
      C_PIT1_SIZE => 32,
      C_PIT1_READABLE => 1,
      C_PIT1_PRESCALER => 0,
      C_PIT1_INTERRUPT => 0,
      C_USE_PIT2 => 0,
      C_PIT2_SIZE => 32,
      C_PIT2_READABLE => 1,
      C_PIT2_PRESCALER => 0,
      C_PIT2_INTERRUPT => 0,
      C_USE_PIT3 => 0,
      C_PIT3_SIZE => 32,
      C_PIT3_READABLE => 1,
      C_PIT3_PRESCALER => 0,
      C_PIT3_INTERRUPT => 0,
      C_USE_PIT4 => 0,
      C_PIT4_SIZE => 32,
      C_PIT4_READABLE => 1,
      C_PIT4_PRESCALER => 0,
      C_PIT4_INTERRUPT => 0,
      C_USE_GPO1 => 1,
      C_GPO1_SIZE => 32,
      C_GPO1_INIT => X"00000000",
      C_USE_GPO2 => 1,
      C_GPO2_SIZE => 32,
      C_GPO2_INIT => X"00000000",
      C_USE_GPO3 => 1,
      C_GPO3_SIZE => 32,
      C_GPO3_INIT => X"00000000",
      C_USE_GPO4 => 0,
      C_GPO4_SIZE => 32,
      C_GPO4_INIT => X"00000000",
      C_USE_GPI1 => 1,
      C_GPI1_SIZE => 32,
      C_GPI1_INTERRUPT => 0,
      C_USE_GPI2 => 1,
      C_GPI2_SIZE => 32,
      C_GPI2_INTERRUPT => 0,
      C_USE_GPI3 => 0,
      C_GPI3_SIZE => 32,
      C_GPI3_INTERRUPT => 0,
      C_USE_GPI4 => 0,
      C_GPI4_SIZE => 32,
      C_GPI4_INTERRUPT => 0,
      C_INTC_USE_EXT_INTR => 0,
      C_INTC_INTR_SIZE => 1,
      C_INTC_LEVEL_EDGE => B"0000000000000000",
      C_INTC_POSITIVE => B"0000000000000001",
      C_INTC_HAS_FAST => 0,
      C_INTC_ADDR_WIDTH => 32,
      C_INTC_BASE_VECTORS => X"00000000"
    )
    port map (
      CLK => CLK,
      Rst => Rst,
      IO_Addr_Strobe => IO_Addr_Strobe,
      IO_Read_Strobe => IO_Read_Strobe,
      IO_Write_Strobe => IO_Write_Strobe,
      IO_Address => IO_Address,
      IO_Byte_Enable => IO_Byte_Enable,
      IO_Write_Data => IO_Write_Data,
      IO_Read_Data => IO_Read_Data,
      IO_Ready => IO_Ready,
      UART_Rx => UART_Rx,
      UART_Tx => UART_Tx,
      UART_Interrupt => UART_Interrupt,
      FIT1_Interrupt => FIT1_Interrupt,
      FIT1_Toggle => FIT1_Toggle,
      FIT2_Interrupt => FIT2_Interrupt,
      FIT2_Toggle => FIT2_Toggle,
      FIT3_Interrupt => FIT3_Interrupt,
      FIT3_Toggle => FIT3_Toggle,
      FIT4_Interrupt => FIT4_Interrupt,
      FIT4_Toggle => FIT4_Toggle,
      PIT1_Enable => PIT1_Enable,
      PIT1_Interrupt => PIT1_Interrupt,
      PIT1_Toggle => PIT1_Toggle,
      PIT2_Enable => PIT2_Enable,
      PIT2_Interrupt => PIT2_Interrupt,
      PIT2_Toggle => PIT2_Toggle,
      PIT3_Enable => PIT3_Enable,
      PIT3_Interrupt => PIT3_Interrupt,
      PIT3_Toggle => PIT3_Toggle,
      PIT4_Enable => PIT4_Enable,
      PIT4_Interrupt => PIT4_Interrupt,
      PIT4_Toggle => PIT4_Toggle,
      GPO1 => GPO1,
      GPO2 => GPO2,
      GPO3 => GPO3,
      GPO4 => GPO4,
      GPI1 => GPI1,
      GPI1_Interrupt => GPI1_Interrupt,
      GPI2 => GPI2,
      GPI2_Interrupt => GPI2_Interrupt,
      GPI3 => GPI3,
      GPI3_Interrupt => GPI3_Interrupt,
      GPI4 => GPI4,
      GPI4_Interrupt => GPI4_Interrupt,
      INTC_Interrupt => INTC_Interrupt,
      INTC_IRQ => INTC_IRQ,
      INTC_Processor_Ack => INTC_Processor_Ack,
      INTC_Interrupt_Address => INTC_Interrupt_Address,
      LMB_ABus => LMB_ABus,
      LMB_WriteDBus => LMB_WriteDBus,
      LMB_AddrStrobe => LMB_AddrStrobe,
      LMB_ReadStrobe => LMB_ReadStrobe,
      LMB_WriteStrobe => LMB_WriteStrobe,
      LMB_BE => LMB_BE,
      Sl_DBus => Sl_DBus,
      Sl_Ready => Sl_Ready,
      Sl_Wait => Sl_Wait,
      Sl_UE => Sl_UE,
      Sl_CE => Sl_CE
    );

end architecture STRUCTURE;

