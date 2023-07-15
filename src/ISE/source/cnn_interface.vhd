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

entity cnn_interface is
	port
	(
		mcu_clk , rst : in std_logic;
		ready: in std_logic;
		
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
		QSPI_FLASH_IO0 : inout std_logic;
		
		A: out patch_unsigned;
		B: out patch_unsigned;
		I: out std_logic_vector(busWidth-1 downto 0);
		x_bnd: out std_logic_vector(busWidth-1 downto 0);
		u_bnd: out std_logic_vector(busWidth-1 downto 0);
		
		u_interface_we : out std_logic_vector(0 downto 0);
		u_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
		u_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
		u_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		x_interface_we : out std_logic_vector(0 downto 0);
		x_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
		x_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
		x_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		ideal_interface_we : out std_logic_vector(0 downto 0);
		ideal_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
		ideal_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
		ideal_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		error_u: in error_patch;
		error_x: in error_patch;
		error_i: in std_logic_vector(errorWidth-1 downto 0);
		
		cacheWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		cacheHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		
		Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
		iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
		
		cnn_rst: out std_logic:='1'
	);
end cnn_interface;

architecture Behavioral of cnn_interface is
	--for COMMANDS
	signal control_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal control_address : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal gpo1 : std_logic_vector(2*busWidth-1 downto 0);--control address/control value
	signal gpi1 : std_logic_vector(2*busWidth-1 downto 0);--rand_num/ready
	
	--for RANDOM NUMBER
	signal rand_num: std_logic_vector (busWidth-1 downto 0);
	signal rand_gen: std_logic:='0';
begin
	control_address<=gpo1(16+busWidth-1 downto 16);
	control_data_in<=gpo1(15 downto 0);

	gpi1(busWidth-1+16 downto 16)<=rand_num;
	gpi1(15 downto 1)<=(others=>'0');
	gpi1(0)<=ready;	
	
	
	MICROPROCESSOR: mpu
		port map
		(
			rst, mcu_clk,
			
			Ethernet_Lite_TX_CLK, Ethernet_Lite_RX_ER, Ethernet_Lite_RX_DV, Ethernet_Lite_RX_CLK, Ethernet_Lite_RXD, Ethernet_Lite_CRS, Ethernet_Lite_COL,
			
			uart_rx, gpi1,
			
			error_i, error_u(0,0), error_u(0,1), error_u(0,2), error_u(1,0), error_u(1,2), error_u(1,1), error_u(2,0), error_u(2,1), error_u(2,2),
			error_x(0,0), error_x(0,2), error_x(0,1), error_x(1,1), error_x(1,0), error_x(1,2), error_x(2,0), error_x(2,2), error_x(2,1),
			
			u_interface_data_out, x_interface_data_out, ideal_interface_data_out,
			
			mcbx_zio, mcbx_rzq,
			mcbx_dram_udqs_n, mcbx_dram_udqs, mcbx_dram_dqs_n, mcbx_dram_dqs, mcbx_dram_dq,
			
			QSPI_FLASH_SS, QSPI_FLASH_SCLK, QSPI_FLASH_IO1, QSPI_FLASH_IO0,
			
			Ethernet_Lite_MDIO,
			
			mcbx_dram_we_n, mcbx_dram_udm, mcbx_dram_ras_n,	mcbx_dram_odt, mcbx_dram_ldm, mcbx_dram_clk_n,
			mcbx_dram_clk, mcbx_dram_cke, mcbx_dram_cas_n, mcbx_dram_ba, mcbx_dram_addr,
			
			Ethernet_Lite_TX_EN, Ethernet_Lite_TXD, Ethernet_Lite_PHY_RST_N, Ethernet_Lite_MDC, 
			
			uart_tx, gpo1,
			
			u_interface_data_in, u_interface_address, u_interface_we(0),
			x_interface_data_in, x_interface_address, x_interface_we(0),
			ideal_interface_address, ideal_interface_we(0),	ideal_interface_data_in,
			
			A(0, 0), A(0, 1), A(0, 2), A(1, 0), A(1, 1), A(1, 2), A(2, 0), A(2, 1), A(2, 2),
			B(0, 0), B(0, 1), B(0, 2), B(1, 0), B(1, 1), B(1, 2), B(2, 0), B(2, 1), B(2, 2),
			I, x_bnd, u_bnd
		);
		
	COMMANDS: cnn_commands
		port map
		(
			mcu_clk,
			control_data_in, control_address,
			cacheWidth, cacheHeight,
			Ts, iter_cnt,
			cnn_rst,
			rand_gen
		);
		
	RANDNUMGEN: cnn_rand
		port map
		(
			mcu_clk, rand_gen, rand_num
		);
end Behavioral;

