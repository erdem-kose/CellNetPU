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
			sys_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			
			iter_cnt: in std_logic_vector(busWidth/2-2 downto 0);
			template_no : in std_logic_vector(busWidth/2-3 downto 0);
			Ts : in std_logic_vector(busWidth-1 downto 0);
		
			imageWidth: in std_logic_vector(busWidth-1 downto 0);
			imageHeight: in std_logic_vector(busWidth-1 downto 0);
			
			ram_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			ram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			template_interface_we : in std_logic_vector(0 downto 0);
			template_interface_address : in std_logic_vector(templateAddressWidth-1 downto 0);
			template_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			template_interface_data_out : out std_logic_vector(busWidth-1 downto 0)
	);
end cnn_processor;

architecture Behavioral of cnn_processor is

	component cnn_state_machine is
		port (
			sys_clk, rst, en : in  std_logic;
			ready, alu_calc: out std_logic;

			iter_cnt: in integer range 0 to iterMAX;
			template_no : in integer range 0 to templateCount;
			
			imageWidth: in integer range 0 to imageWidthMAX;
			imageHeight: in integer range 0 to imageHeightMAX;
			
			template_we :out std_logic_vector(0 downto 0);
			template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
			template_data_in :out std_logic_vector (busWidth-1 downto 0);
			template_data_out :in std_logic_vector (busWidth-1 downto 0);
				
			ram_we :out std_logic_vector(0 downto 0);
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
			ram_data_in :out std_logic_vector (busWidth-1 downto 0);
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);

			a_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: out std_logic_vector (busWidth-1 downto 0);
			
			x_old_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			x_new: in std_logic_vector (busWidth-1 downto 0);
			x_new_ready : in std_logic
		);
	end component;

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
	
	component cnn_alu is
		port (
				clk, alu_calc : in  std_logic;
				a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				i_line: in  std_logic_vector (busWidth-1 downto 0);
				x_out : out  std_logic_vector ((busWidth-1) downto 0);
				x_out_ready : out std_logic:='0';
				x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				Ts : in integer range 0 to (2**busWidth)-1
		);
	end component;

	--for TEMPLATES
	signal template_address: std_logic_vector (templateAddressWidth-1 downto 0):= (others => '0');
	signal template_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal template_we: std_logic_vector(0 downto 0) := (others => '0');
	signal template_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	
	--for CNN_ALU
	signal alu_calc: std_logic := '0';
	
	signal a_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal b_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal i_line: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal x_old_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal u_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	
	signal x_new: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_new_ready: std_logic:='0';
	
begin
	--Create ALU, TEMPLATES and STATE_MACHINE
	TEMPLATES : ram_templates
		port map (
			sys_clk,template_we,
			template_address,template_data_in,template_data_out,
			sys_clk,template_interface_we,
			template_interface_address, template_interface_data_in, template_interface_data_out
		);
	ALU: cnn_alu		port map (
			sys_clk,alu_calc,a_line,b_line,i_line,x_new,x_new_ready,x_old_line,u_line,to_integer(unsigned(Ts))
		);
	STATE_MACHINE: cnn_state_machine
		port map
		(
			sys_clk, rst, en, ready, alu_calc,
			to_integer(unsigned(iter_cnt)), to_integer(unsigned(template_no)), to_integer(unsigned(imageWidth)), to_integer(unsigned(imageHeight)),
			template_we, template_address,	template_data_in, template_data_out,
			ram_we, ram_address, ram_data_in ,ram_data_out,
			a_line, b_line,i_line , x_old_line, u_line, x_new, x_new_ready
		);
	
end Behavioral;

