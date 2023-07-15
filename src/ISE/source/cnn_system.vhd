library unisim;
	use unisim.vcomponents.all;
library unimacro;
	use unimacro.vcomponents.all;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_components.all;
	use cnn_library.cnn_constants.all;
	use cnn_library.cnn_types.all;
	
entity cnn_system is
	port
	(
		clk, rst: in  std_logic;
		ready_led: out std_logic;
			
		uart_rx : in std_logic;
		uart_tx : out std_logic;

		mcbx_dram_we_n : out std_logic;
		mcbx_dram_udm : out std_logic;
		mcbx_dram_ras_n : out std_logic;
		mcbx_dram_odt : out std_logic;
		mcbx_dram_ldm : out std_logic;
		mcbx_dram_clk_n : out std_logic;
		mcbx_dram_clk : out std_logic;
		mcbx_dram_cke : out std_logic;
		mcbx_dram_cas_n : out std_logic;
		mcbx_dram_ba : out std_logic_vector(2 downto 0);
		mcbx_dram_addr : out std_logic_vector(12 downto 0);
		mcbx_dram_udqs_n : inout std_logic;
		mcbx_dram_udqs : inout std_logic;
		mcbx_dram_dqs_n : inout std_logic;
		mcbx_dram_dqs : inout std_logic;
		mcbx_dram_dq : inout std_logic_vector(15 downto 0);
		mcbx_zio : inout std_logic;
		mcbx_rzq : inout std_logic;

		Ethernet_Lite_TX_CLK : in std_logic;
		Ethernet_Lite_RX_ER : in std_logic;
		Ethernet_Lite_RX_DV : in std_logic;
		Ethernet_Lite_RX_CLK : in std_logic;
		Ethernet_Lite_RXD : in std_logic_vector(3 downto 0);
		Ethernet_Lite_CRS : in std_logic;
		Ethernet_Lite_COL : in std_logic;
		Ethernet_Lite_TX_EN : out std_logic;
		Ethernet_Lite_TXD : out std_logic_vector(3 downto 0);
		Ethernet_Lite_PHY_RST_N : out std_logic;
		Ethernet_Lite_MDC : out std_logic;
		Ethernet_Lite_MDIO : inout std_logic;

		QSPI_FLASH_SS : inout std_logic;
		QSPI_FLASH_SCLK : inout std_logic;
		QSPI_FLASH_IO1 : inout std_logic;
		QSPI_FLASH_IO0 : inout std_logic
	);
end cnn_system;

architecture Behavioral of cnn_system is
	--for CLOCK
	signal sys_clk: std_logic := '0';
	signal mcu_clk: std_logic := '0';
	
	--for Template Connections
	signal A: patch_unsigned;
	signal B: patch_unsigned;
	signal I: std_logic_vector(busWidth-1 downto 0);
	signal x_bnd: std_logic_vector(busWidth-1 downto 0);
	signal u_bnd: std_logic_vector(busWidth-1 downto 0);
	
	--for CACHE Connections
	signal x_interface_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal x_interface_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal x_interface_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal x_interface_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal u_interface_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal u_interface_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal u_interface_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal u_interface_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');

	signal ideal_interface_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal ideal_interface_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal ideal_interface_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal ideal_interface_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');

	--for Control and Sync
	signal ready: std_logic :='0';

	signal cacheWidth: std_logic_vector(busWidth-1 downto 0);
	signal cacheHeight: std_logic_vector(busWidth-1 downto 0);
	
	signal Ts : std_logic_vector(busWidth-1 downto 0);
	signal iter_cnt: std_logic_vector(busWidth-1 downto 0);
	
	signal cnn_rst: std_logic :='1';
	
	--for TEMPLATE Creation
	signal error_u: error_patch;
	signal error_x: error_patch;
	signal error_i: std_logic_vector(errorWidth-1 downto 0);
			
begin
	ready_led<=ready;
	--Clock
	CLOCKING: cnn_clocking
		port map
		(
			clk, sys_clk, mcu_clk
		);
	--Create PROCESSOR
	PROCESSOR: cnn_processor
		port map
		(
			sys_clk, mcu_clk, cnn_rst, not(cnn_rst), ready,
			
			A, B, I, x_bnd, u_bnd,
			u_interface_we, u_interface_address, u_interface_data_in, u_interface_data_out,
			x_interface_we, x_interface_address, x_interface_data_in, x_interface_data_out,
			ideal_interface_we, ideal_interface_address, ideal_interface_data_in, ideal_interface_data_out,
			
			error_u, error_x, error_i,
			
			cacheWidth, cacheHeight,
			
			Ts, iter_cnt
		);
	--Create INTERFACE
	INTERFACE: cnn_interface
		port map
		(
			sys_clk, rst, ready,
			
			uart_rx, uart_tx,

			mcbx_dram_we_n, mcbx_dram_udm, mcbx_dram_ras_n, mcbx_dram_odt, mcbx_dram_ldm, mcbx_dram_clk_n, mcbx_dram_clk, mcbx_dram_cke, mcbx_dram_cas_n,
			mcbx_dram_ba, mcbx_dram_addr, mcbx_dram_udqs_n, mcbx_dram_udqs, mcbx_dram_dqs_n, mcbx_dram_dqs, mcbx_dram_dq, mcbx_zio, mcbx_rzq,

			Ethernet_Lite_TX_CLK, Ethernet_Lite_RX_ER, Ethernet_Lite_RX_DV, Ethernet_Lite_RX_CLK, Ethernet_Lite_RXD, Ethernet_Lite_CRS,
			Ethernet_Lite_COL, Ethernet_Lite_TX_EN, Ethernet_Lite_TXD, Ethernet_Lite_PHY_RST_N, Ethernet_Lite_MDC, Ethernet_Lite_MDIO,

			QSPI_FLASH_SS, QSPI_FLASH_SCLK, QSPI_FLASH_IO1, QSPI_FLASH_IO0,
			
			A, B, I, x_bnd, u_bnd,
			
			u_interface_we, u_interface_address, u_interface_data_in, u_interface_data_out,
			x_interface_we, x_interface_address, x_interface_data_in, x_interface_data_out,
			ideal_interface_we, ideal_interface_address, ideal_interface_data_in, ideal_interface_data_out,
			
			error_u, error_x, error_i,
			
			cacheWidth, cacheHeight,
			
			Ts, iter_cnt,
			
			cnn_rst
		);
end Behavioral;

