library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_system is
	port (
			clk, rst, en: in  std_logic;
			ready: out std_logic;

			adrs :in std_logic_vector (ramAddressWidth-1 downto 0);
			data :out std_logic_vector (busWidth-1 downto 0);
			wen :in std_logic_vector(0 downto 0)
	);
end cnn_system;

architecture Behavioral of cnn_system is
	component cnn_processor is
		port (
				clk, rst, en : in  std_logic;
				ready: out std_logic :='0';
				
				template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
				template_data_in :out std_logic_vector (busWidth-1 downto 0);
				template_we :out std_logic_vector(0 downto 0);
				template_data_out :in std_logic_vector (busWidth-1 downto 0);
				
				bram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				bram_data_in :out std_logic_vector (busWidth-1 downto 0);
				bram_we :out std_logic_vector(0 downto 0);
				bram_data_out :in std_logic_vector (busWidth-1 downto 0)
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
	
	component ram_generic is
		port (
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(ramAddressWidth-1 downto 0);
			dina : in std_logic_vector(busWidth-1 downto 0);
			douta : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component cnn_ram_output is
		port (
				en : in  std_logic;
						
				out_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				out_data :in std_logic_vector (busWidth-1 downto 0);
				out_we :out std_logic_vector(0 downto 0):=(others => '0');
				
				adrs_1 :in std_logic_vector (ramAddressWidth-1 downto 0);
				data_1 :out std_logic_vector (busWidth-1 downto 0);
				wen_1 :in std_logic_vector(0 downto 0);
				
				adrs_2 :in std_logic_vector (ramAddressWidth-1 downto 0);
				data_2 :out std_logic_vector (busWidth-1 downto 0);
				wen_2 :in std_logic_vector(0 downto 0)
		);
	end component;
	--for TEMPLATES
	signal template_address: std_logic_vector (templateAddressWidth-1 downto 0):= (others => '0');
	signal template_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal template_we: std_logic_vector(0 downto 0) := (others => '0');
	signal template_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	
	--for RAM
	signal bram_address: std_logic_vector (ramAddressWidth-1 downto 0):= (others => '0');
	signal bram_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal bram_we: std_logic_vector(0 downto 0) := (others => '0');
	signal bram_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	--
	--for OUTPUT_SW
	signal proc_bram_address: std_logic_vector (ramAddressWidth-1 downto 0):= (others => '0');
	signal proc_bram_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal proc_bram_we: std_logic_vector(0 downto 0) := (others => '0');
	--
begin

	--Create RAM and ROMs and PROCESSOR
	PROCESSOR: cnn_processor
		port map (
						clk, rst, en , ready,
						template_address, template_data_in, template_we, template_data_out,
						proc_bram_address, bram_data_in, proc_bram_we, proc_bram_data_out
					);
	TEMPLATES : ram_templates
		port map (clk,template_we,template_address,template_data_in,template_data_out);
	RAM : ram_generic
		port map (clk,bram_we,bram_address,bram_data_in,bram_data_out);
	RAM_OUTPUT_SWITCH : cnn_ram_output
		port map (
						en,bram_address,bram_data_out,bram_we,
						proc_bram_address,proc_bram_data_out,proc_bram_we,
						adrs,data,wen
					);
end Behavioral;

