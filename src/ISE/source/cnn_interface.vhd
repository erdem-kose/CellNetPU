library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;


entity cnn_interface is
	port
	(
		sys_clk, mcu_clk , rst : in std_logic;
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

		bram_we : in std_logic_vector(0 downto 0);
		bram_address : in std_logic_vector(ramAddressWidth-1 downto 0);
		bram_data_in : in std_logic_vector(busWidth-1 downto 0);
		bram_data_out : out std_logic_vector(busWidth-1 downto 0);
			
		template_we : out std_logic_vector(0 downto 0);
		template_address : out std_logic_vector(templateAddressWidth-1 downto 0);
		template_data_in : out std_logic_vector(busWidth-1 downto 0);
		template_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		error_i : in std_logic_vector(errorWidth-1 downto 0);
		error_u00 : in std_logic_vector(errorWidth-1 downto 0);
		error_u01 : in std_logic_vector(errorWidth-1 downto 0);
		error_u02 : in std_logic_vector(errorWidth-1 downto 0);
		error_u10 : in std_logic_vector(errorWidth-1 downto 0);
		error_u12 : in std_logic_vector(errorWidth-1 downto 0);
		error_u11 : in std_logic_vector(errorWidth-1 downto 0);
		error_u20 : in std_logic_vector(errorWidth-1 downto 0);
		error_u21 : in std_logic_vector(errorWidth-1 downto 0);
		error_u22 : in std_logic_vector(errorWidth-1 downto 0);
		error_x00 : in std_logic_vector(errorWidth-1 downto 0);
		error_x02 : in std_logic_vector(errorWidth-1 downto 0);
		error_x01 : in std_logic_vector(errorWidth-1 downto 0);
		error_x11 : in std_logic_vector(errorWidth-1 downto 0);
		error_x10 : in std_logic_vector(errorWidth-1 downto 0);
		error_x12 : in std_logic_vector(errorWidth-1 downto 0);
		error_x20 : in std_logic_vector(errorWidth-1 downto 0);
		error_x22 : in std_logic_vector(errorWidth-1 downto 0);
		error_x21 : in std_logic_vector(errorWidth-1 downto 0);
			
		rand_num: in std_logic_vector (busWidth-1 downto 0);
		
		imageWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		imageHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		
		Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
		iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
		template_no : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(0,busWidth));
		learn_rate : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
		
		cnn_rst: out std_logic:='1';
		state_mode: out std_logic_vector(modeWidth-1 downto 0):=(others=>'0');

		bram_x_location :out std_logic_vector (busWidth-1 downto 0);
		bram_u_location :out std_logic_vector (busWidth-1 downto 0);
		bram_ideal_location :out std_logic_vector (busWidth-1 downto 0);
		bram_error_location :out std_logic_vector (busWidth-1 downto 0)
	);
end cnn_interface;

architecture Behavioral of cnn_interface is
	component mpu
		port
		(
			reset : in std_logic;
			gclk : in std_logic;
			ethernet_lite_tx_clk : in std_logic;
			ethernet_lite_rx_er : in std_logic;
			ethernet_lite_rx_dv : in std_logic;
			ethernet_lite_rx_clk : in std_logic;
			ethernet_lite_rxd : in std_logic_vector(3 downto 0);
			ethernet_lite_crs : in std_logic;
			ethernet_lite_col : in std_logic;
			iomodule_0_uart_rx : in std_logic;
			iomodule_0_gpi1 : in std_logic_vector(31 downto 0);
			iomodule_0_gpi2 : in std_logic_vector(31 downto 0);
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
			zio : inout std_logic;
			rzq : inout std_logic;
			mcbx_dram_udqs_n : inout std_logic;
			mcbx_dram_udqs : inout std_logic;
			mcbx_dram_dqs_n : inout std_logic;
			mcbx_dram_dqs : inout std_logic;
			mcbx_dram_dq : inout std_logic_vector(15 downto 0);
			qspi_flash_ss : inout std_logic;
			qspi_flash_sclk : inout std_logic;
			qspi_flash_io1 : inout std_logic;
			qspi_flash_io0 : inout std_logic;
			ethernet_lite_mdio : inout std_logic;      
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
			ethernet_lite_tx_en : out std_logic;
			ethernet_lite_txd : out std_logic_vector(3 downto 0);
			ethernet_lite_phy_rst_n : out std_logic;
			ethernet_lite_mdc : out std_logic;
			iomodule_0_uart_tx : out std_logic;
			iomodule_0_gpo1 : out std_logic_vector(31 downto 0);
			iomodule_0_gpo2 : out std_logic_vector(31 downto 0);
			iomodule_0_gpo3 : out std_logic_vector(31 downto 0)
		);
	end component;

	attribute BOX_TYPE : STRING;
	attribute BOX_TYPE of mpu : component is "user_black_box";
 
	component ram_generic is
		port
		(
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(15 downto 0);
			dina : in std_logic_vector(15 downto 0);
			douta : out std_logic_vector(15 downto 0);
			clkb : in std_logic;
			web : in std_logic_vector(0 downto 0);
			addrb : in std_logic_vector(15 downto 0);
			dinb : in std_logic_vector(15 downto 0);
			doutb : out std_logic_vector(15 downto 0)
		);
	end component;

	component cnn_commands is
		port
		(
			clk : in std_logic;
			
			control_data_in : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
			control_address : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		
			imageWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
			imageHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
			
			Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
			iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
			template_no : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(0,busWidth));
			learn_rate : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
			
			cnn_rst: out std_logic:='1';
			state_mode: out std_logic_vector(modeWidth-1 downto 0):=(others=>'0');
			
			interface_bram_we : out std_logic_vector(0 downto 0);
			template_we : out std_logic_vector(0 downto 0);
			
			bram_x_location :out std_logic_vector (busWidth-1 downto 0):= std_logic_vector(to_unsigned(0,busWidth));
			bram_u_location :out std_logic_vector (busWidth-1 downto 0):= std_logic_vector(to_unsigned(1,busWidth));
			bram_ideal_location :out std_logic_vector (busWidth-1 downto 0):= std_logic_vector(to_unsigned(2,busWidth));
			bram_error_location :out std_logic_vector (busWidth-1 downto 0):= std_logic_vector(to_unsigned(3,busWidth))
		);
	end component;

	signal control_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal control_address : std_logic_vector(busWidth-1 downto 0):=(others=>'0');

	signal interface_bram_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal interface_bram_address : std_logic_vector(ramAddressWidth-1 downto 0):=(others=>'0');
	signal interface_bram_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal interface_bram_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal gpo1 : std_logic_vector(2*busWidth-1 downto 0);--bram:bram_address,bram_data_in
	signal gpo2 : std_logic_vector(2*busWidth-1 downto 0);--template:template_address,template_data_in
	signal gpo3 : std_logic_vector(2*busWidth-1 downto 0);--control address/control value
	signal gpi1 : std_logic_vector(2*busWidth-1 downto 0);--template_data_out,bram_data_out
	signal gpi2 : std_logic_vector(2*busWidth-1 downto 0);--rand_num/ready
