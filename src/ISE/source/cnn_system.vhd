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
			ready: out std_logic;

			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
			ram_data_in :out std_logic_vector (busWidth-1 downto 0);
			ram_we :out std_logic_vector(0 downto 0);
			ram_data_out :in std_logic_vector (busWidth-1 downto 0)
	);
end cnn_system;

architecture Behavioral of cnn_system is
	component cnn_clocking
		port
		(-- Clock in ports
			clk_in : in std_logic;
			-- Clock out ports
			sys_clk : out std_logic;
			dvi_clk : out std_logic;
			dvi2x_clk : out std_logic
		);
	end component;
	
	component cnn_processor is
		port (
				sys_clk, rst, en : in  std_logic;
				ready: out std_logic :='0';
				
				ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				ram_data_in :out std_logic_vector (busWidth-1 downto 0);
				ram_we :out std_logic_vector(0 downto 0);
				ram_data_out :in std_logic_vector (busWidth-1 downto 0)
		);
	end component;
	
	--for CLOCK
	signal sys_clk: std_logic := '0';
	signal dvi_clk: std_logic := '0';
	signal dvi2x_clk: std_logic := '0';
begin
	--Clock
	CLOCKING: cnn_clocking
		port map (clk,sys_clk,dvi_clk,dvi2x_clk);
	--Create RAM and ROMs and PROCESSOR
	PROCESSOR: cnn_processor
		port map (
						sys_clk, rst, en , ready,
						ram_address, ram_data_in, ram_we, ram_data_out
					);
end Behavioral;

