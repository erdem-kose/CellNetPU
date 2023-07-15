library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;
	
entity cnn_system is
	port (
		clk, rst: in  std_logic;
		ready_led: out std_logic;
			
		uart_rx : in std_logic;
		uart_tx : out std_logic
	);
end cnn_system;

architecture Behavioral of cnn_system is
	component cnn_clocking
		port
		(-- Clock in ports
			clk_in : in std_logic;
			-- Clock out ports
			sys_clk : out std_logic;
			mcu_clk : out std_logic;
			div_clk : out std_logic
		);
	end component;
	
	component cnn_processor is
		port (
			sys_clk, div_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			
			ram_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			ram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			template_interface_we : in std_logic_vector(0 downto 0);
			template_interface_address : in std_logic_vector(templateAddressWidth-1 downto 0);
			template_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			template_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
			
			error_squa_sum: out std_logic_vector (errorWidth-1 downto 0);
			rand_num_out: out std_logic_vector (busWidth-1 downto 0);
			
			imageWidth: in std_logic_vector(busWidth-1 downto 0);
			imageHeight: in std_logic_vector(busWidth-1 downto 0);
			
			Ts : in std_logic_vector(busWidth-1 downto 0);
			iter_cnt: in std_logic_vector(busWidth-1 downto 0);
			template_no : in std_logic_vector(busWidth-1 downto 0);
			learn_rate : in std_logic_vector(busWidth-1 downto 0);
			
			state_mode: in std_logic_vector(modeWidth-1 downto 0):=(others=>'0');

			ram_x_location :in std_logic_vector (busWidth-1 downto 0);
			ram_u_location :in std_logic_vector (busWidth-1 downto 0);
			ram_ideal_location :in std_logic_vector (busWidth-1 downto 0);
			ram_error_location :in std_logic_vector (busWidth-1 downto 0)
		);
	end component;
	
	component cnn_interface is
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
	end component;

	--for CLOCK
	signal sys_clk: std_logic := '0';
	signal mcu_clk: std_logic := '0';
	signal div_clk: std_logic := '0';
	
	--for RAM Connections
	signal ram_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal ram_address : std_logic_vector(ramAddressWidth-1 downto 0):=(others=>'0');
	signal ram_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal ram_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal ram_x_location : std_logic_vector (busWidth-1 downto 0);
	signal ram_u_location : std_logic_vector (busWidth-1 downto 0);
	signal ram_ideal_location : std_logic_vector (busWidth-1 downto 0);
	signal ram_error_location : std_logic_vector (busWidth-1 downto 0);
	
	--for TEMPLATE Connections
	signal template_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal template_address : std_logic_vector(templateAddressWidth-1 downto 0):=(others=>'0');
	signal template_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal template_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');

	--for Control and Sync
	signal ready: std_logic :='0';

	signal imageWidth: std_logic_vector(busWidth-1 downto 0);
	signal imageHeight: std_logic_vector(busWidth-1 downto 0);
	
	signal Ts : std_logic_vector(busWidth-1 downto 0);
	signal iter_cnt: std_logic_vector(busWidth-1 downto 0);
	signal template_no : std_logic_vector(busWidth-1 downto 0);
	signal learn_rate : std_logic_vector(busWidth-1 downto 0);
	
	signal cnn_rst: std_logic :='1';
	signal state_mode: std_logic_vector(modeWidth-1 downto 0):=(others=>'0');
	
	--for TEMPLATE Creation
	signal error_squa_sum: std_logic_vector (errorWidth-1 downto 0):=(others => '0');
	signal rand_num: std_logic_vector (busWidth-1 downto 0);

begin
	ready_led<=ready;
	--Clock
	CLOCKING: cnn_clocking
		port map (
			clk, sys_clk, mcu_clk, div_clk
		);
	--Create PROCESSOR
	PROCESSOR: cnn_processor
		port map (
			sys_clk, div_clk, cnn_rst, not(cnn_rst), ready,
			ram_we, ram_address, ram_data_in, ram_data_out,
			template_we, template_address, template_data_in, template_data_out,
			error_squa_sum, rand_num,
			imageWidth, imageHeight,
			Ts, iter_cnt, template_no, learn_rate, 
			state_mode, 
			ram_x_location, ram_u_location, ram_ideal_location, ram_error_location
		);
	--Create INTERFACE
	INTERFACE: cnn_interface
		port map (
			sys_clk, mcu_clk, rst, ready,
			uart_rx, uart_tx,
			ram_we, ram_address, ram_data_in, ram_data_out,
			template_we, template_address, template_data_in, template_data_out,
			error_squa_sum, rand_num,
			imageWidth, imageHeight,
			Ts, iter_cnt, template_no, learn_rate,
			cnn_rst,	state_mode,
			ram_x_location, ram_u_location, ram_ideal_location, ram_error_location
		);
end Behavioral;

