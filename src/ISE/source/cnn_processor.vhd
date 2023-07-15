library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;

entity cnn_processor is
	port (
			sys_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			
			template_address :out std_logic_vector (templateAddressWidth-1 downto 0):=(others=>'0');
			template_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			template_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			template_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			bram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			bram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			bram_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			bram_data_out :in std_logic_vector (busWidth-1 downto 0)
	);
end cnn_processor;

architecture Behavioral of cnn_processor is

	component cnn_state_machine is
		port (
				sys_clk, rst, en : in  std_logic;
				ready, alu_rst: out std_logic;
				
				template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
				template_data_in :out std_logic_vector (busWidth-1 downto 0);
				template_we :out std_logic_vector(0 downto 0);
				template_data_out :in std_logic_vector (busWidth-1 downto 0);
				
				bram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				bram_data_in :out std_logic_vector (busWidth-1 downto 0);
				bram_we :out std_logic_vector(0 downto 0);
				bram_data_out :in std_logic_vector (busWidth-1 downto 0);

				a_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
				b_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
				i_line: out std_logic_vector (busWidth-1 downto 0);
				
				x_old_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
				u_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
				x_new: in std_logic_vector (busWidth-1 downto 0);
				x_new_ready : in std_logic
		);
	end component;
	
	component cnn_alu is
		port (
				clk, rst : in  std_logic;
				a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				i_line: in  std_logic_vector (busWidth-1 downto 0);
				x_out : out  std_logic_vector ((busWidth-1) downto 0);
				x_out_ready : out std_logic:='0';
				x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0)
		);
	end component;

	--for CNN_ALU
	signal alu_rst: std_logic := '0';
	
	signal a_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal b_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal i_line: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal x_old_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal u_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	
	signal x_new: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_new_ready: std_logic:='0';
	--
	
begin
	--Create ALU and STATE_MACHINE
	ALU: cnn_alu		port map (sys_clk,alu_rst,a_line,b_line,i_line,x_new,x_new_ready,x_old_line,u_line);
	STATE_MACHINE: cnn_state_machine
		port map (
				sys_clk, rst, en, ready, alu_rst,
				template_address,	template_data_in , template_we, template_data_out,
				bram_address, bram_data_in, bram_we ,bram_data_out,
				a_line, b_line,i_line , x_old_line, u_line, x_new, x_new_ready
		);
	
end Behavioral;

