library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;

entity cnn_fifo is
	port (
		d : in std_logic_vector(busWidth-1 downto 0);
		clk : in std_logic;
		ce : in std_logic;
		q : out std_logic_vector(busWidth-1 downto 0);
	 
		imageWidth: in integer range 0 to 1920
	);
end cnn_fifo;

architecture Behavioral of cnn_fifo is
	component fifo_bram_core
	  port (
		 clka : in std_logic;
		 wea : in std_logic_vector(0 downto 0);
		 addra : in std_logic_vector(fifoCoreAddressWidth-1 downto 0);
		 dina : in std_logic_vector(busWidth-1 downto 0);
		 douta : out std_logic_vector(busWidth-1 downto 0);
		 clkb : in std_logic;
		 web : in std_logic_vector(0 downto 0);
		 addrb : in std_logic_vector(fifoCoreAddressWidth-1 downto 0);
		 dinb : in std_logic_vector(busWidth-1 downto 0);
		 doutb : out std_logic_vector(busWidth-1 downto 0)
	  );
	end component;
	
	signal read_address : integer range 0 to imageWidthMAX:= 0;
	signal write_address : integer range 0 to imageWidthMAX:= imageWidth;
		
	signal bram_read_address : std_logic_vector (fifoCoreAddressWidth-1 downto 0):=(others=>'0');
	signal bram_read_data_in : std_logic_vector (busWidth-1 downto 0):=(others=>'0');
	signal bram_read_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal bram_read_data_out : std_logic_vector (busWidth-1 downto 0):=(others=>'0');

	signal bram_write_address : std_logic_vector (fifoCoreAddressWidth-1 downto 0):=(others=>'0');
	signal bram_write_data_in : std_logic_vector (busWidth-1 downto 0):=(others=>'0');
	signal bram_write_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal bram_write_data_out : std_logic_vector (busWidth-1 downto 0):=(others=>'0');


begin
	BRAM_CORE: fifo_bram_core
		port map (
						clk, bram_read_we, bram_read_address, bram_read_data_in, bram_read_data_out,
						clk, bram_write_we, bram_write_address, bram_write_data_in, bram_write_data_out
					);
	

	bram_write_we<="1" when (ce='1') else "0";
	bram_read_address<=std_logic_vector(to_unsigned(read_address,fifoCoreAddressWidth));
	bram_write_address<=std_logic_vector(to_unsigned(write_address,fifoCoreAddressWidth));

	q<=bram_read_data_out;
	
	process (clk,ce)
	begin
		if(ce='1') then
			if (falling_edge(clk)) then
				bram_write_data_in<=d;
				if(read_address=imageWidth) then
					read_address<=0;
					write_address<=imageWidth;
				elsif(write_address=imageWidth) then
					read_address<=1;
					write_address<=0;
				else
					read_address<=read_address+1;
					write_address<=write_address+1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

