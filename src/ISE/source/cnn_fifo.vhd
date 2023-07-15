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

entity cnn_fifo is
	port
	(
		d : in std_logic_vector(busWidth-1 downto 0);
		clk : in std_logic;
		ce : in std_logic;
		q : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	 
		cacheWidth: in integer range 0 to cacheWidthMAX
	);
end cnn_fifo;

architecture Behavioral of cnn_fifo is
	signal FIFO: fifo_core:=(others=>(others=>'0'));
begin
	process (clk,ce)
		variable read_address : integer range 0 to cacheWidthMAX:= 0;
		variable write_address : integer range 0 to cacheWidthMAX:= cacheWidthMAX;
	begin
		if (falling_edge(clk)) then
			if(ce='1') then
				if(read_address=cacheWidth) then
					read_address:=0;
					write_address:=cacheWidth;
				elsif(write_address=cacheWidth) then
					read_address:=1;
					write_address:=0;
				else
					read_address:=read_address+1;
					write_address:=write_address+1;
				end if;
				q<=FIFO(read_address);
				FIFO(write_address)<=d;
			else
				if (read_address=0) then
					write_address:=cacheWidth;
				end if;
			end if;
			
		end if;
	end process;
end Behavioral;