begin

	interface_bram_address<=gpo1(16+ramAddressWidth-1 downto 16);
	interface_bram_data_in<=gpo1(15 downto 0);
	
	template_address<=gpo2(16+templateAddressWidth-1 downto 16);
	template_data_in<=gpo2(15 downto 0);
	
	gpi1(31 downto 16)<=template_data_out;
	gpi1(15 downto 0)<=interface_bram_data_out;
	
	control_address<=gpo3(16+busWidth-1 downto 16);
	control_data_in<=gpo3(15 downto 0);

	gpi2(busWidth-1+16 downto 16)<=rand_num;
	gpi2(15 downto 1)<=(others=>'0');
	gpi2(0)<=ready;	
	
	INTERFACE_MPU: mpu
		port map
		(
			rst, mcu_clk,
			
			Ethernet_Lite_TX_CLK, Ethernet_Lite_RX_ER, Ethernet_Lite_RX_DV, Ethernet_Lite_RX_CLK, Ethernet_Lite_RXD, Ethernet_Lite_CRS, Ethernet_Lite_COL,
			
			uart_rx, gpi1, gpi2,
			
			error_i, error_u00, error_u01, error_u02, error_u10, error_u12, error_u11, error_u20, error_u21, error_u22,
			error_x00, error_x02, error_x01, error_x11, error_x10, error_x12, error_x20, error_x22, error_x21,
			
			mcbx_zio, mcbx_rzq,
			mcbx_dram_udqs_n, mcbx_dram_udqs, mcbx_dram_dqs_n, mcbx_dram_dqs, mcbx_dram_dq,
			
			QSPI_FLASH_SS, QSPI_FLASH_SCLK, QSPI_FLASH_IO1, QSPI_FLASH_IO0,
			
			Ethernet_Lite_MDIO,
			
			mcbx_dram_we_n, mcbx_dram_udm, mcbx_dram_ras_n,	mcbx_dram_odt, mcbx_dram_ldm, mcbx_dram_clk_n,
			mcbx_dram_clk, mcbx_dram_cke, mcbx_dram_cas_n, mcbx_dram_ba, mcbx_dram_addr,
			
			Ethernet_Lite_TX_EN, Ethernet_Lite_TXD, Ethernet_Lite_PHY_RST_N, Ethernet_Lite_MDC, 
			
			uart_tx, gpo1, gpo2, gpo3
		);
	INTERFACE_L2CACHE: ram_generic
		port map
		(
			sys_clk, interface_bram_we,
			interface_bram_address, interface_bram_data_in, interface_bram_data_out,
			sys_clk, bram_we,
			bram_address, bram_data_in, bram_data_out
		);
	INTERFACE_COMMANDS: cnn_commands
		port map
		(
			mcu_clk, control_data_in, control_address,
			imageWidth, imageHeight,
			Ts, iter_cnt, template_no, learn_rate, 
			cnn_rst, state_mode,
			interface_bram_we, template_we,
			bram_x_location, bram_u_location, bram_ideal_location, bram_error_location
		);
end Behavioral;

