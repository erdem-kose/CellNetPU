-------------------------------------------------------------------------------
-- mpu_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity mpu_stub is
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
    iomodule_0_GPO2 : out std_logic_vector(31 downto 0);
    iomodule_0_GPO3 : out std_logic_vector(31 downto 0);
    iomodule_0_GPI1 : in std_logic_vector(31 downto 0);
    iomodule_0_GPI2 : in std_logic_vector(31 downto 0);
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
    error_x21 : in std_logic_vector(31 downto 0)
  );
end mpu_stub;

architecture STRUCTURE of mpu_stub is

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
      iomodule_0_GPO2 : out std_logic_vector(31 downto 0);
      iomodule_0_GPO3 : out std_logic_vector(31 downto 0);
      iomodule_0_GPI1 : in std_logic_vector(31 downto 0);
      iomodule_0_GPI2 : in std_logic_vector(31 downto 0);
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
      error_x21 : in std_logic_vector(31 downto 0)
    );
  end component;

  attribute BUFFER_TYPE : STRING;
  attribute BOX_TYPE : STRING;
  attribute BUFFER_TYPE of Ethernet_Lite_TX_CLK : signal is "IBUF";
  attribute BUFFER_TYPE of Ethernet_Lite_RX_CLK : signal is "IBUF";
  attribute BOX_TYPE of mpu : component is "user_black_box";

begin

  mpu_i : mpu
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
      iomodule_0_GPO2 => iomodule_0_GPO2,
      iomodule_0_GPO3 => iomodule_0_GPO3,
      iomodule_0_GPI1 => iomodule_0_GPI1,
      iomodule_0_GPI2 => iomodule_0_GPI2,
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
      error_x21 => error_x21
    );

end architecture STRUCTURE;
