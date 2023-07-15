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
			
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			ram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			ram_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			ram_data_out :in std_logic_vector (busWidth-1 downto 0)
	);
end cnn_processor;

architecture Behavioral of cnn_processor is

	component cnn_state_machine is
		port (
				sys_clk, rst, en : in  std_logic;
				ready, alu_calc: out std_logic;
				
				template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
				template_data_in :out std_logic_vector (busWidth-1 downto 0);
				template_we :out std_logic_vector(0 downto 0);
				template_data_out :in std_logic_vector (busWidth-1 downto 0);
				
				ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				ram_data_in :out std_logic_vector (busWidth-1 downto 0);
				ram_we :out std_logic_vector(0 downto 0);
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
			douta : out std_logic_vector(busWidth-1 downto 0)
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
				u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0)
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
		port map (sys_clk,template_we,template_address,template_data_in,template_data_out);
	ALU: cnn_alu		port map (sys_clk,alu_calc,a_line,b_line,i_line,x_new,x_new_ready,x_old_line,u_line);
	STATE_MACHINE: cnn_state_machine
		port map (
				sys_clk, rst, en, ready, alu_calc,
				template_address,	template_data_in , template_we, template_data_out,
				ram_address, ram_data_in, ram_we ,ram_data_out,
				a_line, b_line,i_line , x_old_line, u_line, x_new, x_new_ready
		);
	
end Behavioral;

