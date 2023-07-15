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

entity cnn_processor is
	port
	(
		sys_clk, mcu_clk, rst, en : in  std_logic;
		ready: out std_logic:='0';
		
		A: in patch_unsigned;
		B: in patch_unsigned;
		I: in std_logic_vector(busWidth-1 downto 0);
		x_bnd: in std_logic_vector(busWidth-1 downto 0);
		u_bnd: in std_logic_vector(busWidth-1 downto 0);
		
		u_interface_we : in std_logic_vector(0 downto 0);
		u_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
		u_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
		u_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
	
		x_interface_we : in std_logic_vector(0 downto 0);
		x_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
		x_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
		x_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
	
		ideal_interface_we : in std_logic_vector(0 downto 0);
		ideal_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
		ideal_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
		ideal_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
		
		error_u: out error_patch;
		error_x: out error_patch;
		error_i: out std_logic_vector(errorWidth-1 downto 0);
		
		cacheWidth: in std_logic_vector(busWidth-1 downto 0);
		cacheHeight: in std_logic_vector(busWidth-1 downto 0);
		
		Ts : in std_logic_vector(busWidth-1 downto 0);
		iter_cnt: in std_logic_vector(busWidth-1 downto 0)
	);
end cnn_processor;

architecture Behavioral of cnn_processor is
	--for CACHES
	signal u_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal u_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal u_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal u_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal x_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal x_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal x_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal x_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal ideal_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal ideal_address : std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
	signal ideal_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal ideal_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	--for CNN_ALU
	signal alu_calc: std_logic := '0';
	signal alu_err_rst: std_logic := '0';
	
	signal x_old: patch_unsigned := (others => (others => (others => '0')));
	signal u: patch_unsigned := (others => (others => (others => '0')));

	signal x_new: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_new_ready: std_logic:='0';
	
	signal ideal: std_logic_vector (busWidth-1 downto 0):=(others => '0');
begin
	--Create ALU, CACHES and STATE_MACHINE
	
	L2CACHE_U: ram_generic
		port map
		(
			sys_clk, u_we,
			u_address, u_data_in, u_data_out,
			mcu_clk, u_interface_we,
			u_interface_address, u_interface_data_in, u_interface_data_out
		);
		
	L2CACHE_X: ram_generic
		port map
		(
			sys_clk, x_we,
			x_address, x_data_in, x_data_out,
			mcu_clk, x_interface_we,
			x_interface_address, x_interface_data_in, x_interface_data_out
		);

	L2CACHE_IDEAL: ram_generic
		port map
		(
			sys_clk, ideal_we,
			ideal_address, ideal_data_in, ideal_data_out,
			mcu_clk, ideal_interface_we,
			ideal_interface_address, ideal_interface_data_in, ideal_interface_data_out
		);
		
	AU: cnn_au		port map
		(
			sys_clk,
			
			alu_calc, alu_err_rst,
			A,B,I,x_old,u,
			x_new,x_new_ready,
			to_integer(unsigned(Ts)),
			
			ideal,
			
			error_u, error_x, error_i
		);
		
	STATE_MACHINE: cnn_state_machine
		port map
		(
			sys_clk, rst, en, ready,
			alu_calc, alu_err_rst,
			
			u_we, u_address, u_data_in, u_data_out,
			x_we, x_address, x_data_in, x_data_out,
			ideal_we, ideal_address, ideal_data_in, ideal_data_out,
			
			x_bnd, u_bnd,
			
			x_old, u, x_new, x_new_ready,
			
			ideal,
		
			to_integer(unsigned(cacheWidth)), to_integer(unsigned(cacheHeight)),	to_integer(unsigned(iter_cnt))
		);

end Behavioral;

