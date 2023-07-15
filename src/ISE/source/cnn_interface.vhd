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
	port (
		sys_clk, mcu_clk , rst : in std_logic;
		ready: in std_logic;
		
		uart_rx : in std_logic;
		uart_tx : out std_logic;

		bram_we : in std_logic_vector(0 downto 0);
		bram_address : in std_logic_vector(ramAddressWidth-1 downto 0);
		bram_data_in : in std_logic_vector(busWidth-1 downto 0);
		bram_data_out : out std_logic_vector(busWidth-1 downto 0);
			
		template_we : out std_logic_vector(0 downto 0);
		template_address : out std_logic_vector(templateAddressWidth-1 downto 0);
		template_data_in : out std_logic_vector(busWidth-1 downto 0);
		template_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		error_squa_sum: in std_logic_vector (errorWidth-1 downto 0);
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
	component mcu
		port (
			Clk : in std_logic;
			Reset : in std_logic;
			UART_Rx : in std_logic;
			UART_Tx : out std_logic;
			GPO1 : out std_logic_vector(2*busWidth-1 downto 0);
			GPO2 : out std_logic_vector(2*busWidth-1 downto 0);
			GPO3 : out std_logic_vector(2*busWidth-1 downto 0);
			GPI1 : in std_logic_vector(2*busWidth-1 downto 0);
			GPI1_Interrupt : out std_logic;
			GPI2 : in std_logic_vector(2*busWidth-1 downto 0);
			GPI2_Interrupt : out std_logic;
			GPI3 : in std_logic_vector(2*busWidth-1 downto 0);
			GPI3_Interrupt : out std_logic
		);
	end component;
	
	component ram_generic
		port (
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

	component cnn_constants
		port (
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
	signal gpi1_interrupt : std_logic :='0';
	signal gpi2 : std_logic_vector(2*busWidth-1 downto 0);--rand_num/ready
	signal gpi2_interrupt : std_logic :='0';
	signal gpi3 : std_logic_vector(2*busWidth-1 downto 0);--error
	signal gpi3_interrupt : std_logic :='0';
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
	
	gpi3<=error_squa_sum;		
	
	INTERFACE_MCU: mcu
		port map (
			mcu_clk, rst,
			uart_rx, uart_tx,
			gpo1, gpo2, gpo3,
			gpi1, gpi1_interrupt, gpi2, gpi2_interrupt, gpi3, gpi3_interrupt
		);
	INTERFACE_BRAM: ram_generic
		port map (
			sys_clk, interface_bram_we,
			interface_bram_address, interface_bram_data_in, interface_bram_data_out,
			sys_clk, bram_we,
			bram_address, bram_data_in, bram_data_out
		);
	INTERFACE_CONSTANTS: cnn_constants
		port map(
			mcu_clk, control_data_in, control_address,
			imageWidth, imageHeight,
			Ts, iter_cnt, template_no, learn_rate, 
			cnn_rst, state_mode,
			interface_bram_we, template_we,
			bram_x_location, bram_u_location, bram_ideal_location, bram_error_location
		);
end Behavioral;

