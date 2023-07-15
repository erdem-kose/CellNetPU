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
			clk, rst, en: in  std_logic;
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
			mcu_clk : out std_logic
		);
	end component;
	
	component cnn_processor is
		port (
			sys_clk, rst, en : in  std_logic;
			ready: out std_logic :='0';

			iter_cnt: in std_logic_vector(busWidth/2-2 downto 0);
			template_no : in std_logic_vector(busWidth/2-3 downto 0);
			Ts : in std_logic_vector(busWidth-1 downto 0);
			
			imageWidth: in std_logic_vector(busWidth-1 downto 0);
			imageHeight: in std_logic_vector(busWidth-1 downto 0);
			
			ram_we :out std_logic_vector(0 downto 0);
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
			ram_data_in :out std_logic_vector (busWidth-1 downto 0);
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			template_interface_we : in std_logic_vector(0 downto 0);
			template_interface_address : in std_logic_vector(templateAddressWidth-1 downto 0);
			template_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			template_interface_data_out : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component cnn_interface is
		port (
			sys_clk, mcu_clk, rst : in std_logic;
			ready: in std_logic;
			
			cnn_rst: out std_logic:='0';
			
			uart_rx : in std_logic;
			uart_tx : out std_logic;
			
			iter_cnt: out std_logic_vector(busWidth/2-2 downto 0);
			template_no : out std_logic_vector(busWidth/2-3 downto 0);
			Ts : out std_logic_vector(busWidth-1 downto 0);
		
			imageWidth: out std_logic_vector(busWidth-1 downto 0);
			imageHeight: out std_logic_vector(busWidth-1 downto 0);
			
			bram_we : in std_logic_vector(0 downto 0);
			bram_address : in std_logic_vector(ramAddressWidth-1 downto 0);
			bram_data_in : in std_logic_vector(busWidth-1 downto 0);
			bram_data_out : out std_logic_vector(busWidth-1 downto 0);
			
			template_we : out std_logic_vector(0 downto 0);
			template_address : out std_logic_vector(templateAddressWidth-1 downto 0);
			template_data_in : out std_logic_vector(busWidth-1 downto 0);
			template_data_out : in std_logic_vector(busWidth-1 downto 0)
		);
	end component;

	--for CLOCK
	signal sys_clk: std_logic := '0';
	signal mcu_clk: std_logic := '0';
	
	--for RAM Connections
	signal ram_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal ram_address : std_logic_vector(ramAddressWidth-1 downto 0):=(others=>'0');
	signal ram_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal ram_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	--for TEMPLATE Connections
	signal template_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal template_address : std_logic_vector(templateAddressWidth-1 downto 0):=(others=>'0');
	signal template_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal template_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');

	--for Control and Sync
	signal iter_cnt: std_logic_vector(busWidth/2-2 downto 0);
	signal template_no : std_logic_vector(busWidth/2-3 downto 0);
	signal Ts : std_logic_vector(busWidth-1 downto 0);
	signal imageWidth: std_logic_vector(busWidth-1 downto 0);
	signal imageHeight: std_logic_vector(busWidth-1 downto 0);
	signal ready: std_logic :='0';
	signal cnn_rst: std_logic :='0';
	
begin
	ready_led<=ready;
	--Clock
	CLOCKING: cnn_clocking
		port map (clk,sys_clk,mcu_clk);
	--Create RAM and ROMs and PROCESSOR
	PROCESSOR: cnn_processor
		port map (
			sys_clk, cnn_rst, en , ready,
			iter_cnt, template_no, Ts, imageWidth, imageHeight,
			ram_we, ram_address, ram_data_in, ram_data_out,
			template_we, template_address, template_data_in, template_data_out
		);
	--Create RAM and ROMs and PROCESSOR
	INTERFACE: cnn_interface
		port map (
			sys_clk, mcu_clk, rst, ready, cnn_rst,
			uart_rx, uart_tx,
			iter_cnt, template_no, Ts, imageWidth, imageHeight,
			ram_we, ram_address, ram_data_in, ram_data_out,
			template_we, template_address, template_data_in, template_data_out
		);
end Behavioral;

