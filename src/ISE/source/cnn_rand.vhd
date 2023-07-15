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
	
entity cnn_rand is
	port (
		clk: in  std_logic;
		rand_gen: in  std_logic;
		rand_num: out std_logic_vector (busWidth-1 downto 0):=(others=>'0')
	);
end cnn_rand;

architecture Behavioral of cnn_rand is
	signal rand_temp: signed (busWidth-1 downto 0) := (others=>'0');
begin
					
	process (clk)
		
	begin
		if (rising_edge(clk)) then
			--Galois Linear-feedback shift register

			--x^10+x^7+1, period 2^n-1 = 1023
			rand_temp(15 downto 10)<=(others=>rand_temp(0));
			rand_temp(9)<=rand_temp(0) xor '1';
			rand_temp(8)<=rand_temp(9);
			rand_temp(7)<=rand_temp(8);
			rand_temp(6)<=rand_temp(7) xor rand_temp(0);
			rand_temp(5)<=rand_temp(6);
			rand_temp(4)<=rand_temp(5);
			rand_temp(3)<=rand_temp(4);
			rand_temp(2)<=rand_temp(3);
			rand_temp(1)<=rand_temp(2);
			rand_temp(0)<=rand_temp(1);
			if(rand_gen='1') then
				rand_num<=std_logic_vector(rand_temp);
			end if;
		end if;
	end process;
end Behavioral;

