library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;

entity cnn_processor is
	port (
			clk, rst, en : in  std_logic;
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
				clk, rst, en : in  std_logic;
				ready: out std_logic;
				alu_en: out std_logic;
				alu_clk: out std_logic;
				
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
				x_new: in std_logic_vector (busWidth-1 downto 0)
		);
	end component;
	
	component cnn_alu is
		port (
				en, clk : in  std_logic;
				a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				i_line: in  std_logic_vector (busWidth-1 downto 0);
				x_out : out  std_logic_vector ((busWidth-1) downto 0);
				x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
				u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0)
		);
	end component;

	--for CNN_ALU
	signal alu_en: std_logic := '0';
	signal alu_clk: std_logic := '0';
	
	signal a_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal b_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal i_line: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal x_old_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	signal u_line: std_logic_vector ((busWidth*patchSize-1) downto 0) := (others => '0');
	
	signal x_new: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	--
	
begin
	--Create ALU and STATE_MACHINE
	ALU: cnn_alu		port map (alu_en,alu_clk,a_line,b_line,i_line,x_new,x_old_line,u_line);
	STATE_MACHINE: cnn_state_machine
		port map (
				clk, rst, en, ready, alu_en, alu_clk,
				template_address,	template_data_in , template_we, template_data_out,
				bram_address, bram_data_in, bram_we ,bram_data_out,
				a_line, b_line,i_line , x_old_line, u_line, x_new
		);
	
end Behavioral;

