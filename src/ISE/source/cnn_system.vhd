library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_system is
	port (
			clk, rst, en : in  std_logic;
			ready: out std_logic
	);
end cnn_system;

architecture Behavioral of cnn_system is
	component cnn_processor is
		port (
				clk, rst, en : in  std_logic;
				ready: out std_logic;
				template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
				template_data_in :out std_logic_vector (busWidth-1 downto 0);
				template_we :out std_logic;
				template_data_out :in std_logic_vector (busWidth-1 downto 0);
				ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
				ram_data_in :out std_logic_vector (busWidth-1 downto 0);
				ram_we :out std_logic;
				ram_data_out :in std_logic_vector (busWidth-1 downto 0);
				rom_image_out : in std_logic_vector (busWidth-1 downto 0);
				rom_image_address : out std_logic_vector (romAddressWidth-1 downto 0);
				rom_ideal_out : in std_logic_vector (busWidth-1 downto 0);
				rom_ideal_address : out std_logic_vector (romAddressWidth-1 downto 0)
		);
	end component;
	
	component ram_templates is
		port (
			a : in std_logic_vector(templateAddressWidth-1 downto 0);
			d : in std_logic_vector(busWidth-1 downto 0);
			clk : in std_logic;
			we : in std_logic;
			spo : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component ram_generic is
		port (
			a : in std_logic_vector(ramAddressWidth-1 downto 0);
			d : in std_logic_vector(busWidth-1 downto 0);
			clk : in std_logic;
			we : in std_logic;
			spo : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;

	component rom_input_image is
		port (
			a : in  std_logic_vector (romAddressWidth-1 downto 0);
			spo : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component rom_ideal_image
		port (
			a : in  std_logic_vector (romAddressWidth-1 downto 0);
			spo : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;

	--for TEMPLATES
	signal template_address: std_logic_vector (templateAddressWidth-1 downto 0):= (others => '0');
	signal template_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal template_we: std_logic := '0';
	signal template_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	
	--for RAM
	signal ram_address: std_logic_vector (ramAddressWidth-1 downto 0):= (others => '0');
	signal ram_data_in: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal ram_we: std_logic := '0';
	signal ram_data_out: std_logic_vector (busWidth-1 downto 0):= (others => '0');

	--for IMAGE ROMs
	signal input_image_data: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal input_image_address: std_logic_vector (romAddressWidth-1 downto 0):= (others => '0');
	
	signal ideal_image_data: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal ideal_image_address: std_logic_vector (romAddressWidth-1 downto 0):= (others => '0');
	--
	
begin

	--Create RAM and ROMs and PROCESSOR
	PROCESSOR: cnn_processor		port map (
						clk, rst, en , ready,
						template_address,template_data_in,template_we,template_data_out,
						ram_address,ram_data_in,ram_we,ram_data_out,
						input_image_data, input_image_address, ideal_image_data, ideal_image_address
					);
	TEMPLATES : ram_templates
		port map (template_address,template_data_in,clk,template_we,template_data_out);
	RAM : ram_generic
		port map (ram_address,ram_data_in,clk,ram_we,ram_data_out);
	INPUT_IMAGE: rom_input_image		port map (input_image_address, input_image_data);
	IDEAL_IMAGE: rom_ideal_image		port map (ideal_image_address, ideal_image_data);

end Behavioral;

