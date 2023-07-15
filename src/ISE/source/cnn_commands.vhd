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

entity cnn_commands is
	port
	(
		clk : in std_logic;
		
		control_data_in : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		control_address : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
		cacheWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(cacheWidthMAX,busWidth));
		cacheHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(cacheHeightMAX,busWidth));
		
		Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
		iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
		
		cnn_rst: out std_logic:='1';
		
		rand_gen: out std_logic:='0'
	);
end cnn_commands;

architecture Behavioral of cnn_commands is

begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			case (to_integer(unsigned(control_address))) is
				when 0 =>
				
				when 1 =>
					cacheWidth<=control_data_in;
				when 2 =>
					cacheHeight<=control_data_in;
				when 3 =>
					Ts<=control_data_in;
				when 4 =>
					iter_cnt<=control_data_in;
				when 5 =>
					rand_gen<=control_data_in(0);
				when 6 =>
					cnn_rst<=control_data_in(0);
				when others =>
					
			end case;
		end if;
	end process;

end Behavioral;

