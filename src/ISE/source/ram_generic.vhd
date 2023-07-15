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
	
entity ram_generic is
port 
	(
		clka   : in  std_logic;
		wea    : in  std_logic_vector(0 downto 0);
		addra  : in  std_logic_vector(cacheAddressWidth-1 downto 0);
		dina   : in  std_logic_vector(busWidth-1 downto 0);
		douta  : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		clkb   : in  std_logic;
		web    : in  std_logic_vector(0 downto 0);
		addrb  : in  std_logic_vector(cacheAddressWidth-1 downto 0);
		dinb   : in  std_logic_vector(busWidth-1 downto 0);
		doutb  : out std_logic_vector(busWidth-1 downto 0):=(others=>'0')
	);
end ram_generic;
 
architecture Behavioral of ram_generic is
	-- Shared memory
	type mem_type is array ( (2**cacheAddressWidth)-1 downto 0 ) of std_logic_vector(busWidth-1 downto 0);
	shared variable mem : mem_type :=(others=>(others=>'0'));
begin
	-- Port A
	process(clka)
	begin
		if(clka'event and clka='1') then
			if(wea="1") then
				mem(conv_integer(addra)) := dina;
			end if;
			douta <= mem(conv_integer(addra));
		end if;
	end process;
	 
	-- Port B
	process(clkb)
	begin
		if(clkb'event and clkb='1') then
			if(web="1") then
				mem(conv_integer(addrb)) := dinb;
			end if;
			doutb <= mem(conv_integer(addrb));
		end if;
	end process;
end Behavioral;