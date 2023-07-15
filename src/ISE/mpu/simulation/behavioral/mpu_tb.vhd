-------------------------------------------------------------------------------
-- mpu_tb.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

-- START USER CODE (Do not remove this line)

-- User: Put your libraries here. Code in this
--       section will not be overwritten.

-- END USER CODE (Do not remove this line)

entity mpu_tb is
end mpu_tb;

architecture STRUCTURE of mpu_tb is

  constant GCLK_PERIOD : time := 10000.000000 ps;
  constant RESET_LENGTH : time := 160000 ps;

  component mpu is
    port (
      zio : inout std_logic;
      rzq : inout std_logic;
      mcbx_dram_we_n : out std_logic;
      mcbx_dram_udqs_n : inout std_logic;
      mcbx_dram_udqs : inout std_logic;
      mcbx_dram_udm : out std_logic;
      mcbx_dram_ras_n : out std_logic;
      mcbx_dram_odt : out std_logic;
      mcbx_dram_ldm : out std_logic;
      mcbx_dram_dqs_n : inout std_logic;
      mcbx_dram_dqs : inout std_logic;
      mcbx_dram_dq : inout std_logic_vector(15 downto 0);
      mcbx_dram_clk_n : out std_logic;
      mcbx_dram_clk : out std_logic;
      mcbx_dram_cke : out std_logic;
      mcbx_dram_cas_n : out std_logic;
      mcbx_dram_ba : out std_logic_vector(2 downto 0);
      mcbx_dram_addr : out std_logic_vector(12 downto 0);
      RESET : in std_logic;
      QSPI_FLASH_SS : inout std_logic;
      QSPI_FLASH_SCLK : inout std_logic;
      QSPI_FLASH_IO1 : inout std_logic;
      QSPI_FLASH_IO0 : inout std_logic;
      GCLK : in std_logic;
      Ethernet_Lite_TX_EN : out std_logic;
      Ethernet_Lite_TX_CLK : in std_logic;
      Ethernet_Lite_TXD : out std_logic_vector(3 downto 0);
      Ethernet_Lite_RX_ER : in std_logic;
      Ethernet_Lite_RX_DV : in std_logic;
      Ethernet_Lite_RX_CLK : in std_logic;
      Ethernet_Lite_RXD : in std_logic_vector(3 downto 0);
      Ethernet_Lite_PHY_RST_N : out std_logic;
      Ethernet_Lite_MDIO : inout std_logic;
      Ethernet_Lite_MDC : out std_logic;
      Ethernet_Lite_CRS : in std_logic;
      Ethernet_Lite_COL : in std_logic;
      iomodule_0_UART_Rx : in std_logic;
      iomodule_0_UART_Tx : out std_logic;
      iomodule_0_GPO1 : out std_logic_vector(31 downto 0);
      iomodule_0_GPI1 : in std_logic_vector(31 downto 0);
      error_i : in std_logic_vector(31 downto 0);
      error_u00 : in std_logic_vector(31 downto 0);
      error_u01 : in std_logic_vector(31 downto 0);
      error_u02 : in std_logic_vector(31 downto 0);
      error_u10 : in std_logic_vector(31 downto 0);
      error_u12 : in std_logic_vector(31 downto 0);
      error_u11 : in std_logic_vector(31 downto 0);
      error_u20 : in std_logic_vector(31 downto 0);
      error_u21 : in std_logic_vector(31 downto 0);
      error_u22 : in std_logic_vector(31 downto 0);
      error_x00 : in std_logic_vector(31 downto 0);
      error_x02 : in std_logic_vector(31 downto 0);
      error_x01 : in std_logic_vector(31 downto 0);
      error_x11 : in std_logic_vector(31 downto 0);
      error_x10 : in std_logic_vector(31 downto 0);
      error_x12 : in std_logic_vector(31 downto 0);
      error_x20 : in std_logic_vector(31 downto 0);
      error_x22 : in std_logic_vector(31 downto 0);
      error_x21 : in std_logic_vector(31 downto 0);
      u_data_in : out std_logic_vector(15 downto 0);
      u_data_out : in std_logic_vector(15 downto 0);
      u_address : out std_logic_vector(13 downto 0);
      u_we : out std_logic;
      x_data_in : out std_logic_vector(15 downto 0);
      x_data_out : in std_logic_vector(15 downto 0);
      x_address : out std_logic_vector(13 downto 0);
      x_we : out std_logic;
      ideal_address : out std_logic_vector(13 downto 0);
      ideal_we : out std_logic;
      ideal_data_in : out std_logic_vector(15 downto 0);
      ideal_data_out : in std_logic_vector(15 downto 0);
      template_A00 : out std_logic_vector(15 downto 0);
      template_A01 : out std_logic_vector(15 downto 0);
      template_A02 : out std_logic_vector(15 downto 0);
      template_A10 : out std_logic_vector(15 downto 0);
      template_A11 : out std_logic_vector(15 downto 0);
      template_A12 : out std_logic_vector(15 downto 0);
      template_A20 : out std_logic_vector(15 downto 0);
      template_A21 : out std_logic_vector(15 downto 0);
      template_A22 : out std_logic_vector(15 downto 0);
      template_B00 : out std_logic_vector(15 downto 0);
      template_B01 : out std_logic_vector(15 downto 0);
      template_B02 : out std_logic_vector(15 downto 0);
      template_B10 : out std_logic_vector(15 downto 0);
      template_B11 : out std_logic_vector(15 downto 0);
      template_B12 : out std_logic_vector(15 downto 0);
      template_B20 : out std_logic_vector(15 downto 0);
      template_B21 : out std_logic_vector(15 downto 0);
      template_B22 : out std_logic_vector(15 downto 0);
      template_I : out std_logic_vector(15 downto 0);
      template_xbnd : out std_logic_vector(15 downto 0);
      template_ubnd : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Internal signals

  signal Ethernet_Lite_COL : std_logic;
  signal Ethernet_Lite_CRS : std_logic;
  signal Ethernet_Lite_MDC : std_logic;
  signal Ethernet_Lite_MDIO : std_logic;
  signal Ethernet_Lite_PHY_RST_N : std_logic;
  signal Ethernet_Lite_RXD : std_logic_vector(3 downto 0);
  signal Ethernet_Lite_RX_CLK : std_logic;
  signal Ethernet_Lite_RX_DV : std_logic;
  signal Ethernet_Lite_RX_ER : std_logic;
  signal Ethernet_Lite_TXD : std_logic_vector(3 downto 0);
  signal Ethernet_Lite_TX_CLK : std_logic;
  signal Ethernet_Lite_TX_EN : std_logic;
  signal GCLK : std_logic;
  signal QSPI_FLASH_IO0 : std_logic;
  signal QSPI_FLASH_IO1 : std_logic;
  signal QSPI_FLASH_SCLK : std_logic;
  signal QSPI_FLASH_SS : std_logic;
  signal RESET : std_logic;
  signal error_i : std_logic_vector(31 downto 0);
  signal error_u00 : std_logic_vector(31 downto 0);
  signal error_u01 : std_logic_vector(31 downto 0);
  signal error_u02 : std_logic_vector(31 downto 0);
  signal error_u10 : std_logic_vector(31 downto 0);
  signal error_u11 : std_logic_vector(31 downto 0);
  signal error_u12 : std_logic_vector(31 downto 0);
  signal error_u20 : std_logic_vector(31 downto 0);
  signal error_u21 : std_logic_vector(31 downto 0);
  signal error_u22 : std_logic_vector(31 downto 0);
  signal error_x00 : std_logic_vector(31 downto 0);
  signal error_x01 : std_logic_vector(31 downto 0);
  signal error_x02 : std_logic_vector(31 downto 0);
  signal error_x10 : std_logic_vector(31 downto 0);
  signal error_x11 : std_logic_vector(31 downto 0);
  signal error_x12 : std_logic_vector(31 downto 0);
  signal error_x20 : std_logic_vector(31 downto 0);
  signal error_x21 : std_logic_vector(31 downto 0);
  signal error_x22 : std_logic_vector(31 downto 0);
  signal ideal_address : std_logic_vector(13 downto 0);
  signal ideal_data_in : std_logic_vector(15 downto 0);
  signal ideal_data_out : std_logic_vector(15 downto 0);
  signal ideal_we : std_logic;
  signal iomodule_0_GPI1 : std_logic_vector(31 downto 0);
  signal iomodule_0_GPO1 : std_logic_vector(31 downto 0);
  signal iomodule_0_UART_Rx : std_logic;
  signal iomodule_0_UART_Tx : std_logic;
  signal mcbx_dram_addr : std_logic_vector(12 downto 0);
  signal mcbx_dram_ba : std_logic_vector(2 downto 0);
  signal mcbx_dram_cas_n : std_logic;
  signal mcbx_dram_cke : std_logic;
  signal mcbx_dram_clk : std_logic;
  signal mcbx_dram_clk_n : std_logic;
  signal mcbx_dram_dq : std_logic_vector(15 downto 0);
  signal mcbx_dram_dqs : std_logic;
  signal mcbx_dram_dqs_n : std_logic;
  signal mcbx_dram_ldm : std_logic;
  signal mcbx_dram_odt : std_logic;
  signal mcbx_dram_ras_n : std_logic;
  signal mcbx_dram_udm : std_logic;
  signal mcbx_dram_udqs : std_logic;
  signal mcbx_dram_udqs_n : std_logic;
  signal mcbx_dram_we_n : std_logic;
  signal rzq : std_logic;
  signal template_A00 : std_logic_vector(15 downto 0);
  signal template_A01 : std_logic_vector(15 downto 0);
  signal template_A02 : std_logic_vector(15 downto 0);
  signal template_A10 : std_logic_vector(15 downto 0);
  signal template_A11 : std_logic_vector(15 downto 0);
  signal template_A12 : std_logic_vector(15 downto 0);
  signal template_A20 : std_logic_vector(15 downto 0);
  signal template_A21 : std_logic_vector(15 downto 0);
  signal template_A22 : std_logic_vector(15 downto 0);
  signal template_B00 : std_logic_vector(15 downto 0);
  signal template_B01 : std_logic_vector(15 downto 0);
  signal template_B02 : std_logic_vector(15 downto 0);
  signal template_B10 : std_logic_vector(15 downto 0);
  signal template_B11 : std_logic_vector(15 downto 0);
  signal template_B12 : std_logic_vector(15 downto 0);
  signal template_B20 : std_logic_vector(15 downto 0);
  signal template_B21 : std_logic_vector(15 downto 0);
  signal template_B22 : std_logic_vector(15 downto 0);
  signal template_I : std_logic_vector(15 downto 0);
  signal template_ubnd : std_logic_vector(15 downto 0);
  signal template_xbnd : std_logic_vector(15 downto 0);
  signal u_address : std_logic_vector(13 downto 0);
  signal u_data_in : std_logic_vector(15 downto 0);
  signal u_data_out : std_logic_vector(15 downto 0);
  signal u_we : std_logic;
  signal x_address : std_logic_vector(13 downto 0);
  signal x_data_in : std_logic_vector(15 downto 0);
  signal x_data_out : std_logic_vector(15 downto 0);
  signal x_we : std_logic;
  signal zio : std_logic;

  -- START USER CODE (Do not remove this line)

  -- User: Put your signals here. Code in this
  --       section will not be overwritten.

  -- END USER CODE (Do not remove this line)

begin

  dut : mpu
    port map (
      zio => zio,
      rzq => rzq,
      mcbx_dram_we_n => mcbx_dram_we_n,
      mcbx_dram_udqs_n => mcbx_dram_udqs_n,
      mcbx_dram_udqs => mcbx_dram_udqs,
      mcbx_dram_udm => mcbx_dram_udm,
      mcbx_dram_ras_n => mcbx_dram_ras_n,
      mcbx_dram_odt => mcbx_dram_odt,
      mcbx_dram_ldm => mcbx_dram_ldm,
      mcbx_dram_dqs_n => mcbx_dram_dqs_n,
      mcbx_dram_dqs => mcbx_dram_dqs,
      mcbx_dram_dq => mcbx_dram_dq,
      mcbx_dram_clk_n => mcbx_dram_clk_n,
      mcbx_dram_clk => mcbx_dram_clk,
      mcbx_dram_cke => mcbx_dram_cke,
      mcbx_dram_cas_n => mcbx_dram_cas_n,
      mcbx_dram_ba => mcbx_dram_ba,
      mcbx_dram_addr => mcbx_dram_addr,
      RESET => RESET,
      QSPI_FLASH_SS => QSPI_FLASH_SS,
      QSPI_FLASH_SCLK => QSPI_FLASH_SCLK,
      QSPI_FLASH_IO1 => QSPI_FLASH_IO1,
      QSPI_FLASH_IO0 => QSPI_FLASH_IO0,
      GCLK => GCLK,
      Ethernet_Lite_TX_EN => Ethernet_Lite_TX_EN,
      Ethernet_Lite_TX_CLK => Ethernet_Lite_TX_CLK,
      Ethernet_Lite_TXD => Ethernet_Lite_TXD,
      Ethernet_Lite_RX_ER => Ethernet_Lite_RX_ER,
      Ethernet_Lite_RX_DV => Ethernet_Lite_RX_DV,
      Ethernet_Lite_RX_CLK => Ethernet_Lite_RX_CLK,
      Ethernet_Lite_RXD => Ethernet_Lite_RXD,
      Ethernet_Lite_PHY_RST_N => Ethernet_Lite_PHY_RST_N,
      Ethernet_Lite_MDIO => Ethernet_Lite_MDIO,
      Ethernet_Lite_MDC => Ethernet_Lite_MDC,
      Ethernet_Lite_CRS => Ethernet_Lite_CRS,
      Ethernet_Lite_COL => Ethernet_Lite_COL,
      iomodule_0_UART_Rx => iomodule_0_UART_Rx,
      iomodule_0_UART_Tx => iomodule_0_UART_Tx,
      iomodule_0_GPO1 => iomodule_0_GPO1,
      iomodule_0_GPI1 => iomodule_0_GPI1,
      error_i => error_i,
      error_u00 => error_u00,
      error_u01 => error_u01,
      error_u02 => error_u02,
      error_u10 => error_u10,
      error_u12 => error_u12,
      error_u11 => error_u11,
      error_u20 => error_u20,
      error_u21 => error_u21,
      error_u22 => error_u22,
      error_x00 => error_x00,
      error_x02 => error_x02,
      error_x01 => error_x01,
      error_x11 => error_x11,
      error_x10 => error_x10,
      error_x12 => error_x12,
      error_x20 => error_x20,
      error_x22 => error_x22,
      error_x21 => error_x21,
      u_data_in => u_data_in,
      u_data_out => u_data_out,
      u_address => u_address,
      u_we => u_we,
      x_data_in => x_data_in,
      x_data_out => x_data_out,
      x_address => x_address,
      x_we => x_we,
      ideal_address => ideal_address,
      ideal_we => ideal_we,
      ideal_data_in => ideal_data_in,
      ideal_data_out => ideal_data_out,
      template_A00 => template_A00,
      template_A01 => template_A01,
      template_A02 => template_A02,
      template_A10 => template_A10,
      template_A11 => template_A11,
      template_A12 => template_A12,
      template_A20 => template_A20,
      template_A21 => template_A21,
      template_A22 => template_A22,
      template_B00 => template_B00,
      template_B01 => template_B01,
      template_B02 => template_B02,
      template_B10 => template_B10,
      template_B11 => template_B11,
      template_B12 => template_B12,
      template_B20 => template_B20,
      template_B21 => template_B21,
      template_B22 => template_B22,
      template_I => template_I,
      template_xbnd => template_xbnd,
      template_ubnd => template_ubnd
    );

  -- Clock generator for GCLK

  process
  begin
    GCLK <= '0';
    loop
      wait for (GCLK_PERIOD/2);
      GCLK <= not GCLK;
    end loop;
  end process;

  -- Reset Generator for RESET

  process
  begin
    RESET <= '0';
    wait for (RESET_LENGTH);
    RESET <= not RESET;
    wait;
  end process;

  -- START USER CODE (Do not remove this line)

  -- User: Put your stimulus here. Code in this
  --       section will not be overwritten.

  -- END USER CODE (Do not remove this line)

end architecture STRUCTURE;

