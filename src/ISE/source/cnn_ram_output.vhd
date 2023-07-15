library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_ram_output is
	port (
			en : in  std_logic;
					
			out_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			out_data :in std_logic_vector (busWidth-1 downto 0);
			out_we :out std_logic_vector(0 downto 0):=(others => '0');
			
			adrs_1 :in std_logic_vector (ramAddressWidth-1 downto 0);
			data_1 :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			wen_1 :in std_logic_vector(0 downto 0);
			
			adrs_2 :in std_logic_vector (ramAddressWidth-1 downto 0);
			data_2 :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			wen_2 :in std_logic_vector(0 downto 0)
	);
end cnn_ram_output;

architecture Behavioral of cnn_ram_output is

begin
	
	data_1<=out_data when (en='1') else (others=>'0');
	data_2<=out_data when (en='0') else (others=>'0');
	out_address<=adrs_1 when (en='1') else adrs_2;
	out_we<=wen_1 when (en='1') else wen_2;

end Behavioral;




