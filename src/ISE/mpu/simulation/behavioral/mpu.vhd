-------------------------------------------------------------------------------
-- mpu.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity mpu is
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
end mpu;

architecture STRUCTURE of mpu is

  component mpu_x_data_in_out_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_x_address_we_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(13 downto 0);
      GPIO_IO_O : out std_logic_vector(13 downto 0);
      GPIO_IO_T : out std_logic_vector(13 downto 0);
      GPIO2_IO_I : in std_logic_vector(0 downto 0);
      GPIO2_IO_O : out std_logic_vector(0 downto 0);
      GPIO2_IO_T : out std_logic_vector(0 downto 0)
    );
  end component;

  component mpu_u_data_in_out_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_u_address_we_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(13 downto 0);
      GPIO_IO_O : out std_logic_vector(13 downto 0);
      GPIO_IO_T : out std_logic_vector(13 downto 0);
      GPIO2_IO_I : in std_logic_vector(0 downto 0);
      GPIO2_IO_O : out std_logic_vector(0 downto 0);
      GPIO2_IO_T : out std_logic_vector(0 downto 0)
    );
  end component;

  component mpu_template_i_base_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_template_b21_b22_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_b12_b20_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_b10_b11_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_b01_b02_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_a22_b00_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_a20_a21_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_a11_a12_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_a02_a10_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_template_a00_a01_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_proc_sys_reset_0_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      MB_Debug_Sys_Rst : in std_logic;
      Core_Reset_Req_0 : in std_logic;
      Chip_Reset_Req_0 : in std_logic;
      System_Reset_Req_0 : in std_logic;
      Core_Reset_Req_1 : in std_logic;
      Chip_Reset_Req_1 : in std_logic;
      System_Reset_Req_1 : in std_logic;
      Dcm_locked : in std_logic;
      RstcPPCresetcore_0 : out std_logic;
      RstcPPCresetchip_0 : out std_logic;
      RstcPPCresetsys_0 : out std_logic;
      RstcPPCresetcore_1 : out std_logic;
      RstcPPCresetchip_1 : out std_logic;
      RstcPPCresetsys_1 : out std_logic;
      MB_Reset : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0);
      Interconnect_aresetn : out std_logic_vector(0 to 0);
      Peripheral_aresetn : out std_logic_vector(0 to 0)
    );
  end component;

  component mpu_microblaze_0_intc_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      Intr : in std_logic_vector(0 downto 0);
      Processor_clk : in std_logic;
      Processor_rst : in std_logic;
      Irq : out std_logic;
      Interrupt_address : out std_logic_vector(31 downto 0);
      Processor_ack : in std_logic_vector(1 downto 0);
      Interrupt_address_in : in std_logic_vector(31 downto 0);
      Processor_ack_out : out std_logic_vector(1 downto 0)
    );
  end component;

  component mpu_microblaze_0_ilmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      Sl_Wait : in std_logic_vector(0 to 0);
      Sl_UE : in std_logic_vector(0 to 0);
      Sl_CE : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_Wait : out std_logic;
      LMB_UE : out std_logic;
      LMB_CE : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mpu_microblaze_0_i_bram_ctrl_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
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
      Sl_CE : out std_logic;
      LMB1_ABus : in std_logic_vector(0 to 31);
      LMB1_WriteDBus : in std_logic_vector(0 to 31);
      LMB1_AddrStrobe : in std_logic;
      LMB1_ReadStrobe : in std_logic;
      LMB1_WriteStrobe : in std_logic;
      LMB1_BE : in std_logic_vector(0 to 3);
      Sl1_DBus : out std_logic_vector(0 to 31);
      Sl1_Ready : out std_logic;
      Sl1_Wait : out std_logic;
      Sl1_UE : out std_logic;
      Sl1_CE : out std_logic;
      LMB2_ABus : in std_logic_vector(0 to 31);
      LMB2_WriteDBus : in std_logic_vector(0 to 31);
      LMB2_AddrStrobe : in std_logic;
      LMB2_ReadStrobe : in std_logic;
      LMB2_WriteStrobe : in std_logic;
      LMB2_BE : in std_logic_vector(0 to 3);
      Sl2_DBus : out std_logic_vector(0 to 31);
      Sl2_Ready : out std_logic;
      Sl2_Wait : out std_logic;
      Sl2_UE : out std_logic;
      Sl2_CE : out std_logic;
      LMB3_ABus : in std_logic_vector(0 to 31);
      LMB3_WriteDBus : in std_logic_vector(0 to 31);
      LMB3_AddrStrobe : in std_logic;
      LMB3_ReadStrobe : in std_logic;
      LMB3_WriteStrobe : in std_logic;
      LMB3_BE : in std_logic_vector(0 to 3);
      Sl3_DBus : out std_logic_vector(0 to 31);
      Sl3_Ready : out std_logic;
      Sl3_Wait : out std_logic;
      Sl3_UE : out std_logic;
      Sl3_CE : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31);
      Interrupt : out std_logic;
      UE : out std_logic;
      CE : out std_logic;
      SPLB_CTRL_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB_CTRL_PLB_PAValid : in std_logic;
      SPLB_CTRL_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB_CTRL_PLB_RNW : in std_logic;
      SPLB_CTRL_PLB_BE : in std_logic_vector(0 to 3);
      SPLB_CTRL_PLB_size : in std_logic_vector(0 to 3);
      SPLB_CTRL_PLB_type : in std_logic_vector(0 to 2);
      SPLB_CTRL_PLB_wrDBus : in std_logic_vector(0 to 31);
      SPLB_CTRL_Sl_addrAck : out std_logic;
      SPLB_CTRL_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB_CTRL_Sl_wait : out std_logic;
      SPLB_CTRL_Sl_rearbitrate : out std_logic;
      SPLB_CTRL_Sl_wrDAck : out std_logic;
      SPLB_CTRL_Sl_wrComp : out std_logic;
      SPLB_CTRL_Sl_rdDBus : out std_logic_vector(0 to 31);
      SPLB_CTRL_Sl_rdDAck : out std_logic;
      SPLB_CTRL_Sl_rdComp : out std_logic;
      SPLB_CTRL_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB_CTRL_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB_CTRL_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB_CTRL_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB_CTRL_PLB_SAValid : in std_logic;
      SPLB_CTRL_PLB_rdPrim : in std_logic;
      SPLB_CTRL_PLB_wrPrim : in std_logic;
      SPLB_CTRL_PLB_abort : in std_logic;
      SPLB_CTRL_PLB_busLock : in std_logic;
      SPLB_CTRL_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_lockErr : in std_logic;
      SPLB_CTRL_PLB_wrBurst : in std_logic;
      SPLB_CTRL_PLB_rdBurst : in std_logic;
      SPLB_CTRL_PLB_wrPendReq : in std_logic;
      SPLB_CTRL_PLB_rdPendReq : in std_logic;
      SPLB_CTRL_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB_CTRL_Sl_wrBTerm : out std_logic;
      SPLB_CTRL_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB_CTRL_Sl_rdBTerm : out std_logic;
      SPLB_CTRL_Sl_MIRQ : out std_logic_vector(0 to 0);
      S_AXI_CTRL_ACLK : in std_logic;
      S_AXI_CTRL_ARESETN : in std_logic;
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic
    );
  end component;

  component mpu_microblaze_0_dlmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 63);
      Sl_Ready : in std_logic_vector(0 to 1);
      Sl_Wait : in std_logic_vector(0 to 1);
      Sl_UE : in std_logic_vector(0 to 1);
      Sl_CE : in std_logic_vector(0 to 1);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_Wait : out std_logic;
      LMB_UE : out std_logic;
      LMB_CE : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mpu_microblaze_0_d_bram_ctrl_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
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
      Sl_CE : out std_logic;
      LMB1_ABus : in std_logic_vector(0 to 31);
      LMB1_WriteDBus : in std_logic_vector(0 to 31);
      LMB1_AddrStrobe : in std_logic;
      LMB1_ReadStrobe : in std_logic;
      LMB1_WriteStrobe : in std_logic;
      LMB1_BE : in std_logic_vector(0 to 3);
      Sl1_DBus : out std_logic_vector(0 to 31);
      Sl1_Ready : out std_logic;
      Sl1_Wait : out std_logic;
      Sl1_UE : out std_logic;
      Sl1_CE : out std_logic;
      LMB2_ABus : in std_logic_vector(0 to 31);
      LMB2_WriteDBus : in std_logic_vector(0 to 31);
      LMB2_AddrStrobe : in std_logic;
      LMB2_ReadStrobe : in std_logic;
      LMB2_WriteStrobe : in std_logic;
      LMB2_BE : in std_logic_vector(0 to 3);
      Sl2_DBus : out std_logic_vector(0 to 31);
      Sl2_Ready : out std_logic;
      Sl2_Wait : out std_logic;
      Sl2_UE : out std_logic;
      Sl2_CE : out std_logic;
      LMB3_ABus : in std_logic_vector(0 to 31);
      LMB3_WriteDBus : in std_logic_vector(0 to 31);
      LMB3_AddrStrobe : in std_logic;
      LMB3_ReadStrobe : in std_logic;
      LMB3_WriteStrobe : in std_logic;
      LMB3_BE : in std_logic_vector(0 to 3);
      Sl3_DBus : out std_logic_vector(0 to 31);
      Sl3_Ready : out std_logic;
      Sl3_Wait : out std_logic;
      Sl3_UE : out std_logic;
      Sl3_CE : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31);
      Interrupt : out std_logic;
      UE : out std_logic;
      CE : out std_logic;
      SPLB_CTRL_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB_CTRL_PLB_PAValid : in std_logic;
      SPLB_CTRL_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB_CTRL_PLB_RNW : in std_logic;
      SPLB_CTRL_PLB_BE : in std_logic_vector(0 to 3);
      SPLB_CTRL_PLB_size : in std_logic_vector(0 to 3);
      SPLB_CTRL_PLB_type : in std_logic_vector(0 to 2);
      SPLB_CTRL_PLB_wrDBus : in std_logic_vector(0 to 31);
      SPLB_CTRL_Sl_addrAck : out std_logic;
      SPLB_CTRL_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB_CTRL_Sl_wait : out std_logic;
      SPLB_CTRL_Sl_rearbitrate : out std_logic;
      SPLB_CTRL_Sl_wrDAck : out std_logic;
      SPLB_CTRL_Sl_wrComp : out std_logic;
      SPLB_CTRL_Sl_rdDBus : out std_logic_vector(0 to 31);
      SPLB_CTRL_Sl_rdDAck : out std_logic;
      SPLB_CTRL_Sl_rdComp : out std_logic;
      SPLB_CTRL_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB_CTRL_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB_CTRL_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB_CTRL_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB_CTRL_PLB_SAValid : in std_logic;
      SPLB_CTRL_PLB_rdPrim : in std_logic;
      SPLB_CTRL_PLB_wrPrim : in std_logic;
      SPLB_CTRL_PLB_abort : in std_logic;
      SPLB_CTRL_PLB_busLock : in std_logic;
      SPLB_CTRL_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_lockErr : in std_logic;
      SPLB_CTRL_PLB_wrBurst : in std_logic;
      SPLB_CTRL_PLB_rdBurst : in std_logic;
      SPLB_CTRL_PLB_wrPendReq : in std_logic;
      SPLB_CTRL_PLB_rdPendReq : in std_logic;
      SPLB_CTRL_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB_CTRL_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB_CTRL_Sl_wrBTerm : out std_logic;
      SPLB_CTRL_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB_CTRL_Sl_rdBTerm : out std_logic;
      SPLB_CTRL_Sl_MIRQ : out std_logic_vector(0 to 0);
      S_AXI_CTRL_ACLK : in std_logic;
      S_AXI_CTRL_ARESETN : in std_logic;
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic
    );
  end component;

  component mpu_microblaze_0_bram_block_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mpu_microblaze_0_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      INTERRUPT_ADDRESS : in std_logic_vector(0 to 31);
      INTERRUPT_ACK : out std_logic_vector(0 to 1);
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      MB_Error : out std_logic;
      WAKEUP : in std_logic_vector(0 to 1);
      SLEEP : out std_logic;
      DBG_WAKEUP : out std_logic;
      LOCKSTEP_MASTER_OUT : out std_logic_vector(0 to 4095);
      LOCKSTEP_SLAVE_IN : in std_logic_vector(0 to 4095);
      LOCKSTEP_OUT : out std_logic_vector(0 to 4095);
      INSTR : in std_logic_vector(0 to 31);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      ICE : in std_logic;
      IUE : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DCE : in std_logic;
      DUE : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      M_AXI_IP_AWID : out std_logic_vector(0 downto 0);
      M_AXI_IP_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_IP_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_IP_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_IP_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_IP_AWLOCK : out std_logic;
      M_AXI_IP_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_IP_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_IP_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_IP_AWVALID : out std_logic;
      M_AXI_IP_AWREADY : in std_logic;
      M_AXI_IP_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_IP_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_IP_WLAST : out std_logic;
      M_AXI_IP_WVALID : out std_logic;
      M_AXI_IP_WREADY : in std_logic;
      M_AXI_IP_BID : in std_logic_vector(0 downto 0);
      M_AXI_IP_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_IP_BVALID : in std_logic;
      M_AXI_IP_BREADY : out std_logic;
      M_AXI_IP_ARID : out std_logic_vector(0 downto 0);
      M_AXI_IP_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_IP_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_IP_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_IP_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_IP_ARLOCK : out std_logic;
      M_AXI_IP_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_IP_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_IP_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_IP_ARVALID : out std_logic;
      M_AXI_IP_ARREADY : in std_logic;
      M_AXI_IP_RID : in std_logic_vector(0 downto 0);
      M_AXI_IP_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_IP_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_IP_RLAST : in std_logic;
      M_AXI_IP_RVALID : in std_logic;
      M_AXI_IP_RREADY : out std_logic;
      M_AXI_DP_AWID : out std_logic_vector(0 downto 0);
      M_AXI_DP_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_DP_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_DP_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_DP_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_DP_AWLOCK : out std_logic;
      M_AXI_DP_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_DP_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_DP_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_DP_AWVALID : out std_logic;
      M_AXI_DP_AWREADY : in std_logic;
      M_AXI_DP_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_DP_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_DP_WLAST : out std_logic;
      M_AXI_DP_WVALID : out std_logic;
      M_AXI_DP_WREADY : in std_logic;
      M_AXI_DP_BID : in std_logic_vector(0 downto 0);
      M_AXI_DP_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_DP_BVALID : in std_logic;
      M_AXI_DP_BREADY : out std_logic;
      M_AXI_DP_ARID : out std_logic_vector(0 downto 0);
      M_AXI_DP_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_DP_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_DP_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_DP_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_DP_ARLOCK : out std_logic;
      M_AXI_DP_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_DP_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_DP_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_DP_ARVALID : out std_logic;
      M_AXI_DP_ARREADY : in std_logic;
      M_AXI_DP_RID : in std_logic_vector(0 downto 0);
      M_AXI_DP_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_DP_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_DP_RLAST : in std_logic;
      M_AXI_DP_RVALID : in std_logic;
      M_AXI_DP_RREADY : out std_logic;
      M_AXI_IC_AWID : out std_logic_vector(0 downto 0);
      M_AXI_IC_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_IC_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_IC_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_IC_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_IC_AWLOCK : out std_logic;
      M_AXI_IC_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_IC_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_IC_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_IC_AWVALID : out std_logic;
      M_AXI_IC_AWREADY : in std_logic;
      M_AXI_IC_AWUSER : out std_logic_vector(4 downto 0);
      M_AXI_IC_AWDOMAIN : out std_logic_vector(1 downto 0);
      M_AXI_IC_AWSNOOP : out std_logic_vector(2 downto 0);
      M_AXI_IC_AWBAR : out std_logic_vector(1 downto 0);
      M_AXI_IC_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_IC_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_IC_WLAST : out std_logic;
      M_AXI_IC_WVALID : out std_logic;
      M_AXI_IC_WREADY : in std_logic;
      M_AXI_IC_WUSER : out std_logic_vector(0 downto 0);
      M_AXI_IC_BID : in std_logic_vector(0 downto 0);
      M_AXI_IC_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_IC_BVALID : in std_logic;
      M_AXI_IC_BREADY : out std_logic;
      M_AXI_IC_BUSER : in std_logic_vector(0 downto 0);
      M_AXI_IC_WACK : out std_logic;
      M_AXI_IC_ARID : out std_logic_vector(0 downto 0);
      M_AXI_IC_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_IC_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_IC_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_IC_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_IC_ARLOCK : out std_logic;
      M_AXI_IC_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_IC_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_IC_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_IC_ARVALID : out std_logic;
      M_AXI_IC_ARREADY : in std_logic;
      M_AXI_IC_ARUSER : out std_logic_vector(4 downto 0);
      M_AXI_IC_ARDOMAIN : out std_logic_vector(1 downto 0);
      M_AXI_IC_ARSNOOP : out std_logic_vector(3 downto 0);
      M_AXI_IC_ARBAR : out std_logic_vector(1 downto 0);
      M_AXI_IC_RID : in std_logic_vector(0 downto 0);
      M_AXI_IC_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_IC_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_IC_RLAST : in std_logic;
      M_AXI_IC_RVALID : in std_logic;
      M_AXI_IC_RREADY : out std_logic;
      M_AXI_IC_RUSER : in std_logic_vector(0 downto 0);
      M_AXI_IC_RACK : out std_logic;
      M_AXI_IC_ACVALID : in std_logic;
      M_AXI_IC_ACADDR : in std_logic_vector(31 downto 0);
      M_AXI_IC_ACSNOOP : in std_logic_vector(3 downto 0);
      M_AXI_IC_ACPROT : in std_logic_vector(2 downto 0);
      M_AXI_IC_ACREADY : out std_logic;
      M_AXI_IC_CRREADY : in std_logic;
      M_AXI_IC_CRVALID : out std_logic;
      M_AXI_IC_CRRESP : out std_logic_vector(4 downto 0);
      M_AXI_IC_CDVALID : out std_logic;
      M_AXI_IC_CDREADY : in std_logic;
      M_AXI_IC_CDDATA : out std_logic_vector(31 downto 0);
      M_AXI_IC_CDLAST : out std_logic;
      M_AXI_DC_AWID : out std_logic_vector(0 downto 0);
      M_AXI_DC_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_DC_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_DC_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_DC_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_DC_AWLOCK : out std_logic;
      M_AXI_DC_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_DC_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_DC_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_DC_AWVALID : out std_logic;
      M_AXI_DC_AWREADY : in std_logic;
      M_AXI_DC_AWUSER : out std_logic_vector(4 downto 0);
      M_AXI_DC_AWDOMAIN : out std_logic_vector(1 downto 0);
      M_AXI_DC_AWSNOOP : out std_logic_vector(2 downto 0);
      M_AXI_DC_AWBAR : out std_logic_vector(1 downto 0);
      M_AXI_DC_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_DC_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_DC_WLAST : out std_logic;
      M_AXI_DC_WVALID : out std_logic;
      M_AXI_DC_WREADY : in std_logic;
      M_AXI_DC_WUSER : out std_logic_vector(0 downto 0);
      M_AXI_DC_BID : in std_logic_vector(0 downto 0);
      M_AXI_DC_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_DC_BVALID : in std_logic;
      M_AXI_DC_BREADY : out std_logic;
      M_AXI_DC_BUSER : in std_logic_vector(0 downto 0);
      M_AXI_DC_WACK : out std_logic;
      M_AXI_DC_ARID : out std_logic_vector(0 downto 0);
      M_AXI_DC_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_DC_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_DC_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_DC_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_DC_ARLOCK : out std_logic;
      M_AXI_DC_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_DC_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_DC_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_DC_ARVALID : out std_logic;
      M_AXI_DC_ARREADY : in std_logic;
      M_AXI_DC_ARUSER : out std_logic_vector(4 downto 0);
      M_AXI_DC_ARDOMAIN : out std_logic_vector(1 downto 0);
      M_AXI_DC_ARSNOOP : out std_logic_vector(3 downto 0);
      M_AXI_DC_ARBAR : out std_logic_vector(1 downto 0);
      M_AXI_DC_RID : in std_logic_vector(0 downto 0);
      M_AXI_DC_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_DC_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_DC_RLAST : in std_logic;
      M_AXI_DC_RVALID : in std_logic;
      M_AXI_DC_RREADY : out std_logic;
      M_AXI_DC_RUSER : in std_logic_vector(0 downto 0);
      M_AXI_DC_RACK : out std_logic;
      M_AXI_DC_ACVALID : in std_logic;
      M_AXI_DC_ACADDR : in std_logic_vector(31 downto 0);
      M_AXI_DC_ACSNOOP : in std_logic_vector(3 downto 0);
      M_AXI_DC_ACPROT : in std_logic_vector(2 downto 0);
      M_AXI_DC_ACREADY : out std_logic;
      M_AXI_DC_CRREADY : in std_logic;
      M_AXI_DC_CRVALID : out std_logic;
      M_AXI_DC_CRRESP : out std_logic_vector(4 downto 0);
      M_AXI_DC_CDVALID : out std_logic;
      M_AXI_DC_CDREADY : in std_logic;
      M_AXI_DC_CDDATA : out std_logic_vector(31 downto 0);
      M_AXI_DC_CDLAST : out std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 7);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_DCache_Rdy : out std_logic;
      Trace_DCache_Read : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_ICache_Rdy : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      Trace_Jump_Hit : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      M0_AXIS_TLAST : out std_logic;
      M0_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M0_AXIS_TVALID : out std_logic;
      M0_AXIS_TREADY : in std_logic;
      S0_AXIS_TLAST : in std_logic;
      S0_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S0_AXIS_TVALID : in std_logic;
      S0_AXIS_TREADY : out std_logic;
      M1_AXIS_TLAST : out std_logic;
      M1_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M1_AXIS_TVALID : out std_logic;
      M1_AXIS_TREADY : in std_logic;
      S1_AXIS_TLAST : in std_logic;
      S1_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S1_AXIS_TVALID : in std_logic;
      S1_AXIS_TREADY : out std_logic;
      M2_AXIS_TLAST : out std_logic;
      M2_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M2_AXIS_TVALID : out std_logic;
      M2_AXIS_TREADY : in std_logic;
      S2_AXIS_TLAST : in std_logic;
      S2_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S2_AXIS_TVALID : in std_logic;
      S2_AXIS_TREADY : out std_logic;
      M3_AXIS_TLAST : out std_logic;
      M3_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M3_AXIS_TVALID : out std_logic;
      M3_AXIS_TREADY : in std_logic;
      S3_AXIS_TLAST : in std_logic;
      S3_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S3_AXIS_TVALID : in std_logic;
      S3_AXIS_TREADY : out std_logic;
      M4_AXIS_TLAST : out std_logic;
      M4_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M4_AXIS_TVALID : out std_logic;
      M4_AXIS_TREADY : in std_logic;
      S4_AXIS_TLAST : in std_logic;
      S4_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S4_AXIS_TVALID : in std_logic;
      S4_AXIS_TREADY : out std_logic;
      M5_AXIS_TLAST : out std_logic;
      M5_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M5_AXIS_TVALID : out std_logic;
      M5_AXIS_TREADY : in std_logic;
      S5_AXIS_TLAST : in std_logic;
      S5_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S5_AXIS_TVALID : in std_logic;
      S5_AXIS_TREADY : out std_logic;
      M6_AXIS_TLAST : out std_logic;
      M6_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M6_AXIS_TVALID : out std_logic;
      M6_AXIS_TREADY : in std_logic;
      S6_AXIS_TLAST : in std_logic;
      S6_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S6_AXIS_TVALID : in std_logic;
      S6_AXIS_TREADY : out std_logic;
      M7_AXIS_TLAST : out std_logic;
      M7_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M7_AXIS_TVALID : out std_logic;
      M7_AXIS_TREADY : in std_logic;
      S7_AXIS_TLAST : in std_logic;
      S7_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S7_AXIS_TVALID : in std_logic;
      S7_AXIS_TREADY : out std_logic;
      M8_AXIS_TLAST : out std_logic;
      M8_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M8_AXIS_TVALID : out std_logic;
      M8_AXIS_TREADY : in std_logic;
      S8_AXIS_TLAST : in std_logic;
      S8_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S8_AXIS_TVALID : in std_logic;
      S8_AXIS_TREADY : out std_logic;
      M9_AXIS_TLAST : out std_logic;
      M9_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M9_AXIS_TVALID : out std_logic;
      M9_AXIS_TREADY : in std_logic;
      S9_AXIS_TLAST : in std_logic;
      S9_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S9_AXIS_TVALID : in std_logic;
      S9_AXIS_TREADY : out std_logic;
      M10_AXIS_TLAST : out std_logic;
      M10_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M10_AXIS_TVALID : out std_logic;
      M10_AXIS_TREADY : in std_logic;
      S10_AXIS_TLAST : in std_logic;
      S10_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S10_AXIS_TVALID : in std_logic;
      S10_AXIS_TREADY : out std_logic;
      M11_AXIS_TLAST : out std_logic;
      M11_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M11_AXIS_TVALID : out std_logic;
      M11_AXIS_TREADY : in std_logic;
      S11_AXIS_TLAST : in std_logic;
      S11_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S11_AXIS_TVALID : in std_logic;
      S11_AXIS_TREADY : out std_logic;
      M12_AXIS_TLAST : out std_logic;
      M12_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M12_AXIS_TVALID : out std_logic;
      M12_AXIS_TREADY : in std_logic;
      S12_AXIS_TLAST : in std_logic;
      S12_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S12_AXIS_TVALID : in std_logic;
      S12_AXIS_TREADY : out std_logic;
      M13_AXIS_TLAST : out std_logic;
      M13_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M13_AXIS_TVALID : out std_logic;
      M13_AXIS_TREADY : in std_logic;
      S13_AXIS_TLAST : in std_logic;
      S13_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S13_AXIS_TVALID : in std_logic;
      S13_AXIS_TREADY : out std_logic;
      M14_AXIS_TLAST : out std_logic;
      M14_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M14_AXIS_TVALID : out std_logic;
      M14_AXIS_TREADY : in std_logic;
      S14_AXIS_TLAST : in std_logic;
      S14_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S14_AXIS_TVALID : in std_logic;
      S14_AXIS_TREADY : out std_logic;
      M15_AXIS_TLAST : out std_logic;
      M15_AXIS_TDATA : out std_logic_vector(31 downto 0);
      M15_AXIS_TVALID : out std_logic;
      M15_AXIS_TREADY : in std_logic;
      S15_AXIS_TLAST : in std_logic;
      S15_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S15_AXIS_TVALID : in std_logic;
      S15_AXIS_TREADY : out std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mpu_iomodule_0_wrapper is
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
  end component;

  component mpu_ideal_data_in_out_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_ideal_address_we_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(13 downto 0);
      GPIO_IO_O : out std_logic_vector(13 downto 0);
      GPIO_IO_T : out std_logic_vector(13 downto 0);
      GPIO2_IO_I : in std_logic_vector(0 downto 0);
      GPIO2_IO_O : out std_logic_vector(0 downto 0);
      GPIO2_IO_T : out std_logic_vector(0 downto 0)
    );
  end component;

  component mpu_error_x21_x22_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_x12_x20_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_x10_x11_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_x01_x02_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_u22_x00_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_u20_u21_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_u11_u12_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_u02_u10_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_u00_u01_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_error_i_base_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(31 downto 0);
      GPIO_IO_O : out std_logic_vector(31 downto 0);
      GPIO_IO_T : out std_logic_vector(31 downto 0);
      GPIO2_IO_I : in std_logic_vector(31 downto 0);
      GPIO2_IO_O : out std_logic_vector(31 downto 0);
      GPIO2_IO_T : out std_logic_vector(31 downto 0)
    );
  end component;

  component mpu_debug_module_wrapper is
    port (
      Interrupt : out std_logic;
      Debug_SYS_Rst : out std_logic;
      Ext_BRK : out std_logic;
      Ext_NM_BRK : out std_logic;
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      Dbg_Clk_0 : out std_logic;
      Dbg_TDI_0 : out std_logic;
      Dbg_TDO_0 : in std_logic;
      Dbg_Reg_En_0 : out std_logic_vector(0 to 7);
      Dbg_Capture_0 : out std_logic;
      Dbg_Shift_0 : out std_logic;
      Dbg_Update_0 : out std_logic;
      Dbg_Rst_0 : out std_logic;
      Dbg_Clk_1 : out std_logic;
      Dbg_TDI_1 : out std_logic;
      Dbg_TDO_1 : in std_logic;
      Dbg_Reg_En_1 : out std_logic_vector(0 to 7);
      Dbg_Capture_1 : out std_logic;
      Dbg_Shift_1 : out std_logic;
      Dbg_Update_1 : out std_logic;
      Dbg_Rst_1 : out std_logic;
      Dbg_Clk_2 : out std_logic;
      Dbg_TDI_2 : out std_logic;
      Dbg_TDO_2 : in std_logic;
      Dbg_Reg_En_2 : out std_logic_vector(0 to 7);
      Dbg_Capture_2 : out std_logic;
      Dbg_Shift_2 : out std_logic;
      Dbg_Update_2 : out std_logic;
      Dbg_Rst_2 : out std_logic;
      Dbg_Clk_3 : out std_logic;
      Dbg_TDI_3 : out std_logic;
      Dbg_TDO_3 : in std_logic;
      Dbg_Reg_En_3 : out std_logic_vector(0 to 7);
      Dbg_Capture_3 : out std_logic;
      Dbg_Shift_3 : out std_logic;
      Dbg_Update_3 : out std_logic;
      Dbg_Rst_3 : out std_logic;
      Dbg_Clk_4 : out std_logic;
      Dbg_TDI_4 : out std_logic;
      Dbg_TDO_4 : in std_logic;
      Dbg_Reg_En_4 : out std_logic_vector(0 to 7);
      Dbg_Capture_4 : out std_logic;
      Dbg_Shift_4 : out std_logic;
      Dbg_Update_4 : out std_logic;
      Dbg_Rst_4 : out std_logic;
      Dbg_Clk_5 : out std_logic;
      Dbg_TDI_5 : out std_logic;
      Dbg_TDO_5 : in std_logic;
      Dbg_Reg_En_5 : out std_logic_vector(0 to 7);
      Dbg_Capture_5 : out std_logic;
      Dbg_Shift_5 : out std_logic;
      Dbg_Update_5 : out std_logic;
      Dbg_Rst_5 : out std_logic;
      Dbg_Clk_6 : out std_logic;
      Dbg_TDI_6 : out std_logic;
      Dbg_TDO_6 : in std_logic;
      Dbg_Reg_En_6 : out std_logic_vector(0 to 7);
      Dbg_Capture_6 : out std_logic;
      Dbg_Shift_6 : out std_logic;
      Dbg_Update_6 : out std_logic;
      Dbg_Rst_6 : out std_logic;
      Dbg_Clk_7 : out std_logic;
      Dbg_TDI_7 : out std_logic;
      Dbg_TDO_7 : in std_logic;
      Dbg_Reg_En_7 : out std_logic_vector(0 to 7);
      Dbg_Capture_7 : out std_logic;
      Dbg_Shift_7 : out std_logic;
      Dbg_Update_7 : out std_logic;
      Dbg_Rst_7 : out std_logic;
      Dbg_Clk_8 : out std_logic;
      Dbg_TDI_8 : out std_logic;
      Dbg_TDO_8 : in std_logic;
      Dbg_Reg_En_8 : out std_logic_vector(0 to 7);
      Dbg_Capture_8 : out std_logic;
      Dbg_Shift_8 : out std_logic;
      Dbg_Update_8 : out std_logic;
      Dbg_Rst_8 : out std_logic;
      Dbg_Clk_9 : out std_logic;
      Dbg_TDI_9 : out std_logic;
      Dbg_TDO_9 : in std_logic;
      Dbg_Reg_En_9 : out std_logic_vector(0 to 7);
      Dbg_Capture_9 : out std_logic;
      Dbg_Shift_9 : out std_logic;
      Dbg_Update_9 : out std_logic;
      Dbg_Rst_9 : out std_logic;
      Dbg_Clk_10 : out std_logic;
      Dbg_TDI_10 : out std_logic;
      Dbg_TDO_10 : in std_logic;
      Dbg_Reg_En_10 : out std_logic_vector(0 to 7);
      Dbg_Capture_10 : out std_logic;
      Dbg_Shift_10 : out std_logic;
      Dbg_Update_10 : out std_logic;
      Dbg_Rst_10 : out std_logic;
      Dbg_Clk_11 : out std_logic;
      Dbg_TDI_11 : out std_logic;
      Dbg_TDO_11 : in std_logic;
      Dbg_Reg_En_11 : out std_logic_vector(0 to 7);
      Dbg_Capture_11 : out std_logic;
      Dbg_Shift_11 : out std_logic;
      Dbg_Update_11 : out std_logic;
      Dbg_Rst_11 : out std_logic;
      Dbg_Clk_12 : out std_logic;
      Dbg_TDI_12 : out std_logic;
      Dbg_TDO_12 : in std_logic;
      Dbg_Reg_En_12 : out std_logic_vector(0 to 7);
      Dbg_Capture_12 : out std_logic;
      Dbg_Shift_12 : out std_logic;
      Dbg_Update_12 : out std_logic;
      Dbg_Rst_12 : out std_logic;
      Dbg_Clk_13 : out std_logic;
      Dbg_TDI_13 : out std_logic;
      Dbg_TDO_13 : in std_logic;
      Dbg_Reg_En_13 : out std_logic_vector(0 to 7);
      Dbg_Capture_13 : out std_logic;
      Dbg_Shift_13 : out std_logic;
      Dbg_Update_13 : out std_logic;
      Dbg_Rst_13 : out std_logic;
      Dbg_Clk_14 : out std_logic;
      Dbg_TDI_14 : out std_logic;
      Dbg_TDO_14 : in std_logic;
      Dbg_Reg_En_14 : out std_logic_vector(0 to 7);
      Dbg_Capture_14 : out std_logic;
      Dbg_Shift_14 : out std_logic;
      Dbg_Update_14 : out std_logic;
      Dbg_Rst_14 : out std_logic;
      Dbg_Clk_15 : out std_logic;
      Dbg_TDI_15 : out std_logic;
      Dbg_TDO_15 : in std_logic;
      Dbg_Reg_En_15 : out std_logic_vector(0 to 7);
      Dbg_Capture_15 : out std_logic;
      Dbg_Shift_15 : out std_logic;
      Dbg_Update_15 : out std_logic;
      Dbg_Rst_15 : out std_logic;
      Dbg_Clk_16 : out std_logic;
      Dbg_TDI_16 : out std_logic;
      Dbg_TDO_16 : in std_logic;
      Dbg_Reg_En_16 : out std_logic_vector(0 to 7);
      Dbg_Capture_16 : out std_logic;
      Dbg_Shift_16 : out std_logic;
      Dbg_Update_16 : out std_logic;
      Dbg_Rst_16 : out std_logic;
      Dbg_Clk_17 : out std_logic;
      Dbg_TDI_17 : out std_logic;
      Dbg_TDO_17 : in std_logic;
      Dbg_Reg_En_17 : out std_logic_vector(0 to 7);
      Dbg_Capture_17 : out std_logic;
      Dbg_Shift_17 : out std_logic;
      Dbg_Update_17 : out std_logic;
      Dbg_Rst_17 : out std_logic;
      Dbg_Clk_18 : out std_logic;
      Dbg_TDI_18 : out std_logic;
      Dbg_TDO_18 : in std_logic;
      Dbg_Reg_En_18 : out std_logic_vector(0 to 7);
      Dbg_Capture_18 : out std_logic;
      Dbg_Shift_18 : out std_logic;
      Dbg_Update_18 : out std_logic;
      Dbg_Rst_18 : out std_logic;
      Dbg_Clk_19 : out std_logic;
      Dbg_TDI_19 : out std_logic;
      Dbg_TDO_19 : in std_logic;
      Dbg_Reg_En_19 : out std_logic_vector(0 to 7);
      Dbg_Capture_19 : out std_logic;
      Dbg_Shift_19 : out std_logic;
      Dbg_Update_19 : out std_logic;
      Dbg_Rst_19 : out std_logic;
      Dbg_Clk_20 : out std_logic;
      Dbg_TDI_20 : out std_logic;
      Dbg_TDO_20 : in std_logic;
      Dbg_Reg_En_20 : out std_logic_vector(0 to 7);
      Dbg_Capture_20 : out std_logic;
      Dbg_Shift_20 : out std_logic;
      Dbg_Update_20 : out std_logic;
      Dbg_Rst_20 : out std_logic;
      Dbg_Clk_21 : out std_logic;
      Dbg_TDI_21 : out std_logic;
      Dbg_TDO_21 : in std_logic;
      Dbg_Reg_En_21 : out std_logic_vector(0 to 7);
      Dbg_Capture_21 : out std_logic;
      Dbg_Shift_21 : out std_logic;
      Dbg_Update_21 : out std_logic;
      Dbg_Rst_21 : out std_logic;
      Dbg_Clk_22 : out std_logic;
      Dbg_TDI_22 : out std_logic;
      Dbg_TDO_22 : in std_logic;
      Dbg_Reg_En_22 : out std_logic_vector(0 to 7);
      Dbg_Capture_22 : out std_logic;
      Dbg_Shift_22 : out std_logic;
      Dbg_Update_22 : out std_logic;
      Dbg_Rst_22 : out std_logic;
      Dbg_Clk_23 : out std_logic;
      Dbg_TDI_23 : out std_logic;
      Dbg_TDO_23 : in std_logic;
      Dbg_Reg_En_23 : out std_logic_vector(0 to 7);
      Dbg_Capture_23 : out std_logic;
      Dbg_Shift_23 : out std_logic;
      Dbg_Update_23 : out std_logic;
      Dbg_Rst_23 : out std_logic;
      Dbg_Clk_24 : out std_logic;
      Dbg_TDI_24 : out std_logic;
      Dbg_TDO_24 : in std_logic;
      Dbg_Reg_En_24 : out std_logic_vector(0 to 7);
      Dbg_Capture_24 : out std_logic;
      Dbg_Shift_24 : out std_logic;
      Dbg_Update_24 : out std_logic;
      Dbg_Rst_24 : out std_logic;
      Dbg_Clk_25 : out std_logic;
      Dbg_TDI_25 : out std_logic;
      Dbg_TDO_25 : in std_logic;
      Dbg_Reg_En_25 : out std_logic_vector(0 to 7);
      Dbg_Capture_25 : out std_logic;
      Dbg_Shift_25 : out std_logic;
      Dbg_Update_25 : out std_logic;
      Dbg_Rst_25 : out std_logic;
      Dbg_Clk_26 : out std_logic;
      Dbg_TDI_26 : out std_logic;
      Dbg_TDO_26 : in std_logic;
      Dbg_Reg_En_26 : out std_logic_vector(0 to 7);
      Dbg_Capture_26 : out std_logic;
      Dbg_Shift_26 : out std_logic;
      Dbg_Update_26 : out std_logic;
      Dbg_Rst_26 : out std_logic;
      Dbg_Clk_27 : out std_logic;
      Dbg_TDI_27 : out std_logic;
      Dbg_TDO_27 : in std_logic;
      Dbg_Reg_En_27 : out std_logic_vector(0 to 7);
      Dbg_Capture_27 : out std_logic;
      Dbg_Shift_27 : out std_logic;
      Dbg_Update_27 : out std_logic;
      Dbg_Rst_27 : out std_logic;
      Dbg_Clk_28 : out std_logic;
      Dbg_TDI_28 : out std_logic;
      Dbg_TDO_28 : in std_logic;
      Dbg_Reg_En_28 : out std_logic_vector(0 to 7);
      Dbg_Capture_28 : out std_logic;
      Dbg_Shift_28 : out std_logic;
      Dbg_Update_28 : out std_logic;
      Dbg_Rst_28 : out std_logic;
      Dbg_Clk_29 : out std_logic;
      Dbg_TDI_29 : out std_logic;
      Dbg_TDO_29 : in std_logic;
      Dbg_Reg_En_29 : out std_logic_vector(0 to 7);
      Dbg_Capture_29 : out std_logic;
      Dbg_Shift_29 : out std_logic;
      Dbg_Update_29 : out std_logic;
      Dbg_Rst_29 : out std_logic;
      Dbg_Clk_30 : out std_logic;
      Dbg_TDI_30 : out std_logic;
      Dbg_TDO_30 : in std_logic;
      Dbg_Reg_En_30 : out std_logic_vector(0 to 7);
      Dbg_Capture_30 : out std_logic;
      Dbg_Shift_30 : out std_logic;
      Dbg_Update_30 : out std_logic;
      Dbg_Rst_30 : out std_logic;
      Dbg_Clk_31 : out std_logic;
      Dbg_TDI_31 : out std_logic;
      Dbg_TDO_31 : in std_logic;
      Dbg_Reg_En_31 : out std_logic_vector(0 to 7);
      Dbg_Capture_31 : out std_logic;
      Dbg_Shift_31 : out std_logic;
      Dbg_Update_31 : out std_logic;
      Dbg_Rst_31 : out std_logic;
      bscan_tdi : out std_logic;
      bscan_reset : out std_logic;
      bscan_shift : out std_logic;
      bscan_update : out std_logic;
      bscan_capture : out std_logic;
      bscan_sel1 : out std_logic;
      bscan_drck1 : out std_logic;
      bscan_tdo1 : in std_logic;
      bscan_ext_tdi : in std_logic;
      bscan_ext_reset : in std_logic;
      bscan_ext_shift : in std_logic;
      bscan_ext_update : in std_logic;
      bscan_ext_capture : in std_logic;
      bscan_ext_sel : in std_logic;
      bscan_ext_drck : in std_logic;
      bscan_ext_tdo : out std_logic;
      Ext_JTAG_DRCK : out std_logic;
      Ext_JTAG_RESET : out std_logic;
      Ext_JTAG_SEL : out std_logic;
      Ext_JTAG_CAPTURE : out std_logic;
      Ext_JTAG_SHIFT : out std_logic;
      Ext_JTAG_UPDATE : out std_logic;
      Ext_JTAG_TDI : out std_logic;
      Ext_JTAG_TDO : in std_logic
    );
  end component;

  component mpu_clock_generator_0_wrapper is
    port (
      CLKIN : in std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUT6 : out std_logic;
      CLKOUT7 : out std_logic;
      CLKOUT8 : out std_logic;
      CLKOUT9 : out std_logic;
      CLKOUT10 : out std_logic;
      CLKOUT11 : out std_logic;
      CLKOUT12 : out std_logic;
      CLKOUT13 : out std_logic;
      CLKOUT14 : out std_logic;
      CLKOUT15 : out std_logic;
      CLKFBIN : in std_logic;
      CLKFBOUT : out std_logic;
      PSCLK : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSDONE : out std_logic;
      RST : in std_logic;
      LOCKED : out std_logic
    );
  end component;

  component mpu_axi_interconnect_2_wrapper is
    port (
      INTERCONNECT_ACLK : in std_logic;
      INTERCONNECT_ARESETN : in std_logic;
      S_AXI_ARESET_OUT_N : out std_logic_vector(0 to 0);
      M_AXI_ARESET_OUT_N : out std_logic_vector(10 downto 0);
      IRQ : out std_logic;
      S_AXI_ACLK : in std_logic_vector(0 to 0);
      S_AXI_AWID : in std_logic_vector(0 to 0);
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWQOS : in std_logic_vector(3 downto 0);
      S_AXI_AWUSER : in std_logic_vector(0 to 0);
      S_AXI_AWVALID : in std_logic_vector(0 to 0);
      S_AXI_AWREADY : out std_logic_vector(0 to 0);
      S_AXI_WID : in std_logic_vector(0 to 0);
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic_vector(0 to 0);
      S_AXI_WUSER : in std_logic_vector(0 to 0);
      S_AXI_WVALID : in std_logic_vector(0 to 0);
      S_AXI_WREADY : out std_logic_vector(0 to 0);
      S_AXI_BID : out std_logic_vector(0 to 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BUSER : out std_logic_vector(0 to 0);
      S_AXI_BVALID : out std_logic_vector(0 to 0);
      S_AXI_BREADY : in std_logic_vector(0 to 0);
      S_AXI_ARID : in std_logic_vector(0 to 0);
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARQOS : in std_logic_vector(3 downto 0);
      S_AXI_ARUSER : in std_logic_vector(0 to 0);
      S_AXI_ARVALID : in std_logic_vector(0 to 0);
      S_AXI_ARREADY : out std_logic_vector(0 to 0);
      S_AXI_RID : out std_logic_vector(0 to 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic_vector(0 to 0);
      S_AXI_RUSER : out std_logic_vector(0 to 0);
      S_AXI_RVALID : out std_logic_vector(0 to 0);
      S_AXI_RREADY : in std_logic_vector(0 to 0);
      M_AXI_ACLK : in std_logic_vector(10 downto 0);
      M_AXI_AWID : out std_logic_vector(10 downto 0);
      M_AXI_AWADDR : out std_logic_vector(351 downto 0);
      M_AXI_AWLEN : out std_logic_vector(87 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(32 downto 0);
      M_AXI_AWBURST : out std_logic_vector(21 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(21 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(43 downto 0);
      M_AXI_AWPROT : out std_logic_vector(32 downto 0);
      M_AXI_AWREGION : out std_logic_vector(43 downto 0);
      M_AXI_AWQOS : out std_logic_vector(43 downto 0);
      M_AXI_AWUSER : out std_logic_vector(10 downto 0);
      M_AXI_AWVALID : out std_logic_vector(10 downto 0);
      M_AXI_AWREADY : in std_logic_vector(10 downto 0);
      M_AXI_WID : out std_logic_vector(10 downto 0);
      M_AXI_WDATA : out std_logic_vector(351 downto 0);
      M_AXI_WSTRB : out std_logic_vector(43 downto 0);
      M_AXI_WLAST : out std_logic_vector(10 downto 0);
      M_AXI_WUSER : out std_logic_vector(10 downto 0);
      M_AXI_WVALID : out std_logic_vector(10 downto 0);
      M_AXI_WREADY : in std_logic_vector(10 downto 0);
      M_AXI_BID : in std_logic_vector(10 downto 0);
      M_AXI_BRESP : in std_logic_vector(21 downto 0);
      M_AXI_BUSER : in std_logic_vector(10 downto 0);
      M_AXI_BVALID : in std_logic_vector(10 downto 0);
      M_AXI_BREADY : out std_logic_vector(10 downto 0);
      M_AXI_ARID : out std_logic_vector(10 downto 0);
      M_AXI_ARADDR : out std_logic_vector(351 downto 0);
      M_AXI_ARLEN : out std_logic_vector(87 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(32 downto 0);
      M_AXI_ARBURST : out std_logic_vector(21 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(21 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(43 downto 0);
      M_AXI_ARPROT : out std_logic_vector(32 downto 0);
      M_AXI_ARREGION : out std_logic_vector(43 downto 0);
      M_AXI_ARQOS : out std_logic_vector(43 downto 0);
      M_AXI_ARUSER : out std_logic_vector(10 downto 0);
      M_AXI_ARVALID : out std_logic_vector(10 downto 0);
      M_AXI_ARREADY : in std_logic_vector(10 downto 0);
      M_AXI_RID : in std_logic_vector(10 downto 0);
      M_AXI_RDATA : in std_logic_vector(351 downto 0);
      M_AXI_RRESP : in std_logic_vector(21 downto 0);
      M_AXI_RLAST : in std_logic_vector(10 downto 0);
      M_AXI_RUSER : in std_logic_vector(10 downto 0);
      M_AXI_RVALID : in std_logic_vector(10 downto 0);
      M_AXI_RREADY : out std_logic_vector(10 downto 0);
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic;
      INTERCONNECT_ARESET_OUT_N : out std_logic;
      DEBUG_AW_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AR_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AW_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AW_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AW_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AW_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AW_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AR_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AR_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AR_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AR_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_B_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_R_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_R_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_BID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_BID_ERROR : out std_logic;
      DEBUG_RID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_RID_ERROR : out std_logic;
      DEBUG_SR_SC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SR_SC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SR_SC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SC_SF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SC_SF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SC_SF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SF_CB_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SF_CB_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SF_CB_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_CB_MF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_CB_MF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_CB_MF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MF_MC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MF_MC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MF_MC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MC_MP_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MC_MP_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MC_MP_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MP_MR_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MP_MR_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MP_MR_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_WDATACONTROL : out std_logic_vector(6 downto 0)
    );
  end component;

  component mpu_axi_interconnect_1_wrapper is
    port (
      INTERCONNECT_ACLK : in std_logic;
      INTERCONNECT_ARESETN : in std_logic;
      S_AXI_ARESET_OUT_N : out std_logic_vector(0 to 0);
      M_AXI_ARESET_OUT_N : out std_logic_vector(5 downto 0);
      IRQ : out std_logic;
      S_AXI_ACLK : in std_logic_vector(0 to 0);
      S_AXI_AWID : in std_logic_vector(0 to 0);
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWQOS : in std_logic_vector(3 downto 0);
      S_AXI_AWUSER : in std_logic_vector(0 to 0);
      S_AXI_AWVALID : in std_logic_vector(0 to 0);
      S_AXI_AWREADY : out std_logic_vector(0 to 0);
      S_AXI_WID : in std_logic_vector(0 to 0);
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic_vector(0 to 0);
      S_AXI_WUSER : in std_logic_vector(0 to 0);
      S_AXI_WVALID : in std_logic_vector(0 to 0);
      S_AXI_WREADY : out std_logic_vector(0 to 0);
      S_AXI_BID : out std_logic_vector(0 to 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BUSER : out std_logic_vector(0 to 0);
      S_AXI_BVALID : out std_logic_vector(0 to 0);
      S_AXI_BREADY : in std_logic_vector(0 to 0);
      S_AXI_ARID : in std_logic_vector(0 to 0);
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARQOS : in std_logic_vector(3 downto 0);
      S_AXI_ARUSER : in std_logic_vector(0 to 0);
      S_AXI_ARVALID : in std_logic_vector(0 to 0);
      S_AXI_ARREADY : out std_logic_vector(0 to 0);
      S_AXI_RID : out std_logic_vector(0 to 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic_vector(0 to 0);
      S_AXI_RUSER : out std_logic_vector(0 to 0);
      S_AXI_RVALID : out std_logic_vector(0 to 0);
      S_AXI_RREADY : in std_logic_vector(0 to 0);
      M_AXI_ACLK : in std_logic_vector(5 downto 0);
      M_AXI_AWID : out std_logic_vector(5 downto 0);
      M_AXI_AWADDR : out std_logic_vector(191 downto 0);
      M_AXI_AWLEN : out std_logic_vector(47 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(17 downto 0);
      M_AXI_AWBURST : out std_logic_vector(11 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(11 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(23 downto 0);
      M_AXI_AWPROT : out std_logic_vector(17 downto 0);
      M_AXI_AWREGION : out std_logic_vector(23 downto 0);
      M_AXI_AWQOS : out std_logic_vector(23 downto 0);
      M_AXI_AWUSER : out std_logic_vector(5 downto 0);
      M_AXI_AWVALID : out std_logic_vector(5 downto 0);
      M_AXI_AWREADY : in std_logic_vector(5 downto 0);
      M_AXI_WID : out std_logic_vector(5 downto 0);
      M_AXI_WDATA : out std_logic_vector(191 downto 0);
      M_AXI_WSTRB : out std_logic_vector(23 downto 0);
      M_AXI_WLAST : out std_logic_vector(5 downto 0);
      M_AXI_WUSER : out std_logic_vector(5 downto 0);
      M_AXI_WVALID : out std_logic_vector(5 downto 0);
      M_AXI_WREADY : in std_logic_vector(5 downto 0);
      M_AXI_BID : in std_logic_vector(5 downto 0);
      M_AXI_BRESP : in std_logic_vector(11 downto 0);
      M_AXI_BUSER : in std_logic_vector(5 downto 0);
      M_AXI_BVALID : in std_logic_vector(5 downto 0);
      M_AXI_BREADY : out std_logic_vector(5 downto 0);
      M_AXI_ARID : out std_logic_vector(5 downto 0);
      M_AXI_ARADDR : out std_logic_vector(191 downto 0);
      M_AXI_ARLEN : out std_logic_vector(47 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(17 downto 0);
      M_AXI_ARBURST : out std_logic_vector(11 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(11 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(23 downto 0);
      M_AXI_ARPROT : out std_logic_vector(17 downto 0);
      M_AXI_ARREGION : out std_logic_vector(23 downto 0);
      M_AXI_ARQOS : out std_logic_vector(23 downto 0);
      M_AXI_ARUSER : out std_logic_vector(5 downto 0);
      M_AXI_ARVALID : out std_logic_vector(5 downto 0);
      M_AXI_ARREADY : in std_logic_vector(5 downto 0);
      M_AXI_RID : in std_logic_vector(5 downto 0);
      M_AXI_RDATA : in std_logic_vector(191 downto 0);
      M_AXI_RRESP : in std_logic_vector(11 downto 0);
      M_AXI_RLAST : in std_logic_vector(5 downto 0);
      M_AXI_RUSER : in std_logic_vector(5 downto 0);
      M_AXI_RVALID : in std_logic_vector(5 downto 0);
      M_AXI_RREADY : out std_logic_vector(5 downto 0);
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic;
      INTERCONNECT_ARESET_OUT_N : out std_logic;
      DEBUG_AW_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AR_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AW_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AW_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AW_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AW_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AW_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AR_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AR_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AR_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AR_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_B_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_R_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_R_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_BID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_BID_ERROR : out std_logic;
      DEBUG_RID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_RID_ERROR : out std_logic;
      DEBUG_SR_SC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SR_SC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SR_SC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SC_SF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SC_SF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SC_SF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SF_CB_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SF_CB_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SF_CB_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_CB_MF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_CB_MF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_CB_MF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MF_MC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MF_MC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MF_MC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MC_MP_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MC_MP_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MC_MP_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MP_MR_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MP_MR_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MP_MR_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_WDATACONTROL : out std_logic_vector(6 downto 0)
    );
  end component;

  component mpu_template_xbnd_ubnd_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(15 downto 0);
      GPIO_IO_O : out std_logic_vector(15 downto 0);
      GPIO_IO_T : out std_logic_vector(15 downto 0);
      GPIO2_IO_I : in std_logic_vector(15 downto 0);
      GPIO2_IO_O : out std_logic_vector(15 downto 0);
      GPIO2_IO_T : out std_logic_vector(15 downto 0)
    );
  end component;

  component mpu_axi4lite_0_wrapper is
    port (
      INTERCONNECT_ACLK : in std_logic;
      INTERCONNECT_ARESETN : in std_logic;
      S_AXI_ARESET_OUT_N : out std_logic_vector(0 to 0);
      M_AXI_ARESET_OUT_N : out std_logic_vector(15 downto 0);
      IRQ : out std_logic;
      S_AXI_ACLK : in std_logic_vector(0 to 0);
      S_AXI_AWID : in std_logic_vector(0 to 0);
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWQOS : in std_logic_vector(3 downto 0);
      S_AXI_AWUSER : in std_logic_vector(0 to 0);
      S_AXI_AWVALID : in std_logic_vector(0 to 0);
      S_AXI_AWREADY : out std_logic_vector(0 to 0);
      S_AXI_WID : in std_logic_vector(0 to 0);
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic_vector(0 to 0);
      S_AXI_WUSER : in std_logic_vector(0 to 0);
      S_AXI_WVALID : in std_logic_vector(0 to 0);
      S_AXI_WREADY : out std_logic_vector(0 to 0);
      S_AXI_BID : out std_logic_vector(0 to 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BUSER : out std_logic_vector(0 to 0);
      S_AXI_BVALID : out std_logic_vector(0 to 0);
      S_AXI_BREADY : in std_logic_vector(0 to 0);
      S_AXI_ARID : in std_logic_vector(0 to 0);
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARQOS : in std_logic_vector(3 downto 0);
      S_AXI_ARUSER : in std_logic_vector(0 to 0);
      S_AXI_ARVALID : in std_logic_vector(0 to 0);
      S_AXI_ARREADY : out std_logic_vector(0 to 0);
      S_AXI_RID : out std_logic_vector(0 to 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic_vector(0 to 0);
      S_AXI_RUSER : out std_logic_vector(0 to 0);
      S_AXI_RVALID : out std_logic_vector(0 to 0);
      S_AXI_RREADY : in std_logic_vector(0 to 0);
      M_AXI_ACLK : in std_logic_vector(15 downto 0);
      M_AXI_AWID : out std_logic_vector(15 downto 0);
      M_AXI_AWADDR : out std_logic_vector(511 downto 0);
      M_AXI_AWLEN : out std_logic_vector(127 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(47 downto 0);
      M_AXI_AWBURST : out std_logic_vector(31 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(31 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(63 downto 0);
      M_AXI_AWPROT : out std_logic_vector(47 downto 0);
      M_AXI_AWREGION : out std_logic_vector(63 downto 0);
      M_AXI_AWQOS : out std_logic_vector(63 downto 0);
      M_AXI_AWUSER : out std_logic_vector(15 downto 0);
      M_AXI_AWVALID : out std_logic_vector(15 downto 0);
      M_AXI_AWREADY : in std_logic_vector(15 downto 0);
      M_AXI_WID : out std_logic_vector(15 downto 0);
      M_AXI_WDATA : out std_logic_vector(511 downto 0);
      M_AXI_WSTRB : out std_logic_vector(63 downto 0);
      M_AXI_WLAST : out std_logic_vector(15 downto 0);
      M_AXI_WUSER : out std_logic_vector(15 downto 0);
      M_AXI_WVALID : out std_logic_vector(15 downto 0);
      M_AXI_WREADY : in std_logic_vector(15 downto 0);
      M_AXI_BID : in std_logic_vector(15 downto 0);
      M_AXI_BRESP : in std_logic_vector(31 downto 0);
      M_AXI_BUSER : in std_logic_vector(15 downto 0);
      M_AXI_BVALID : in std_logic_vector(15 downto 0);
      M_AXI_BREADY : out std_logic_vector(15 downto 0);
      M_AXI_ARID : out std_logic_vector(15 downto 0);
      M_AXI_ARADDR : out std_logic_vector(511 downto 0);
      M_AXI_ARLEN : out std_logic_vector(127 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(47 downto 0);
      M_AXI_ARBURST : out std_logic_vector(31 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(31 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(63 downto 0);
      M_AXI_ARPROT : out std_logic_vector(47 downto 0);
      M_AXI_ARREGION : out std_logic_vector(63 downto 0);
      M_AXI_ARQOS : out std_logic_vector(63 downto 0);
      M_AXI_ARUSER : out std_logic_vector(15 downto 0);
      M_AXI_ARVALID : out std_logic_vector(15 downto 0);
      M_AXI_ARREADY : in std_logic_vector(15 downto 0);
      M_AXI_RID : in std_logic_vector(15 downto 0);
      M_AXI_RDATA : in std_logic_vector(511 downto 0);
      M_AXI_RRESP : in std_logic_vector(31 downto 0);
      M_AXI_RLAST : in std_logic_vector(15 downto 0);
      M_AXI_RUSER : in std_logic_vector(15 downto 0);
      M_AXI_RVALID : in std_logic_vector(15 downto 0);
      M_AXI_RREADY : out std_logic_vector(15 downto 0);
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic;
      INTERCONNECT_ARESET_OUT_N : out std_logic;
      DEBUG_AW_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AR_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AW_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AW_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AW_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AW_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AW_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AR_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AR_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AR_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AR_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_B_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_R_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_R_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_BID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_BID_ERROR : out std_logic;
      DEBUG_RID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_RID_ERROR : out std_logic;
      DEBUG_SR_SC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SR_SC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SR_SC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SC_SF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SC_SF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SC_SF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SF_CB_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SF_CB_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SF_CB_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_CB_MF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_CB_MF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_CB_MF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MF_MC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MF_MC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MF_MC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MC_MP_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MC_MP_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MC_MP_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MP_MR_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MP_MR_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MP_MR_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_WDATACONTROL : out std_logic_vector(6 downto 0)
    );
  end component;

  component mpu_axi4_0_wrapper is
    port (
      INTERCONNECT_ACLK : in std_logic;
      INTERCONNECT_ARESETN : in std_logic;
      S_AXI_ARESET_OUT_N : out std_logic_vector(1 downto 0);
      M_AXI_ARESET_OUT_N : out std_logic_vector(0 to 0);
      IRQ : out std_logic;
      S_AXI_ACLK : in std_logic_vector(1 downto 0);
      S_AXI_AWID : in std_logic_vector(1 downto 0);
      S_AXI_AWADDR : in std_logic_vector(63 downto 0);
      S_AXI_AWLEN : in std_logic_vector(15 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(5 downto 0);
      S_AXI_AWBURST : in std_logic_vector(3 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(3 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(7 downto 0);
      S_AXI_AWPROT : in std_logic_vector(5 downto 0);
      S_AXI_AWQOS : in std_logic_vector(7 downto 0);
      S_AXI_AWUSER : in std_logic_vector(9 downto 0);
      S_AXI_AWVALID : in std_logic_vector(1 downto 0);
      S_AXI_AWREADY : out std_logic_vector(1 downto 0);
      S_AXI_WID : in std_logic_vector(1 downto 0);
      S_AXI_WDATA : in std_logic_vector(63 downto 0);
      S_AXI_WSTRB : in std_logic_vector(7 downto 0);
      S_AXI_WLAST : in std_logic_vector(1 downto 0);
      S_AXI_WUSER : in std_logic_vector(1 downto 0);
      S_AXI_WVALID : in std_logic_vector(1 downto 0);
      S_AXI_WREADY : out std_logic_vector(1 downto 0);
      S_AXI_BID : out std_logic_vector(1 downto 0);
      S_AXI_BRESP : out std_logic_vector(3 downto 0);
      S_AXI_BUSER : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic_vector(1 downto 0);
      S_AXI_BREADY : in std_logic_vector(1 downto 0);
      S_AXI_ARID : in std_logic_vector(1 downto 0);
      S_AXI_ARADDR : in std_logic_vector(63 downto 0);
      S_AXI_ARLEN : in std_logic_vector(15 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(5 downto 0);
      S_AXI_ARBURST : in std_logic_vector(3 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(3 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(7 downto 0);
      S_AXI_ARPROT : in std_logic_vector(5 downto 0);
      S_AXI_ARQOS : in std_logic_vector(7 downto 0);
      S_AXI_ARUSER : in std_logic_vector(9 downto 0);
      S_AXI_ARVALID : in std_logic_vector(1 downto 0);
      S_AXI_ARREADY : out std_logic_vector(1 downto 0);
      S_AXI_RID : out std_logic_vector(1 downto 0);
      S_AXI_RDATA : out std_logic_vector(63 downto 0);
      S_AXI_RRESP : out std_logic_vector(3 downto 0);
      S_AXI_RLAST : out std_logic_vector(1 downto 0);
      S_AXI_RUSER : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic_vector(1 downto 0);
      S_AXI_RREADY : in std_logic_vector(1 downto 0);
      M_AXI_ACLK : in std_logic_vector(0 to 0);
      M_AXI_AWID : out std_logic_vector(0 to 0);
      M_AXI_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(1 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_AWREGION : out std_logic_vector(3 downto 0);
      M_AXI_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_AWUSER : out std_logic_vector(4 downto 0);
      M_AXI_AWVALID : out std_logic_vector(0 to 0);
      M_AXI_AWREADY : in std_logic_vector(0 to 0);
      M_AXI_WID : out std_logic_vector(0 to 0);
      M_AXI_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_WLAST : out std_logic_vector(0 to 0);
      M_AXI_WUSER : out std_logic_vector(0 to 0);
      M_AXI_WVALID : out std_logic_vector(0 to 0);
      M_AXI_WREADY : in std_logic_vector(0 to 0);
      M_AXI_BID : in std_logic_vector(0 to 0);
      M_AXI_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_BUSER : in std_logic_vector(0 to 0);
      M_AXI_BVALID : in std_logic_vector(0 to 0);
      M_AXI_BREADY : out std_logic_vector(0 to 0);
      M_AXI_ARID : out std_logic_vector(0 to 0);
      M_AXI_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(1 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_ARREGION : out std_logic_vector(3 downto 0);
      M_AXI_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_ARUSER : out std_logic_vector(4 downto 0);
      M_AXI_ARVALID : out std_logic_vector(0 to 0);
      M_AXI_ARREADY : in std_logic_vector(0 to 0);
      M_AXI_RID : in std_logic_vector(0 to 0);
      M_AXI_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_RLAST : in std_logic_vector(0 to 0);
      M_AXI_RUSER : in std_logic_vector(0 to 0);
      M_AXI_RVALID : in std_logic_vector(0 to 0);
      M_AXI_RREADY : out std_logic_vector(0 to 0);
      S_AXI_CTRL_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_AWVALID : in std_logic;
      S_AXI_CTRL_AWREADY : out std_logic;
      S_AXI_CTRL_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_WVALID : in std_logic;
      S_AXI_CTRL_WREADY : out std_logic;
      S_AXI_CTRL_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_BVALID : out std_logic;
      S_AXI_CTRL_BREADY : in std_logic;
      S_AXI_CTRL_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_CTRL_ARVALID : in std_logic;
      S_AXI_CTRL_ARREADY : out std_logic;
      S_AXI_CTRL_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_CTRL_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_CTRL_RVALID : out std_logic;
      S_AXI_CTRL_RREADY : in std_logic;
      INTERCONNECT_ARESET_OUT_N : out std_logic;
      DEBUG_AW_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AR_ARB_GRANT : out std_logic_vector(7 downto 0);
      DEBUG_AW_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AW_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AW_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AW_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AW_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AW_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_TRANS_QUAL : out std_logic_vector(0 to 0);
      DEBUG_AR_ACCEPT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_THREAD : out std_logic_vector(15 downto 0);
      DEBUG_AR_ACTIVE_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_AR_ACTIVE_REGION : out std_logic_vector(7 downto 0);
      DEBUG_AR_ERROR : out std_logic_vector(7 downto 0);
      DEBUG_AR_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_B_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_R_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_R_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_AW_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_AR_ISSUING_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_BEAT_CNT : out std_logic_vector(7 downto 0);
      DEBUG_W_TRANS_SEQ : out std_logic_vector(7 downto 0);
      DEBUG_BID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_BID_ERROR : out std_logic;
      DEBUG_RID_TARGET : out std_logic_vector(7 downto 0);
      DEBUG_RID_ERROR : out std_logic;
      DEBUG_SR_SC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SR_SC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SR_SC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SR_SC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SR_SC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SC_SF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SC_SF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SC_SF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SC_SF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SC_SF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_SF_CB_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_SF_CB_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_SF_CB_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_SF_CB_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_SF_CB_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_CB_MF_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_CB_MF_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_CB_MF_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_CB_MF_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_CB_MF_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MF_MC_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MF_MC_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MF_MC_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MF_MC_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MF_MC_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MC_MP_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MC_MP_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MC_MP_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MC_MP_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MC_MP_WDATACONTROL : out std_logic_vector(6 downto 0);
      DEBUG_MP_MR_ARADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_ARADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_AWADDR : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_AWADDRCONTROL : out std_logic_vector(23 downto 0);
      DEBUG_MP_MR_BRESP : out std_logic_vector(4 downto 0);
      DEBUG_MP_MR_RDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_RDATACONTROL : out std_logic_vector(5 downto 0);
      DEBUG_MP_MR_WDATA : out std_logic_vector(31 downto 0);
      DEBUG_MP_MR_WDATACONTROL : out std_logic_vector(6 downto 0)
    );
  end component;

  component mpu_axi2axi_connector_2_wrapper is
    port (
      ACLK : in std_logic;
      ARESETN : in std_logic;
      S_AXI_AWID : in std_logic_vector(0 to 0);
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWREGION : in std_logic_vector(3 downto 0);
      S_AXI_AWQOS : in std_logic_vector(3 downto 0);
      S_AXI_AWUSER : in std_logic_vector(0 to 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WID : in std_logic_vector(0 to 0);
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic;
      S_AXI_WUSER : in std_logic_vector(0 to 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BID : out std_logic_vector(0 to 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BUSER : out std_logic_vector(0 to 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARID : in std_logic_vector(0 to 0);
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARREGION : in std_logic_vector(3 downto 0);
      S_AXI_ARQOS : in std_logic_vector(3 downto 0);
      S_AXI_ARUSER : in std_logic_vector(0 to 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RID : out std_logic_vector(0 to 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic;
      S_AXI_RUSER : out std_logic_vector(0 to 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      M_AXI_AWID : out std_logic_vector(0 to 0);
      M_AXI_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(1 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_AWREGION : out std_logic_vector(3 downto 0);
      M_AXI_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_AWUSER : out std_logic_vector(0 to 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_WID : out std_logic_vector(0 to 0);
      M_AXI_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_WLAST : out std_logic;
      M_AXI_WUSER : out std_logic_vector(0 to 0);
      M_AXI_WVALID : out std_logic;
      M_AXI_WREADY : in std_logic;
      M_AXI_BID : in std_logic_vector(0 to 0);
      M_AXI_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_BUSER : in std_logic_vector(0 to 0);
      M_AXI_BVALID : in std_logic;
      M_AXI_BREADY : out std_logic;
      M_AXI_ARID : out std_logic_vector(0 to 0);
      M_AXI_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(1 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_ARREGION : out std_logic_vector(3 downto 0);
      M_AXI_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_ARUSER : out std_logic_vector(0 to 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_RID : in std_logic_vector(0 to 0);
      M_AXI_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_RLAST : in std_logic;
      M_AXI_RUSER : in std_logic_vector(0 to 0);
      M_AXI_RVALID : in std_logic;
      M_AXI_RREADY : out std_logic
    );
  end component;

  component mpu_axi2axi_connector_1_wrapper is
    port (
      ACLK : in std_logic;
      ARESETN : in std_logic;
      S_AXI_AWID : in std_logic_vector(0 to 0);
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWLOCK : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWREGION : in std_logic_vector(3 downto 0);
      S_AXI_AWQOS : in std_logic_vector(3 downto 0);
      S_AXI_AWUSER : in std_logic_vector(0 to 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WID : in std_logic_vector(0 to 0);
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic;
      S_AXI_WUSER : in std_logic_vector(0 to 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BID : out std_logic_vector(0 to 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BUSER : out std_logic_vector(0 to 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARID : in std_logic_vector(0 to 0);
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARLOCK : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARREGION : in std_logic_vector(3 downto 0);
      S_AXI_ARQOS : in std_logic_vector(3 downto 0);
      S_AXI_ARUSER : in std_logic_vector(0 to 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RID : out std_logic_vector(0 to 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic;
      S_AXI_RUSER : out std_logic_vector(0 to 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      M_AXI_AWID : out std_logic_vector(0 to 0);
      M_AXI_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWLOCK : out std_logic_vector(1 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_AWREGION : out std_logic_vector(3 downto 0);
      M_AXI_AWQOS : out std_logic_vector(3 downto 0);
      M_AXI_AWUSER : out std_logic_vector(0 to 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_WID : out std_logic_vector(0 to 0);
      M_AXI_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_WLAST : out std_logic;
      M_AXI_WUSER : out std_logic_vector(0 to 0);
      M_AXI_WVALID : out std_logic;
      M_AXI_WREADY : in std_logic;
      M_AXI_BID : in std_logic_vector(0 to 0);
      M_AXI_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_BUSER : in std_logic_vector(0 to 0);
      M_AXI_BVALID : in std_logic;
      M_AXI_BREADY : out std_logic;
      M_AXI_ARID : out std_logic_vector(0 to 0);
      M_AXI_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARLOCK : out std_logic_vector(1 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_ARREGION : out std_logic_vector(3 downto 0);
      M_AXI_ARQOS : out std_logic_vector(3 downto 0);
      M_AXI_ARUSER : out std_logic_vector(0 to 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_RID : in std_logic_vector(0 to 0);
      M_AXI_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_RLAST : in std_logic;
      M_AXI_RUSER : in std_logic_vector(0 to 0);
      M_AXI_RVALID : in std_logic;
      M_AXI_RREADY : out std_logic
    );
  end component;

  component mpu_qspi_flash_wrapper is
    port (
      EXT_SPI_CLK : in std_logic;
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI4_ACLK : in std_logic;
      S_AXI4_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(6 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(6 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI4_AWID : in std_logic_vector(3 downto 0);
      S_AXI4_AWADDR : in std_logic_vector(23 downto 0);
      S_AXI4_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI4_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI4_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI4_AWLOCK : in std_logic;
      S_AXI4_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI4_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI4_AWVALID : in std_logic;
      S_AXI4_AWREADY : out std_logic;
      S_AXI4_WDATA : in std_logic_vector(31 downto 0);
      S_AXI4_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI4_WLAST : in std_logic;
      S_AXI4_WVALID : in std_logic;
      S_AXI4_WREADY : out std_logic;
      S_AXI4_BID : out std_logic_vector(3 downto 0);
      S_AXI4_BRESP : out std_logic_vector(1 downto 0);
      S_AXI4_BVALID : out std_logic;
      S_AXI4_BREADY : in std_logic;
      S_AXI4_ARID : in std_logic_vector(3 downto 0);
      S_AXI4_ARADDR : in std_logic_vector(23 downto 0);
      S_AXI4_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI4_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI4_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI4_ARLOCK : in std_logic;
      S_AXI4_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI4_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI4_ARVALID : in std_logic;
      S_AXI4_ARREADY : out std_logic;
      S_AXI4_RID : out std_logic_vector(3 downto 0);
      S_AXI4_RDATA : out std_logic_vector(31 downto 0);
      S_AXI4_RRESP : out std_logic_vector(1 downto 0);
      S_AXI4_RLAST : out std_logic;
      S_AXI4_RVALID : out std_logic;
      S_AXI4_RREADY : in std_logic;
      SCK_I : in std_logic;
      SCK_O : out std_logic;
      SCK_T : out std_logic;
      SS_I : in std_logic_vector(0 downto 0);
      SS_O : out std_logic_vector(0 downto 0);
      SS_T : out std_logic;
      SPISEL : in std_logic;
      IP2INTC_Irpt : out std_logic;
      IO0_I : in std_logic;
      IO0_O : out std_logic;
      IO0_T : out std_logic;
      IO1_I : in std_logic;
      IO1_O : out std_logic;
      IO1_T : out std_logic;
      IO2_I : in std_logic;
      IO2_O : out std_logic;
      IO2_T : out std_logic;
      IO3_I : in std_logic;
      IO3_O : out std_logic;
      IO3_T : out std_logic
    );
  end component;

  component mpu_mcb_ddr2_wrapper is
    port (
      sysclk_2x : in std_logic;
      sysclk_2x_180 : in std_logic;
      pll_ce_0 : in std_logic;
      pll_ce_90 : in std_logic;
      pll_lock : in std_logic;
      pll_lock_bufpll_o : out std_logic;
      sysclk_2x_bufpll_o : out std_logic;
      sysclk_2x_180_bufpll_o : out std_logic;
      pll_ce_0_bufpll_o : out std_logic;
      pll_ce_90_bufpll_o : out std_logic;
      sys_rst : in std_logic;
      mcbx_dram_addr : out std_logic_vector(12 downto 0);
      mcbx_dram_ba : out std_logic_vector(2 downto 0);
      mcbx_dram_ras_n : out std_logic;
      mcbx_dram_cas_n : out std_logic;
      mcbx_dram_we_n : out std_logic;
      mcbx_dram_cke : out std_logic;
      mcbx_dram_clk : out std_logic;
      mcbx_dram_clk_n : out std_logic;
      mcbx_dram_dq : inout std_logic_vector(15 downto 0);
      mcbx_dram_dqs : inout std_logic;
      mcbx_dram_dqs_n : inout std_logic;
      mcbx_dram_udqs : inout std_logic;
      mcbx_dram_udqs_n : inout std_logic;
      mcbx_dram_udm : out std_logic;
      mcbx_dram_ldm : out std_logic;
      mcbx_dram_odt : out std_logic;
      mcbx_dram_ddr3_rst : out std_logic;
      rzq : inout std_logic;
      zio : inout std_logic;
      ui_clk : in std_logic;
      uo_done_cal : out std_logic;
      s0_axi_aclk : in std_logic;
      s0_axi_aresetn : in std_logic;
      s0_axi_awid : in std_logic_vector(0 to 0);
      s0_axi_awaddr : in std_logic_vector(31 downto 0);
      s0_axi_awlen : in std_logic_vector(7 downto 0);
      s0_axi_awsize : in std_logic_vector(2 downto 0);
      s0_axi_awburst : in std_logic_vector(1 downto 0);
      s0_axi_awlock : in std_logic_vector(0 to 0);
      s0_axi_awcache : in std_logic_vector(3 downto 0);
      s0_axi_awprot : in std_logic_vector(2 downto 0);
      s0_axi_awqos : in std_logic_vector(3 downto 0);
      s0_axi_awvalid : in std_logic;
      s0_axi_awready : out std_logic;
      s0_axi_wdata : in std_logic_vector(31 downto 0);
      s0_axi_wstrb : in std_logic_vector(3 downto 0);
      s0_axi_wlast : in std_logic;
      s0_axi_wvalid : in std_logic;
      s0_axi_wready : out std_logic;
      s0_axi_bid : out std_logic_vector(0 to 0);
      s0_axi_bresp : out std_logic_vector(1 downto 0);
      s0_axi_bvalid : out std_logic;
      s0_axi_bready : in std_logic;
      s0_axi_arid : in std_logic_vector(0 to 0);
      s0_axi_araddr : in std_logic_vector(31 downto 0);
      s0_axi_arlen : in std_logic_vector(7 downto 0);
      s0_axi_arsize : in std_logic_vector(2 downto 0);
      s0_axi_arburst : in std_logic_vector(1 downto 0);
      s0_axi_arlock : in std_logic_vector(0 to 0);
      s0_axi_arcache : in std_logic_vector(3 downto 0);
      s0_axi_arprot : in std_logic_vector(2 downto 0);
      s0_axi_arqos : in std_logic_vector(3 downto 0);
      s0_axi_arvalid : in std_logic;
      s0_axi_arready : out std_logic;
      s0_axi_rid : out std_logic_vector(0 to 0);
      s0_axi_rdata : out std_logic_vector(31 downto 0);
      s0_axi_rresp : out std_logic_vector(1 downto 0);
      s0_axi_rlast : out std_logic;
      s0_axi_rvalid : out std_logic;
      s0_axi_rready : in std_logic;
      s1_axi_aclk : in std_logic;
      s1_axi_aresetn : in std_logic;
      s1_axi_awid : in std_logic_vector(3 downto 0);
      s1_axi_awaddr : in std_logic_vector(31 downto 0);
      s1_axi_awlen : in std_logic_vector(7 downto 0);
      s1_axi_awsize : in std_logic_vector(2 downto 0);
      s1_axi_awburst : in std_logic_vector(1 downto 0);
      s1_axi_awlock : in std_logic_vector(0 to 0);
      s1_axi_awcache : in std_logic_vector(3 downto 0);
      s1_axi_awprot : in std_logic_vector(2 downto 0);
      s1_axi_awqos : in std_logic_vector(3 downto 0);
      s1_axi_awvalid : in std_logic;
      s1_axi_awready : out std_logic;
      s1_axi_wdata : in std_logic_vector(31 downto 0);
      s1_axi_wstrb : in std_logic_vector(3 downto 0);
      s1_axi_wlast : in std_logic;
      s1_axi_wvalid : in std_logic;
      s1_axi_wready : out std_logic;
      s1_axi_bid : out std_logic_vector(3 downto 0);
      s1_axi_bresp : out std_logic_vector(1 downto 0);
      s1_axi_bvalid : out std_logic;
      s1_axi_bready : in std_logic;
      s1_axi_arid : in std_logic_vector(3 downto 0);
      s1_axi_araddr : in std_logic_vector(31 downto 0);
      s1_axi_arlen : in std_logic_vector(7 downto 0);
      s1_axi_arsize : in std_logic_vector(2 downto 0);
      s1_axi_arburst : in std_logic_vector(1 downto 0);
      s1_axi_arlock : in std_logic_vector(0 to 0);
      s1_axi_arcache : in std_logic_vector(3 downto 0);
      s1_axi_arprot : in std_logic_vector(2 downto 0);
      s1_axi_arqos : in std_logic_vector(3 downto 0);
      s1_axi_arvalid : in std_logic;
      s1_axi_arready : out std_logic;
      s1_axi_rid : out std_logic_vector(3 downto 0);
      s1_axi_rdata : out std_logic_vector(31 downto 0);
      s1_axi_rresp : out std_logic_vector(1 downto 0);
      s1_axi_rlast : out std_logic;
      s1_axi_rvalid : out std_logic;
      s1_axi_rready : in std_logic;
      s2_axi_aclk : in std_logic;
      s2_axi_aresetn : in std_logic;
      s2_axi_awid : in std_logic_vector(3 downto 0);
      s2_axi_awaddr : in std_logic_vector(31 downto 0);
      s2_axi_awlen : in std_logic_vector(7 downto 0);
      s2_axi_awsize : in std_logic_vector(2 downto 0);
      s2_axi_awburst : in std_logic_vector(1 downto 0);
      s2_axi_awlock : in std_logic_vector(0 to 0);
      s2_axi_awcache : in std_logic_vector(3 downto 0);
      s2_axi_awprot : in std_logic_vector(2 downto 0);
      s2_axi_awqos : in std_logic_vector(3 downto 0);
      s2_axi_awvalid : in std_logic;
      s2_axi_awready : out std_logic;
      s2_axi_wdata : in std_logic_vector(31 downto 0);
      s2_axi_wstrb : in std_logic_vector(3 downto 0);
      s2_axi_wlast : in std_logic;
      s2_axi_wvalid : in std_logic;
      s2_axi_wready : out std_logic;
      s2_axi_bid : out std_logic_vector(3 downto 0);
      s2_axi_bresp : out std_logic_vector(1 downto 0);
      s2_axi_bvalid : out std_logic;
      s2_axi_bready : in std_logic;
      s2_axi_arid : in std_logic_vector(3 downto 0);
      s2_axi_araddr : in std_logic_vector(31 downto 0);
      s2_axi_arlen : in std_logic_vector(7 downto 0);
      s2_axi_arsize : in std_logic_vector(2 downto 0);
      s2_axi_arburst : in std_logic_vector(1 downto 0);
      s2_axi_arlock : in std_logic_vector(0 to 0);
      s2_axi_arcache : in std_logic_vector(3 downto 0);
      s2_axi_arprot : in std_logic_vector(2 downto 0);
      s2_axi_arqos : in std_logic_vector(3 downto 0);
      s2_axi_arvalid : in std_logic;
      s2_axi_arready : out std_logic;
      s2_axi_rid : out std_logic_vector(3 downto 0);
      s2_axi_rdata : out std_logic_vector(31 downto 0);
      s2_axi_rresp : out std_logic_vector(1 downto 0);
      s2_axi_rlast : out std_logic;
      s2_axi_rvalid : out std_logic;
      s2_axi_rready : in std_logic;
      s3_axi_aclk : in std_logic;
      s3_axi_aresetn : in std_logic;
      s3_axi_awid : in std_logic_vector(3 downto 0);
      s3_axi_awaddr : in std_logic_vector(31 downto 0);
      s3_axi_awlen : in std_logic_vector(7 downto 0);
      s3_axi_awsize : in std_logic_vector(2 downto 0);
      s3_axi_awburst : in std_logic_vector(1 downto 0);
      s3_axi_awlock : in std_logic_vector(0 to 0);
      s3_axi_awcache : in std_logic_vector(3 downto 0);
      s3_axi_awprot : in std_logic_vector(2 downto 0);
      s3_axi_awqos : in std_logic_vector(3 downto 0);
      s3_axi_awvalid : in std_logic;
      s3_axi_awready : out std_logic;
      s3_axi_wdata : in std_logic_vector(31 downto 0);
      s3_axi_wstrb : in std_logic_vector(3 downto 0);
      s3_axi_wlast : in std_logic;
      s3_axi_wvalid : in std_logic;
      s3_axi_wready : out std_logic;
      s3_axi_bid : out std_logic_vector(3 downto 0);
      s3_axi_bresp : out std_logic_vector(1 downto 0);
      s3_axi_bvalid : out std_logic;
      s3_axi_bready : in std_logic;
      s3_axi_arid : in std_logic_vector(3 downto 0);
      s3_axi_araddr : in std_logic_vector(31 downto 0);
      s3_axi_arlen : in std_logic_vector(7 downto 0);
      s3_axi_arsize : in std_logic_vector(2 downto 0);
      s3_axi_arburst : in std_logic_vector(1 downto 0);
      s3_axi_arlock : in std_logic_vector(0 to 0);
      s3_axi_arcache : in std_logic_vector(3 downto 0);
      s3_axi_arprot : in std_logic_vector(2 downto 0);
      s3_axi_arqos : in std_logic_vector(3 downto 0);
      s3_axi_arvalid : in std_logic;
      s3_axi_arready : out std_logic;
      s3_axi_rid : out std_logic_vector(3 downto 0);
      s3_axi_rdata : out std_logic_vector(31 downto 0);
      s3_axi_rresp : out std_logic_vector(1 downto 0);
      s3_axi_rlast : out std_logic;
      s3_axi_rvalid : out std_logic;
      s3_axi_rready : in std_logic;
      s4_axi_aclk : in std_logic;
      s4_axi_aresetn : in std_logic;
      s4_axi_awid : in std_logic_vector(3 downto 0);
      s4_axi_awaddr : in std_logic_vector(31 downto 0);
      s4_axi_awlen : in std_logic_vector(7 downto 0);
      s4_axi_awsize : in std_logic_vector(2 downto 0);
      s4_axi_awburst : in std_logic_vector(1 downto 0);
      s4_axi_awlock : in std_logic_vector(0 to 0);
      s4_axi_awcache : in std_logic_vector(3 downto 0);
      s4_axi_awprot : in std_logic_vector(2 downto 0);
      s4_axi_awqos : in std_logic_vector(3 downto 0);
      s4_axi_awvalid : in std_logic;
      s4_axi_awready : out std_logic;
      s4_axi_wdata : in std_logic_vector(31 downto 0);
      s4_axi_wstrb : in std_logic_vector(3 downto 0);
      s4_axi_wlast : in std_logic;
      s4_axi_wvalid : in std_logic;
      s4_axi_wready : out std_logic;
      s4_axi_bid : out std_logic_vector(3 downto 0);
      s4_axi_bresp : out std_logic_vector(1 downto 0);
      s4_axi_bvalid : out std_logic;
      s4_axi_bready : in std_logic;
      s4_axi_arid : in std_logic_vector(3 downto 0);
      s4_axi_araddr : in std_logic_vector(31 downto 0);
      s4_axi_arlen : in std_logic_vector(7 downto 0);
      s4_axi_arsize : in std_logic_vector(2 downto 0);
      s4_axi_arburst : in std_logic_vector(1 downto 0);
      s4_axi_arlock : in std_logic_vector(0 to 0);
      s4_axi_arcache : in std_logic_vector(3 downto 0);
      s4_axi_arprot : in std_logic_vector(2 downto 0);
      s4_axi_arqos : in std_logic_vector(3 downto 0);
      s4_axi_arvalid : in std_logic;
      s4_axi_arready : out std_logic;
      s4_axi_rid : out std_logic_vector(3 downto 0);
      s4_axi_rdata : out std_logic_vector(31 downto 0);
      s4_axi_rresp : out std_logic_vector(1 downto 0);
      s4_axi_rlast : out std_logic;
      s4_axi_rvalid : out std_logic;
      s4_axi_rready : in std_logic;
      s5_axi_aclk : in std_logic;
      s5_axi_aresetn : in std_logic;
      s5_axi_awid : in std_logic_vector(3 downto 0);
      s5_axi_awaddr : in std_logic_vector(31 downto 0);
      s5_axi_awlen : in std_logic_vector(7 downto 0);
      s5_axi_awsize : in std_logic_vector(2 downto 0);
      s5_axi_awburst : in std_logic_vector(1 downto 0);
      s5_axi_awlock : in std_logic_vector(0 to 0);
      s5_axi_awcache : in std_logic_vector(3 downto 0);
      s5_axi_awprot : in std_logic_vector(2 downto 0);
      s5_axi_awqos : in std_logic_vector(3 downto 0);
      s5_axi_awvalid : in std_logic;
      s5_axi_awready : out std_logic;
      s5_axi_wdata : in std_logic_vector(31 downto 0);
      s5_axi_wstrb : in std_logic_vector(3 downto 0);
      s5_axi_wlast : in std_logic;
      s5_axi_wvalid : in std_logic;
      s5_axi_wready : out std_logic;
      s5_axi_bid : out std_logic_vector(3 downto 0);
      s5_axi_bresp : out std_logic_vector(1 downto 0);
      s5_axi_bvalid : out std_logic;
      s5_axi_bready : in std_logic;
      s5_axi_arid : in std_logic_vector(3 downto 0);
      s5_axi_araddr : in std_logic_vector(31 downto 0);
      s5_axi_arlen : in std_logic_vector(7 downto 0);
      s5_axi_arsize : in std_logic_vector(2 downto 0);
      s5_axi_arburst : in std_logic_vector(1 downto 0);
      s5_axi_arlock : in std_logic_vector(0 to 0);
      s5_axi_arcache : in std_logic_vector(3 downto 0);
      s5_axi_arprot : in std_logic_vector(2 downto 0);
      s5_axi_arqos : in std_logic_vector(3 downto 0);
      s5_axi_arvalid : in std_logic;
      s5_axi_arready : out std_logic;
      s5_axi_rid : out std_logic_vector(3 downto 0);
      s5_axi_rdata : out std_logic_vector(31 downto 0);
      s5_axi_rresp : out std_logic_vector(1 downto 0);
      s5_axi_rlast : out std_logic;
      s5_axi_rvalid : out std_logic;
      s5_axi_rready : in std_logic
    );
  end component;

  component mpu_ethernet_lite_wrapper is
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      IP2INTC_Irpt : out std_logic;
      S_AXI_AWID : in std_logic_vector(0 downto 0);
      S_AXI_AWADDR : in std_logic_vector(12 downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WLAST : in std_logic;
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BID : out std_logic_vector(0 downto 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARID : in std_logic_vector(0 downto 0);
      S_AXI_ARADDR : in std_logic_vector(12 downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RID : out std_logic_vector(0 downto 0);
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic;
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      PHY_tx_clk : in std_logic;
      PHY_rx_clk : in std_logic;
      PHY_crs : in std_logic;
      PHY_dv : in std_logic;
      PHY_rx_data : in std_logic_vector(3 downto 0);
      PHY_col : in std_logic;
      PHY_rx_er : in std_logic;
      PHY_rst_n : out std_logic;
      PHY_tx_en : out std_logic;
      PHY_tx_data : out std_logic_vector(3 downto 0);
      PHY_MDC : out std_logic;
      PHY_MDIO_I : in std_logic;
      PHY_MDIO_O : out std_logic;
      PHY_MDIO_T : out std_logic
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal Ethernet_Lite_IP2INTC_Irpt : std_logic_vector(0 downto 0);
  signal Ethernet_Lite_MDIO_I : std_logic;
  signal Ethernet_Lite_MDIO_O : std_logic;
  signal Ethernet_Lite_MDIO_T : std_logic;
  signal Ext_BRK : std_logic;
  signal Ext_NM_BRK : std_logic;
  signal QSPI_FLASH_IO0_I : std_logic;
  signal QSPI_FLASH_IO0_O : std_logic;
  signal QSPI_FLASH_IO0_T : std_logic;
  signal QSPI_FLASH_IO1_I : std_logic;
  signal QSPI_FLASH_IO1_O : std_logic;
  signal QSPI_FLASH_IO1_T : std_logic;
  signal QSPI_FLASH_SCLK_I : std_logic;
  signal QSPI_FLASH_SCLK_O : std_logic;
  signal QSPI_FLASH_SCLK_T : std_logic;
  signal QSPI_FLASH_SS_I : std_logic_vector(0 downto 0);
  signal QSPI_FLASH_SS_O : std_logic_vector(0 downto 0);
  signal QSPI_FLASH_SS_T : std_logic;
  signal axi4_0_M_ARADDR : std_logic_vector(31 downto 0);
  signal axi4_0_M_ARBURST : std_logic_vector(1 downto 0);
  signal axi4_0_M_ARCACHE : std_logic_vector(3 downto 0);
  signal axi4_0_M_ARESETN : std_logic_vector(0 to 0);
  signal axi4_0_M_ARID : std_logic_vector(0 to 0);
  signal axi4_0_M_ARLEN : std_logic_vector(7 downto 0);
  signal axi4_0_M_ARLOCK : std_logic_vector(1 downto 0);
  signal axi4_0_M_ARPROT : std_logic_vector(2 downto 0);
  signal axi4_0_M_ARQOS : std_logic_vector(3 downto 0);
  signal axi4_0_M_ARREADY : std_logic_vector(0 to 0);
  signal axi4_0_M_ARSIZE : std_logic_vector(2 downto 0);
  signal axi4_0_M_ARVALID : std_logic_vector(0 to 0);
  signal axi4_0_M_AWADDR : std_logic_vector(31 downto 0);
  signal axi4_0_M_AWBURST : std_logic_vector(1 downto 0);
  signal axi4_0_M_AWCACHE : std_logic_vector(3 downto 0);
  signal axi4_0_M_AWID : std_logic_vector(0 to 0);
  signal axi4_0_M_AWLEN : std_logic_vector(7 downto 0);
  signal axi4_0_M_AWLOCK : std_logic_vector(1 downto 0);
  signal axi4_0_M_AWPROT : std_logic_vector(2 downto 0);
  signal axi4_0_M_AWQOS : std_logic_vector(3 downto 0);
  signal axi4_0_M_AWREADY : std_logic_vector(0 to 0);
  signal axi4_0_M_AWSIZE : std_logic_vector(2 downto 0);
  signal axi4_0_M_AWVALID : std_logic_vector(0 to 0);
  signal axi4_0_M_BID : std_logic_vector(0 to 0);
  signal axi4_0_M_BREADY : std_logic_vector(0 to 0);
  signal axi4_0_M_BRESP : std_logic_vector(1 downto 0);
  signal axi4_0_M_BVALID : std_logic_vector(0 to 0);
  signal axi4_0_M_RDATA : std_logic_vector(31 downto 0);
  signal axi4_0_M_RID : std_logic_vector(0 to 0);
  signal axi4_0_M_RLAST : std_logic_vector(0 to 0);
  signal axi4_0_M_RREADY : std_logic_vector(0 to 0);
  signal axi4_0_M_RRESP : std_logic_vector(1 downto 0);
  signal axi4_0_M_RVALID : std_logic_vector(0 to 0);
  signal axi4_0_M_WDATA : std_logic_vector(31 downto 0);
  signal axi4_0_M_WLAST : std_logic_vector(0 to 0);
  signal axi4_0_M_WREADY : std_logic_vector(0 to 0);
  signal axi4_0_M_WSTRB : std_logic_vector(3 downto 0);
  signal axi4_0_M_WVALID : std_logic_vector(0 to 0);
  signal axi4_0_S_ARADDR : std_logic_vector(63 downto 0);
  signal axi4_0_S_ARBURST : std_logic_vector(3 downto 0);
  signal axi4_0_S_ARCACHE : std_logic_vector(7 downto 0);
  signal axi4_0_S_ARID : std_logic_vector(1 downto 0);
  signal axi4_0_S_ARLEN : std_logic_vector(15 downto 0);
  signal axi4_0_S_ARLOCK : std_logic_vector(3 downto 0);
  signal axi4_0_S_ARPROT : std_logic_vector(5 downto 0);
  signal axi4_0_S_ARQOS : std_logic_vector(7 downto 0);
  signal axi4_0_S_ARREADY : std_logic_vector(1 downto 0);
  signal axi4_0_S_ARSIZE : std_logic_vector(5 downto 0);
  signal axi4_0_S_ARUSER : std_logic_vector(9 downto 0);
  signal axi4_0_S_ARVALID : std_logic_vector(1 downto 0);
  signal axi4_0_S_AWADDR : std_logic_vector(63 downto 0);
  signal axi4_0_S_AWBURST : std_logic_vector(3 downto 0);
  signal axi4_0_S_AWCACHE : std_logic_vector(7 downto 0);
  signal axi4_0_S_AWID : std_logic_vector(1 downto 0);
  signal axi4_0_S_AWLEN : std_logic_vector(15 downto 0);
  signal axi4_0_S_AWLOCK : std_logic_vector(3 downto 0);
  signal axi4_0_S_AWPROT : std_logic_vector(5 downto 0);
  signal axi4_0_S_AWQOS : std_logic_vector(7 downto 0);
  signal axi4_0_S_AWREADY : std_logic_vector(1 downto 0);
  signal axi4_0_S_AWSIZE : std_logic_vector(5 downto 0);
  signal axi4_0_S_AWUSER : std_logic_vector(9 downto 0);
  signal axi4_0_S_AWVALID : std_logic_vector(1 downto 0);
  signal axi4_0_S_BID : std_logic_vector(1 downto 0);
  signal axi4_0_S_BREADY : std_logic_vector(1 downto 0);
  signal axi4_0_S_BRESP : std_logic_vector(3 downto 0);
  signal axi4_0_S_BUSER : std_logic_vector(1 downto 0);
  signal axi4_0_S_BVALID : std_logic_vector(1 downto 0);
  signal axi4_0_S_RDATA : std_logic_vector(63 downto 0);
  signal axi4_0_S_RID : std_logic_vector(1 downto 0);
  signal axi4_0_S_RLAST : std_logic_vector(1 downto 0);
  signal axi4_0_S_RREADY : std_logic_vector(1 downto 0);
  signal axi4_0_S_RRESP : std_logic_vector(3 downto 0);
  signal axi4_0_S_RUSER : std_logic_vector(1 downto 0);
  signal axi4_0_S_RVALID : std_logic_vector(1 downto 0);
  signal axi4_0_S_WDATA : std_logic_vector(63 downto 0);
  signal axi4_0_S_WLAST : std_logic_vector(1 downto 0);
  signal axi4_0_S_WREADY : std_logic_vector(1 downto 0);
  signal axi4_0_S_WSTRB : std_logic_vector(7 downto 0);
  signal axi4_0_S_WUSER : std_logic_vector(1 downto 0);
  signal axi4_0_S_WVALID : std_logic_vector(1 downto 0);
  signal axi4lite_0_M_ARADDR : std_logic_vector(511 downto 0);
  signal axi4lite_0_M_ARBURST : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_ARCACHE : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_ARESETN : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_ARID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_ARLEN : std_logic_vector(127 downto 0);
  signal axi4lite_0_M_ARLOCK : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_ARPROT : std_logic_vector(47 downto 0);
  signal axi4lite_0_M_ARQOS : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_ARREADY : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_ARREGION : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_ARSIZE : std_logic_vector(47 downto 0);
  signal axi4lite_0_M_ARUSER : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_ARVALID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_AWADDR : std_logic_vector(511 downto 0);
  signal axi4lite_0_M_AWBURST : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_AWCACHE : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_AWID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_AWLEN : std_logic_vector(127 downto 0);
  signal axi4lite_0_M_AWLOCK : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_AWPROT : std_logic_vector(47 downto 0);
  signal axi4lite_0_M_AWQOS : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_AWREADY : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_AWREGION : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_AWSIZE : std_logic_vector(47 downto 0);
  signal axi4lite_0_M_AWUSER : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_AWVALID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_BID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_BREADY : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_BRESP : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_BUSER : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_BVALID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_RDATA : std_logic_vector(511 downto 0);
  signal axi4lite_0_M_RID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_RLAST : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_RREADY : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_RRESP : std_logic_vector(31 downto 0);
  signal axi4lite_0_M_RUSER : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_RVALID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_WDATA : std_logic_vector(511 downto 0);
  signal axi4lite_0_M_WID : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_WLAST : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_WREADY : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_WSTRB : std_logic_vector(63 downto 0);
  signal axi4lite_0_M_WUSER : std_logic_vector(15 downto 0);
  signal axi4lite_0_M_WVALID : std_logic_vector(15 downto 0);
  signal axi4lite_0_S_ARADDR : std_logic_vector(31 downto 0);
  signal axi4lite_0_S_ARBURST : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_ARCACHE : std_logic_vector(3 downto 0);
  signal axi4lite_0_S_ARID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_ARLEN : std_logic_vector(7 downto 0);
  signal axi4lite_0_S_ARLOCK : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_ARPROT : std_logic_vector(2 downto 0);
  signal axi4lite_0_S_ARQOS : std_logic_vector(3 downto 0);
  signal axi4lite_0_S_ARREADY : std_logic_vector(0 to 0);
  signal axi4lite_0_S_ARSIZE : std_logic_vector(2 downto 0);
  signal axi4lite_0_S_ARVALID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_AWADDR : std_logic_vector(31 downto 0);
  signal axi4lite_0_S_AWBURST : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_AWCACHE : std_logic_vector(3 downto 0);
  signal axi4lite_0_S_AWID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_AWLEN : std_logic_vector(7 downto 0);
  signal axi4lite_0_S_AWLOCK : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_AWPROT : std_logic_vector(2 downto 0);
  signal axi4lite_0_S_AWQOS : std_logic_vector(3 downto 0);
  signal axi4lite_0_S_AWREADY : std_logic_vector(0 to 0);
  signal axi4lite_0_S_AWSIZE : std_logic_vector(2 downto 0);
  signal axi4lite_0_S_AWVALID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_BID : std_logic_vector(0 downto 0);
  signal axi4lite_0_S_BREADY : std_logic_vector(0 to 0);
  signal axi4lite_0_S_BRESP : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_BVALID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_RDATA : std_logic_vector(31 downto 0);
  signal axi4lite_0_S_RID : std_logic_vector(0 downto 0);
  signal axi4lite_0_S_RLAST : std_logic_vector(0 to 0);
  signal axi4lite_0_S_RREADY : std_logic_vector(0 to 0);
  signal axi4lite_0_S_RRESP : std_logic_vector(1 downto 0);
  signal axi4lite_0_S_RVALID : std_logic_vector(0 to 0);
  signal axi4lite_0_S_WDATA : std_logic_vector(31 downto 0);
  signal axi4lite_0_S_WLAST : std_logic_vector(0 to 0);
  signal axi4lite_0_S_WREADY : std_logic_vector(0 to 0);
  signal axi4lite_0_S_WSTRB : std_logic_vector(3 downto 0);
  signal axi4lite_0_S_WVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_M_ARADDR : std_logic_vector(191 downto 0);
  signal axi_interconnect_1_M_ARESETN : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_ARREADY : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_ARVALID : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_AWADDR : std_logic_vector(191 downto 0);
  signal axi_interconnect_1_M_AWREADY : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_AWVALID : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_BREADY : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_BRESP : std_logic_vector(11 downto 0);
  signal axi_interconnect_1_M_BVALID : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_RDATA : std_logic_vector(191 downto 0);
  signal axi_interconnect_1_M_RREADY : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_RRESP : std_logic_vector(11 downto 0);
  signal axi_interconnect_1_M_RVALID : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_WDATA : std_logic_vector(191 downto 0);
  signal axi_interconnect_1_M_WREADY : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_M_WSTRB : std_logic_vector(23 downto 0);
  signal axi_interconnect_1_M_WVALID : std_logic_vector(5 downto 0);
  signal axi_interconnect_1_S_ARADDR : std_logic_vector(31 downto 0);
  signal axi_interconnect_1_S_ARBURST : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_ARCACHE : std_logic_vector(3 downto 0);
  signal axi_interconnect_1_S_ARID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_ARLEN : std_logic_vector(7 downto 0);
  signal axi_interconnect_1_S_ARLOCK : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_ARPROT : std_logic_vector(2 downto 0);
  signal axi_interconnect_1_S_ARQOS : std_logic_vector(3 downto 0);
  signal axi_interconnect_1_S_ARREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_ARSIZE : std_logic_vector(2 downto 0);
  signal axi_interconnect_1_S_ARUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_ARVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_AWADDR : std_logic_vector(31 downto 0);
  signal axi_interconnect_1_S_AWBURST : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_AWCACHE : std_logic_vector(3 downto 0);
  signal axi_interconnect_1_S_AWID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_AWLEN : std_logic_vector(7 downto 0);
  signal axi_interconnect_1_S_AWLOCK : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_AWPROT : std_logic_vector(2 downto 0);
  signal axi_interconnect_1_S_AWQOS : std_logic_vector(3 downto 0);
  signal axi_interconnect_1_S_AWREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_AWSIZE : std_logic_vector(2 downto 0);
  signal axi_interconnect_1_S_AWUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_AWVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_BID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_BREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_BRESP : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_BUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_BVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_RDATA : std_logic_vector(31 downto 0);
  signal axi_interconnect_1_S_RID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_RLAST : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_RREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_RRESP : std_logic_vector(1 downto 0);
  signal axi_interconnect_1_S_RUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_RVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_WDATA : std_logic_vector(31 downto 0);
  signal axi_interconnect_1_S_WID : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_WLAST : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_WREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_WSTRB : std_logic_vector(3 downto 0);
  signal axi_interconnect_1_S_WUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_1_S_WVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_M_ARADDR : std_logic_vector(351 downto 0);
  signal axi_interconnect_2_M_ARESETN : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_ARREADY : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_ARVALID : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_AWADDR : std_logic_vector(351 downto 0);
  signal axi_interconnect_2_M_AWREADY : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_AWVALID : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_BREADY : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_BRESP : std_logic_vector(21 downto 0);
  signal axi_interconnect_2_M_BVALID : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_RDATA : std_logic_vector(351 downto 0);
  signal axi_interconnect_2_M_RREADY : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_RRESP : std_logic_vector(21 downto 0);
  signal axi_interconnect_2_M_RVALID : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_WDATA : std_logic_vector(351 downto 0);
  signal axi_interconnect_2_M_WREADY : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_M_WSTRB : std_logic_vector(43 downto 0);
  signal axi_interconnect_2_M_WVALID : std_logic_vector(10 downto 0);
  signal axi_interconnect_2_S_ARADDR : std_logic_vector(31 downto 0);
  signal axi_interconnect_2_S_ARBURST : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_ARCACHE : std_logic_vector(3 downto 0);
  signal axi_interconnect_2_S_ARID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_ARLEN : std_logic_vector(7 downto 0);
  signal axi_interconnect_2_S_ARLOCK : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_ARPROT : std_logic_vector(2 downto 0);
  signal axi_interconnect_2_S_ARQOS : std_logic_vector(3 downto 0);
  signal axi_interconnect_2_S_ARREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_ARSIZE : std_logic_vector(2 downto 0);
  signal axi_interconnect_2_S_ARUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_ARVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_AWADDR : std_logic_vector(31 downto 0);
  signal axi_interconnect_2_S_AWBURST : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_AWCACHE : std_logic_vector(3 downto 0);
  signal axi_interconnect_2_S_AWID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_AWLEN : std_logic_vector(7 downto 0);
  signal axi_interconnect_2_S_AWLOCK : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_AWPROT : std_logic_vector(2 downto 0);
  signal axi_interconnect_2_S_AWQOS : std_logic_vector(3 downto 0);
  signal axi_interconnect_2_S_AWREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_AWSIZE : std_logic_vector(2 downto 0);
  signal axi_interconnect_2_S_AWUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_AWVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_BID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_BREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_BRESP : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_BUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_BVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_RDATA : std_logic_vector(31 downto 0);
  signal axi_interconnect_2_S_RID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_RLAST : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_RREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_RRESP : std_logic_vector(1 downto 0);
  signal axi_interconnect_2_S_RUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_RVALID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_WDATA : std_logic_vector(31 downto 0);
  signal axi_interconnect_2_S_WID : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_WLAST : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_WREADY : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_WSTRB : std_logic_vector(3 downto 0);
  signal axi_interconnect_2_S_WUSER : std_logic_vector(0 to 0);
  signal axi_interconnect_2_S_WVALID : std_logic_vector(0 to 0);
  signal clk_100_0000MHzPLL0 : std_logic_vector(0 to 0);
  signal clk_600_0000MHz180PLL0_nobuf : std_logic;
  signal clk_600_0000MHzPLL0_nobuf : std_logic;
  signal error_u11_u12_GPIO2_IO_I : std_logic_vector(31 downto 0);
  signal error_x01_x02_GPIO2_IO_I : std_logic_vector(31 downto 0);
  signal error_x01_x02_GPIO_IO_I : std_logic_vector(31 downto 0);
  signal error_x10_x11_GPIO2_IO_I : std_logic_vector(31 downto 0);
  signal error_x10_x11_GPIO_IO_I : std_logic_vector(31 downto 0);
  signal error_x12_x20_GPIO2_IO_I : std_logic_vector(31 downto 0);
  signal error_x12_x20_GPIO_IO_I : std_logic_vector(31 downto 0);
  signal error_x21_x22_GPIO2_IO_I : std_logic_vector(31 downto 0);
  signal error_x21_x22_GPIO_IO_I : std_logic_vector(31 downto 0);
  signal ideal_address_we_GPIO2_IO_O : std_logic_vector(0 to 0);
  signal ideal_address_we_GPIO_IO_O : std_logic_vector(13 downto 0);
  signal ideal_data_in_out_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr : std_logic_vector(0 to 31);
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk : std_logic;
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din : std_logic_vector(0 to 31);
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout : std_logic_vector(0 to 31);
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN : std_logic;
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst : std_logic;
  signal microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN : std_logic_vector(0 to 3);
  signal microblaze_0_debug_Dbg_Capture : std_logic;
  signal microblaze_0_debug_Dbg_Clk : std_logic;
  signal microblaze_0_debug_Dbg_Reg_En : std_logic_vector(0 to 7);
  signal microblaze_0_debug_Dbg_Shift : std_logic;
  signal microblaze_0_debug_Dbg_TDI : std_logic;
  signal microblaze_0_debug_Dbg_TDO : std_logic;
  signal microblaze_0_debug_Dbg_Update : std_logic;
  signal microblaze_0_debug_Debug_Rst : std_logic;
  signal microblaze_0_dlmb_LMB_ABus : std_logic_vector(0 to 31);
  signal microblaze_0_dlmb_LMB_AddrStrobe : std_logic;
  signal microblaze_0_dlmb_LMB_BE : std_logic_vector(0 to 3);
  signal microblaze_0_dlmb_LMB_CE : std_logic;
  signal microblaze_0_dlmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal microblaze_0_dlmb_LMB_ReadStrobe : std_logic;
  signal microblaze_0_dlmb_LMB_Ready : std_logic;
  signal microblaze_0_dlmb_LMB_Rst : std_logic;
  signal microblaze_0_dlmb_LMB_UE : std_logic;
  signal microblaze_0_dlmb_LMB_Wait : std_logic;
  signal microblaze_0_dlmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal microblaze_0_dlmb_LMB_WriteStrobe : std_logic;
  signal microblaze_0_dlmb_M_ABus : std_logic_vector(0 to 31);
  signal microblaze_0_dlmb_M_AddrStrobe : std_logic;
  signal microblaze_0_dlmb_M_BE : std_logic_vector(0 to 3);
  signal microblaze_0_dlmb_M_DBus : std_logic_vector(0 to 31);
  signal microblaze_0_dlmb_M_ReadStrobe : std_logic;
  signal microblaze_0_dlmb_M_WriteStrobe : std_logic;
  signal microblaze_0_dlmb_Sl_CE : std_logic_vector(0 to 1);
  signal microblaze_0_dlmb_Sl_DBus : std_logic_vector(0 to 63);
  signal microblaze_0_dlmb_Sl_Ready : std_logic_vector(0 to 1);
  signal microblaze_0_dlmb_Sl_UE : std_logic_vector(0 to 1);
  signal microblaze_0_dlmb_Sl_Wait : std_logic_vector(0 to 1);
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr : std_logic_vector(0 to 31);
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk : std_logic;
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din : std_logic_vector(0 to 31);
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout : std_logic_vector(0 to 31);
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN : std_logic;
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst : std_logic;
  signal microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN : std_logic_vector(0 to 3);
  signal microblaze_0_ilmb_LMB_ABus : std_logic_vector(0 to 31);
  signal microblaze_0_ilmb_LMB_AddrStrobe : std_logic;
  signal microblaze_0_ilmb_LMB_BE : std_logic_vector(0 to 3);
  signal microblaze_0_ilmb_LMB_CE : std_logic;
  signal microblaze_0_ilmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal microblaze_0_ilmb_LMB_ReadStrobe : std_logic;
  signal microblaze_0_ilmb_LMB_Ready : std_logic;
  signal microblaze_0_ilmb_LMB_Rst : std_logic;
  signal microblaze_0_ilmb_LMB_UE : std_logic;
  signal microblaze_0_ilmb_LMB_Wait : std_logic;
  signal microblaze_0_ilmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal microblaze_0_ilmb_LMB_WriteStrobe : std_logic;
  signal microblaze_0_ilmb_M_ABus : std_logic_vector(0 to 31);
  signal microblaze_0_ilmb_M_AddrStrobe : std_logic;
  signal microblaze_0_ilmb_M_ReadStrobe : std_logic;
  signal microblaze_0_ilmb_Sl_CE : std_logic_vector(0 to 0);
  signal microblaze_0_ilmb_Sl_DBus : std_logic_vector(0 to 31);
  signal microblaze_0_ilmb_Sl_Ready : std_logic_vector(0 to 0);
  signal microblaze_0_ilmb_Sl_UE : std_logic_vector(0 to 0);
  signal microblaze_0_ilmb_Sl_Wait : std_logic_vector(0 to 0);
  signal microblaze_0_interrupt_Interrupt : std_logic;
  signal microblaze_0_interrupt_Interrupt_Ack : std_logic_vector(1 downto 0);
  signal microblaze_0_interrupt_Interrupt_Address : std_logic_vector(0 to 31);
  signal net_error_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u00_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u01_GPIO2_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u02_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u10_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u11_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u20_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u21_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_u22_GPIO_IO_I_pin : std_logic_vector(31 downto 0);
  signal net_error_x00 : std_logic_vector(31 downto 0);
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(1 downto 0);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd6 : std_logic_vector(5 downto 0);
  signal net_gnd8 : std_logic_vector(7 downto 0);
  signal net_gnd11 : std_logic_vector(10 downto 0);
  signal net_gnd14 : std_logic_vector(13 downto 0);
  signal net_gnd16 : std_logic_vector(15 downto 0);
  signal net_gnd24 : std_logic_vector(23 downto 0);
  signal net_gnd32 : std_logic_vector(31 downto 0);
  signal net_gnd4096 : std_logic_vector(0 to 4095);
  signal net_ideal_data_out : std_logic_vector(15 downto 0);
  signal net_u_data_out : std_logic_vector(15 downto 0);
  signal net_vcc0 : std_logic;
  signal net_x_data_out : std_logic_vector(15 downto 0);
  signal pgassign1 : std_logic_vector(10 downto 0);
  signal pgassign2 : std_logic_vector(5 downto 0);
  signal pgassign3 : std_logic_vector(15 downto 0);
  signal pgassign4 : std_logic_vector(1 downto 0);
  signal proc_sys_reset_0_BUS_STRUCT_RESET : std_logic_vector(0 to 0);
  signal proc_sys_reset_0_Dcm_locked : std_logic;
  signal proc_sys_reset_0_Interconnect_aresetn : std_logic_vector(0 to 0);
  signal proc_sys_reset_0_MB_Debug_Sys_Rst : std_logic;
  signal proc_sys_reset_0_MB_Reset : std_logic;
  signal proc_sys_reset_0_Peripheral_Reset : std_logic_vector(0 to 0);
  signal template_A00_A01_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_A00_A01_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_A02_A10_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_A02_A10_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_A11_A12_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_A11_A12_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_A20_A21_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_A20_A21_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_A22_B00_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_A22_B00_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_B01_B02_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_B01_B02_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_B10_B11_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_B10_B11_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_B12_B20_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_B12_B20_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_B21_B22_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_B21_B22_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_I_base_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal template_xbnd_ubnd_GPIO2_IO_O : std_logic_vector(15 downto 0);
  signal template_xbnd_ubnd_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal u_address_we_GPIO2_IO_O : std_logic_vector(0 to 0);
  signal u_address_we_GPIO_IO_O : std_logic_vector(13 downto 0);
  signal u_data_in_out_GPIO_IO_O : std_logic_vector(15 downto 0);
  signal x_address_we_GPIO2_IO_O : std_logic_vector(0 to 0);
  signal x_address_we_GPIO_IO_O : std_logic_vector(13 downto 0);
  signal x_data_in_out_GPIO_IO_O : std_logic_vector(15 downto 0);

begin

  -- Internal assignments

  net_error_GPIO_IO_I_pin <= error_i;
  net_error_u00_GPIO_IO_I_pin <= error_u00;
  net_error_u01_GPIO2_IO_I_pin <= error_u01;
  net_error_u02_GPIO_IO_I_pin <= error_u02;
  net_error_u10_GPIO_IO_I_pin <= error_u10;
  error_u11_u12_GPIO2_IO_I <= error_u12;
  net_error_u11_GPIO_IO_I_pin <= error_u11;
  net_error_u20_GPIO_IO_I_pin <= error_u20;
  net_error_u21_GPIO_IO_I_pin <= error_u21;
  net_error_u22_GPIO_IO_I_pin <= error_u22;
  net_error_x00 <= error_x00;
  error_x01_x02_GPIO2_IO_I <= error_x02;
  error_x01_x02_GPIO_IO_I <= error_x01;
  error_x10_x11_GPIO2_IO_I <= error_x11;
  error_x10_x11_GPIO_IO_I <= error_x10;
  error_x12_x20_GPIO_IO_I <= error_x12;
  error_x12_x20_GPIO2_IO_I <= error_x20;
  error_x21_x22_GPIO2_IO_I <= error_x22;
  error_x21_x22_GPIO_IO_I <= error_x21;
  u_data_in <= u_data_in_out_GPIO_IO_O;
  net_u_data_out <= u_data_out;
  u_address <= u_address_we_GPIO_IO_O;
  u_we <= u_address_we_GPIO2_IO_O(0);
  x_data_in <= x_data_in_out_GPIO_IO_O;
  net_x_data_out <= x_data_out;
  x_address <= x_address_we_GPIO_IO_O;
  x_we <= x_address_we_GPIO2_IO_O(0);
  ideal_address <= ideal_address_we_GPIO_IO_O;
  ideal_we <= ideal_address_we_GPIO2_IO_O(0);
  ideal_data_in <= ideal_data_in_out_GPIO_IO_O;
  net_ideal_data_out <= ideal_data_out;
  template_A00 <= template_A00_A01_GPIO_IO_O;
  template_A01 <= template_A00_A01_GPIO2_IO_O;
  template_A02 <= template_A02_A10_GPIO_IO_O;
  template_A10 <= template_A02_A10_GPIO2_IO_O;
  template_A11 <= template_A11_A12_GPIO_IO_O;
  template_A12 <= template_A11_A12_GPIO2_IO_O;
  template_A20 <= template_A20_A21_GPIO_IO_O;
  template_A21 <= template_A20_A21_GPIO2_IO_O;
  template_A22 <= template_A22_B00_GPIO_IO_O;
  template_B00 <= template_A22_B00_GPIO2_IO_O;
  template_B01 <= template_B01_B02_GPIO_IO_O;
  template_B02 <= template_B01_B02_GPIO2_IO_O;
  template_B10 <= template_B10_B11_GPIO_IO_O;
  template_B11 <= template_B10_B11_GPIO2_IO_O;
  template_B12 <= template_B12_B20_GPIO_IO_O;
  template_B20 <= template_B12_B20_GPIO2_IO_O;
  template_B21 <= template_B21_B22_GPIO_IO_O;
  template_B22 <= template_B21_B22_GPIO2_IO_O;
  template_I <= template_I_base_GPIO_IO_O;
  template_xbnd <= template_xbnd_ubnd_GPIO_IO_O;
  template_ubnd <= template_xbnd_ubnd_GPIO2_IO_O;
  axi4lite_0_M_BID(0 downto 0) <= B"0";
  axi4lite_0_M_BID(1 downto 1) <= B"0";
  axi4lite_0_M_BID(2 downto 2) <= B"0";
  axi4lite_0_M_BID(3 downto 3) <= B"0";
  axi4lite_0_M_BID(4 downto 4) <= B"0";
  axi4lite_0_M_BID(5 downto 5) <= B"0";
  axi4lite_0_M_BID(6 downto 6) <= B"0";
  axi4lite_0_M_BID(7 downto 7) <= B"0";
  axi4lite_0_M_BID(8 downto 8) <= B"0";
  axi4lite_0_M_BID(9 downto 9) <= B"0";
  axi4lite_0_M_BID(10 downto 10) <= B"0";
  axi4lite_0_M_BID(11 downto 11) <= B"0";
  axi4lite_0_M_BID(14 downto 14) <= B"0";
  axi4lite_0_M_BUSER(0 downto 0) <= B"0";
  axi4lite_0_M_BUSER(1 downto 1) <= B"0";
  axi4lite_0_M_BUSER(2 downto 2) <= B"0";
  axi4lite_0_M_BUSER(3 downto 3) <= B"0";
  axi4lite_0_M_BUSER(4 downto 4) <= B"0";
  axi4lite_0_M_BUSER(5 downto 5) <= B"0";
  axi4lite_0_M_BUSER(6 downto 6) <= B"0";
  axi4lite_0_M_BUSER(7 downto 7) <= B"0";
  axi4lite_0_M_BUSER(8 downto 8) <= B"0";
  axi4lite_0_M_BUSER(9 downto 9) <= B"0";
  axi4lite_0_M_BUSER(10 downto 10) <= B"0";
  axi4lite_0_M_BUSER(11 downto 11) <= B"0";
  axi4lite_0_M_BUSER(14 downto 14) <= B"0";
  axi4lite_0_M_BUSER(15 downto 15) <= B"0";
  axi4lite_0_M_RID(0 downto 0) <= B"0";
  axi4lite_0_M_RID(1 downto 1) <= B"0";
  axi4lite_0_M_RID(2 downto 2) <= B"0";
  axi4lite_0_M_RID(3 downto 3) <= B"0";
  axi4lite_0_M_RID(4 downto 4) <= B"0";
  axi4lite_0_M_RID(5 downto 5) <= B"0";
  axi4lite_0_M_RID(6 downto 6) <= B"0";
  axi4lite_0_M_RID(7 downto 7) <= B"0";
  axi4lite_0_M_RID(8 downto 8) <= B"0";
  axi4lite_0_M_RID(9 downto 9) <= B"0";
  axi4lite_0_M_RID(10 downto 10) <= B"0";
  axi4lite_0_M_RID(11 downto 11) <= B"0";
  axi4lite_0_M_RID(14 downto 14) <= B"0";
  axi4lite_0_M_RLAST(0 downto 0) <= B"0";
  axi4lite_0_M_RLAST(1 downto 1) <= B"0";
  axi4lite_0_M_RLAST(2 downto 2) <= B"0";
  axi4lite_0_M_RLAST(3 downto 3) <= B"0";
  axi4lite_0_M_RLAST(4 downto 4) <= B"0";
  axi4lite_0_M_RLAST(5 downto 5) <= B"0";
  axi4lite_0_M_RLAST(6 downto 6) <= B"0";
  axi4lite_0_M_RLAST(7 downto 7) <= B"0";
  axi4lite_0_M_RLAST(8 downto 8) <= B"0";
  axi4lite_0_M_RLAST(9 downto 9) <= B"0";
  axi4lite_0_M_RLAST(10 downto 10) <= B"0";
  axi4lite_0_M_RLAST(11 downto 11) <= B"0";
  axi4lite_0_M_RLAST(14 downto 14) <= B"0";
  axi4lite_0_M_RUSER(0 downto 0) <= B"0";
  axi4lite_0_M_RUSER(1 downto 1) <= B"0";
  axi4lite_0_M_RUSER(2 downto 2) <= B"0";
  axi4lite_0_M_RUSER(3 downto 3) <= B"0";
  axi4lite_0_M_RUSER(4 downto 4) <= B"0";
  axi4lite_0_M_RUSER(5 downto 5) <= B"0";
  axi4lite_0_M_RUSER(6 downto 6) <= B"0";
  axi4lite_0_M_RUSER(7 downto 7) <= B"0";
  axi4lite_0_M_RUSER(8 downto 8) <= B"0";
  axi4lite_0_M_RUSER(9 downto 9) <= B"0";
  axi4lite_0_M_RUSER(10 downto 10) <= B"0";
  axi4lite_0_M_RUSER(11 downto 11) <= B"0";
  axi4lite_0_M_RUSER(14 downto 14) <= B"0";
  axi4lite_0_M_RUSER(15 downto 15) <= B"0";
  pgassign1(10 downto 10) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(9 downto 9) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(8 downto 8) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(7 downto 7) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(6 downto 6) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(5 downto 5) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(4 downto 4) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(3 downto 3) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(2 downto 2) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(1 downto 1) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign1(0 downto 0) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(5 downto 5) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(4 downto 4) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(3 downto 3) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(2 downto 2) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(1 downto 1) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign2(0 downto 0) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(15 downto 15) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(14 downto 14) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(13 downto 13) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(12 downto 12) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(11 downto 11) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(10 downto 10) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(9 downto 9) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(8 downto 8) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(7 downto 7) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(6 downto 6) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(5 downto 5) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(4 downto 4) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(3 downto 3) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(2 downto 2) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(1 downto 1) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign3(0 downto 0) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign4(1 downto 1) <= clk_100_0000MHzPLL0(0 to 0);
  pgassign4(0 downto 0) <= clk_100_0000MHzPLL0(0 to 0);
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd11(10 downto 0) <= B"00000000000";
  net_gnd14(13 downto 0) <= B"00000000000000";
  net_gnd16(15 downto 0) <= B"0000000000000000";
  net_gnd2(1 downto 0) <= B"00";
  net_gnd24(23 downto 0) <= B"000000000000000000000000";
  net_gnd3(0 to 2) <= B"000";
  net_gnd32(31 downto 0) <= B"00000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd4096(0 to 4095) <= X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  net_gnd6(5 downto 0) <= B"000000";
  net_gnd8(7 downto 0) <= B"00000000";
  net_vcc0 <= '1';

  x_data_in_out : mpu_x_data_in_out_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(0),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(8 downto 0),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(0),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(0),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(31 downto 0),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(3 downto 0),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(0),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(0),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(1 downto 0),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(0),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(0),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(8 downto 0),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(0),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(0),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(31 downto 0),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(1 downto 0),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(0),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(0),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => x_data_in_out_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_x_data_out,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  x_address_we : mpu_x_address_we_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(1),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(40 downto 32),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(1),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(1),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(63 downto 32),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(7 downto 4),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(1),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(1),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(3 downto 2),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(1),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(1),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(40 downto 32),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(1),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(1),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(63 downto 32),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(3 downto 2),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(1),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(1),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd14,
      GPIO_IO_O => x_address_we_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd1(0 to 0),
      GPIO2_IO_O => x_address_we_GPIO2_IO_O(0 to 0),
      GPIO2_IO_T => open
    );

  u_data_in_out : mpu_u_data_in_out_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(2),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(72 downto 64),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(2),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(2),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(95 downto 64),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(11 downto 8),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(2),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(2),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(5 downto 4),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(2),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(2),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(72 downto 64),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(2),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(2),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(95 downto 64),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(5 downto 4),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(2),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(2),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => u_data_in_out_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_u_data_out,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  u_address_we : mpu_u_address_we_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(3),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(104 downto 96),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(3),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(3),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(127 downto 96),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(15 downto 12),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(3),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(3),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(7 downto 6),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(3),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(3),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(104 downto 96),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(3),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(3),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(127 downto 96),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(7 downto 6),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(3),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(3),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd14,
      GPIO_IO_O => u_address_we_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd1(0 to 0),
      GPIO2_IO_O => u_address_we_GPIO2_IO_O(0 to 0),
      GPIO2_IO_T => open
    );

  template_I_base : mpu_template_i_base_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(0),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(8 downto 0),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(0),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(0),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(31 downto 0),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(3 downto 0),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(0),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(0),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(1 downto 0),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(0),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(0),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(8 downto 0),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(0),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(0),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(31 downto 0),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(1 downto 0),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(0),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(0),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_I_base_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd32,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  template_B21_B22 : mpu_template_b21_b22_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(1),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(40 downto 32),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(1),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(1),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(63 downto 32),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(7 downto 4),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(1),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(1),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(3 downto 2),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(1),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(1),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(40 downto 32),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(1),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(1),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(63 downto 32),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(3 downto 2),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(1),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(1),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_B21_B22_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_B21_B22_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_B12_B20 : mpu_template_b12_b20_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(2),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(72 downto 64),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(2),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(2),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(95 downto 64),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(11 downto 8),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(2),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(2),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(5 downto 4),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(2),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(2),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(72 downto 64),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(2),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(2),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(95 downto 64),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(5 downto 4),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(2),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(2),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_B12_B20_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_B12_B20_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_B10_B11 : mpu_template_b10_b11_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(3),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(104 downto 96),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(3),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(3),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(127 downto 96),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(15 downto 12),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(3),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(3),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(7 downto 6),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(3),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(3),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(104 downto 96),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(3),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(3),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(127 downto 96),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(7 downto 6),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(3),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(3),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_B10_B11_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_B10_B11_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_B01_B02 : mpu_template_b01_b02_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(4),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(136 downto 128),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(4),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(4),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(159 downto 128),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(19 downto 16),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(4),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(4),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(9 downto 8),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(4),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(4),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(136 downto 128),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(4),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(4),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(159 downto 128),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(9 downto 8),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(4),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(4),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_B01_B02_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_B01_B02_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_A22_B00 : mpu_template_a22_b00_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(5),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(168 downto 160),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(5),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(5),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(191 downto 160),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(23 downto 20),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(5),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(5),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(11 downto 10),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(5),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(5),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(168 downto 160),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(5),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(5),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(191 downto 160),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(11 downto 10),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(5),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(5),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_A22_B00_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_A22_B00_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_A20_A21 : mpu_template_a20_a21_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(6),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(200 downto 192),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(6),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(6),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(223 downto 192),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(27 downto 24),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(6),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(6),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(13 downto 12),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(6),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(6),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(200 downto 192),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(6),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(6),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(223 downto 192),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(13 downto 12),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(6),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(6),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_A20_A21_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_A20_A21_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_A11_A12 : mpu_template_a11_a12_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(7),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(232 downto 224),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(7),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(7),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(255 downto 224),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(31 downto 28),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(7),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(7),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(15 downto 14),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(7),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(7),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(232 downto 224),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(7),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(7),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(255 downto 224),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(15 downto 14),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(7),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(7),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_A11_A12_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_A11_A12_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_A02_A10 : mpu_template_a02_a10_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(8),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(264 downto 256),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(8),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(8),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(287 downto 256),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(35 downto 32),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(8),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(8),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(17 downto 16),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(8),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(8),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(264 downto 256),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(8),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(8),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(287 downto 256),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(17 downto 16),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(8),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(8),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_A02_A10_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_A02_A10_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  template_A00_A01 : mpu_template_a00_a01_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(9),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(296 downto 288),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(9),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(9),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(319 downto 288),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(39 downto 36),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(9),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(9),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(19 downto 18),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(9),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(9),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(296 downto 288),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(9),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(9),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(319 downto 288),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(19 downto 18),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(9),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(9),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_A00_A01_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_A00_A01_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  proc_sys_reset_0 : mpu_proc_sys_reset_0_wrapper
    port map (
      Slowest_sync_clk => pgassign1(10),
      Ext_Reset_In => RESET,
      Aux_Reset_In => net_gnd0,
      MB_Debug_Sys_Rst => proc_sys_reset_0_MB_Debug_Sys_Rst,
      Core_Reset_Req_0 => net_gnd0,
      Chip_Reset_Req_0 => net_gnd0,
      System_Reset_Req_0 => net_gnd0,
      Core_Reset_Req_1 => net_gnd0,
      Chip_Reset_Req_1 => net_gnd0,
      System_Reset_Req_1 => net_gnd0,
      Dcm_locked => proc_sys_reset_0_Dcm_locked,
      RstcPPCresetcore_0 => open,
      RstcPPCresetchip_0 => open,
      RstcPPCresetsys_0 => open,
      RstcPPCresetcore_1 => open,
      RstcPPCresetchip_1 => open,
      RstcPPCresetsys_1 => open,
      MB_Reset => proc_sys_reset_0_MB_Reset,
      Bus_Struct_Reset => proc_sys_reset_0_BUS_STRUCT_RESET(0 to 0),
      Peripheral_Reset => proc_sys_reset_0_Peripheral_Reset(0 to 0),
      Interconnect_aresetn => proc_sys_reset_0_Interconnect_aresetn(0 to 0),
      Peripheral_aresetn => open
    );

  microblaze_0_intc : mpu_microblaze_0_intc_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(0),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(8 downto 0),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(0),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(0),
      S_AXI_WDATA => axi4lite_0_M_WDATA(31 downto 0),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(3 downto 0),
      S_AXI_WVALID => axi4lite_0_M_WVALID(0),
      S_AXI_WREADY => axi4lite_0_M_WREADY(0),
      S_AXI_BRESP => axi4lite_0_M_BRESP(1 downto 0),
      S_AXI_BVALID => axi4lite_0_M_BVALID(0),
      S_AXI_BREADY => axi4lite_0_M_BREADY(0),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(8 downto 0),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(0),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(0),
      S_AXI_RDATA => axi4lite_0_M_RDATA(31 downto 0),
      S_AXI_RRESP => axi4lite_0_M_RRESP(1 downto 0),
      S_AXI_RVALID => axi4lite_0_M_RVALID(0),
      S_AXI_RREADY => axi4lite_0_M_RREADY(0),
      Intr => Ethernet_Lite_IP2INTC_Irpt(0 downto 0),
      Processor_clk => net_gnd0,
      Processor_rst => net_gnd0,
      Irq => microblaze_0_interrupt_Interrupt,
      Interrupt_address => microblaze_0_interrupt_Interrupt_Address(0 to 31),
      Processor_ack => microblaze_0_interrupt_Interrupt_Ack,
      Interrupt_address_in => net_gnd32,
      Processor_ack_out => open
    );

  microblaze_0_ilmb : mpu_microblaze_0_ilmb_wrapper
    port map (
      LMB_Clk => pgassign1(10),
      SYS_Rst => proc_sys_reset_0_BUS_STRUCT_RESET(0),
      LMB_Rst => microblaze_0_ilmb_LMB_Rst,
      M_ABus => microblaze_0_ilmb_M_ABus,
      M_ReadStrobe => microblaze_0_ilmb_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => microblaze_0_ilmb_M_AddrStrobe,
      M_DBus => net_gnd32(31 downto 0),
      M_BE => net_gnd4,
      Sl_DBus => microblaze_0_ilmb_Sl_DBus,
      Sl_Ready => microblaze_0_ilmb_Sl_Ready(0 to 0),
      Sl_Wait => microblaze_0_ilmb_Sl_Wait(0 to 0),
      Sl_UE => microblaze_0_ilmb_Sl_UE(0 to 0),
      Sl_CE => microblaze_0_ilmb_Sl_CE(0 to 0),
      LMB_ABus => microblaze_0_ilmb_LMB_ABus,
      LMB_ReadStrobe => microblaze_0_ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => microblaze_0_ilmb_LMB_WriteStrobe,
      LMB_AddrStrobe => microblaze_0_ilmb_LMB_AddrStrobe,
      LMB_ReadDBus => microblaze_0_ilmb_LMB_ReadDBus,
      LMB_WriteDBus => microblaze_0_ilmb_LMB_WriteDBus,
      LMB_Ready => microblaze_0_ilmb_LMB_Ready,
      LMB_Wait => microblaze_0_ilmb_LMB_Wait,
      LMB_UE => microblaze_0_ilmb_LMB_UE,
      LMB_CE => microblaze_0_ilmb_LMB_CE,
      LMB_BE => microblaze_0_ilmb_LMB_BE
    );

  microblaze_0_i_bram_ctrl : mpu_microblaze_0_i_bram_ctrl_wrapper
    port map (
      LMB_Clk => pgassign1(10),
      LMB_Rst => microblaze_0_ilmb_LMB_Rst,
      LMB_ABus => microblaze_0_ilmb_LMB_ABus,
      LMB_WriteDBus => microblaze_0_ilmb_LMB_WriteDBus,
      LMB_AddrStrobe => microblaze_0_ilmb_LMB_AddrStrobe,
      LMB_ReadStrobe => microblaze_0_ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => microblaze_0_ilmb_LMB_WriteStrobe,
      LMB_BE => microblaze_0_ilmb_LMB_BE,
      Sl_DBus => microblaze_0_ilmb_Sl_DBus,
      Sl_Ready => microblaze_0_ilmb_Sl_Ready(0),
      Sl_Wait => microblaze_0_ilmb_Sl_Wait(0),
      Sl_UE => microblaze_0_ilmb_Sl_UE(0),
      Sl_CE => microblaze_0_ilmb_Sl_CE(0),
      LMB1_ABus => net_gnd32(31 downto 0),
      LMB1_WriteDBus => net_gnd32(31 downto 0),
      LMB1_AddrStrobe => net_gnd0,
      LMB1_ReadStrobe => net_gnd0,
      LMB1_WriteStrobe => net_gnd0,
      LMB1_BE => net_gnd4,
      Sl1_DBus => open,
      Sl1_Ready => open,
      Sl1_Wait => open,
      Sl1_UE => open,
      Sl1_CE => open,
      LMB2_ABus => net_gnd32(31 downto 0),
      LMB2_WriteDBus => net_gnd32(31 downto 0),
      LMB2_AddrStrobe => net_gnd0,
      LMB2_ReadStrobe => net_gnd0,
      LMB2_WriteStrobe => net_gnd0,
      LMB2_BE => net_gnd4,
      Sl2_DBus => open,
      Sl2_Ready => open,
      Sl2_Wait => open,
      Sl2_UE => open,
      Sl2_CE => open,
      LMB3_ABus => net_gnd32(31 downto 0),
      LMB3_WriteDBus => net_gnd32(31 downto 0),
      LMB3_AddrStrobe => net_gnd0,
      LMB3_ReadStrobe => net_gnd0,
      LMB3_WriteStrobe => net_gnd0,
      LMB3_BE => net_gnd4,
      Sl3_DBus => open,
      Sl3_Ready => open,
      Sl3_Wait => open,
      Sl3_UE => open,
      Sl3_CE => open,
      BRAM_Rst_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst,
      BRAM_Clk_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk,
      BRAM_EN_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN,
      BRAM_WEN_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN,
      BRAM_Addr_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr,
      BRAM_Din_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din,
      BRAM_Dout_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout,
      Interrupt => open,
      UE => open,
      CE => open,
      SPLB_CTRL_PLB_ABus => net_gnd32(31 downto 0),
      SPLB_CTRL_PLB_PAValid => net_gnd0,
      SPLB_CTRL_PLB_masterID => net_gnd1(0 to 0),
      SPLB_CTRL_PLB_RNW => net_gnd0,
      SPLB_CTRL_PLB_BE => net_gnd4,
      SPLB_CTRL_PLB_size => net_gnd4,
      SPLB_CTRL_PLB_type => net_gnd3,
      SPLB_CTRL_PLB_wrDBus => net_gnd32(31 downto 0),
      SPLB_CTRL_Sl_addrAck => open,
      SPLB_CTRL_Sl_SSize => open,
      SPLB_CTRL_Sl_wait => open,
      SPLB_CTRL_Sl_rearbitrate => open,
      SPLB_CTRL_Sl_wrDAck => open,
      SPLB_CTRL_Sl_wrComp => open,
      SPLB_CTRL_Sl_rdDBus => open,
      SPLB_CTRL_Sl_rdDAck => open,
      SPLB_CTRL_Sl_rdComp => open,
      SPLB_CTRL_Sl_MBusy => open,
      SPLB_CTRL_Sl_MWrErr => open,
      SPLB_CTRL_Sl_MRdErr => open,
      SPLB_CTRL_PLB_UABus => net_gnd32(31 downto 0),
      SPLB_CTRL_PLB_SAValid => net_gnd0,
      SPLB_CTRL_PLB_rdPrim => net_gnd0,
      SPLB_CTRL_PLB_wrPrim => net_gnd0,
      SPLB_CTRL_PLB_abort => net_gnd0,
      SPLB_CTRL_PLB_busLock => net_gnd0,
      SPLB_CTRL_PLB_MSize => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_lockErr => net_gnd0,
      SPLB_CTRL_PLB_wrBurst => net_gnd0,
      SPLB_CTRL_PLB_rdBurst => net_gnd0,
      SPLB_CTRL_PLB_wrPendReq => net_gnd0,
      SPLB_CTRL_PLB_rdPendReq => net_gnd0,
      SPLB_CTRL_PLB_wrPendPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_rdPendPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_reqPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB_CTRL_Sl_wrBTerm => open,
      SPLB_CTRL_Sl_rdWdAddr => open,
      SPLB_CTRL_Sl_rdBTerm => open,
      SPLB_CTRL_Sl_MIRQ => open,
      S_AXI_CTRL_ACLK => net_vcc0,
      S_AXI_CTRL_ARESETN => net_gnd0,
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WSTRB => net_gnd4(0 to 3),
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0
    );

  microblaze_0_dlmb : mpu_microblaze_0_dlmb_wrapper
    port map (
      LMB_Clk => pgassign1(10),
      SYS_Rst => proc_sys_reset_0_BUS_STRUCT_RESET(0),
      LMB_Rst => microblaze_0_dlmb_LMB_Rst,
      M_ABus => microblaze_0_dlmb_M_ABus,
      M_ReadStrobe => microblaze_0_dlmb_M_ReadStrobe,
      M_WriteStrobe => microblaze_0_dlmb_M_WriteStrobe,
      M_AddrStrobe => microblaze_0_dlmb_M_AddrStrobe,
      M_DBus => microblaze_0_dlmb_M_DBus,
      M_BE => microblaze_0_dlmb_M_BE,
      Sl_DBus => microblaze_0_dlmb_Sl_DBus,
      Sl_Ready => microblaze_0_dlmb_Sl_Ready,
      Sl_Wait => microblaze_0_dlmb_Sl_Wait,
      Sl_UE => microblaze_0_dlmb_Sl_UE,
      Sl_CE => microblaze_0_dlmb_Sl_CE,
      LMB_ABus => microblaze_0_dlmb_LMB_ABus,
      LMB_ReadStrobe => microblaze_0_dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => microblaze_0_dlmb_LMB_WriteStrobe,
      LMB_AddrStrobe => microblaze_0_dlmb_LMB_AddrStrobe,
      LMB_ReadDBus => microblaze_0_dlmb_LMB_ReadDBus,
      LMB_WriteDBus => microblaze_0_dlmb_LMB_WriteDBus,
      LMB_Ready => microblaze_0_dlmb_LMB_Ready,
      LMB_Wait => microblaze_0_dlmb_LMB_Wait,
      LMB_UE => microblaze_0_dlmb_LMB_UE,
      LMB_CE => microblaze_0_dlmb_LMB_CE,
      LMB_BE => microblaze_0_dlmb_LMB_BE
    );

  microblaze_0_d_bram_ctrl : mpu_microblaze_0_d_bram_ctrl_wrapper
    port map (
      LMB_Clk => pgassign1(10),
      LMB_Rst => microblaze_0_dlmb_LMB_Rst,
      LMB_ABus => microblaze_0_dlmb_LMB_ABus,
      LMB_WriteDBus => microblaze_0_dlmb_LMB_WriteDBus,
      LMB_AddrStrobe => microblaze_0_dlmb_LMB_AddrStrobe,
      LMB_ReadStrobe => microblaze_0_dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => microblaze_0_dlmb_LMB_WriteStrobe,
      LMB_BE => microblaze_0_dlmb_LMB_BE,
      Sl_DBus => microblaze_0_dlmb_Sl_DBus(0 to 31),
      Sl_Ready => microblaze_0_dlmb_Sl_Ready(0),
      Sl_Wait => microblaze_0_dlmb_Sl_Wait(0),
      Sl_UE => microblaze_0_dlmb_Sl_UE(0),
      Sl_CE => microblaze_0_dlmb_Sl_CE(0),
      LMB1_ABus => net_gnd32(31 downto 0),
      LMB1_WriteDBus => net_gnd32(31 downto 0),
      LMB1_AddrStrobe => net_gnd0,
      LMB1_ReadStrobe => net_gnd0,
      LMB1_WriteStrobe => net_gnd0,
      LMB1_BE => net_gnd4,
      Sl1_DBus => open,
      Sl1_Ready => open,
      Sl1_Wait => open,
      Sl1_UE => open,
      Sl1_CE => open,
      LMB2_ABus => net_gnd32(31 downto 0),
      LMB2_WriteDBus => net_gnd32(31 downto 0),
      LMB2_AddrStrobe => net_gnd0,
      LMB2_ReadStrobe => net_gnd0,
      LMB2_WriteStrobe => net_gnd0,
      LMB2_BE => net_gnd4,
      Sl2_DBus => open,
      Sl2_Ready => open,
      Sl2_Wait => open,
      Sl2_UE => open,
      Sl2_CE => open,
      LMB3_ABus => net_gnd32(31 downto 0),
      LMB3_WriteDBus => net_gnd32(31 downto 0),
      LMB3_AddrStrobe => net_gnd0,
      LMB3_ReadStrobe => net_gnd0,
      LMB3_WriteStrobe => net_gnd0,
      LMB3_BE => net_gnd4,
      Sl3_DBus => open,
      Sl3_Ready => open,
      Sl3_Wait => open,
      Sl3_UE => open,
      Sl3_CE => open,
      BRAM_Rst_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst,
      BRAM_Clk_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk,
      BRAM_EN_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN,
      BRAM_WEN_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN,
      BRAM_Addr_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr,
      BRAM_Din_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din,
      BRAM_Dout_A => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout,
      Interrupt => open,
      UE => open,
      CE => open,
      SPLB_CTRL_PLB_ABus => net_gnd32(31 downto 0),
      SPLB_CTRL_PLB_PAValid => net_gnd0,
      SPLB_CTRL_PLB_masterID => net_gnd1(0 to 0),
      SPLB_CTRL_PLB_RNW => net_gnd0,
      SPLB_CTRL_PLB_BE => net_gnd4,
      SPLB_CTRL_PLB_size => net_gnd4,
      SPLB_CTRL_PLB_type => net_gnd3,
      SPLB_CTRL_PLB_wrDBus => net_gnd32(31 downto 0),
      SPLB_CTRL_Sl_addrAck => open,
      SPLB_CTRL_Sl_SSize => open,
      SPLB_CTRL_Sl_wait => open,
      SPLB_CTRL_Sl_rearbitrate => open,
      SPLB_CTRL_Sl_wrDAck => open,
      SPLB_CTRL_Sl_wrComp => open,
      SPLB_CTRL_Sl_rdDBus => open,
      SPLB_CTRL_Sl_rdDAck => open,
      SPLB_CTRL_Sl_rdComp => open,
      SPLB_CTRL_Sl_MBusy => open,
      SPLB_CTRL_Sl_MWrErr => open,
      SPLB_CTRL_Sl_MRdErr => open,
      SPLB_CTRL_PLB_UABus => net_gnd32(31 downto 0),
      SPLB_CTRL_PLB_SAValid => net_gnd0,
      SPLB_CTRL_PLB_rdPrim => net_gnd0,
      SPLB_CTRL_PLB_wrPrim => net_gnd0,
      SPLB_CTRL_PLB_abort => net_gnd0,
      SPLB_CTRL_PLB_busLock => net_gnd0,
      SPLB_CTRL_PLB_MSize => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_lockErr => net_gnd0,
      SPLB_CTRL_PLB_wrBurst => net_gnd0,
      SPLB_CTRL_PLB_rdBurst => net_gnd0,
      SPLB_CTRL_PLB_wrPendReq => net_gnd0,
      SPLB_CTRL_PLB_rdPendReq => net_gnd0,
      SPLB_CTRL_PLB_wrPendPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_rdPendPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_reqPri => net_gnd2(1 downto 0),
      SPLB_CTRL_PLB_TAttribute => net_gnd16(15 downto 0),
      SPLB_CTRL_Sl_wrBTerm => open,
      SPLB_CTRL_Sl_rdWdAddr => open,
      SPLB_CTRL_Sl_rdBTerm => open,
      SPLB_CTRL_Sl_MIRQ => open,
      S_AXI_CTRL_ACLK => net_vcc0,
      S_AXI_CTRL_ARESETN => net_gnd0,
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WSTRB => net_gnd4(0 to 3),
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0
    );

  microblaze_0_bram_block : mpu_microblaze_0_bram_block_wrapper
    port map (
      BRAM_Rst_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst,
      BRAM_Clk_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk,
      BRAM_EN_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN,
      BRAM_WEN_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN,
      BRAM_Addr_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr,
      BRAM_Din_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din,
      BRAM_Dout_A => microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout,
      BRAM_Rst_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst,
      BRAM_Clk_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk,
      BRAM_EN_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN,
      BRAM_WEN_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN,
      BRAM_Addr_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr,
      BRAM_Din_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din,
      BRAM_Dout_B => microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout
    );

  microblaze_0 : mpu_microblaze_0_wrapper
    port map (
      CLK => pgassign1(10),
      RESET => microblaze_0_dlmb_LMB_Rst,
      MB_RESET => proc_sys_reset_0_MB_Reset,
      INTERRUPT => microblaze_0_interrupt_Interrupt,
      INTERRUPT_ADDRESS => microblaze_0_interrupt_Interrupt_Address,
      INTERRUPT_ACK => microblaze_0_interrupt_Interrupt_Ack(1 downto 0),
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      MB_Error => open,
      WAKEUP => net_gnd2(1 downto 0),
      SLEEP => open,
      DBG_WAKEUP => open,
      LOCKSTEP_MASTER_OUT => open,
      LOCKSTEP_SLAVE_IN => net_gnd4096,
      LOCKSTEP_OUT => open,
      INSTR => microblaze_0_ilmb_LMB_ReadDBus,
      IREADY => microblaze_0_ilmb_LMB_Ready,
      IWAIT => microblaze_0_ilmb_LMB_Wait,
      ICE => microblaze_0_ilmb_LMB_CE,
      IUE => microblaze_0_ilmb_LMB_UE,
      INSTR_ADDR => microblaze_0_ilmb_M_ABus,
      IFETCH => microblaze_0_ilmb_M_ReadStrobe,
      I_AS => microblaze_0_ilmb_M_AddrStrobe,
      IPLB_M_ABort => open,
      IPLB_M_ABus => open,
      IPLB_M_UABus => open,
      IPLB_M_BE => open,
      IPLB_M_busLock => open,
      IPLB_M_lockErr => open,
      IPLB_M_MSize => open,
      IPLB_M_priority => open,
      IPLB_M_rdBurst => open,
      IPLB_M_request => open,
      IPLB_M_RNW => open,
      IPLB_M_size => open,
      IPLB_M_TAttribute => open,
      IPLB_M_type => open,
      IPLB_M_wrBurst => open,
      IPLB_M_wrDBus => open,
      IPLB_MBusy => net_gnd0,
      IPLB_MRdErr => net_gnd0,
      IPLB_MWrErr => net_gnd0,
      IPLB_MIRQ => net_gnd0,
      IPLB_MWrBTerm => net_gnd0,
      IPLB_MWrDAck => net_gnd0,
      IPLB_MAddrAck => net_gnd0,
      IPLB_MRdBTerm => net_gnd0,
      IPLB_MRdDAck => net_gnd0,
      IPLB_MRdDBus => net_gnd32(31 downto 0),
      IPLB_MRdWdAddr => net_gnd4,
      IPLB_MRearbitrate => net_gnd0,
      IPLB_MSSize => net_gnd2(1 downto 0),
      IPLB_MTimeout => net_gnd0,
      DATA_READ => microblaze_0_dlmb_LMB_ReadDBus,
      DREADY => microblaze_0_dlmb_LMB_Ready,
      DWAIT => microblaze_0_dlmb_LMB_Wait,
      DCE => microblaze_0_dlmb_LMB_CE,
      DUE => microblaze_0_dlmb_LMB_UE,
      DATA_WRITE => microblaze_0_dlmb_M_DBus,
      DATA_ADDR => microblaze_0_dlmb_M_ABus,
      D_AS => microblaze_0_dlmb_M_AddrStrobe,
      READ_STROBE => microblaze_0_dlmb_M_ReadStrobe,
      WRITE_STROBE => microblaze_0_dlmb_M_WriteStrobe,
      BYTE_ENABLE => microblaze_0_dlmb_M_BE,
      DPLB_M_ABort => open,
      DPLB_M_ABus => open,
      DPLB_M_UABus => open,
      DPLB_M_BE => open,
      DPLB_M_busLock => open,
      DPLB_M_lockErr => open,
      DPLB_M_MSize => open,
      DPLB_M_priority => open,
      DPLB_M_rdBurst => open,
      DPLB_M_request => open,
      DPLB_M_RNW => open,
      DPLB_M_size => open,
      DPLB_M_TAttribute => open,
      DPLB_M_type => open,
      DPLB_M_wrBurst => open,
      DPLB_M_wrDBus => open,
      DPLB_MBusy => net_gnd0,
      DPLB_MRdErr => net_gnd0,
      DPLB_MWrErr => net_gnd0,
      DPLB_MIRQ => net_gnd0,
      DPLB_MWrBTerm => net_gnd0,
      DPLB_MWrDAck => net_gnd0,
      DPLB_MAddrAck => net_gnd0,
      DPLB_MRdBTerm => net_gnd0,
      DPLB_MRdDAck => net_gnd0,
      DPLB_MRdDBus => net_gnd32(31 downto 0),
      DPLB_MRdWdAddr => net_gnd4,
      DPLB_MRearbitrate => net_gnd0,
      DPLB_MSSize => net_gnd2(1 downto 0),
      DPLB_MTimeout => net_gnd0,
      M_AXI_IP_AWID => open,
      M_AXI_IP_AWADDR => open,
      M_AXI_IP_AWLEN => open,
      M_AXI_IP_AWSIZE => open,
      M_AXI_IP_AWBURST => open,
      M_AXI_IP_AWLOCK => open,
      M_AXI_IP_AWCACHE => open,
      M_AXI_IP_AWPROT => open,
      M_AXI_IP_AWQOS => open,
      M_AXI_IP_AWVALID => open,
      M_AXI_IP_AWREADY => net_gnd0,
      M_AXI_IP_WDATA => open,
      M_AXI_IP_WSTRB => open,
      M_AXI_IP_WLAST => open,
      M_AXI_IP_WVALID => open,
      M_AXI_IP_WREADY => net_gnd0,
      M_AXI_IP_BID => net_gnd1(0 to 0),
      M_AXI_IP_BRESP => net_gnd2,
      M_AXI_IP_BVALID => net_gnd0,
      M_AXI_IP_BREADY => open,
      M_AXI_IP_ARID => open,
      M_AXI_IP_ARADDR => open,
      M_AXI_IP_ARLEN => open,
      M_AXI_IP_ARSIZE => open,
      M_AXI_IP_ARBURST => open,
      M_AXI_IP_ARLOCK => open,
      M_AXI_IP_ARCACHE => open,
      M_AXI_IP_ARPROT => open,
      M_AXI_IP_ARQOS => open,
      M_AXI_IP_ARVALID => open,
      M_AXI_IP_ARREADY => net_gnd0,
      M_AXI_IP_RID => net_gnd1(0 to 0),
      M_AXI_IP_RDATA => net_gnd32,
      M_AXI_IP_RRESP => net_gnd2,
      M_AXI_IP_RLAST => net_gnd0,
      M_AXI_IP_RVALID => net_gnd0,
      M_AXI_IP_RREADY => open,
      M_AXI_DP_AWID => axi4lite_0_S_AWID(0 to 0),
      M_AXI_DP_AWADDR => axi4lite_0_S_AWADDR,
      M_AXI_DP_AWLEN => axi4lite_0_S_AWLEN,
      M_AXI_DP_AWSIZE => axi4lite_0_S_AWSIZE,
      M_AXI_DP_AWBURST => axi4lite_0_S_AWBURST,
      M_AXI_DP_AWLOCK => axi4lite_0_S_AWLOCK(0),
      M_AXI_DP_AWCACHE => axi4lite_0_S_AWCACHE,
      M_AXI_DP_AWPROT => axi4lite_0_S_AWPROT,
      M_AXI_DP_AWQOS => axi4lite_0_S_AWQOS,
      M_AXI_DP_AWVALID => axi4lite_0_S_AWVALID(0),
      M_AXI_DP_AWREADY => axi4lite_0_S_AWREADY(0),
      M_AXI_DP_WDATA => axi4lite_0_S_WDATA,
      M_AXI_DP_WSTRB => axi4lite_0_S_WSTRB,
      M_AXI_DP_WLAST => axi4lite_0_S_WLAST(0),
      M_AXI_DP_WVALID => axi4lite_0_S_WVALID(0),
      M_AXI_DP_WREADY => axi4lite_0_S_WREADY(0),
      M_AXI_DP_BID => axi4lite_0_S_BID(0 downto 0),
      M_AXI_DP_BRESP => axi4lite_0_S_BRESP,
      M_AXI_DP_BVALID => axi4lite_0_S_BVALID(0),
      M_AXI_DP_BREADY => axi4lite_0_S_BREADY(0),
      M_AXI_DP_ARID => axi4lite_0_S_ARID(0 to 0),
      M_AXI_DP_ARADDR => axi4lite_0_S_ARADDR,
      M_AXI_DP_ARLEN => axi4lite_0_S_ARLEN,
      M_AXI_DP_ARSIZE => axi4lite_0_S_ARSIZE,
      M_AXI_DP_ARBURST => axi4lite_0_S_ARBURST,
      M_AXI_DP_ARLOCK => axi4lite_0_S_ARLOCK(0),
      M_AXI_DP_ARCACHE => axi4lite_0_S_ARCACHE,
      M_AXI_DP_ARPROT => axi4lite_0_S_ARPROT,
      M_AXI_DP_ARQOS => axi4lite_0_S_ARQOS,
      M_AXI_DP_ARVALID => axi4lite_0_S_ARVALID(0),
      M_AXI_DP_ARREADY => axi4lite_0_S_ARREADY(0),
      M_AXI_DP_RID => axi4lite_0_S_RID(0 downto 0),
      M_AXI_DP_RDATA => axi4lite_0_S_RDATA,
      M_AXI_DP_RRESP => axi4lite_0_S_RRESP,
      M_AXI_DP_RLAST => axi4lite_0_S_RLAST(0),
      M_AXI_DP_RVALID => axi4lite_0_S_RVALID(0),
      M_AXI_DP_RREADY => axi4lite_0_S_RREADY(0),
      M_AXI_IC_AWID => axi4_0_S_AWID(1 downto 1),
      M_AXI_IC_AWADDR => axi4_0_S_AWADDR(63 downto 32),
      M_AXI_IC_AWLEN => axi4_0_S_AWLEN(15 downto 8),
      M_AXI_IC_AWSIZE => axi4_0_S_AWSIZE(5 downto 3),
      M_AXI_IC_AWBURST => axi4_0_S_AWBURST(3 downto 2),
      M_AXI_IC_AWLOCK => axi4_0_S_AWLOCK(2),
      M_AXI_IC_AWCACHE => axi4_0_S_AWCACHE(7 downto 4),
      M_AXI_IC_AWPROT => axi4_0_S_AWPROT(5 downto 3),
      M_AXI_IC_AWQOS => axi4_0_S_AWQOS(7 downto 4),
      M_AXI_IC_AWVALID => axi4_0_S_AWVALID(1),
      M_AXI_IC_AWREADY => axi4_0_S_AWREADY(1),
      M_AXI_IC_AWUSER => axi4_0_S_AWUSER(9 downto 5),
      M_AXI_IC_AWDOMAIN => open,
      M_AXI_IC_AWSNOOP => open,
      M_AXI_IC_AWBAR => open,
      M_AXI_IC_WDATA => axi4_0_S_WDATA(63 downto 32),
      M_AXI_IC_WSTRB => axi4_0_S_WSTRB(7 downto 4),
      M_AXI_IC_WLAST => axi4_0_S_WLAST(1),
      M_AXI_IC_WVALID => axi4_0_S_WVALID(1),
      M_AXI_IC_WREADY => axi4_0_S_WREADY(1),
      M_AXI_IC_WUSER => axi4_0_S_WUSER(1 downto 1),
      M_AXI_IC_BID => axi4_0_S_BID(1 downto 1),
      M_AXI_IC_BRESP => axi4_0_S_BRESP(3 downto 2),
      M_AXI_IC_BVALID => axi4_0_S_BVALID(1),
      M_AXI_IC_BREADY => axi4_0_S_BREADY(1),
      M_AXI_IC_BUSER => axi4_0_S_BUSER(1 downto 1),
      M_AXI_IC_WACK => open,
      M_AXI_IC_ARID => axi4_0_S_ARID(1 downto 1),
      M_AXI_IC_ARADDR => axi4_0_S_ARADDR(63 downto 32),
      M_AXI_IC_ARLEN => axi4_0_S_ARLEN(15 downto 8),
      M_AXI_IC_ARSIZE => axi4_0_S_ARSIZE(5 downto 3),
      M_AXI_IC_ARBURST => axi4_0_S_ARBURST(3 downto 2),
      M_AXI_IC_ARLOCK => axi4_0_S_ARLOCK(2),
      M_AXI_IC_ARCACHE => axi4_0_S_ARCACHE(7 downto 4),
      M_AXI_IC_ARPROT => axi4_0_S_ARPROT(5 downto 3),
      M_AXI_IC_ARQOS => axi4_0_S_ARQOS(7 downto 4),
      M_AXI_IC_ARVALID => axi4_0_S_ARVALID(1),
      M_AXI_IC_ARREADY => axi4_0_S_ARREADY(1),
      M_AXI_IC_ARUSER => axi4_0_S_ARUSER(9 downto 5),
      M_AXI_IC_ARDOMAIN => open,
      M_AXI_IC_ARSNOOP => open,
      M_AXI_IC_ARBAR => open,
      M_AXI_IC_RID => axi4_0_S_RID(1 downto 1),
      M_AXI_IC_RDATA => axi4_0_S_RDATA(63 downto 32),
      M_AXI_IC_RRESP => axi4_0_S_RRESP(3 downto 2),
      M_AXI_IC_RLAST => axi4_0_S_RLAST(1),
      M_AXI_IC_RVALID => axi4_0_S_RVALID(1),
      M_AXI_IC_RREADY => axi4_0_S_RREADY(1),
      M_AXI_IC_RUSER => axi4_0_S_RUSER(1 downto 1),
      M_AXI_IC_RACK => open,
      M_AXI_IC_ACVALID => net_gnd0,
      M_AXI_IC_ACADDR => net_gnd32,
      M_AXI_IC_ACSNOOP => net_gnd4(0 to 3),
      M_AXI_IC_ACPROT => net_gnd3(0 to 2),
      M_AXI_IC_ACREADY => open,
      M_AXI_IC_CRREADY => net_gnd0,
      M_AXI_IC_CRVALID => open,
      M_AXI_IC_CRRESP => open,
      M_AXI_IC_CDVALID => open,
      M_AXI_IC_CDREADY => net_gnd0,
      M_AXI_IC_CDDATA => open,
      M_AXI_IC_CDLAST => open,
      M_AXI_DC_AWID => axi4_0_S_AWID(0 downto 0),
      M_AXI_DC_AWADDR => axi4_0_S_AWADDR(31 downto 0),
      M_AXI_DC_AWLEN => axi4_0_S_AWLEN(7 downto 0),
      M_AXI_DC_AWSIZE => axi4_0_S_AWSIZE(2 downto 0),
      M_AXI_DC_AWBURST => axi4_0_S_AWBURST(1 downto 0),
      M_AXI_DC_AWLOCK => axi4_0_S_AWLOCK(0),
      M_AXI_DC_AWCACHE => axi4_0_S_AWCACHE(3 downto 0),
      M_AXI_DC_AWPROT => axi4_0_S_AWPROT(2 downto 0),
      M_AXI_DC_AWQOS => axi4_0_S_AWQOS(3 downto 0),
      M_AXI_DC_AWVALID => axi4_0_S_AWVALID(0),
      M_AXI_DC_AWREADY => axi4_0_S_AWREADY(0),
      M_AXI_DC_AWUSER => axi4_0_S_AWUSER(4 downto 0),
      M_AXI_DC_AWDOMAIN => open,
      M_AXI_DC_AWSNOOP => open,
      M_AXI_DC_AWBAR => open,
      M_AXI_DC_WDATA => axi4_0_S_WDATA(31 downto 0),
      M_AXI_DC_WSTRB => axi4_0_S_WSTRB(3 downto 0),
      M_AXI_DC_WLAST => axi4_0_S_WLAST(0),
      M_AXI_DC_WVALID => axi4_0_S_WVALID(0),
      M_AXI_DC_WREADY => axi4_0_S_WREADY(0),
      M_AXI_DC_WUSER => axi4_0_S_WUSER(0 downto 0),
      M_AXI_DC_BID => axi4_0_S_BID(0 downto 0),
      M_AXI_DC_BRESP => axi4_0_S_BRESP(1 downto 0),
      M_AXI_DC_BVALID => axi4_0_S_BVALID(0),
      M_AXI_DC_BREADY => axi4_0_S_BREADY(0),
      M_AXI_DC_BUSER => axi4_0_S_BUSER(0 downto 0),
      M_AXI_DC_WACK => open,
      M_AXI_DC_ARID => axi4_0_S_ARID(0 downto 0),
      M_AXI_DC_ARADDR => axi4_0_S_ARADDR(31 downto 0),
      M_AXI_DC_ARLEN => axi4_0_S_ARLEN(7 downto 0),
      M_AXI_DC_ARSIZE => axi4_0_S_ARSIZE(2 downto 0),
      M_AXI_DC_ARBURST => axi4_0_S_ARBURST(1 downto 0),
      M_AXI_DC_ARLOCK => axi4_0_S_ARLOCK(0),
      M_AXI_DC_ARCACHE => axi4_0_S_ARCACHE(3 downto 0),
      M_AXI_DC_ARPROT => axi4_0_S_ARPROT(2 downto 0),
      M_AXI_DC_ARQOS => axi4_0_S_ARQOS(3 downto 0),
      M_AXI_DC_ARVALID => axi4_0_S_ARVALID(0),
      M_AXI_DC_ARREADY => axi4_0_S_ARREADY(0),
      M_AXI_DC_ARUSER => axi4_0_S_ARUSER(4 downto 0),
      M_AXI_DC_ARDOMAIN => open,
      M_AXI_DC_ARSNOOP => open,
      M_AXI_DC_ARBAR => open,
      M_AXI_DC_RID => axi4_0_S_RID(0 downto 0),
      M_AXI_DC_RDATA => axi4_0_S_RDATA(31 downto 0),
      M_AXI_DC_RRESP => axi4_0_S_RRESP(1 downto 0),
      M_AXI_DC_RLAST => axi4_0_S_RLAST(0),
      M_AXI_DC_RVALID => axi4_0_S_RVALID(0),
      M_AXI_DC_RREADY => axi4_0_S_RREADY(0),
      M_AXI_DC_RUSER => axi4_0_S_RUSER(0 downto 0),
      M_AXI_DC_RACK => open,
      M_AXI_DC_ACVALID => net_gnd0,
      M_AXI_DC_ACADDR => net_gnd32,
      M_AXI_DC_ACSNOOP => net_gnd4(0 to 3),
      M_AXI_DC_ACPROT => net_gnd3(0 to 2),
      M_AXI_DC_ACREADY => open,
      M_AXI_DC_CRREADY => net_gnd0,
      M_AXI_DC_CRVALID => open,
      M_AXI_DC_CRRESP => open,
      M_AXI_DC_CDVALID => open,
      M_AXI_DC_CDREADY => net_gnd0,
      M_AXI_DC_CDDATA => open,
      M_AXI_DC_CDLAST => open,
      DBG_CLK => microblaze_0_debug_Dbg_Clk,
      DBG_TDI => microblaze_0_debug_Dbg_TDI,
      DBG_TDO => microblaze_0_debug_Dbg_TDO,
      DBG_REG_EN => microblaze_0_debug_Dbg_Reg_En,
      DBG_SHIFT => microblaze_0_debug_Dbg_Shift,
      DBG_CAPTURE => microblaze_0_debug_Dbg_Capture,
      DBG_UPDATE => microblaze_0_debug_Dbg_Update,
      DEBUG_RST => microblaze_0_debug_Debug_Rst,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_DCache_Rdy => open,
      Trace_DCache_Read => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_ICache_Rdy => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      Trace_Jump_Hit => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32(31 downto 0),
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32(31 downto 0),
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32(31 downto 0),
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32(31 downto 0),
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32(31 downto 0),
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32(31 downto 0),
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32(31 downto 0),
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32(31 downto 0),
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32(31 downto 0),
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32(31 downto 0),
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32(31 downto 0),
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32(31 downto 0),
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32(31 downto 0),
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32(31 downto 0),
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32(31 downto 0),
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32(31 downto 0),
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      M0_AXIS_TLAST => open,
      M0_AXIS_TDATA => open,
      M0_AXIS_TVALID => open,
      M0_AXIS_TREADY => net_gnd0,
      S0_AXIS_TLAST => net_gnd0,
      S0_AXIS_TDATA => net_gnd32,
      S0_AXIS_TVALID => net_gnd0,
      S0_AXIS_TREADY => open,
      M1_AXIS_TLAST => open,
      M1_AXIS_TDATA => open,
      M1_AXIS_TVALID => open,
      M1_AXIS_TREADY => net_gnd0,
      S1_AXIS_TLAST => net_gnd0,
      S1_AXIS_TDATA => net_gnd32,
      S1_AXIS_TVALID => net_gnd0,
      S1_AXIS_TREADY => open,
      M2_AXIS_TLAST => open,
      M2_AXIS_TDATA => open,
      M2_AXIS_TVALID => open,
      M2_AXIS_TREADY => net_gnd0,
      S2_AXIS_TLAST => net_gnd0,
      S2_AXIS_TDATA => net_gnd32,
      S2_AXIS_TVALID => net_gnd0,
      S2_AXIS_TREADY => open,
      M3_AXIS_TLAST => open,
      M3_AXIS_TDATA => open,
      M3_AXIS_TVALID => open,
      M3_AXIS_TREADY => net_gnd0,
      S3_AXIS_TLAST => net_gnd0,
      S3_AXIS_TDATA => net_gnd32,
      S3_AXIS_TVALID => net_gnd0,
      S3_AXIS_TREADY => open,
      M4_AXIS_TLAST => open,
      M4_AXIS_TDATA => open,
      M4_AXIS_TVALID => open,
      M4_AXIS_TREADY => net_gnd0,
      S4_AXIS_TLAST => net_gnd0,
      S4_AXIS_TDATA => net_gnd32,
      S4_AXIS_TVALID => net_gnd0,
      S4_AXIS_TREADY => open,
      M5_AXIS_TLAST => open,
      M5_AXIS_TDATA => open,
      M5_AXIS_TVALID => open,
      M5_AXIS_TREADY => net_gnd0,
      S5_AXIS_TLAST => net_gnd0,
      S5_AXIS_TDATA => net_gnd32,
      S5_AXIS_TVALID => net_gnd0,
      S5_AXIS_TREADY => open,
      M6_AXIS_TLAST => open,
      M6_AXIS_TDATA => open,
      M6_AXIS_TVALID => open,
      M6_AXIS_TREADY => net_gnd0,
      S6_AXIS_TLAST => net_gnd0,
      S6_AXIS_TDATA => net_gnd32,
      S6_AXIS_TVALID => net_gnd0,
      S6_AXIS_TREADY => open,
      M7_AXIS_TLAST => open,
      M7_AXIS_TDATA => open,
      M7_AXIS_TVALID => open,
      M7_AXIS_TREADY => net_gnd0,
      S7_AXIS_TLAST => net_gnd0,
      S7_AXIS_TDATA => net_gnd32,
      S7_AXIS_TVALID => net_gnd0,
      S7_AXIS_TREADY => open,
      M8_AXIS_TLAST => open,
      M8_AXIS_TDATA => open,
      M8_AXIS_TVALID => open,
      M8_AXIS_TREADY => net_gnd0,
      S8_AXIS_TLAST => net_gnd0,
      S8_AXIS_TDATA => net_gnd32,
      S8_AXIS_TVALID => net_gnd0,
      S8_AXIS_TREADY => open,
      M9_AXIS_TLAST => open,
      M9_AXIS_TDATA => open,
      M9_AXIS_TVALID => open,
      M9_AXIS_TREADY => net_gnd0,
      S9_AXIS_TLAST => net_gnd0,
      S9_AXIS_TDATA => net_gnd32,
      S9_AXIS_TVALID => net_gnd0,
      S9_AXIS_TREADY => open,
      M10_AXIS_TLAST => open,
      M10_AXIS_TDATA => open,
      M10_AXIS_TVALID => open,
      M10_AXIS_TREADY => net_gnd0,
      S10_AXIS_TLAST => net_gnd0,
      S10_AXIS_TDATA => net_gnd32,
      S10_AXIS_TVALID => net_gnd0,
      S10_AXIS_TREADY => open,
      M11_AXIS_TLAST => open,
      M11_AXIS_TDATA => open,
      M11_AXIS_TVALID => open,
      M11_AXIS_TREADY => net_gnd0,
      S11_AXIS_TLAST => net_gnd0,
      S11_AXIS_TDATA => net_gnd32,
      S11_AXIS_TVALID => net_gnd0,
      S11_AXIS_TREADY => open,
      M12_AXIS_TLAST => open,
      M12_AXIS_TDATA => open,
      M12_AXIS_TVALID => open,
      M12_AXIS_TREADY => net_gnd0,
      S12_AXIS_TLAST => net_gnd0,
      S12_AXIS_TDATA => net_gnd32,
      S12_AXIS_TVALID => net_gnd0,
      S12_AXIS_TREADY => open,
      M13_AXIS_TLAST => open,
      M13_AXIS_TDATA => open,
      M13_AXIS_TVALID => open,
      M13_AXIS_TREADY => net_gnd0,
      S13_AXIS_TLAST => net_gnd0,
      S13_AXIS_TDATA => net_gnd32,
      S13_AXIS_TVALID => net_gnd0,
      S13_AXIS_TREADY => open,
      M14_AXIS_TLAST => open,
      M14_AXIS_TDATA => open,
      M14_AXIS_TVALID => open,
      M14_AXIS_TREADY => net_gnd0,
      S14_AXIS_TLAST => net_gnd0,
      S14_AXIS_TDATA => net_gnd32,
      S14_AXIS_TVALID => net_gnd0,
      S14_AXIS_TREADY => open,
      M15_AXIS_TLAST => open,
      M15_AXIS_TDATA => open,
      M15_AXIS_TVALID => open,
      M15_AXIS_TREADY => net_gnd0,
      S15_AXIS_TLAST => net_gnd0,
      S15_AXIS_TDATA => net_gnd32,
      S15_AXIS_TVALID => net_gnd0,
      S15_AXIS_TREADY => open,
      ICACHE_FSL_IN_CLK => open,
      ICACHE_FSL_IN_READ => open,
      ICACHE_FSL_IN_DATA => net_gnd32(31 downto 0),
      ICACHE_FSL_IN_CONTROL => net_gnd0,
      ICACHE_FSL_IN_EXISTS => net_gnd0,
      ICACHE_FSL_OUT_CLK => open,
      ICACHE_FSL_OUT_WRITE => open,
      ICACHE_FSL_OUT_DATA => open,
      ICACHE_FSL_OUT_CONTROL => open,
      ICACHE_FSL_OUT_FULL => net_gnd0,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32(31 downto 0),
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  iomodule_0 : mpu_iomodule_0_wrapper
    port map (
      CLK => pgassign1(10),
      Rst => proc_sys_reset_0_Peripheral_Reset(0),
      IO_Addr_Strobe => open,
      IO_Read_Strobe => open,
      IO_Write_Strobe => open,
      IO_Address => open,
      IO_Byte_Enable => open,
      IO_Write_Data => open,
      IO_Read_Data => net_gnd32,
      IO_Ready => net_gnd0,
      UART_Rx => iomodule_0_UART_Rx,
      UART_Tx => iomodule_0_UART_Tx,
      UART_Interrupt => open,
      FIT1_Interrupt => open,
      FIT1_Toggle => open,
      FIT2_Interrupt => open,
      FIT2_Toggle => open,
      FIT3_Interrupt => open,
      FIT3_Toggle => open,
      FIT4_Interrupt => open,
      FIT4_Toggle => open,
      PIT1_Enable => net_gnd0,
      PIT1_Interrupt => open,
      PIT1_Toggle => open,
      PIT2_Enable => net_gnd0,
      PIT2_Interrupt => open,
      PIT2_Toggle => open,
      PIT3_Enable => net_gnd0,
      PIT3_Interrupt => open,
      PIT3_Toggle => open,
      PIT4_Enable => net_gnd0,
      PIT4_Interrupt => open,
      PIT4_Toggle => open,
      GPO1 => iomodule_0_GPO1,
      GPO2 => open,
      GPO3 => open,
      GPO4 => open,
      GPI1 => iomodule_0_GPI1,
      GPI1_Interrupt => open,
      GPI2 => net_gnd32,
      GPI2_Interrupt => open,
      GPI3 => net_gnd32,
      GPI3_Interrupt => open,
      GPI4 => net_gnd32,
      GPI4_Interrupt => open,
      INTC_Interrupt => net_gnd1(0 to 0),
      INTC_IRQ => open,
      INTC_Processor_Ack => net_gnd2,
      INTC_Interrupt_Address => open,
      LMB_ABus => microblaze_0_dlmb_LMB_ABus,
      LMB_WriteDBus => microblaze_0_dlmb_LMB_WriteDBus,
      LMB_AddrStrobe => microblaze_0_dlmb_LMB_AddrStrobe,
      LMB_ReadStrobe => microblaze_0_dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => microblaze_0_dlmb_LMB_WriteStrobe,
      LMB_BE => microblaze_0_dlmb_LMB_BE,
      Sl_DBus => microblaze_0_dlmb_Sl_DBus(32 to 63),
      Sl_Ready => microblaze_0_dlmb_Sl_Ready(1),
      Sl_Wait => microblaze_0_dlmb_Sl_Wait(1),
      Sl_UE => microblaze_0_dlmb_Sl_UE(1),
      Sl_CE => microblaze_0_dlmb_Sl_CE(1)
    );

  ideal_data_in_out : mpu_ideal_data_in_out_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(4),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(136 downto 128),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(4),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(4),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(159 downto 128),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(19 downto 16),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(4),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(4),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(9 downto 8),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(4),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(4),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(136 downto 128),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(4),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(4),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(159 downto 128),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(9 downto 8),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(4),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(4),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => ideal_data_in_out_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_ideal_data_out,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  ideal_address_we : mpu_ideal_address_we_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_1_M_ARESETN(5),
      S_AXI_AWADDR => axi_interconnect_1_M_AWADDR(168 downto 160),
      S_AXI_AWVALID => axi_interconnect_1_M_AWVALID(5),
      S_AXI_AWREADY => axi_interconnect_1_M_AWREADY(5),
      S_AXI_WDATA => axi_interconnect_1_M_WDATA(191 downto 160),
      S_AXI_WSTRB => axi_interconnect_1_M_WSTRB(23 downto 20),
      S_AXI_WVALID => axi_interconnect_1_M_WVALID(5),
      S_AXI_WREADY => axi_interconnect_1_M_WREADY(5),
      S_AXI_BRESP => axi_interconnect_1_M_BRESP(11 downto 10),
      S_AXI_BVALID => axi_interconnect_1_M_BVALID(5),
      S_AXI_BREADY => axi_interconnect_1_M_BREADY(5),
      S_AXI_ARADDR => axi_interconnect_1_M_ARADDR(168 downto 160),
      S_AXI_ARVALID => axi_interconnect_1_M_ARVALID(5),
      S_AXI_ARREADY => axi_interconnect_1_M_ARREADY(5),
      S_AXI_RDATA => axi_interconnect_1_M_RDATA(191 downto 160),
      S_AXI_RRESP => axi_interconnect_1_M_RRESP(11 downto 10),
      S_AXI_RVALID => axi_interconnect_1_M_RVALID(5),
      S_AXI_RREADY => axi_interconnect_1_M_RREADY(5),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd14,
      GPIO_IO_O => ideal_address_we_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd1(0 to 0),
      GPIO2_IO_O => ideal_address_we_GPIO2_IO_O(0 to 0),
      GPIO2_IO_T => open
    );

  error_x21_x22 : mpu_error_x21_x22_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(1),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(40 downto 32),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(1),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(1),
      S_AXI_WDATA => axi4lite_0_M_WDATA(63 downto 32),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(7 downto 4),
      S_AXI_WVALID => axi4lite_0_M_WVALID(1),
      S_AXI_WREADY => axi4lite_0_M_WREADY(1),
      S_AXI_BRESP => axi4lite_0_M_BRESP(3 downto 2),
      S_AXI_BVALID => axi4lite_0_M_BVALID(1),
      S_AXI_BREADY => axi4lite_0_M_BREADY(1),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(40 downto 32),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(1),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(1),
      S_AXI_RDATA => axi4lite_0_M_RDATA(63 downto 32),
      S_AXI_RRESP => axi4lite_0_M_RRESP(3 downto 2),
      S_AXI_RVALID => axi4lite_0_M_RVALID(1),
      S_AXI_RREADY => axi4lite_0_M_RREADY(1),
      IP2INTC_Irpt => open,
      GPIO_IO_I => error_x21_x22_GPIO_IO_I,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => error_x21_x22_GPIO2_IO_I,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_x12_x20 : mpu_error_x12_x20_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(2),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(72 downto 64),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(2),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(2),
      S_AXI_WDATA => axi4lite_0_M_WDATA(95 downto 64),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(11 downto 8),
      S_AXI_WVALID => axi4lite_0_M_WVALID(2),
      S_AXI_WREADY => axi4lite_0_M_WREADY(2),
      S_AXI_BRESP => axi4lite_0_M_BRESP(5 downto 4),
      S_AXI_BVALID => axi4lite_0_M_BVALID(2),
      S_AXI_BREADY => axi4lite_0_M_BREADY(2),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(72 downto 64),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(2),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(2),
      S_AXI_RDATA => axi4lite_0_M_RDATA(95 downto 64),
      S_AXI_RRESP => axi4lite_0_M_RRESP(5 downto 4),
      S_AXI_RVALID => axi4lite_0_M_RVALID(2),
      S_AXI_RREADY => axi4lite_0_M_RREADY(2),
      IP2INTC_Irpt => open,
      GPIO_IO_I => error_x12_x20_GPIO_IO_I,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => error_x12_x20_GPIO2_IO_I,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_x10_x11 : mpu_error_x10_x11_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(3),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(104 downto 96),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(3),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(3),
      S_AXI_WDATA => axi4lite_0_M_WDATA(127 downto 96),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(15 downto 12),
      S_AXI_WVALID => axi4lite_0_M_WVALID(3),
      S_AXI_WREADY => axi4lite_0_M_WREADY(3),
      S_AXI_BRESP => axi4lite_0_M_BRESP(7 downto 6),
      S_AXI_BVALID => axi4lite_0_M_BVALID(3),
      S_AXI_BREADY => axi4lite_0_M_BREADY(3),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(104 downto 96),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(3),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(3),
      S_AXI_RDATA => axi4lite_0_M_RDATA(127 downto 96),
      S_AXI_RRESP => axi4lite_0_M_RRESP(7 downto 6),
      S_AXI_RVALID => axi4lite_0_M_RVALID(3),
      S_AXI_RREADY => axi4lite_0_M_RREADY(3),
      IP2INTC_Irpt => open,
      GPIO_IO_I => error_x10_x11_GPIO_IO_I,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => error_x10_x11_GPIO2_IO_I,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_x01_x02 : mpu_error_x01_x02_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(4),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(136 downto 128),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(4),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(4),
      S_AXI_WDATA => axi4lite_0_M_WDATA(159 downto 128),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(19 downto 16),
      S_AXI_WVALID => axi4lite_0_M_WVALID(4),
      S_AXI_WREADY => axi4lite_0_M_WREADY(4),
      S_AXI_BRESP => axi4lite_0_M_BRESP(9 downto 8),
      S_AXI_BVALID => axi4lite_0_M_BVALID(4),
      S_AXI_BREADY => axi4lite_0_M_BREADY(4),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(136 downto 128),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(4),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(4),
      S_AXI_RDATA => axi4lite_0_M_RDATA(159 downto 128),
      S_AXI_RRESP => axi4lite_0_M_RRESP(9 downto 8),
      S_AXI_RVALID => axi4lite_0_M_RVALID(4),
      S_AXI_RREADY => axi4lite_0_M_RREADY(4),
      IP2INTC_Irpt => open,
      GPIO_IO_I => error_x01_x02_GPIO_IO_I,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => error_x01_x02_GPIO2_IO_I,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_u22_x00 : mpu_error_u22_x00_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(5),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(168 downto 160),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(5),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(5),
      S_AXI_WDATA => axi4lite_0_M_WDATA(191 downto 160),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(23 downto 20),
      S_AXI_WVALID => axi4lite_0_M_WVALID(5),
      S_AXI_WREADY => axi4lite_0_M_WREADY(5),
      S_AXI_BRESP => axi4lite_0_M_BRESP(11 downto 10),
      S_AXI_BVALID => axi4lite_0_M_BVALID(5),
      S_AXI_BREADY => axi4lite_0_M_BREADY(5),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(168 downto 160),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(5),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(5),
      S_AXI_RDATA => axi4lite_0_M_RDATA(191 downto 160),
      S_AXI_RRESP => axi4lite_0_M_RRESP(11 downto 10),
      S_AXI_RVALID => axi4lite_0_M_RVALID(5),
      S_AXI_RREADY => axi4lite_0_M_RREADY(5),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_u22_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_error_x00,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_u20_u21 : mpu_error_u20_u21_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(6),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(200 downto 192),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(6),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(6),
      S_AXI_WDATA => axi4lite_0_M_WDATA(223 downto 192),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(27 downto 24),
      S_AXI_WVALID => axi4lite_0_M_WVALID(6),
      S_AXI_WREADY => axi4lite_0_M_WREADY(6),
      S_AXI_BRESP => axi4lite_0_M_BRESP(13 downto 12),
      S_AXI_BVALID => axi4lite_0_M_BVALID(6),
      S_AXI_BREADY => axi4lite_0_M_BREADY(6),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(200 downto 192),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(6),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(6),
      S_AXI_RDATA => axi4lite_0_M_RDATA(223 downto 192),
      S_AXI_RRESP => axi4lite_0_M_RRESP(13 downto 12),
      S_AXI_RVALID => axi4lite_0_M_RVALID(6),
      S_AXI_RREADY => axi4lite_0_M_RREADY(6),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_u20_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_error_u21_GPIO_IO_I_pin,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_u11_u12 : mpu_error_u11_u12_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(7),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(232 downto 224),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(7),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(7),
      S_AXI_WDATA => axi4lite_0_M_WDATA(255 downto 224),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(31 downto 28),
      S_AXI_WVALID => axi4lite_0_M_WVALID(7),
      S_AXI_WREADY => axi4lite_0_M_WREADY(7),
      S_AXI_BRESP => axi4lite_0_M_BRESP(15 downto 14),
      S_AXI_BVALID => axi4lite_0_M_BVALID(7),
      S_AXI_BREADY => axi4lite_0_M_BREADY(7),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(232 downto 224),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(7),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(7),
      S_AXI_RDATA => axi4lite_0_M_RDATA(255 downto 224),
      S_AXI_RRESP => axi4lite_0_M_RRESP(15 downto 14),
      S_AXI_RVALID => axi4lite_0_M_RVALID(7),
      S_AXI_RREADY => axi4lite_0_M_RREADY(7),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_u11_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => error_u11_u12_GPIO2_IO_I,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_u02_u10 : mpu_error_u02_u10_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(8),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(264 downto 256),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(8),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(8),
      S_AXI_WDATA => axi4lite_0_M_WDATA(287 downto 256),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(35 downto 32),
      S_AXI_WVALID => axi4lite_0_M_WVALID(8),
      S_AXI_WREADY => axi4lite_0_M_WREADY(8),
      S_AXI_BRESP => axi4lite_0_M_BRESP(17 downto 16),
      S_AXI_BVALID => axi4lite_0_M_BVALID(8),
      S_AXI_BREADY => axi4lite_0_M_BREADY(8),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(264 downto 256),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(8),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(8),
      S_AXI_RDATA => axi4lite_0_M_RDATA(287 downto 256),
      S_AXI_RRESP => axi4lite_0_M_RRESP(17 downto 16),
      S_AXI_RVALID => axi4lite_0_M_RVALID(8),
      S_AXI_RREADY => axi4lite_0_M_RREADY(8),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_u02_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_error_u10_GPIO_IO_I_pin,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_u00_u01 : mpu_error_u00_u01_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(9),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(296 downto 288),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(9),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(9),
      S_AXI_WDATA => axi4lite_0_M_WDATA(319 downto 288),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(39 downto 36),
      S_AXI_WVALID => axi4lite_0_M_WVALID(9),
      S_AXI_WREADY => axi4lite_0_M_WREADY(9),
      S_AXI_BRESP => axi4lite_0_M_BRESP(19 downto 18),
      S_AXI_BVALID => axi4lite_0_M_BVALID(9),
      S_AXI_BREADY => axi4lite_0_M_BREADY(9),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(296 downto 288),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(9),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(9),
      S_AXI_RDATA => axi4lite_0_M_RDATA(319 downto 288),
      S_AXI_RRESP => axi4lite_0_M_RRESP(19 downto 18),
      S_AXI_RVALID => axi4lite_0_M_RVALID(9),
      S_AXI_RREADY => axi4lite_0_M_RREADY(9),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_u00_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_error_u01_GPIO2_IO_I_pin,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  error_i_base : mpu_error_i_base_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(10),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(328 downto 320),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(10),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(10),
      S_AXI_WDATA => axi4lite_0_M_WDATA(351 downto 320),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(43 downto 40),
      S_AXI_WVALID => axi4lite_0_M_WVALID(10),
      S_AXI_WREADY => axi4lite_0_M_WREADY(10),
      S_AXI_BRESP => axi4lite_0_M_BRESP(21 downto 20),
      S_AXI_BVALID => axi4lite_0_M_BVALID(10),
      S_AXI_BREADY => axi4lite_0_M_BREADY(10),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(328 downto 320),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(10),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(10),
      S_AXI_RDATA => axi4lite_0_M_RDATA(351 downto 320),
      S_AXI_RRESP => axi4lite_0_M_RRESP(21 downto 20),
      S_AXI_RVALID => axi4lite_0_M_RVALID(10),
      S_AXI_RREADY => axi4lite_0_M_RREADY(10),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_error_GPIO_IO_I_pin,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd32,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  debug_module : mpu_debug_module_wrapper
    port map (
      Interrupt => open,
      Debug_SYS_Rst => proc_sys_reset_0_MB_Debug_Sys_Rst,
      Ext_BRK => Ext_BRK,
      Ext_NM_BRK => Ext_NM_BRK,
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(11),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(383 downto 352),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(11),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(11),
      S_AXI_WDATA => axi4lite_0_M_WDATA(383 downto 352),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(47 downto 44),
      S_AXI_WVALID => axi4lite_0_M_WVALID(11),
      S_AXI_WREADY => axi4lite_0_M_WREADY(11),
      S_AXI_BRESP => axi4lite_0_M_BRESP(23 downto 22),
      S_AXI_BVALID => axi4lite_0_M_BVALID(11),
      S_AXI_BREADY => axi4lite_0_M_BREADY(11),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(383 downto 352),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(11),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(11),
      S_AXI_RDATA => axi4lite_0_M_RDATA(383 downto 352),
      S_AXI_RRESP => axi4lite_0_M_RRESP(23 downto 22),
      S_AXI_RVALID => axi4lite_0_M_RVALID(11),
      S_AXI_RREADY => axi4lite_0_M_RREADY(11),
      SPLB_Clk => net_gnd0,
      SPLB_Rst => net_gnd0,
      PLB_ABus => net_gnd32(31 downto 0),
      PLB_UABus => net_gnd32(31 downto 0),
      PLB_PAValid => net_gnd0,
      PLB_SAValid => net_gnd0,
      PLB_rdPrim => net_gnd0,
      PLB_wrPrim => net_gnd0,
      PLB_masterID => net_gnd3,
      PLB_abort => net_gnd0,
      PLB_busLock => net_gnd0,
      PLB_RNW => net_gnd0,
      PLB_BE => net_gnd4,
      PLB_MSize => net_gnd2(1 downto 0),
      PLB_size => net_gnd4,
      PLB_type => net_gnd3,
      PLB_lockErr => net_gnd0,
      PLB_wrDBus => net_gnd32(31 downto 0),
      PLB_wrBurst => net_gnd0,
      PLB_rdBurst => net_gnd0,
      PLB_wrPendReq => net_gnd0,
      PLB_rdPendReq => net_gnd0,
      PLB_wrPendPri => net_gnd2(1 downto 0),
      PLB_rdPendPri => net_gnd2(1 downto 0),
      PLB_reqPri => net_gnd2(1 downto 0),
      PLB_TAttribute => net_gnd16(15 downto 0),
      Sl_addrAck => open,
      Sl_SSize => open,
      Sl_wait => open,
      Sl_rearbitrate => open,
      Sl_wrDAck => open,
      Sl_wrComp => open,
      Sl_wrBTerm => open,
      Sl_rdDBus => open,
      Sl_rdWdAddr => open,
      Sl_rdDAck => open,
      Sl_rdComp => open,
      Sl_rdBTerm => open,
      Sl_MBusy => open,
      Sl_MWrErr => open,
      Sl_MRdErr => open,
      Sl_MIRQ => open,
      Dbg_Clk_0 => microblaze_0_debug_Dbg_Clk,
      Dbg_TDI_0 => microblaze_0_debug_Dbg_TDI,
      Dbg_TDO_0 => microblaze_0_debug_Dbg_TDO,
      Dbg_Reg_En_0 => microblaze_0_debug_Dbg_Reg_En,
      Dbg_Capture_0 => microblaze_0_debug_Dbg_Capture,
      Dbg_Shift_0 => microblaze_0_debug_Dbg_Shift,
      Dbg_Update_0 => microblaze_0_debug_Dbg_Update,
      Dbg_Rst_0 => microblaze_0_debug_Debug_Rst,
      Dbg_Clk_1 => open,
      Dbg_TDI_1 => open,
      Dbg_TDO_1 => net_gnd0,
      Dbg_Reg_En_1 => open,
      Dbg_Capture_1 => open,
      Dbg_Shift_1 => open,
      Dbg_Update_1 => open,
      Dbg_Rst_1 => open,
      Dbg_Clk_2 => open,
      Dbg_TDI_2 => open,
      Dbg_TDO_2 => net_gnd0,
      Dbg_Reg_En_2 => open,
      Dbg_Capture_2 => open,
      Dbg_Shift_2 => open,
      Dbg_Update_2 => open,
      Dbg_Rst_2 => open,
      Dbg_Clk_3 => open,
      Dbg_TDI_3 => open,
      Dbg_TDO_3 => net_gnd0,
      Dbg_Reg_En_3 => open,
      Dbg_Capture_3 => open,
      Dbg_Shift_3 => open,
      Dbg_Update_3 => open,
      Dbg_Rst_3 => open,
      Dbg_Clk_4 => open,
      Dbg_TDI_4 => open,
      Dbg_TDO_4 => net_gnd0,
      Dbg_Reg_En_4 => open,
      Dbg_Capture_4 => open,
      Dbg_Shift_4 => open,
      Dbg_Update_4 => open,
      Dbg_Rst_4 => open,
      Dbg_Clk_5 => open,
      Dbg_TDI_5 => open,
      Dbg_TDO_5 => net_gnd0,
      Dbg_Reg_En_5 => open,
      Dbg_Capture_5 => open,
      Dbg_Shift_5 => open,
      Dbg_Update_5 => open,
      Dbg_Rst_5 => open,
      Dbg_Clk_6 => open,
      Dbg_TDI_6 => open,
      Dbg_TDO_6 => net_gnd0,
      Dbg_Reg_En_6 => open,
      Dbg_Capture_6 => open,
      Dbg_Shift_6 => open,
      Dbg_Update_6 => open,
      Dbg_Rst_6 => open,
      Dbg_Clk_7 => open,
      Dbg_TDI_7 => open,
      Dbg_TDO_7 => net_gnd0,
      Dbg_Reg_En_7 => open,
      Dbg_Capture_7 => open,
      Dbg_Shift_7 => open,
      Dbg_Update_7 => open,
      Dbg_Rst_7 => open,
      Dbg_Clk_8 => open,
      Dbg_TDI_8 => open,
      Dbg_TDO_8 => net_gnd0,
      Dbg_Reg_En_8 => open,
      Dbg_Capture_8 => open,
      Dbg_Shift_8 => open,
      Dbg_Update_8 => open,
      Dbg_Rst_8 => open,
      Dbg_Clk_9 => open,
      Dbg_TDI_9 => open,
      Dbg_TDO_9 => net_gnd0,
      Dbg_Reg_En_9 => open,
      Dbg_Capture_9 => open,
      Dbg_Shift_9 => open,
      Dbg_Update_9 => open,
      Dbg_Rst_9 => open,
      Dbg_Clk_10 => open,
      Dbg_TDI_10 => open,
      Dbg_TDO_10 => net_gnd0,
      Dbg_Reg_En_10 => open,
      Dbg_Capture_10 => open,
      Dbg_Shift_10 => open,
      Dbg_Update_10 => open,
      Dbg_Rst_10 => open,
      Dbg_Clk_11 => open,
      Dbg_TDI_11 => open,
      Dbg_TDO_11 => net_gnd0,
      Dbg_Reg_En_11 => open,
      Dbg_Capture_11 => open,
      Dbg_Shift_11 => open,
      Dbg_Update_11 => open,
      Dbg_Rst_11 => open,
      Dbg_Clk_12 => open,
      Dbg_TDI_12 => open,
      Dbg_TDO_12 => net_gnd0,
      Dbg_Reg_En_12 => open,
      Dbg_Capture_12 => open,
      Dbg_Shift_12 => open,
      Dbg_Update_12 => open,
      Dbg_Rst_12 => open,
      Dbg_Clk_13 => open,
      Dbg_TDI_13 => open,
      Dbg_TDO_13 => net_gnd0,
      Dbg_Reg_En_13 => open,
      Dbg_Capture_13 => open,
      Dbg_Shift_13 => open,
      Dbg_Update_13 => open,
      Dbg_Rst_13 => open,
      Dbg_Clk_14 => open,
      Dbg_TDI_14 => open,
      Dbg_TDO_14 => net_gnd0,
      Dbg_Reg_En_14 => open,
      Dbg_Capture_14 => open,
      Dbg_Shift_14 => open,
      Dbg_Update_14 => open,
      Dbg_Rst_14 => open,
      Dbg_Clk_15 => open,
      Dbg_TDI_15 => open,
      Dbg_TDO_15 => net_gnd0,
      Dbg_Reg_En_15 => open,
      Dbg_Capture_15 => open,
      Dbg_Shift_15 => open,
      Dbg_Update_15 => open,
      Dbg_Rst_15 => open,
      Dbg_Clk_16 => open,
      Dbg_TDI_16 => open,
      Dbg_TDO_16 => net_gnd0,
      Dbg_Reg_En_16 => open,
      Dbg_Capture_16 => open,
      Dbg_Shift_16 => open,
      Dbg_Update_16 => open,
      Dbg_Rst_16 => open,
      Dbg_Clk_17 => open,
      Dbg_TDI_17 => open,
      Dbg_TDO_17 => net_gnd0,
      Dbg_Reg_En_17 => open,
      Dbg_Capture_17 => open,
      Dbg_Shift_17 => open,
      Dbg_Update_17 => open,
      Dbg_Rst_17 => open,
      Dbg_Clk_18 => open,
      Dbg_TDI_18 => open,
      Dbg_TDO_18 => net_gnd0,
      Dbg_Reg_En_18 => open,
      Dbg_Capture_18 => open,
      Dbg_Shift_18 => open,
      Dbg_Update_18 => open,
      Dbg_Rst_18 => open,
      Dbg_Clk_19 => open,
      Dbg_TDI_19 => open,
      Dbg_TDO_19 => net_gnd0,
      Dbg_Reg_En_19 => open,
      Dbg_Capture_19 => open,
      Dbg_Shift_19 => open,
      Dbg_Update_19 => open,
      Dbg_Rst_19 => open,
      Dbg_Clk_20 => open,
      Dbg_TDI_20 => open,
      Dbg_TDO_20 => net_gnd0,
      Dbg_Reg_En_20 => open,
      Dbg_Capture_20 => open,
      Dbg_Shift_20 => open,
      Dbg_Update_20 => open,
      Dbg_Rst_20 => open,
      Dbg_Clk_21 => open,
      Dbg_TDI_21 => open,
      Dbg_TDO_21 => net_gnd0,
      Dbg_Reg_En_21 => open,
      Dbg_Capture_21 => open,
      Dbg_Shift_21 => open,
      Dbg_Update_21 => open,
      Dbg_Rst_21 => open,
      Dbg_Clk_22 => open,
      Dbg_TDI_22 => open,
      Dbg_TDO_22 => net_gnd0,
      Dbg_Reg_En_22 => open,
      Dbg_Capture_22 => open,
      Dbg_Shift_22 => open,
      Dbg_Update_22 => open,
      Dbg_Rst_22 => open,
      Dbg_Clk_23 => open,
      Dbg_TDI_23 => open,
      Dbg_TDO_23 => net_gnd0,
      Dbg_Reg_En_23 => open,
      Dbg_Capture_23 => open,
      Dbg_Shift_23 => open,
      Dbg_Update_23 => open,
      Dbg_Rst_23 => open,
      Dbg_Clk_24 => open,
      Dbg_TDI_24 => open,
      Dbg_TDO_24 => net_gnd0,
      Dbg_Reg_En_24 => open,
      Dbg_Capture_24 => open,
      Dbg_Shift_24 => open,
      Dbg_Update_24 => open,
      Dbg_Rst_24 => open,
      Dbg_Clk_25 => open,
      Dbg_TDI_25 => open,
      Dbg_TDO_25 => net_gnd0,
      Dbg_Reg_En_25 => open,
      Dbg_Capture_25 => open,
      Dbg_Shift_25 => open,
      Dbg_Update_25 => open,
      Dbg_Rst_25 => open,
      Dbg_Clk_26 => open,
      Dbg_TDI_26 => open,
      Dbg_TDO_26 => net_gnd0,
      Dbg_Reg_En_26 => open,
      Dbg_Capture_26 => open,
      Dbg_Shift_26 => open,
      Dbg_Update_26 => open,
      Dbg_Rst_26 => open,
      Dbg_Clk_27 => open,
      Dbg_TDI_27 => open,
      Dbg_TDO_27 => net_gnd0,
      Dbg_Reg_En_27 => open,
      Dbg_Capture_27 => open,
      Dbg_Shift_27 => open,
      Dbg_Update_27 => open,
      Dbg_Rst_27 => open,
      Dbg_Clk_28 => open,
      Dbg_TDI_28 => open,
      Dbg_TDO_28 => net_gnd0,
      Dbg_Reg_En_28 => open,
      Dbg_Capture_28 => open,
      Dbg_Shift_28 => open,
      Dbg_Update_28 => open,
      Dbg_Rst_28 => open,
      Dbg_Clk_29 => open,
      Dbg_TDI_29 => open,
      Dbg_TDO_29 => net_gnd0,
      Dbg_Reg_En_29 => open,
      Dbg_Capture_29 => open,
      Dbg_Shift_29 => open,
      Dbg_Update_29 => open,
      Dbg_Rst_29 => open,
      Dbg_Clk_30 => open,
      Dbg_TDI_30 => open,
      Dbg_TDO_30 => net_gnd0,
      Dbg_Reg_En_30 => open,
      Dbg_Capture_30 => open,
      Dbg_Shift_30 => open,
      Dbg_Update_30 => open,
      Dbg_Rst_30 => open,
      Dbg_Clk_31 => open,
      Dbg_TDI_31 => open,
      Dbg_TDO_31 => net_gnd0,
      Dbg_Reg_En_31 => open,
      Dbg_Capture_31 => open,
      Dbg_Shift_31 => open,
      Dbg_Update_31 => open,
      Dbg_Rst_31 => open,
      bscan_tdi => open,
      bscan_reset => open,
      bscan_shift => open,
      bscan_update => open,
      bscan_capture => open,
      bscan_sel1 => open,
      bscan_drck1 => open,
      bscan_tdo1 => net_gnd0,
      bscan_ext_tdi => net_gnd0,
      bscan_ext_reset => net_gnd0,
      bscan_ext_shift => net_gnd0,
      bscan_ext_update => net_gnd0,
      bscan_ext_capture => net_gnd0,
      bscan_ext_sel => net_gnd0,
      bscan_ext_drck => net_gnd0,
      bscan_ext_tdo => open,
      Ext_JTAG_DRCK => open,
      Ext_JTAG_RESET => open,
      Ext_JTAG_SEL => open,
      Ext_JTAG_CAPTURE => open,
      Ext_JTAG_SHIFT => open,
      Ext_JTAG_UPDATE => open,
      Ext_JTAG_TDI => open,
      Ext_JTAG_TDO => net_gnd0
    );

  clock_generator_0 : mpu_clock_generator_0_wrapper
    port map (
      CLKIN => GCLK,
      CLKOUT0 => clk_600_0000MHzPLL0_nobuf,
      CLKOUT1 => clk_600_0000MHz180PLL0_nobuf,
      CLKOUT2 => clk_100_0000MHzPLL0(0),
      CLKOUT3 => open,
      CLKOUT4 => open,
      CLKOUT5 => open,
      CLKOUT6 => open,
      CLKOUT7 => open,
      CLKOUT8 => open,
      CLKOUT9 => open,
      CLKOUT10 => open,
      CLKOUT11 => open,
      CLKOUT12 => open,
      CLKOUT13 => open,
      CLKOUT14 => open,
      CLKOUT15 => open,
      CLKFBIN => net_gnd0,
      CLKFBOUT => open,
      PSCLK => net_gnd0,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSDONE => open,
      RST => RESET,
      LOCKED => proc_sys_reset_0_Dcm_locked
    );

  axi_interconnect_2 : mpu_axi_interconnect_2_wrapper
    port map (
      INTERCONNECT_ACLK => pgassign1(10),
      INTERCONNECT_ARESETN => proc_sys_reset_0_Interconnect_aresetn(0),
      S_AXI_ARESET_OUT_N => open,
      M_AXI_ARESET_OUT_N => axi_interconnect_2_M_ARESETN,
      IRQ => open,
      S_AXI_ACLK => pgassign1(10 downto 10),
      S_AXI_AWID => axi_interconnect_2_S_AWID(0 to 0),
      S_AXI_AWADDR => axi_interconnect_2_S_AWADDR,
      S_AXI_AWLEN => axi_interconnect_2_S_AWLEN,
      S_AXI_AWSIZE => axi_interconnect_2_S_AWSIZE,
      S_AXI_AWBURST => axi_interconnect_2_S_AWBURST,
      S_AXI_AWLOCK => axi_interconnect_2_S_AWLOCK,
      S_AXI_AWCACHE => axi_interconnect_2_S_AWCACHE,
      S_AXI_AWPROT => axi_interconnect_2_S_AWPROT,
      S_AXI_AWQOS => axi_interconnect_2_S_AWQOS,
      S_AXI_AWUSER => axi_interconnect_2_S_AWUSER(0 to 0),
      S_AXI_AWVALID => axi_interconnect_2_S_AWVALID(0 to 0),
      S_AXI_AWREADY => axi_interconnect_2_S_AWREADY(0 to 0),
      S_AXI_WID => axi_interconnect_2_S_WID(0 to 0),
      S_AXI_WDATA => axi_interconnect_2_S_WDATA,
      S_AXI_WSTRB => axi_interconnect_2_S_WSTRB,
      S_AXI_WLAST => axi_interconnect_2_S_WLAST(0 to 0),
      S_AXI_WUSER => axi_interconnect_2_S_WUSER(0 to 0),
      S_AXI_WVALID => axi_interconnect_2_S_WVALID(0 to 0),
      S_AXI_WREADY => axi_interconnect_2_S_WREADY(0 to 0),
      S_AXI_BID => axi_interconnect_2_S_BID(0 to 0),
      S_AXI_BRESP => axi_interconnect_2_S_BRESP,
      S_AXI_BUSER => axi_interconnect_2_S_BUSER(0 to 0),
      S_AXI_BVALID => axi_interconnect_2_S_BVALID(0 to 0),
      S_AXI_BREADY => axi_interconnect_2_S_BREADY(0 to 0),
      S_AXI_ARID => axi_interconnect_2_S_ARID(0 to 0),
      S_AXI_ARADDR => axi_interconnect_2_S_ARADDR,
      S_AXI_ARLEN => axi_interconnect_2_S_ARLEN,
      S_AXI_ARSIZE => axi_interconnect_2_S_ARSIZE,
      S_AXI_ARBURST => axi_interconnect_2_S_ARBURST,
      S_AXI_ARLOCK => axi_interconnect_2_S_ARLOCK,
      S_AXI_ARCACHE => axi_interconnect_2_S_ARCACHE,
      S_AXI_ARPROT => axi_interconnect_2_S_ARPROT,
      S_AXI_ARQOS => axi_interconnect_2_S_ARQOS,
      S_AXI_ARUSER => axi_interconnect_2_S_ARUSER(0 to 0),
      S_AXI_ARVALID => axi_interconnect_2_S_ARVALID(0 to 0),
      S_AXI_ARREADY => axi_interconnect_2_S_ARREADY(0 to 0),
      S_AXI_RID => axi_interconnect_2_S_RID(0 to 0),
      S_AXI_RDATA => axi_interconnect_2_S_RDATA,
      S_AXI_RRESP => axi_interconnect_2_S_RRESP,
      S_AXI_RLAST => axi_interconnect_2_S_RLAST(0 to 0),
      S_AXI_RUSER => axi_interconnect_2_S_RUSER(0 to 0),
      S_AXI_RVALID => axi_interconnect_2_S_RVALID(0 to 0),
      S_AXI_RREADY => axi_interconnect_2_S_RREADY(0 to 0),
      M_AXI_ACLK => pgassign1,
      M_AXI_AWID => open,
      M_AXI_AWADDR => axi_interconnect_2_M_AWADDR,
      M_AXI_AWLEN => open,
      M_AXI_AWSIZE => open,
      M_AXI_AWBURST => open,
      M_AXI_AWLOCK => open,
      M_AXI_AWCACHE => open,
      M_AXI_AWPROT => open,
      M_AXI_AWREGION => open,
      M_AXI_AWQOS => open,
      M_AXI_AWUSER => open,
      M_AXI_AWVALID => axi_interconnect_2_M_AWVALID,
      M_AXI_AWREADY => axi_interconnect_2_M_AWREADY,
      M_AXI_WID => open,
      M_AXI_WDATA => axi_interconnect_2_M_WDATA,
      M_AXI_WSTRB => axi_interconnect_2_M_WSTRB,
      M_AXI_WLAST => open,
      M_AXI_WUSER => open,
      M_AXI_WVALID => axi_interconnect_2_M_WVALID,
      M_AXI_WREADY => axi_interconnect_2_M_WREADY,
      M_AXI_BID => net_gnd11,
      M_AXI_BRESP => axi_interconnect_2_M_BRESP,
      M_AXI_BUSER => net_gnd11,
      M_AXI_BVALID => axi_interconnect_2_M_BVALID,
      M_AXI_BREADY => axi_interconnect_2_M_BREADY,
      M_AXI_ARID => open,
      M_AXI_ARADDR => axi_interconnect_2_M_ARADDR,
      M_AXI_ARLEN => open,
      M_AXI_ARSIZE => open,
      M_AXI_ARBURST => open,
      M_AXI_ARLOCK => open,
      M_AXI_ARCACHE => open,
      M_AXI_ARPROT => open,
      M_AXI_ARREGION => open,
      M_AXI_ARQOS => open,
      M_AXI_ARUSER => open,
      M_AXI_ARVALID => axi_interconnect_2_M_ARVALID,
      M_AXI_ARREADY => axi_interconnect_2_M_ARREADY,
      M_AXI_RID => net_gnd11,
      M_AXI_RDATA => axi_interconnect_2_M_RDATA,
      M_AXI_RRESP => axi_interconnect_2_M_RRESP,
      M_AXI_RLAST => net_gnd11,
      M_AXI_RUSER => net_gnd11,
      M_AXI_RVALID => axi_interconnect_2_M_RVALID,
      M_AXI_RREADY => axi_interconnect_2_M_RREADY,
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0,
      INTERCONNECT_ARESET_OUT_N => open,
      DEBUG_AW_TRANS_SEQ => open,
      DEBUG_AW_ARB_GRANT => open,
      DEBUG_AR_TRANS_SEQ => open,
      DEBUG_AR_ARB_GRANT => open,
      DEBUG_AW_TRANS_QUAL => open,
      DEBUG_AW_ACCEPT_CNT => open,
      DEBUG_AW_ACTIVE_THREAD => open,
      DEBUG_AW_ACTIVE_TARGET => open,
      DEBUG_AW_ACTIVE_REGION => open,
      DEBUG_AW_ERROR => open,
      DEBUG_AW_TARGET => open,
      DEBUG_AR_TRANS_QUAL => open,
      DEBUG_AR_ACCEPT_CNT => open,
      DEBUG_AR_ACTIVE_THREAD => open,
      DEBUG_AR_ACTIVE_TARGET => open,
      DEBUG_AR_ACTIVE_REGION => open,
      DEBUG_AR_ERROR => open,
      DEBUG_AR_TARGET => open,
      DEBUG_B_TRANS_SEQ => open,
      DEBUG_R_BEAT_CNT => open,
      DEBUG_R_TRANS_SEQ => open,
      DEBUG_AW_ISSUING_CNT => open,
      DEBUG_AR_ISSUING_CNT => open,
      DEBUG_W_BEAT_CNT => open,
      DEBUG_W_TRANS_SEQ => open,
      DEBUG_BID_TARGET => open,
      DEBUG_BID_ERROR => open,
      DEBUG_RID_TARGET => open,
      DEBUG_RID_ERROR => open,
      DEBUG_SR_SC_ARADDR => open,
      DEBUG_SR_SC_ARADDRCONTROL => open,
      DEBUG_SR_SC_AWADDR => open,
      DEBUG_SR_SC_AWADDRCONTROL => open,
      DEBUG_SR_SC_BRESP => open,
      DEBUG_SR_SC_RDATA => open,
      DEBUG_SR_SC_RDATACONTROL => open,
      DEBUG_SR_SC_WDATA => open,
      DEBUG_SR_SC_WDATACONTROL => open,
      DEBUG_SC_SF_ARADDR => open,
      DEBUG_SC_SF_ARADDRCONTROL => open,
      DEBUG_SC_SF_AWADDR => open,
      DEBUG_SC_SF_AWADDRCONTROL => open,
      DEBUG_SC_SF_BRESP => open,
      DEBUG_SC_SF_RDATA => open,
      DEBUG_SC_SF_RDATACONTROL => open,
      DEBUG_SC_SF_WDATA => open,
      DEBUG_SC_SF_WDATACONTROL => open,
      DEBUG_SF_CB_ARADDR => open,
      DEBUG_SF_CB_ARADDRCONTROL => open,
      DEBUG_SF_CB_AWADDR => open,
      DEBUG_SF_CB_AWADDRCONTROL => open,
      DEBUG_SF_CB_BRESP => open,
      DEBUG_SF_CB_RDATA => open,
      DEBUG_SF_CB_RDATACONTROL => open,
      DEBUG_SF_CB_WDATA => open,
      DEBUG_SF_CB_WDATACONTROL => open,
      DEBUG_CB_MF_ARADDR => open,
      DEBUG_CB_MF_ARADDRCONTROL => open,
      DEBUG_CB_MF_AWADDR => open,
      DEBUG_CB_MF_AWADDRCONTROL => open,
      DEBUG_CB_MF_BRESP => open,
      DEBUG_CB_MF_RDATA => open,
      DEBUG_CB_MF_RDATACONTROL => open,
      DEBUG_CB_MF_WDATA => open,
      DEBUG_CB_MF_WDATACONTROL => open,
      DEBUG_MF_MC_ARADDR => open,
      DEBUG_MF_MC_ARADDRCONTROL => open,
      DEBUG_MF_MC_AWADDR => open,
      DEBUG_MF_MC_AWADDRCONTROL => open,
      DEBUG_MF_MC_BRESP => open,
      DEBUG_MF_MC_RDATA => open,
      DEBUG_MF_MC_RDATACONTROL => open,
      DEBUG_MF_MC_WDATA => open,
      DEBUG_MF_MC_WDATACONTROL => open,
      DEBUG_MC_MP_ARADDR => open,
      DEBUG_MC_MP_ARADDRCONTROL => open,
      DEBUG_MC_MP_AWADDR => open,
      DEBUG_MC_MP_AWADDRCONTROL => open,
      DEBUG_MC_MP_BRESP => open,
      DEBUG_MC_MP_RDATA => open,
      DEBUG_MC_MP_RDATACONTROL => open,
      DEBUG_MC_MP_WDATA => open,
      DEBUG_MC_MP_WDATACONTROL => open,
      DEBUG_MP_MR_ARADDR => open,
      DEBUG_MP_MR_ARADDRCONTROL => open,
      DEBUG_MP_MR_AWADDR => open,
      DEBUG_MP_MR_AWADDRCONTROL => open,
      DEBUG_MP_MR_BRESP => open,
      DEBUG_MP_MR_RDATA => open,
      DEBUG_MP_MR_RDATACONTROL => open,
      DEBUG_MP_MR_WDATA => open,
      DEBUG_MP_MR_WDATACONTROL => open
    );

  axi_interconnect_1 : mpu_axi_interconnect_1_wrapper
    port map (
      INTERCONNECT_ACLK => pgassign1(10),
      INTERCONNECT_ARESETN => proc_sys_reset_0_Interconnect_aresetn(0),
      S_AXI_ARESET_OUT_N => open,
      M_AXI_ARESET_OUT_N => axi_interconnect_1_M_ARESETN,
      IRQ => open,
      S_AXI_ACLK => pgassign1(10 downto 10),
      S_AXI_AWID => axi_interconnect_1_S_AWID(0 to 0),
      S_AXI_AWADDR => axi_interconnect_1_S_AWADDR,
      S_AXI_AWLEN => axi_interconnect_1_S_AWLEN,
      S_AXI_AWSIZE => axi_interconnect_1_S_AWSIZE,
      S_AXI_AWBURST => axi_interconnect_1_S_AWBURST,
      S_AXI_AWLOCK => axi_interconnect_1_S_AWLOCK,
      S_AXI_AWCACHE => axi_interconnect_1_S_AWCACHE,
      S_AXI_AWPROT => axi_interconnect_1_S_AWPROT,
      S_AXI_AWQOS => axi_interconnect_1_S_AWQOS,
      S_AXI_AWUSER => axi_interconnect_1_S_AWUSER(0 to 0),
      S_AXI_AWVALID => axi_interconnect_1_S_AWVALID(0 to 0),
      S_AXI_AWREADY => axi_interconnect_1_S_AWREADY(0 to 0),
      S_AXI_WID => axi_interconnect_1_S_WID(0 to 0),
      S_AXI_WDATA => axi_interconnect_1_S_WDATA,
      S_AXI_WSTRB => axi_interconnect_1_S_WSTRB,
      S_AXI_WLAST => axi_interconnect_1_S_WLAST(0 to 0),
      S_AXI_WUSER => axi_interconnect_1_S_WUSER(0 to 0),
      S_AXI_WVALID => axi_interconnect_1_S_WVALID(0 to 0),
      S_AXI_WREADY => axi_interconnect_1_S_WREADY(0 to 0),
      S_AXI_BID => axi_interconnect_1_S_BID(0 to 0),
      S_AXI_BRESP => axi_interconnect_1_S_BRESP,
      S_AXI_BUSER => axi_interconnect_1_S_BUSER(0 to 0),
      S_AXI_BVALID => axi_interconnect_1_S_BVALID(0 to 0),
      S_AXI_BREADY => axi_interconnect_1_S_BREADY(0 to 0),
      S_AXI_ARID => axi_interconnect_1_S_ARID(0 to 0),
      S_AXI_ARADDR => axi_interconnect_1_S_ARADDR,
      S_AXI_ARLEN => axi_interconnect_1_S_ARLEN,
      S_AXI_ARSIZE => axi_interconnect_1_S_ARSIZE,
      S_AXI_ARBURST => axi_interconnect_1_S_ARBURST,
      S_AXI_ARLOCK => axi_interconnect_1_S_ARLOCK,
      S_AXI_ARCACHE => axi_interconnect_1_S_ARCACHE,
      S_AXI_ARPROT => axi_interconnect_1_S_ARPROT,
      S_AXI_ARQOS => axi_interconnect_1_S_ARQOS,
      S_AXI_ARUSER => axi_interconnect_1_S_ARUSER(0 to 0),
      S_AXI_ARVALID => axi_interconnect_1_S_ARVALID(0 to 0),
      S_AXI_ARREADY => axi_interconnect_1_S_ARREADY(0 to 0),
      S_AXI_RID => axi_interconnect_1_S_RID(0 to 0),
      S_AXI_RDATA => axi_interconnect_1_S_RDATA,
      S_AXI_RRESP => axi_interconnect_1_S_RRESP,
      S_AXI_RLAST => axi_interconnect_1_S_RLAST(0 to 0),
      S_AXI_RUSER => axi_interconnect_1_S_RUSER(0 to 0),
      S_AXI_RVALID => axi_interconnect_1_S_RVALID(0 to 0),
      S_AXI_RREADY => axi_interconnect_1_S_RREADY(0 to 0),
      M_AXI_ACLK => pgassign2,
      M_AXI_AWID => open,
      M_AXI_AWADDR => axi_interconnect_1_M_AWADDR,
      M_AXI_AWLEN => open,
      M_AXI_AWSIZE => open,
      M_AXI_AWBURST => open,
      M_AXI_AWLOCK => open,
      M_AXI_AWCACHE => open,
      M_AXI_AWPROT => open,
      M_AXI_AWREGION => open,
      M_AXI_AWQOS => open,
      M_AXI_AWUSER => open,
      M_AXI_AWVALID => axi_interconnect_1_M_AWVALID,
      M_AXI_AWREADY => axi_interconnect_1_M_AWREADY,
      M_AXI_WID => open,
      M_AXI_WDATA => axi_interconnect_1_M_WDATA,
      M_AXI_WSTRB => axi_interconnect_1_M_WSTRB,
      M_AXI_WLAST => open,
      M_AXI_WUSER => open,
      M_AXI_WVALID => axi_interconnect_1_M_WVALID,
      M_AXI_WREADY => axi_interconnect_1_M_WREADY,
      M_AXI_BID => net_gnd6,
      M_AXI_BRESP => axi_interconnect_1_M_BRESP,
      M_AXI_BUSER => net_gnd6,
      M_AXI_BVALID => axi_interconnect_1_M_BVALID,
      M_AXI_BREADY => axi_interconnect_1_M_BREADY,
      M_AXI_ARID => open,
      M_AXI_ARADDR => axi_interconnect_1_M_ARADDR,
      M_AXI_ARLEN => open,
      M_AXI_ARSIZE => open,
      M_AXI_ARBURST => open,
      M_AXI_ARLOCK => open,
      M_AXI_ARCACHE => open,
      M_AXI_ARPROT => open,
      M_AXI_ARREGION => open,
      M_AXI_ARQOS => open,
      M_AXI_ARUSER => open,
      M_AXI_ARVALID => axi_interconnect_1_M_ARVALID,
      M_AXI_ARREADY => axi_interconnect_1_M_ARREADY,
      M_AXI_RID => net_gnd6,
      M_AXI_RDATA => axi_interconnect_1_M_RDATA,
      M_AXI_RRESP => axi_interconnect_1_M_RRESP,
      M_AXI_RLAST => net_gnd6,
      M_AXI_RUSER => net_gnd6,
      M_AXI_RVALID => axi_interconnect_1_M_RVALID,
      M_AXI_RREADY => axi_interconnect_1_M_RREADY,
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0,
      INTERCONNECT_ARESET_OUT_N => open,
      DEBUG_AW_TRANS_SEQ => open,
      DEBUG_AW_ARB_GRANT => open,
      DEBUG_AR_TRANS_SEQ => open,
      DEBUG_AR_ARB_GRANT => open,
      DEBUG_AW_TRANS_QUAL => open,
      DEBUG_AW_ACCEPT_CNT => open,
      DEBUG_AW_ACTIVE_THREAD => open,
      DEBUG_AW_ACTIVE_TARGET => open,
      DEBUG_AW_ACTIVE_REGION => open,
      DEBUG_AW_ERROR => open,
      DEBUG_AW_TARGET => open,
      DEBUG_AR_TRANS_QUAL => open,
      DEBUG_AR_ACCEPT_CNT => open,
      DEBUG_AR_ACTIVE_THREAD => open,
      DEBUG_AR_ACTIVE_TARGET => open,
      DEBUG_AR_ACTIVE_REGION => open,
      DEBUG_AR_ERROR => open,
      DEBUG_AR_TARGET => open,
      DEBUG_B_TRANS_SEQ => open,
      DEBUG_R_BEAT_CNT => open,
      DEBUG_R_TRANS_SEQ => open,
      DEBUG_AW_ISSUING_CNT => open,
      DEBUG_AR_ISSUING_CNT => open,
      DEBUG_W_BEAT_CNT => open,
      DEBUG_W_TRANS_SEQ => open,
      DEBUG_BID_TARGET => open,
      DEBUG_BID_ERROR => open,
      DEBUG_RID_TARGET => open,
      DEBUG_RID_ERROR => open,
      DEBUG_SR_SC_ARADDR => open,
      DEBUG_SR_SC_ARADDRCONTROL => open,
      DEBUG_SR_SC_AWADDR => open,
      DEBUG_SR_SC_AWADDRCONTROL => open,
      DEBUG_SR_SC_BRESP => open,
      DEBUG_SR_SC_RDATA => open,
      DEBUG_SR_SC_RDATACONTROL => open,
      DEBUG_SR_SC_WDATA => open,
      DEBUG_SR_SC_WDATACONTROL => open,
      DEBUG_SC_SF_ARADDR => open,
      DEBUG_SC_SF_ARADDRCONTROL => open,
      DEBUG_SC_SF_AWADDR => open,
      DEBUG_SC_SF_AWADDRCONTROL => open,
      DEBUG_SC_SF_BRESP => open,
      DEBUG_SC_SF_RDATA => open,
      DEBUG_SC_SF_RDATACONTROL => open,
      DEBUG_SC_SF_WDATA => open,
      DEBUG_SC_SF_WDATACONTROL => open,
      DEBUG_SF_CB_ARADDR => open,
      DEBUG_SF_CB_ARADDRCONTROL => open,
      DEBUG_SF_CB_AWADDR => open,
      DEBUG_SF_CB_AWADDRCONTROL => open,
      DEBUG_SF_CB_BRESP => open,
      DEBUG_SF_CB_RDATA => open,
      DEBUG_SF_CB_RDATACONTROL => open,
      DEBUG_SF_CB_WDATA => open,
      DEBUG_SF_CB_WDATACONTROL => open,
      DEBUG_CB_MF_ARADDR => open,
      DEBUG_CB_MF_ARADDRCONTROL => open,
      DEBUG_CB_MF_AWADDR => open,
      DEBUG_CB_MF_AWADDRCONTROL => open,
      DEBUG_CB_MF_BRESP => open,
      DEBUG_CB_MF_RDATA => open,
      DEBUG_CB_MF_RDATACONTROL => open,
      DEBUG_CB_MF_WDATA => open,
      DEBUG_CB_MF_WDATACONTROL => open,
      DEBUG_MF_MC_ARADDR => open,
      DEBUG_MF_MC_ARADDRCONTROL => open,
      DEBUG_MF_MC_AWADDR => open,
      DEBUG_MF_MC_AWADDRCONTROL => open,
      DEBUG_MF_MC_BRESP => open,
      DEBUG_MF_MC_RDATA => open,
      DEBUG_MF_MC_RDATACONTROL => open,
      DEBUG_MF_MC_WDATA => open,
      DEBUG_MF_MC_WDATACONTROL => open,
      DEBUG_MC_MP_ARADDR => open,
      DEBUG_MC_MP_ARADDRCONTROL => open,
      DEBUG_MC_MP_AWADDR => open,
      DEBUG_MC_MP_AWADDRCONTROL => open,
      DEBUG_MC_MP_BRESP => open,
      DEBUG_MC_MP_RDATA => open,
      DEBUG_MC_MP_RDATACONTROL => open,
      DEBUG_MC_MP_WDATA => open,
      DEBUG_MC_MP_WDATACONTROL => open,
      DEBUG_MP_MR_ARADDR => open,
      DEBUG_MP_MR_ARADDRCONTROL => open,
      DEBUG_MP_MR_AWADDR => open,
      DEBUG_MP_MR_AWADDRCONTROL => open,
      DEBUG_MP_MR_BRESP => open,
      DEBUG_MP_MR_RDATA => open,
      DEBUG_MP_MR_RDATACONTROL => open,
      DEBUG_MP_MR_WDATA => open,
      DEBUG_MP_MR_WDATACONTROL => open
    );

  template_xbnd_ubnd : mpu_template_xbnd_ubnd_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi_interconnect_2_M_ARESETN(10),
      S_AXI_AWADDR => axi_interconnect_2_M_AWADDR(328 downto 320),
      S_AXI_AWVALID => axi_interconnect_2_M_AWVALID(10),
      S_AXI_AWREADY => axi_interconnect_2_M_AWREADY(10),
      S_AXI_WDATA => axi_interconnect_2_M_WDATA(351 downto 320),
      S_AXI_WSTRB => axi_interconnect_2_M_WSTRB(43 downto 40),
      S_AXI_WVALID => axi_interconnect_2_M_WVALID(10),
      S_AXI_WREADY => axi_interconnect_2_M_WREADY(10),
      S_AXI_BRESP => axi_interconnect_2_M_BRESP(21 downto 20),
      S_AXI_BVALID => axi_interconnect_2_M_BVALID(10),
      S_AXI_BREADY => axi_interconnect_2_M_BREADY(10),
      S_AXI_ARADDR => axi_interconnect_2_M_ARADDR(328 downto 320),
      S_AXI_ARVALID => axi_interconnect_2_M_ARVALID(10),
      S_AXI_ARREADY => axi_interconnect_2_M_ARREADY(10),
      S_AXI_RDATA => axi_interconnect_2_M_RDATA(351 downto 320),
      S_AXI_RRESP => axi_interconnect_2_M_RRESP(21 downto 20),
      S_AXI_RVALID => axi_interconnect_2_M_RVALID(10),
      S_AXI_RREADY => axi_interconnect_2_M_RREADY(10),
      IP2INTC_Irpt => open,
      GPIO_IO_I => net_gnd16,
      GPIO_IO_O => template_xbnd_ubnd_GPIO_IO_O,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd16,
      GPIO2_IO_O => template_xbnd_ubnd_GPIO2_IO_O,
      GPIO2_IO_T => open
    );

  axi4lite_0 : mpu_axi4lite_0_wrapper
    port map (
      INTERCONNECT_ACLK => pgassign1(10),
      INTERCONNECT_ARESETN => proc_sys_reset_0_Interconnect_aresetn(0),
      S_AXI_ARESET_OUT_N => open,
      M_AXI_ARESET_OUT_N => axi4lite_0_M_ARESETN,
      IRQ => open,
      S_AXI_ACLK => pgassign1(10 downto 10),
      S_AXI_AWID => axi4lite_0_S_AWID(0 to 0),
      S_AXI_AWADDR => axi4lite_0_S_AWADDR,
      S_AXI_AWLEN => axi4lite_0_S_AWLEN,
      S_AXI_AWSIZE => axi4lite_0_S_AWSIZE,
      S_AXI_AWBURST => axi4lite_0_S_AWBURST,
      S_AXI_AWLOCK => axi4lite_0_S_AWLOCK,
      S_AXI_AWCACHE => axi4lite_0_S_AWCACHE,
      S_AXI_AWPROT => axi4lite_0_S_AWPROT,
      S_AXI_AWQOS => axi4lite_0_S_AWQOS,
      S_AXI_AWUSER => net_gnd1(0 to 0),
      S_AXI_AWVALID => axi4lite_0_S_AWVALID(0 to 0),
      S_AXI_AWREADY => axi4lite_0_S_AWREADY(0 to 0),
      S_AXI_WID => net_gnd1(0 to 0),
      S_AXI_WDATA => axi4lite_0_S_WDATA,
      S_AXI_WSTRB => axi4lite_0_S_WSTRB,
      S_AXI_WLAST => axi4lite_0_S_WLAST(0 to 0),
      S_AXI_WUSER => net_gnd1(0 to 0),
      S_AXI_WVALID => axi4lite_0_S_WVALID(0 to 0),
      S_AXI_WREADY => axi4lite_0_S_WREADY(0 to 0),
      S_AXI_BID => axi4lite_0_S_BID(0 downto 0),
      S_AXI_BRESP => axi4lite_0_S_BRESP,
      S_AXI_BUSER => open,
      S_AXI_BVALID => axi4lite_0_S_BVALID(0 to 0),
      S_AXI_BREADY => axi4lite_0_S_BREADY(0 to 0),
      S_AXI_ARID => axi4lite_0_S_ARID(0 to 0),
      S_AXI_ARADDR => axi4lite_0_S_ARADDR,
      S_AXI_ARLEN => axi4lite_0_S_ARLEN,
      S_AXI_ARSIZE => axi4lite_0_S_ARSIZE,
      S_AXI_ARBURST => axi4lite_0_S_ARBURST,
      S_AXI_ARLOCK => axi4lite_0_S_ARLOCK,
      S_AXI_ARCACHE => axi4lite_0_S_ARCACHE,
      S_AXI_ARPROT => axi4lite_0_S_ARPROT,
      S_AXI_ARQOS => axi4lite_0_S_ARQOS,
      S_AXI_ARUSER => net_gnd1(0 to 0),
      S_AXI_ARVALID => axi4lite_0_S_ARVALID(0 to 0),
      S_AXI_ARREADY => axi4lite_0_S_ARREADY(0 to 0),
      S_AXI_RID => axi4lite_0_S_RID(0 downto 0),
      S_AXI_RDATA => axi4lite_0_S_RDATA,
      S_AXI_RRESP => axi4lite_0_S_RRESP,
      S_AXI_RLAST => axi4lite_0_S_RLAST(0 to 0),
      S_AXI_RUSER => open,
      S_AXI_RVALID => axi4lite_0_S_RVALID(0 to 0),
      S_AXI_RREADY => axi4lite_0_S_RREADY(0 to 0),
      M_AXI_ACLK => pgassign3,
      M_AXI_AWID => axi4lite_0_M_AWID,
      M_AXI_AWADDR => axi4lite_0_M_AWADDR,
      M_AXI_AWLEN => axi4lite_0_M_AWLEN,
      M_AXI_AWSIZE => axi4lite_0_M_AWSIZE,
      M_AXI_AWBURST => axi4lite_0_M_AWBURST,
      M_AXI_AWLOCK => axi4lite_0_M_AWLOCK,
      M_AXI_AWCACHE => axi4lite_0_M_AWCACHE,
      M_AXI_AWPROT => axi4lite_0_M_AWPROT,
      M_AXI_AWREGION => axi4lite_0_M_AWREGION,
      M_AXI_AWQOS => axi4lite_0_M_AWQOS,
      M_AXI_AWUSER => axi4lite_0_M_AWUSER,
      M_AXI_AWVALID => axi4lite_0_M_AWVALID,
      M_AXI_AWREADY => axi4lite_0_M_AWREADY,
      M_AXI_WID => axi4lite_0_M_WID,
      M_AXI_WDATA => axi4lite_0_M_WDATA,
      M_AXI_WSTRB => axi4lite_0_M_WSTRB,
      M_AXI_WLAST => axi4lite_0_M_WLAST,
      M_AXI_WUSER => axi4lite_0_M_WUSER,
      M_AXI_WVALID => axi4lite_0_M_WVALID,
      M_AXI_WREADY => axi4lite_0_M_WREADY,
      M_AXI_BID => axi4lite_0_M_BID,
      M_AXI_BRESP => axi4lite_0_M_BRESP,
      M_AXI_BUSER => axi4lite_0_M_BUSER,
      M_AXI_BVALID => axi4lite_0_M_BVALID,
      M_AXI_BREADY => axi4lite_0_M_BREADY,
      M_AXI_ARID => axi4lite_0_M_ARID,
      M_AXI_ARADDR => axi4lite_0_M_ARADDR,
      M_AXI_ARLEN => axi4lite_0_M_ARLEN,
      M_AXI_ARSIZE => axi4lite_0_M_ARSIZE,
      M_AXI_ARBURST => axi4lite_0_M_ARBURST,
      M_AXI_ARLOCK => axi4lite_0_M_ARLOCK,
      M_AXI_ARCACHE => axi4lite_0_M_ARCACHE,
      M_AXI_ARPROT => axi4lite_0_M_ARPROT,
      M_AXI_ARREGION => axi4lite_0_M_ARREGION,
      M_AXI_ARQOS => axi4lite_0_M_ARQOS,
      M_AXI_ARUSER => axi4lite_0_M_ARUSER,
      M_AXI_ARVALID => axi4lite_0_M_ARVALID,
      M_AXI_ARREADY => axi4lite_0_M_ARREADY,
      M_AXI_RID => axi4lite_0_M_RID,
      M_AXI_RDATA => axi4lite_0_M_RDATA,
      M_AXI_RRESP => axi4lite_0_M_RRESP,
      M_AXI_RLAST => axi4lite_0_M_RLAST,
      M_AXI_RUSER => axi4lite_0_M_RUSER,
      M_AXI_RVALID => axi4lite_0_M_RVALID,
      M_AXI_RREADY => axi4lite_0_M_RREADY,
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0,
      INTERCONNECT_ARESET_OUT_N => open,
      DEBUG_AW_TRANS_SEQ => open,
      DEBUG_AW_ARB_GRANT => open,
      DEBUG_AR_TRANS_SEQ => open,
      DEBUG_AR_ARB_GRANT => open,
      DEBUG_AW_TRANS_QUAL => open,
      DEBUG_AW_ACCEPT_CNT => open,
      DEBUG_AW_ACTIVE_THREAD => open,
      DEBUG_AW_ACTIVE_TARGET => open,
      DEBUG_AW_ACTIVE_REGION => open,
      DEBUG_AW_ERROR => open,
      DEBUG_AW_TARGET => open,
      DEBUG_AR_TRANS_QUAL => open,
      DEBUG_AR_ACCEPT_CNT => open,
      DEBUG_AR_ACTIVE_THREAD => open,
      DEBUG_AR_ACTIVE_TARGET => open,
      DEBUG_AR_ACTIVE_REGION => open,
      DEBUG_AR_ERROR => open,
      DEBUG_AR_TARGET => open,
      DEBUG_B_TRANS_SEQ => open,
      DEBUG_R_BEAT_CNT => open,
      DEBUG_R_TRANS_SEQ => open,
      DEBUG_AW_ISSUING_CNT => open,
      DEBUG_AR_ISSUING_CNT => open,
      DEBUG_W_BEAT_CNT => open,
      DEBUG_W_TRANS_SEQ => open,
      DEBUG_BID_TARGET => open,
      DEBUG_BID_ERROR => open,
      DEBUG_RID_TARGET => open,
      DEBUG_RID_ERROR => open,
      DEBUG_SR_SC_ARADDR => open,
      DEBUG_SR_SC_ARADDRCONTROL => open,
      DEBUG_SR_SC_AWADDR => open,
      DEBUG_SR_SC_AWADDRCONTROL => open,
      DEBUG_SR_SC_BRESP => open,
      DEBUG_SR_SC_RDATA => open,
      DEBUG_SR_SC_RDATACONTROL => open,
      DEBUG_SR_SC_WDATA => open,
      DEBUG_SR_SC_WDATACONTROL => open,
      DEBUG_SC_SF_ARADDR => open,
      DEBUG_SC_SF_ARADDRCONTROL => open,
      DEBUG_SC_SF_AWADDR => open,
      DEBUG_SC_SF_AWADDRCONTROL => open,
      DEBUG_SC_SF_BRESP => open,
      DEBUG_SC_SF_RDATA => open,
      DEBUG_SC_SF_RDATACONTROL => open,
      DEBUG_SC_SF_WDATA => open,
      DEBUG_SC_SF_WDATACONTROL => open,
      DEBUG_SF_CB_ARADDR => open,
      DEBUG_SF_CB_ARADDRCONTROL => open,
      DEBUG_SF_CB_AWADDR => open,
      DEBUG_SF_CB_AWADDRCONTROL => open,
      DEBUG_SF_CB_BRESP => open,
      DEBUG_SF_CB_RDATA => open,
      DEBUG_SF_CB_RDATACONTROL => open,
      DEBUG_SF_CB_WDATA => open,
      DEBUG_SF_CB_WDATACONTROL => open,
      DEBUG_CB_MF_ARADDR => open,
      DEBUG_CB_MF_ARADDRCONTROL => open,
      DEBUG_CB_MF_AWADDR => open,
      DEBUG_CB_MF_AWADDRCONTROL => open,
      DEBUG_CB_MF_BRESP => open,
      DEBUG_CB_MF_RDATA => open,
      DEBUG_CB_MF_RDATACONTROL => open,
      DEBUG_CB_MF_WDATA => open,
      DEBUG_CB_MF_WDATACONTROL => open,
      DEBUG_MF_MC_ARADDR => open,
      DEBUG_MF_MC_ARADDRCONTROL => open,
      DEBUG_MF_MC_AWADDR => open,
      DEBUG_MF_MC_AWADDRCONTROL => open,
      DEBUG_MF_MC_BRESP => open,
      DEBUG_MF_MC_RDATA => open,
      DEBUG_MF_MC_RDATACONTROL => open,
      DEBUG_MF_MC_WDATA => open,
      DEBUG_MF_MC_WDATACONTROL => open,
      DEBUG_MC_MP_ARADDR => open,
      DEBUG_MC_MP_ARADDRCONTROL => open,
      DEBUG_MC_MP_AWADDR => open,
      DEBUG_MC_MP_AWADDRCONTROL => open,
      DEBUG_MC_MP_BRESP => open,
      DEBUG_MC_MP_RDATA => open,
      DEBUG_MC_MP_RDATACONTROL => open,
      DEBUG_MC_MP_WDATA => open,
      DEBUG_MC_MP_WDATACONTROL => open,
      DEBUG_MP_MR_ARADDR => open,
      DEBUG_MP_MR_ARADDRCONTROL => open,
      DEBUG_MP_MR_AWADDR => open,
      DEBUG_MP_MR_AWADDRCONTROL => open,
      DEBUG_MP_MR_BRESP => open,
      DEBUG_MP_MR_RDATA => open,
      DEBUG_MP_MR_RDATACONTROL => open,
      DEBUG_MP_MR_WDATA => open,
      DEBUG_MP_MR_WDATACONTROL => open
    );

  axi4_0 : mpu_axi4_0_wrapper
    port map (
      INTERCONNECT_ACLK => pgassign1(10),
      INTERCONNECT_ARESETN => proc_sys_reset_0_Interconnect_aresetn(0),
      S_AXI_ARESET_OUT_N => open,
      M_AXI_ARESET_OUT_N => axi4_0_M_ARESETN(0 to 0),
      IRQ => open,
      S_AXI_ACLK => pgassign4,
      S_AXI_AWID => axi4_0_S_AWID,
      S_AXI_AWADDR => axi4_0_S_AWADDR,
      S_AXI_AWLEN => axi4_0_S_AWLEN,
      S_AXI_AWSIZE => axi4_0_S_AWSIZE,
      S_AXI_AWBURST => axi4_0_S_AWBURST,
      S_AXI_AWLOCK => axi4_0_S_AWLOCK,
      S_AXI_AWCACHE => axi4_0_S_AWCACHE,
      S_AXI_AWPROT => axi4_0_S_AWPROT,
      S_AXI_AWQOS => axi4_0_S_AWQOS,
      S_AXI_AWUSER => axi4_0_S_AWUSER,
      S_AXI_AWVALID => axi4_0_S_AWVALID,
      S_AXI_AWREADY => axi4_0_S_AWREADY,
      S_AXI_WID => net_gnd2,
      S_AXI_WDATA => axi4_0_S_WDATA,
      S_AXI_WSTRB => axi4_0_S_WSTRB,
      S_AXI_WLAST => axi4_0_S_WLAST,
      S_AXI_WUSER => axi4_0_S_WUSER,
      S_AXI_WVALID => axi4_0_S_WVALID,
      S_AXI_WREADY => axi4_0_S_WREADY,
      S_AXI_BID => axi4_0_S_BID,
      S_AXI_BRESP => axi4_0_S_BRESP,
      S_AXI_BUSER => axi4_0_S_BUSER,
      S_AXI_BVALID => axi4_0_S_BVALID,
      S_AXI_BREADY => axi4_0_S_BREADY,
      S_AXI_ARID => axi4_0_S_ARID,
      S_AXI_ARADDR => axi4_0_S_ARADDR,
      S_AXI_ARLEN => axi4_0_S_ARLEN,
      S_AXI_ARSIZE => axi4_0_S_ARSIZE,
      S_AXI_ARBURST => axi4_0_S_ARBURST,
      S_AXI_ARLOCK => axi4_0_S_ARLOCK,
      S_AXI_ARCACHE => axi4_0_S_ARCACHE,
      S_AXI_ARPROT => axi4_0_S_ARPROT,
      S_AXI_ARQOS => axi4_0_S_ARQOS,
      S_AXI_ARUSER => axi4_0_S_ARUSER,
      S_AXI_ARVALID => axi4_0_S_ARVALID,
      S_AXI_ARREADY => axi4_0_S_ARREADY,
      S_AXI_RID => axi4_0_S_RID,
      S_AXI_RDATA => axi4_0_S_RDATA,
      S_AXI_RRESP => axi4_0_S_RRESP,
      S_AXI_RLAST => axi4_0_S_RLAST,
      S_AXI_RUSER => axi4_0_S_RUSER,
      S_AXI_RVALID => axi4_0_S_RVALID,
      S_AXI_RREADY => axi4_0_S_RREADY,
      M_AXI_ACLK => pgassign1(10 downto 10),
      M_AXI_AWID => axi4_0_M_AWID(0 to 0),
      M_AXI_AWADDR => axi4_0_M_AWADDR,
      M_AXI_AWLEN => axi4_0_M_AWLEN,
      M_AXI_AWSIZE => axi4_0_M_AWSIZE,
      M_AXI_AWBURST => axi4_0_M_AWBURST,
      M_AXI_AWLOCK => axi4_0_M_AWLOCK,
      M_AXI_AWCACHE => axi4_0_M_AWCACHE,
      M_AXI_AWPROT => axi4_0_M_AWPROT,
      M_AXI_AWREGION => open,
      M_AXI_AWQOS => axi4_0_M_AWQOS,
      M_AXI_AWUSER => open,
      M_AXI_AWVALID => axi4_0_M_AWVALID(0 to 0),
      M_AXI_AWREADY => axi4_0_M_AWREADY(0 to 0),
      M_AXI_WID => open,
      M_AXI_WDATA => axi4_0_M_WDATA,
      M_AXI_WSTRB => axi4_0_M_WSTRB,
      M_AXI_WLAST => axi4_0_M_WLAST(0 to 0),
      M_AXI_WUSER => open,
      M_AXI_WVALID => axi4_0_M_WVALID(0 to 0),
      M_AXI_WREADY => axi4_0_M_WREADY(0 to 0),
      M_AXI_BID => axi4_0_M_BID(0 to 0),
      M_AXI_BRESP => axi4_0_M_BRESP,
      M_AXI_BUSER => net_gnd1(0 to 0),
      M_AXI_BVALID => axi4_0_M_BVALID(0 to 0),
      M_AXI_BREADY => axi4_0_M_BREADY(0 to 0),
      M_AXI_ARID => axi4_0_M_ARID(0 to 0),
      M_AXI_ARADDR => axi4_0_M_ARADDR,
      M_AXI_ARLEN => axi4_0_M_ARLEN,
      M_AXI_ARSIZE => axi4_0_M_ARSIZE,
      M_AXI_ARBURST => axi4_0_M_ARBURST,
      M_AXI_ARLOCK => axi4_0_M_ARLOCK,
      M_AXI_ARCACHE => axi4_0_M_ARCACHE,
      M_AXI_ARPROT => axi4_0_M_ARPROT,
      M_AXI_ARREGION => open,
      M_AXI_ARQOS => axi4_0_M_ARQOS,
      M_AXI_ARUSER => open,
      M_AXI_ARVALID => axi4_0_M_ARVALID(0 to 0),
      M_AXI_ARREADY => axi4_0_M_ARREADY(0 to 0),
      M_AXI_RID => axi4_0_M_RID(0 to 0),
      M_AXI_RDATA => axi4_0_M_RDATA,
      M_AXI_RRESP => axi4_0_M_RRESP,
      M_AXI_RLAST => axi4_0_M_RLAST(0 to 0),
      M_AXI_RUSER => net_gnd1(0 to 0),
      M_AXI_RVALID => axi4_0_M_RVALID(0 to 0),
      M_AXI_RREADY => axi4_0_M_RREADY(0 to 0),
      S_AXI_CTRL_AWADDR => net_gnd32,
      S_AXI_CTRL_AWVALID => net_gnd0,
      S_AXI_CTRL_AWREADY => open,
      S_AXI_CTRL_WDATA => net_gnd32,
      S_AXI_CTRL_WVALID => net_gnd0,
      S_AXI_CTRL_WREADY => open,
      S_AXI_CTRL_BRESP => open,
      S_AXI_CTRL_BVALID => open,
      S_AXI_CTRL_BREADY => net_gnd0,
      S_AXI_CTRL_ARADDR => net_gnd32,
      S_AXI_CTRL_ARVALID => net_gnd0,
      S_AXI_CTRL_ARREADY => open,
      S_AXI_CTRL_RDATA => open,
      S_AXI_CTRL_RRESP => open,
      S_AXI_CTRL_RVALID => open,
      S_AXI_CTRL_RREADY => net_gnd0,
      INTERCONNECT_ARESET_OUT_N => open,
      DEBUG_AW_TRANS_SEQ => open,
      DEBUG_AW_ARB_GRANT => open,
      DEBUG_AR_TRANS_SEQ => open,
      DEBUG_AR_ARB_GRANT => open,
      DEBUG_AW_TRANS_QUAL => open,
      DEBUG_AW_ACCEPT_CNT => open,
      DEBUG_AW_ACTIVE_THREAD => open,
      DEBUG_AW_ACTIVE_TARGET => open,
      DEBUG_AW_ACTIVE_REGION => open,
      DEBUG_AW_ERROR => open,
      DEBUG_AW_TARGET => open,
      DEBUG_AR_TRANS_QUAL => open,
      DEBUG_AR_ACCEPT_CNT => open,
      DEBUG_AR_ACTIVE_THREAD => open,
      DEBUG_AR_ACTIVE_TARGET => open,
      DEBUG_AR_ACTIVE_REGION => open,
      DEBUG_AR_ERROR => open,
      DEBUG_AR_TARGET => open,
      DEBUG_B_TRANS_SEQ => open,
      DEBUG_R_BEAT_CNT => open,
      DEBUG_R_TRANS_SEQ => open,
      DEBUG_AW_ISSUING_CNT => open,
      DEBUG_AR_ISSUING_CNT => open,
      DEBUG_W_BEAT_CNT => open,
      DEBUG_W_TRANS_SEQ => open,
      DEBUG_BID_TARGET => open,
      DEBUG_BID_ERROR => open,
      DEBUG_RID_TARGET => open,
      DEBUG_RID_ERROR => open,
      DEBUG_SR_SC_ARADDR => open,
      DEBUG_SR_SC_ARADDRCONTROL => open,
      DEBUG_SR_SC_AWADDR => open,
      DEBUG_SR_SC_AWADDRCONTROL => open,
      DEBUG_SR_SC_BRESP => open,
      DEBUG_SR_SC_RDATA => open,
      DEBUG_SR_SC_RDATACONTROL => open,
      DEBUG_SR_SC_WDATA => open,
      DEBUG_SR_SC_WDATACONTROL => open,
      DEBUG_SC_SF_ARADDR => open,
      DEBUG_SC_SF_ARADDRCONTROL => open,
      DEBUG_SC_SF_AWADDR => open,
      DEBUG_SC_SF_AWADDRCONTROL => open,
      DEBUG_SC_SF_BRESP => open,
      DEBUG_SC_SF_RDATA => open,
      DEBUG_SC_SF_RDATACONTROL => open,
      DEBUG_SC_SF_WDATA => open,
      DEBUG_SC_SF_WDATACONTROL => open,
      DEBUG_SF_CB_ARADDR => open,
      DEBUG_SF_CB_ARADDRCONTROL => open,
      DEBUG_SF_CB_AWADDR => open,
      DEBUG_SF_CB_AWADDRCONTROL => open,
      DEBUG_SF_CB_BRESP => open,
      DEBUG_SF_CB_RDATA => open,
      DEBUG_SF_CB_RDATACONTROL => open,
      DEBUG_SF_CB_WDATA => open,
      DEBUG_SF_CB_WDATACONTROL => open,
      DEBUG_CB_MF_ARADDR => open,
      DEBUG_CB_MF_ARADDRCONTROL => open,
      DEBUG_CB_MF_AWADDR => open,
      DEBUG_CB_MF_AWADDRCONTROL => open,
      DEBUG_CB_MF_BRESP => open,
      DEBUG_CB_MF_RDATA => open,
      DEBUG_CB_MF_RDATACONTROL => open,
      DEBUG_CB_MF_WDATA => open,
      DEBUG_CB_MF_WDATACONTROL => open,
      DEBUG_MF_MC_ARADDR => open,
      DEBUG_MF_MC_ARADDRCONTROL => open,
      DEBUG_MF_MC_AWADDR => open,
      DEBUG_MF_MC_AWADDRCONTROL => open,
      DEBUG_MF_MC_BRESP => open,
      DEBUG_MF_MC_RDATA => open,
      DEBUG_MF_MC_RDATACONTROL => open,
      DEBUG_MF_MC_WDATA => open,
      DEBUG_MF_MC_WDATACONTROL => open,
      DEBUG_MC_MP_ARADDR => open,
      DEBUG_MC_MP_ARADDRCONTROL => open,
      DEBUG_MC_MP_AWADDR => open,
      DEBUG_MC_MP_AWADDRCONTROL => open,
      DEBUG_MC_MP_BRESP => open,
      DEBUG_MC_MP_RDATA => open,
      DEBUG_MC_MP_RDATACONTROL => open,
      DEBUG_MC_MP_WDATA => open,
      DEBUG_MC_MP_WDATACONTROL => open,
      DEBUG_MP_MR_ARADDR => open,
      DEBUG_MP_MR_ARADDRCONTROL => open,
      DEBUG_MP_MR_AWADDR => open,
      DEBUG_MP_MR_AWADDRCONTROL => open,
      DEBUG_MP_MR_BRESP => open,
      DEBUG_MP_MR_RDATA => open,
      DEBUG_MP_MR_RDATACONTROL => open,
      DEBUG_MP_MR_WDATA => open,
      DEBUG_MP_MR_WDATACONTROL => open
    );

  axi2axi_connector_2 : mpu_axi2axi_connector_2_wrapper
    port map (
      ACLK => pgassign1(10),
      ARESETN => axi4lite_0_M_ARESETN(12),
      S_AXI_AWID => axi4lite_0_M_AWID(12 downto 12),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(415 downto 384),
      S_AXI_AWLEN => axi4lite_0_M_AWLEN(103 downto 96),
      S_AXI_AWSIZE => axi4lite_0_M_AWSIZE(38 downto 36),
      S_AXI_AWBURST => axi4lite_0_M_AWBURST(25 downto 24),
      S_AXI_AWLOCK => axi4lite_0_M_AWLOCK(25 downto 24),
      S_AXI_AWCACHE => axi4lite_0_M_AWCACHE(51 downto 48),
      S_AXI_AWPROT => axi4lite_0_M_AWPROT(38 downto 36),
      S_AXI_AWREGION => axi4lite_0_M_AWREGION(51 downto 48),
      S_AXI_AWQOS => axi4lite_0_M_AWQOS(51 downto 48),
      S_AXI_AWUSER => axi4lite_0_M_AWUSER(12 downto 12),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(12),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(12),
      S_AXI_WID => axi4lite_0_M_WID(12 downto 12),
      S_AXI_WDATA => axi4lite_0_M_WDATA(415 downto 384),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(51 downto 48),
      S_AXI_WLAST => axi4lite_0_M_WLAST(12),
      S_AXI_WUSER => axi4lite_0_M_WUSER(12 downto 12),
      S_AXI_WVALID => axi4lite_0_M_WVALID(12),
      S_AXI_WREADY => axi4lite_0_M_WREADY(12),
      S_AXI_BID => axi4lite_0_M_BID(12 downto 12),
      S_AXI_BRESP => axi4lite_0_M_BRESP(25 downto 24),
      S_AXI_BUSER => axi4lite_0_M_BUSER(12 downto 12),
      S_AXI_BVALID => axi4lite_0_M_BVALID(12),
      S_AXI_BREADY => axi4lite_0_M_BREADY(12),
      S_AXI_ARID => axi4lite_0_M_ARID(12 downto 12),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(415 downto 384),
      S_AXI_ARLEN => axi4lite_0_M_ARLEN(103 downto 96),
      S_AXI_ARSIZE => axi4lite_0_M_ARSIZE(38 downto 36),
      S_AXI_ARBURST => axi4lite_0_M_ARBURST(25 downto 24),
      S_AXI_ARLOCK => axi4lite_0_M_ARLOCK(25 downto 24),
      S_AXI_ARCACHE => axi4lite_0_M_ARCACHE(51 downto 48),
      S_AXI_ARPROT => axi4lite_0_M_ARPROT(38 downto 36),
      S_AXI_ARREGION => axi4lite_0_M_ARREGION(51 downto 48),
      S_AXI_ARQOS => axi4lite_0_M_ARQOS(51 downto 48),
      S_AXI_ARUSER => axi4lite_0_M_ARUSER(12 downto 12),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(12),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(12),
      S_AXI_RID => axi4lite_0_M_RID(12 downto 12),
      S_AXI_RDATA => axi4lite_0_M_RDATA(415 downto 384),
      S_AXI_RRESP => axi4lite_0_M_RRESP(25 downto 24),
      S_AXI_RLAST => axi4lite_0_M_RLAST(12),
      S_AXI_RUSER => axi4lite_0_M_RUSER(12 downto 12),
      S_AXI_RVALID => axi4lite_0_M_RVALID(12),
      S_AXI_RREADY => axi4lite_0_M_RREADY(12),
      M_AXI_AWID => axi_interconnect_2_S_AWID(0 to 0),
      M_AXI_AWADDR => axi_interconnect_2_S_AWADDR,
      M_AXI_AWLEN => axi_interconnect_2_S_AWLEN,
      M_AXI_AWSIZE => axi_interconnect_2_S_AWSIZE,
      M_AXI_AWBURST => axi_interconnect_2_S_AWBURST,
      M_AXI_AWLOCK => axi_interconnect_2_S_AWLOCK,
      M_AXI_AWCACHE => axi_interconnect_2_S_AWCACHE,
      M_AXI_AWPROT => axi_interconnect_2_S_AWPROT,
      M_AXI_AWREGION => open,
      M_AXI_AWQOS => axi_interconnect_2_S_AWQOS,
      M_AXI_AWUSER => axi_interconnect_2_S_AWUSER(0 to 0),
      M_AXI_AWVALID => axi_interconnect_2_S_AWVALID(0),
      M_AXI_AWREADY => axi_interconnect_2_S_AWREADY(0),
      M_AXI_WID => axi_interconnect_2_S_WID(0 to 0),
      M_AXI_WDATA => axi_interconnect_2_S_WDATA,
      M_AXI_WSTRB => axi_interconnect_2_S_WSTRB,
      M_AXI_WLAST => axi_interconnect_2_S_WLAST(0),
      M_AXI_WUSER => axi_interconnect_2_S_WUSER(0 to 0),
      M_AXI_WVALID => axi_interconnect_2_S_WVALID(0),
      M_AXI_WREADY => axi_interconnect_2_S_WREADY(0),
      M_AXI_BID => axi_interconnect_2_S_BID(0 to 0),
      M_AXI_BRESP => axi_interconnect_2_S_BRESP,
      M_AXI_BUSER => axi_interconnect_2_S_BUSER(0 to 0),
      M_AXI_BVALID => axi_interconnect_2_S_BVALID(0),
      M_AXI_BREADY => axi_interconnect_2_S_BREADY(0),
      M_AXI_ARID => axi_interconnect_2_S_ARID(0 to 0),
      M_AXI_ARADDR => axi_interconnect_2_S_ARADDR,
      M_AXI_ARLEN => axi_interconnect_2_S_ARLEN,
      M_AXI_ARSIZE => axi_interconnect_2_S_ARSIZE,
      M_AXI_ARBURST => axi_interconnect_2_S_ARBURST,
      M_AXI_ARLOCK => axi_interconnect_2_S_ARLOCK,
      M_AXI_ARCACHE => axi_interconnect_2_S_ARCACHE,
      M_AXI_ARPROT => axi_interconnect_2_S_ARPROT,
      M_AXI_ARREGION => open,
      M_AXI_ARQOS => axi_interconnect_2_S_ARQOS,
      M_AXI_ARUSER => axi_interconnect_2_S_ARUSER(0 to 0),
      M_AXI_ARVALID => axi_interconnect_2_S_ARVALID(0),
      M_AXI_ARREADY => axi_interconnect_2_S_ARREADY(0),
      M_AXI_RID => axi_interconnect_2_S_RID(0 to 0),
      M_AXI_RDATA => axi_interconnect_2_S_RDATA,
      M_AXI_RRESP => axi_interconnect_2_S_RRESP,
      M_AXI_RLAST => axi_interconnect_2_S_RLAST(0),
      M_AXI_RUSER => axi_interconnect_2_S_RUSER(0 to 0),
      M_AXI_RVALID => axi_interconnect_2_S_RVALID(0),
      M_AXI_RREADY => axi_interconnect_2_S_RREADY(0)
    );

  axi2axi_connector_1 : mpu_axi2axi_connector_1_wrapper
    port map (
      ACLK => pgassign1(10),
      ARESETN => axi4lite_0_M_ARESETN(13),
      S_AXI_AWID => axi4lite_0_M_AWID(13 downto 13),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(447 downto 416),
      S_AXI_AWLEN => axi4lite_0_M_AWLEN(111 downto 104),
      S_AXI_AWSIZE => axi4lite_0_M_AWSIZE(41 downto 39),
      S_AXI_AWBURST => axi4lite_0_M_AWBURST(27 downto 26),
      S_AXI_AWLOCK => axi4lite_0_M_AWLOCK(27 downto 26),
      S_AXI_AWCACHE => axi4lite_0_M_AWCACHE(55 downto 52),
      S_AXI_AWPROT => axi4lite_0_M_AWPROT(41 downto 39),
      S_AXI_AWREGION => axi4lite_0_M_AWREGION(55 downto 52),
      S_AXI_AWQOS => axi4lite_0_M_AWQOS(55 downto 52),
      S_AXI_AWUSER => axi4lite_0_M_AWUSER(13 downto 13),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(13),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(13),
      S_AXI_WID => axi4lite_0_M_WID(13 downto 13),
      S_AXI_WDATA => axi4lite_0_M_WDATA(447 downto 416),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(55 downto 52),
      S_AXI_WLAST => axi4lite_0_M_WLAST(13),
      S_AXI_WUSER => axi4lite_0_M_WUSER(13 downto 13),
      S_AXI_WVALID => axi4lite_0_M_WVALID(13),
      S_AXI_WREADY => axi4lite_0_M_WREADY(13),
      S_AXI_BID => axi4lite_0_M_BID(13 downto 13),
      S_AXI_BRESP => axi4lite_0_M_BRESP(27 downto 26),
      S_AXI_BUSER => axi4lite_0_M_BUSER(13 downto 13),
      S_AXI_BVALID => axi4lite_0_M_BVALID(13),
      S_AXI_BREADY => axi4lite_0_M_BREADY(13),
      S_AXI_ARID => axi4lite_0_M_ARID(13 downto 13),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(447 downto 416),
      S_AXI_ARLEN => axi4lite_0_M_ARLEN(111 downto 104),
      S_AXI_ARSIZE => axi4lite_0_M_ARSIZE(41 downto 39),
      S_AXI_ARBURST => axi4lite_0_M_ARBURST(27 downto 26),
      S_AXI_ARLOCK => axi4lite_0_M_ARLOCK(27 downto 26),
      S_AXI_ARCACHE => axi4lite_0_M_ARCACHE(55 downto 52),
      S_AXI_ARPROT => axi4lite_0_M_ARPROT(41 downto 39),
      S_AXI_ARREGION => axi4lite_0_M_ARREGION(55 downto 52),
      S_AXI_ARQOS => axi4lite_0_M_ARQOS(55 downto 52),
      S_AXI_ARUSER => axi4lite_0_M_ARUSER(13 downto 13),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(13),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(13),
      S_AXI_RID => axi4lite_0_M_RID(13 downto 13),
      S_AXI_RDATA => axi4lite_0_M_RDATA(447 downto 416),
      S_AXI_RRESP => axi4lite_0_M_RRESP(27 downto 26),
      S_AXI_RLAST => axi4lite_0_M_RLAST(13),
      S_AXI_RUSER => axi4lite_0_M_RUSER(13 downto 13),
      S_AXI_RVALID => axi4lite_0_M_RVALID(13),
      S_AXI_RREADY => axi4lite_0_M_RREADY(13),
      M_AXI_AWID => axi_interconnect_1_S_AWID(0 to 0),
      M_AXI_AWADDR => axi_interconnect_1_S_AWADDR,
      M_AXI_AWLEN => axi_interconnect_1_S_AWLEN,
      M_AXI_AWSIZE => axi_interconnect_1_S_AWSIZE,
      M_AXI_AWBURST => axi_interconnect_1_S_AWBURST,
      M_AXI_AWLOCK => axi_interconnect_1_S_AWLOCK,
      M_AXI_AWCACHE => axi_interconnect_1_S_AWCACHE,
      M_AXI_AWPROT => axi_interconnect_1_S_AWPROT,
      M_AXI_AWREGION => open,
      M_AXI_AWQOS => axi_interconnect_1_S_AWQOS,
      M_AXI_AWUSER => axi_interconnect_1_S_AWUSER(0 to 0),
      M_AXI_AWVALID => axi_interconnect_1_S_AWVALID(0),
      M_AXI_AWREADY => axi_interconnect_1_S_AWREADY(0),
      M_AXI_WID => axi_interconnect_1_S_WID(0 to 0),
      M_AXI_WDATA => axi_interconnect_1_S_WDATA,
      M_AXI_WSTRB => axi_interconnect_1_S_WSTRB,
      M_AXI_WLAST => axi_interconnect_1_S_WLAST(0),
      M_AXI_WUSER => axi_interconnect_1_S_WUSER(0 to 0),
      M_AXI_WVALID => axi_interconnect_1_S_WVALID(0),
      M_AXI_WREADY => axi_interconnect_1_S_WREADY(0),
      M_AXI_BID => axi_interconnect_1_S_BID(0 to 0),
      M_AXI_BRESP => axi_interconnect_1_S_BRESP,
      M_AXI_BUSER => axi_interconnect_1_S_BUSER(0 to 0),
      M_AXI_BVALID => axi_interconnect_1_S_BVALID(0),
      M_AXI_BREADY => axi_interconnect_1_S_BREADY(0),
      M_AXI_ARID => axi_interconnect_1_S_ARID(0 to 0),
      M_AXI_ARADDR => axi_interconnect_1_S_ARADDR,
      M_AXI_ARLEN => axi_interconnect_1_S_ARLEN,
      M_AXI_ARSIZE => axi_interconnect_1_S_ARSIZE,
      M_AXI_ARBURST => axi_interconnect_1_S_ARBURST,
      M_AXI_ARLOCK => axi_interconnect_1_S_ARLOCK,
      M_AXI_ARCACHE => axi_interconnect_1_S_ARCACHE,
      M_AXI_ARPROT => axi_interconnect_1_S_ARPROT,
      M_AXI_ARREGION => open,
      M_AXI_ARQOS => axi_interconnect_1_S_ARQOS,
      M_AXI_ARUSER => axi_interconnect_1_S_ARUSER(0 to 0),
      M_AXI_ARVALID => axi_interconnect_1_S_ARVALID(0),
      M_AXI_ARREADY => axi_interconnect_1_S_ARREADY(0),
      M_AXI_RID => axi_interconnect_1_S_RID(0 to 0),
      M_AXI_RDATA => axi_interconnect_1_S_RDATA,
      M_AXI_RRESP => axi_interconnect_1_S_RRESP,
      M_AXI_RLAST => axi_interconnect_1_S_RLAST(0),
      M_AXI_RUSER => axi_interconnect_1_S_RUSER(0 to 0),
      M_AXI_RVALID => axi_interconnect_1_S_RVALID(0),
      M_AXI_RREADY => axi_interconnect_1_S_RREADY(0)
    );

  QSPI_FLASH : mpu_qspi_flash_wrapper
    port map (
      EXT_SPI_CLK => pgassign1(10),
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(14),
      S_AXI4_ACLK => net_gnd0,
      S_AXI4_ARESETN => net_gnd0,
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(454 downto 448),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(14),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(14),
      S_AXI_WDATA => axi4lite_0_M_WDATA(479 downto 448),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(59 downto 56),
      S_AXI_WVALID => axi4lite_0_M_WVALID(14),
      S_AXI_WREADY => axi4lite_0_M_WREADY(14),
      S_AXI_BRESP => axi4lite_0_M_BRESP(29 downto 28),
      S_AXI_BVALID => axi4lite_0_M_BVALID(14),
      S_AXI_BREADY => axi4lite_0_M_BREADY(14),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(454 downto 448),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(14),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(14),
      S_AXI_RDATA => axi4lite_0_M_RDATA(479 downto 448),
      S_AXI_RRESP => axi4lite_0_M_RRESP(29 downto 28),
      S_AXI_RVALID => axi4lite_0_M_RVALID(14),
      S_AXI_RREADY => axi4lite_0_M_RREADY(14),
      S_AXI4_AWID => net_gnd4(0 to 3),
      S_AXI4_AWADDR => net_gnd24,
      S_AXI4_AWLEN => net_gnd8,
      S_AXI4_AWSIZE => net_gnd3(0 to 2),
      S_AXI4_AWBURST => net_gnd2,
      S_AXI4_AWLOCK => net_gnd0,
      S_AXI4_AWCACHE => net_gnd4(0 to 3),
      S_AXI4_AWPROT => net_gnd3(0 to 2),
      S_AXI4_AWVALID => net_gnd0,
      S_AXI4_AWREADY => open,
      S_AXI4_WDATA => net_gnd32,
      S_AXI4_WSTRB => net_gnd4(0 to 3),
      S_AXI4_WLAST => net_gnd0,
      S_AXI4_WVALID => net_gnd0,
      S_AXI4_WREADY => open,
      S_AXI4_BID => open,
      S_AXI4_BRESP => open,
      S_AXI4_BVALID => open,
      S_AXI4_BREADY => net_gnd0,
      S_AXI4_ARID => net_gnd4(0 to 3),
      S_AXI4_ARADDR => net_gnd24,
      S_AXI4_ARLEN => net_gnd8,
      S_AXI4_ARSIZE => net_gnd3(0 to 2),
      S_AXI4_ARBURST => net_gnd2,
      S_AXI4_ARLOCK => net_gnd0,
      S_AXI4_ARCACHE => net_gnd4(0 to 3),
      S_AXI4_ARPROT => net_gnd3(0 to 2),
      S_AXI4_ARVALID => net_gnd0,
      S_AXI4_ARREADY => open,
      S_AXI4_RID => open,
      S_AXI4_RDATA => open,
      S_AXI4_RRESP => open,
      S_AXI4_RLAST => open,
      S_AXI4_RVALID => open,
      S_AXI4_RREADY => net_gnd0,
      SCK_I => QSPI_FLASH_SCLK_I,
      SCK_O => QSPI_FLASH_SCLK_O,
      SCK_T => QSPI_FLASH_SCLK_T,
      SS_I => QSPI_FLASH_SS_I(0 downto 0),
      SS_O => QSPI_FLASH_SS_O(0 downto 0),
      SS_T => QSPI_FLASH_SS_T,
      SPISEL => net_vcc0,
      IP2INTC_Irpt => open,
      IO0_I => QSPI_FLASH_IO0_I,
      IO0_O => QSPI_FLASH_IO0_O,
      IO0_T => QSPI_FLASH_IO0_T,
      IO1_I => QSPI_FLASH_IO1_I,
      IO1_O => QSPI_FLASH_IO1_O,
      IO1_T => QSPI_FLASH_IO1_T,
      IO2_I => net_gnd0,
      IO2_O => open,
      IO2_T => open,
      IO3_I => net_gnd0,
      IO3_O => open,
      IO3_T => open
    );

  MCB_DDR2 : mpu_mcb_ddr2_wrapper
    port map (
      sysclk_2x => clk_600_0000MHzPLL0_nobuf,
      sysclk_2x_180 => clk_600_0000MHz180PLL0_nobuf,
      pll_ce_0 => net_vcc0,
      pll_ce_90 => net_vcc0,
      pll_lock => proc_sys_reset_0_Dcm_locked,
      pll_lock_bufpll_o => open,
      sysclk_2x_bufpll_o => open,
      sysclk_2x_180_bufpll_o => open,
      pll_ce_0_bufpll_o => open,
      pll_ce_90_bufpll_o => open,
      sys_rst => proc_sys_reset_0_BUS_STRUCT_RESET(0),
      mcbx_dram_addr => mcbx_dram_addr,
      mcbx_dram_ba => mcbx_dram_ba,
      mcbx_dram_ras_n => mcbx_dram_ras_n,
      mcbx_dram_cas_n => mcbx_dram_cas_n,
      mcbx_dram_we_n => mcbx_dram_we_n,
      mcbx_dram_cke => mcbx_dram_cke,
      mcbx_dram_clk => mcbx_dram_clk,
      mcbx_dram_clk_n => mcbx_dram_clk_n,
      mcbx_dram_dq => mcbx_dram_dq,
      mcbx_dram_dqs => mcbx_dram_dqs,
      mcbx_dram_dqs_n => mcbx_dram_dqs_n,
      mcbx_dram_udqs => mcbx_dram_udqs,
      mcbx_dram_udqs_n => mcbx_dram_udqs_n,
      mcbx_dram_udm => mcbx_dram_udm,
      mcbx_dram_ldm => mcbx_dram_ldm,
      mcbx_dram_odt => mcbx_dram_odt,
      mcbx_dram_ddr3_rst => open,
      rzq => rzq,
      zio => zio,
      ui_clk => pgassign1(10),
      uo_done_cal => open,
      s0_axi_aclk => pgassign1(10),
      s0_axi_aresetn => axi4_0_M_ARESETN(0),
      s0_axi_awid => axi4_0_M_AWID(0 to 0),
      s0_axi_awaddr => axi4_0_M_AWADDR,
      s0_axi_awlen => axi4_0_M_AWLEN,
      s0_axi_awsize => axi4_0_M_AWSIZE,
      s0_axi_awburst => axi4_0_M_AWBURST,
      s0_axi_awlock => axi4_0_M_AWLOCK(0 downto 0),
      s0_axi_awcache => axi4_0_M_AWCACHE,
      s0_axi_awprot => axi4_0_M_AWPROT,
      s0_axi_awqos => axi4_0_M_AWQOS,
      s0_axi_awvalid => axi4_0_M_AWVALID(0),
      s0_axi_awready => axi4_0_M_AWREADY(0),
      s0_axi_wdata => axi4_0_M_WDATA,
      s0_axi_wstrb => axi4_0_M_WSTRB,
      s0_axi_wlast => axi4_0_M_WLAST(0),
      s0_axi_wvalid => axi4_0_M_WVALID(0),
      s0_axi_wready => axi4_0_M_WREADY(0),
      s0_axi_bid => axi4_0_M_BID(0 to 0),
      s0_axi_bresp => axi4_0_M_BRESP,
      s0_axi_bvalid => axi4_0_M_BVALID(0),
      s0_axi_bready => axi4_0_M_BREADY(0),
      s0_axi_arid => axi4_0_M_ARID(0 to 0),
      s0_axi_araddr => axi4_0_M_ARADDR,
      s0_axi_arlen => axi4_0_M_ARLEN,
      s0_axi_arsize => axi4_0_M_ARSIZE,
      s0_axi_arburst => axi4_0_M_ARBURST,
      s0_axi_arlock => axi4_0_M_ARLOCK(0 downto 0),
      s0_axi_arcache => axi4_0_M_ARCACHE,
      s0_axi_arprot => axi4_0_M_ARPROT,
      s0_axi_arqos => axi4_0_M_ARQOS,
      s0_axi_arvalid => axi4_0_M_ARVALID(0),
      s0_axi_arready => axi4_0_M_ARREADY(0),
      s0_axi_rid => axi4_0_M_RID(0 to 0),
      s0_axi_rdata => axi4_0_M_RDATA,
      s0_axi_rresp => axi4_0_M_RRESP,
      s0_axi_rlast => axi4_0_M_RLAST(0),
      s0_axi_rvalid => axi4_0_M_RVALID(0),
      s0_axi_rready => axi4_0_M_RREADY(0),
      s1_axi_aclk => net_gnd0,
      s1_axi_aresetn => net_gnd0,
      s1_axi_awid => net_gnd4(0 to 3),
      s1_axi_awaddr => net_gnd32,
      s1_axi_awlen => net_gnd8,
      s1_axi_awsize => net_gnd3(0 to 2),
      s1_axi_awburst => net_gnd2,
      s1_axi_awlock => net_gnd1(0 to 0),
      s1_axi_awcache => net_gnd4(0 to 3),
      s1_axi_awprot => net_gnd3(0 to 2),
      s1_axi_awqos => net_gnd4(0 to 3),
      s1_axi_awvalid => net_gnd0,
      s1_axi_awready => open,
      s1_axi_wdata => net_gnd32,
      s1_axi_wstrb => net_gnd4(0 to 3),
      s1_axi_wlast => net_gnd0,
      s1_axi_wvalid => net_gnd0,
      s1_axi_wready => open,
      s1_axi_bid => open,
      s1_axi_bresp => open,
      s1_axi_bvalid => open,
      s1_axi_bready => net_gnd0,
      s1_axi_arid => net_gnd4(0 to 3),
      s1_axi_araddr => net_gnd32,
      s1_axi_arlen => net_gnd8,
      s1_axi_arsize => net_gnd3(0 to 2),
      s1_axi_arburst => net_gnd2,
      s1_axi_arlock => net_gnd1(0 to 0),
      s1_axi_arcache => net_gnd4(0 to 3),
      s1_axi_arprot => net_gnd3(0 to 2),
      s1_axi_arqos => net_gnd4(0 to 3),
      s1_axi_arvalid => net_gnd0,
      s1_axi_arready => open,
      s1_axi_rid => open,
      s1_axi_rdata => open,
      s1_axi_rresp => open,
      s1_axi_rlast => open,
      s1_axi_rvalid => open,
      s1_axi_rready => net_gnd0,
      s2_axi_aclk => net_gnd0,
      s2_axi_aresetn => net_gnd0,
      s2_axi_awid => net_gnd4(0 to 3),
      s2_axi_awaddr => net_gnd32,
      s2_axi_awlen => net_gnd8,
      s2_axi_awsize => net_gnd3(0 to 2),
      s2_axi_awburst => net_gnd2,
      s2_axi_awlock => net_gnd1(0 to 0),
      s2_axi_awcache => net_gnd4(0 to 3),
      s2_axi_awprot => net_gnd3(0 to 2),
      s2_axi_awqos => net_gnd4(0 to 3),
      s2_axi_awvalid => net_gnd0,
      s2_axi_awready => open,
      s2_axi_wdata => net_gnd32,
      s2_axi_wstrb => net_gnd4(0 to 3),
      s2_axi_wlast => net_gnd0,
      s2_axi_wvalid => net_gnd0,
      s2_axi_wready => open,
      s2_axi_bid => open,
      s2_axi_bresp => open,
      s2_axi_bvalid => open,
      s2_axi_bready => net_gnd0,
      s2_axi_arid => net_gnd4(0 to 3),
      s2_axi_araddr => net_gnd32,
      s2_axi_arlen => net_gnd8,
      s2_axi_arsize => net_gnd3(0 to 2),
      s2_axi_arburst => net_gnd2,
      s2_axi_arlock => net_gnd1(0 to 0),
      s2_axi_arcache => net_gnd4(0 to 3),
      s2_axi_arprot => net_gnd3(0 to 2),
      s2_axi_arqos => net_gnd4(0 to 3),
      s2_axi_arvalid => net_gnd0,
      s2_axi_arready => open,
      s2_axi_rid => open,
      s2_axi_rdata => open,
      s2_axi_rresp => open,
      s2_axi_rlast => open,
      s2_axi_rvalid => open,
      s2_axi_rready => net_gnd0,
      s3_axi_aclk => net_gnd0,
      s3_axi_aresetn => net_gnd0,
      s3_axi_awid => net_gnd4(0 to 3),
      s3_axi_awaddr => net_gnd32,
      s3_axi_awlen => net_gnd8,
      s3_axi_awsize => net_gnd3(0 to 2),
      s3_axi_awburst => net_gnd2,
      s3_axi_awlock => net_gnd1(0 to 0),
      s3_axi_awcache => net_gnd4(0 to 3),
      s3_axi_awprot => net_gnd3(0 to 2),
      s3_axi_awqos => net_gnd4(0 to 3),
      s3_axi_awvalid => net_gnd0,
      s3_axi_awready => open,
      s3_axi_wdata => net_gnd32,
      s3_axi_wstrb => net_gnd4(0 to 3),
      s3_axi_wlast => net_gnd0,
      s3_axi_wvalid => net_gnd0,
      s3_axi_wready => open,
      s3_axi_bid => open,
      s3_axi_bresp => open,
      s3_axi_bvalid => open,
      s3_axi_bready => net_gnd0,
      s3_axi_arid => net_gnd4(0 to 3),
      s3_axi_araddr => net_gnd32,
      s3_axi_arlen => net_gnd8,
      s3_axi_arsize => net_gnd3(0 to 2),
      s3_axi_arburst => net_gnd2,
      s3_axi_arlock => net_gnd1(0 to 0),
      s3_axi_arcache => net_gnd4(0 to 3),
      s3_axi_arprot => net_gnd3(0 to 2),
      s3_axi_arqos => net_gnd4(0 to 3),
      s3_axi_arvalid => net_gnd0,
      s3_axi_arready => open,
      s3_axi_rid => open,
      s3_axi_rdata => open,
      s3_axi_rresp => open,
      s3_axi_rlast => open,
      s3_axi_rvalid => open,
      s3_axi_rready => net_gnd0,
      s4_axi_aclk => net_gnd0,
      s4_axi_aresetn => net_gnd0,
      s4_axi_awid => net_gnd4(0 to 3),
      s4_axi_awaddr => net_gnd32,
      s4_axi_awlen => net_gnd8,
      s4_axi_awsize => net_gnd3(0 to 2),
      s4_axi_awburst => net_gnd2,
      s4_axi_awlock => net_gnd1(0 to 0),
      s4_axi_awcache => net_gnd4(0 to 3),
      s4_axi_awprot => net_gnd3(0 to 2),
      s4_axi_awqos => net_gnd4(0 to 3),
      s4_axi_awvalid => net_gnd0,
      s4_axi_awready => open,
      s4_axi_wdata => net_gnd32,
      s4_axi_wstrb => net_gnd4(0 to 3),
      s4_axi_wlast => net_gnd0,
      s4_axi_wvalid => net_gnd0,
      s4_axi_wready => open,
      s4_axi_bid => open,
      s4_axi_bresp => open,
      s4_axi_bvalid => open,
      s4_axi_bready => net_gnd0,
      s4_axi_arid => net_gnd4(0 to 3),
      s4_axi_araddr => net_gnd32,
      s4_axi_arlen => net_gnd8,
      s4_axi_arsize => net_gnd3(0 to 2),
      s4_axi_arburst => net_gnd2,
      s4_axi_arlock => net_gnd1(0 to 0),
      s4_axi_arcache => net_gnd4(0 to 3),
      s4_axi_arprot => net_gnd3(0 to 2),
      s4_axi_arqos => net_gnd4(0 to 3),
      s4_axi_arvalid => net_gnd0,
      s4_axi_arready => open,
      s4_axi_rid => open,
      s4_axi_rdata => open,
      s4_axi_rresp => open,
      s4_axi_rlast => open,
      s4_axi_rvalid => open,
      s4_axi_rready => net_gnd0,
      s5_axi_aclk => net_gnd0,
      s5_axi_aresetn => net_gnd0,
      s5_axi_awid => net_gnd4(0 to 3),
      s5_axi_awaddr => net_gnd32,
      s5_axi_awlen => net_gnd8,
      s5_axi_awsize => net_gnd3(0 to 2),
      s5_axi_awburst => net_gnd2,
      s5_axi_awlock => net_gnd1(0 to 0),
      s5_axi_awcache => net_gnd4(0 to 3),
      s5_axi_awprot => net_gnd3(0 to 2),
      s5_axi_awqos => net_gnd4(0 to 3),
      s5_axi_awvalid => net_gnd0,
      s5_axi_awready => open,
      s5_axi_wdata => net_gnd32,
      s5_axi_wstrb => net_gnd4(0 to 3),
      s5_axi_wlast => net_gnd0,
      s5_axi_wvalid => net_gnd0,
      s5_axi_wready => open,
      s5_axi_bid => open,
      s5_axi_bresp => open,
      s5_axi_bvalid => open,
      s5_axi_bready => net_gnd0,
      s5_axi_arid => net_gnd4(0 to 3),
      s5_axi_araddr => net_gnd32,
      s5_axi_arlen => net_gnd8,
      s5_axi_arsize => net_gnd3(0 to 2),
      s5_axi_arburst => net_gnd2,
      s5_axi_arlock => net_gnd1(0 to 0),
      s5_axi_arcache => net_gnd4(0 to 3),
      s5_axi_arprot => net_gnd3(0 to 2),
      s5_axi_arqos => net_gnd4(0 to 3),
      s5_axi_arvalid => net_gnd0,
      s5_axi_arready => open,
      s5_axi_rid => open,
      s5_axi_rdata => open,
      s5_axi_rresp => open,
      s5_axi_rlast => open,
      s5_axi_rvalid => open,
      s5_axi_rready => net_gnd0
    );

  Ethernet_Lite : mpu_ethernet_lite_wrapper
    port map (
      S_AXI_ACLK => pgassign1(10),
      S_AXI_ARESETN => axi4lite_0_M_ARESETN(15),
      IP2INTC_Irpt => Ethernet_Lite_IP2INTC_Irpt(0),
      S_AXI_AWID => axi4lite_0_M_AWID(15 downto 15),
      S_AXI_AWADDR => axi4lite_0_M_AWADDR(492 downto 480),
      S_AXI_AWLEN => axi4lite_0_M_AWLEN(127 downto 120),
      S_AXI_AWSIZE => axi4lite_0_M_AWSIZE(47 downto 45),
      S_AXI_AWBURST => axi4lite_0_M_AWBURST(31 downto 30),
      S_AXI_AWCACHE => axi4lite_0_M_AWCACHE(63 downto 60),
      S_AXI_AWVALID => axi4lite_0_M_AWVALID(15),
      S_AXI_AWREADY => axi4lite_0_M_AWREADY(15),
      S_AXI_WDATA => axi4lite_0_M_WDATA(511 downto 480),
      S_AXI_WSTRB => axi4lite_0_M_WSTRB(63 downto 60),
      S_AXI_WLAST => axi4lite_0_M_WLAST(15),
      S_AXI_WVALID => axi4lite_0_M_WVALID(15),
      S_AXI_WREADY => axi4lite_0_M_WREADY(15),
      S_AXI_BID => axi4lite_0_M_BID(15 downto 15),
      S_AXI_BRESP => axi4lite_0_M_BRESP(31 downto 30),
      S_AXI_BVALID => axi4lite_0_M_BVALID(15),
      S_AXI_BREADY => axi4lite_0_M_BREADY(15),
      S_AXI_ARID => axi4lite_0_M_ARID(15 downto 15),
      S_AXI_ARADDR => axi4lite_0_M_ARADDR(492 downto 480),
      S_AXI_ARLEN => axi4lite_0_M_ARLEN(127 downto 120),
      S_AXI_ARSIZE => axi4lite_0_M_ARSIZE(47 downto 45),
      S_AXI_ARBURST => axi4lite_0_M_ARBURST(31 downto 30),
      S_AXI_ARCACHE => axi4lite_0_M_ARCACHE(63 downto 60),
      S_AXI_ARVALID => axi4lite_0_M_ARVALID(15),
      S_AXI_ARREADY => axi4lite_0_M_ARREADY(15),
      S_AXI_RID => axi4lite_0_M_RID(15 downto 15),
      S_AXI_RDATA => axi4lite_0_M_RDATA(511 downto 480),
      S_AXI_RRESP => axi4lite_0_M_RRESP(31 downto 30),
      S_AXI_RLAST => axi4lite_0_M_RLAST(15),
      S_AXI_RVALID => axi4lite_0_M_RVALID(15),
      S_AXI_RREADY => axi4lite_0_M_RREADY(15),
      PHY_tx_clk => Ethernet_Lite_TX_CLK,
      PHY_rx_clk => Ethernet_Lite_RX_CLK,
      PHY_crs => Ethernet_Lite_CRS,
      PHY_dv => Ethernet_Lite_RX_DV,
      PHY_rx_data => Ethernet_Lite_RXD,
      PHY_col => Ethernet_Lite_COL,
      PHY_rx_er => Ethernet_Lite_RX_ER,
      PHY_rst_n => Ethernet_Lite_PHY_RST_N,
      PHY_tx_en => Ethernet_Lite_TX_EN,
      PHY_tx_data => Ethernet_Lite_TXD,
      PHY_MDC => Ethernet_Lite_MDC,
      PHY_MDIO_I => Ethernet_Lite_MDIO_I,
      PHY_MDIO_O => Ethernet_Lite_MDIO_O,
      PHY_MDIO_T => Ethernet_Lite_MDIO_T
    );

  iobuf_0 : IOBUF
    port map (
      I => QSPI_FLASH_SS_O(0),
      IO => QSPI_FLASH_SS,
      O => QSPI_FLASH_SS_I(0),
      T => QSPI_FLASH_SS_T
    );

  iobuf_1 : IOBUF
    port map (
      I => QSPI_FLASH_SCLK_O,
      IO => QSPI_FLASH_SCLK,
      O => QSPI_FLASH_SCLK_I,
      T => QSPI_FLASH_SCLK_T
    );

  iobuf_2 : IOBUF
    port map (
      I => QSPI_FLASH_IO1_O,
      IO => QSPI_FLASH_IO1,
      O => QSPI_FLASH_IO1_I,
      T => QSPI_FLASH_IO1_T
    );

  iobuf_3 : IOBUF
    port map (
      I => QSPI_FLASH_IO0_O,
      IO => QSPI_FLASH_IO0,
      O => QSPI_FLASH_IO0_I,
      T => QSPI_FLASH_IO0_T
    );

  iobuf_4 : IOBUF
    port map (
      I => Ethernet_Lite_MDIO_O,
      IO => Ethernet_Lite_MDIO,
      O => Ethernet_Lite_MDIO_I,
      T => Ethernet_Lite_MDIO_T
    );

end architecture STRUCTURE;

