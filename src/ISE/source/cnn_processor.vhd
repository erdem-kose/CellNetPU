library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;

entity cnn_processor is
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
end cnn_processor;

architecture Behavioral of cnn_processor is
	component ram_templates is
		port (
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(templateAddressWidth-1 downto 0);
			dina : in std_logic_vector(busWidth-1 downto 0);
			douta : out std_logic_vector(busWidth-1 downto 0);
			clkb : in std_logic;
			web : in std_logic_vector(0 downto 0);
			addrb : in std_logic_vector(templateAddressWidth-1 downto 0);
			dinb : in std_logic_vector(busWidth-1 downto 0);
			doutb : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component cnn_calculator is
		port (
			clk, div_clk, calc, err_rst : in  std_logic;
			
			a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: in  std_logic_vector (busWidth-1 downto 0);
			x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
			x_out_ready : out std_logic:='1';
			x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			
			Ts : in integer range 0 to busUSMax;
			learn_rate : in integer range 0 to busUSMax;
		
			image_size: in  std_logic_vector (busWidth-1 downto 0);
			ideal_line: in  std_logic_vector (busWidth-1 downto 0);
			
			error: out std_logic_vector (busWidth-1 downto 0);
			error_squa_sum: out std_logic_vector (errorWidth-1 downto 0)
		);
	end component;

	component cnn_rand is
		port (
			clk: in  std_logic;
			rand_num: out std_logic_vector (busWidth-1 downto 0)
		);
	end component;

	component cnn_state_machine is
		port (
			sys_clk, rst, en : in  std_logic;
			ready, alu_calc, alu_err_rst: out std_logic;
			
			ram_we :out std_logic_vector(0 downto 0);
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
			ram_data_in :out std_logic_vector (busWidth-1 downto 0);
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			template_we :out std_logic_vector(0 downto 0);
			template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
			template_data_in :out std_logic_vector (busWidth-1 downto 0);
			template_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			a_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: out std_logic_vector (busWidth-1 downto 0);
			
			x_old_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			x_new: in std_logic_vector (busWidth-1 downto 0);
			x_new_ready : in std_logic;
			
			ideal_line: out  std_logic_vector (busWidth-1 downto 0);
			image_size: out  std_logic_vector (busWidth-1 downto 0);
			
			error: in std_logic_vector (busWidth-1 downto 0);
			rand_num: in std_logic_vector (busWidth-1 downto 0);
			
			imageWidth: in integer range 0 to imageWidthMAX;
			imageHeight: in integer range 0 to imageHeightMAX;
			
			iter_cnt: in integer range 0 to iterMAX;
			template_no : in integer range 0 to templateCount;
			
			state_mode: in std_logic_vector(modeWidth-1 downto 0):=(others=>'0');
			
			ram_x_location :in std_logic_vector (busWidth-1 downto 0);
			ram_u_location :in std_logic_vector (busWidth-1 downto 0);
			ram_ideal_location :in std_logic_vector (busWidth-1 downto 0);
			ram_error_location :in std_logic_vector (busWidth-1 downto 0)
		);
	end component;

	
	--for TEMPLATES
	signal template_address: std_logic_vector (templateAddressWidth-1 downto 0):= (others => '0');
	signal template_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal template_we: std_logic_vector(0 downto 0) := (others => '0');
	signal template_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	
	--for CNN_ALU
	signal alu_calc: std_logic := '0';
	signal alu_err_rst: std_logic := '0';
	
	signal a_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal b_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal i_line: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal x_old_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal u_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	
	signal x_new: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_new_ready: std_logic:='0';
	
	signal ideal: std_logic_vector (busWidth-1 downto 0):=(others => '0');
	signal image_size: std_logic_vector (busWidth-1 downto 0):=(others => '0');
	
	--for ERROR
	signal error: std_logic_vector (busWidth-1 downto 0):=(others => '0');
	
	--for RANDOM NUMBER
	signal rand_num: std_logic_vector (busWidth-1 downto 0);
begin
	rand_num_out<=rand_num;
	--Create ALU, TEMPLATES and STATE_MACHINE
	TEMPLATES : ram_templates
		port map (
			sys_clk,template_we,
			template_address,template_data_in,template_data_out,
			sys_clk,template_interface_we,
			template_interface_address, template_interface_data_in, template_interface_data_out
		);
	CALCULATOR: cnn_calculator		port map (
			sys_clk, div_clk, alu_calc, alu_err_rst,
			a_line,b_line,i_line,x_new,x_new_ready,x_old_line,u_line,
			to_integer(unsigned(Ts)), to_integer(unsigned(learn_rate)),
			image_size, ideal, error, error_squa_sum
		);
	RANDNUMGEN: cnn_rand
		port map (
			sys_clk, rand_num
		);
	STATE_MACHINE: cnn_state_machine
		port map
		(
			sys_clk, rst, en, ready, alu_calc, alu_err_rst,
			ram_we, ram_address, ram_data_in ,ram_data_out,
			template_we, template_address,	template_data_in, template_data_out,
			a_line, b_line,i_line , x_old_line, u_line, x_new, x_new_ready,
			ideal, image_size,
			error, rand_num,
			to_integer(unsigned(imageWidth)), to_integer(unsigned(imageHeight)),
			to_integer(unsigned(iter_cnt)), to_integer(unsigned(template_no)),
			state_mode,
			ram_x_location, ram_u_location, ram_ideal_location, ram_error_location
		);

end Behavioral;

