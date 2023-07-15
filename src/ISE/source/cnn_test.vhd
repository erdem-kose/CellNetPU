library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;
	
entity testbench is
end testbench;

architecture behavior of testbench is 

-- Component Declaration
	component cnn_processor is
		port (
			sys_clk, div_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
				
			iter_cnt: in std_logic_vector(busWidth-1 downto 0);
			template_no : in std_logic_vector(busWidth-1 downto 0);
			Ts : in std_logic_vector(busWidth-1 downto 0);
			
			imageWidth: in std_logic_vector(busWidth-1 downto 0);
			imageHeight: in std_logic_vector(busWidth-1 downto 0);
			
			ram_we :out  std_logic_vector(0 downto 0):=(others=>'0');
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			ram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
				
			template_interface_we : in std_logic_vector(0 downto 0);
			template_interface_address : in std_logic_vector(templateAddressWidth-1 downto 0);
			template_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			template_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
			
			error_norm_sum: out std_logic_vector (errorWidth-1 downto 0);
			error_squa_sum: out std_logic_vector (errorWidth-1 downto 0)
		);
	end component;
	
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal en : std_logic := '0';
	signal ready : std_logic := '0';
	
	signal iter_cnt: std_logic_vector(busWidth-1 downto 0);
	signal template_no : std_logic_vector(busWidth-1 downto 0);
	signal Ts : std_logic_vector(busWidth-1 downto 0);
			
	signal imageWidth: std_logic_vector(busWidth-1 downto 0);
	signal imageHeight: std_logic_vector(busWidth-1 downto 0);
			
	signal ram_we :std_logic_vector (0 downto 0) := (others => '0') ;
	signal ram_address :  std_logic_vector (ramAddressWidth-1 downto 0) := (others => '0');
	signal ram_data_in : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	signal ram_data_out : std_logic_vector (busWidth-1 downto 0) := (others => '0') ;
	
	signal template_interface_we :std_logic_vector (0 downto 0) := (others => '0') ;
	signal template_interface_address :  std_logic_vector (templateAddressWidth-1 downto 0) := (others => '0');
	signal template_interface_data_in : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	signal template_interface_data_out : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	
	signal error_norm_sum: std_logic_vector (errorWidth-1 downto 0) := (others => '0');
	signal error_squa_sum: std_logic_vector (errorWidth-1 downto 0) := (others => '0');
			
	type ram_struct is array (0 to imageWidthMAX*imageHeightMAX*4-1) of std_logic_vector (busWidth-1 downto 0);
	signal ram: ram_struct := (others => (others => '0'));
	signal ram_init_finish : std_logic := '0';
	signal ram_out_finish : std_logic := '0';
	constant clk_100M_period : time := 10 ns;
	
	signal i: integer range 0 to imageWidthMAX*imageHeightMAX*3-1 := 0;
	
begin
	-- Component Instantiation
	uut: cnn_processor
		port map(
			clk, rst, en, ready,
			iter_cnt, template_no, Ts, imageWidth, imageHeight,
			ram_we, ram_address, ram_data_in, ram_data_out,
			template_interface_we, template_interface_address, template_interface_data_in, template_interface_data_out,
			error_norm_sum, error_squa_sum
		);
					
	--clock
	clock : process
	begin
		clk <= '0';
		wait for clk_100M_period/2;
		clk <= '1';
		wait for clk_100M_period/2;
	end process clock;
	
	--  Test Bench Statements
	tb : process
		file infile: text;
		variable inline: line;
		variable dataread : std_logic_vector (busWidth-1 downto 0);
		file outfile: text;
		variable outline: line;
		variable datawrite : std_logic_vector (busWidth-1 downto 0);
		
		variable address: integer range 0 to imageWidthMAX*imageHeightMAX*3-1 := 0;
	begin
		wait for 100 ns; -- wait until global set/reset completes
		
		if (ram_init_finish='0') then
			file_open(infile,"simfiles/ram_sim.init",read_mode);
			while not endfile(infile) loop
				readline(infile,inline);
				read(inline, dataread);
				ram(i)<=dataread;
				if (not endfile(infile)) then
					i<=i+1;
				else
					i<=0;
				end if;
				wait until rising_edge(clk);
			end loop;
			file_close(infile);
			ram_init_finish<='1';
		end if;
		
		imageWidth<=std_logic_vector(to_unsigned(16,ramAddressWidth));
		imageHeight<=std_logic_vector(to_unsigned(16,ramAddressWidth));
		iter_cnt<=std_logic_vector(to_unsigned(199,ramAddressWidth));
		template_no<=std_logic_vector(to_unsigned(1,ramAddressWidth));
		Ts<=std_logic_vector(to_unsigned(10,ramAddressWidth));

		en<='1';
		rst<='1';
		wait for clk_100M_period/2;
		rst<='0';
		wait for clk_100M_period/2;
		
		while ready='0' loop
			wait for clk_100M_period;
			if ram_we="1" then
				ram(address)<=ram_data_in;
			else
				ram_data_out<=ram(address);
			end if;
			address:=to_integer(unsigned(ram_address));
		end loop;
		
		if (ram_out_finish='0') then
			file_open(outfile,"simfiles/cnn_simulation.out",write_mode);
			while i<=imageWidth*imageHeight-1 loop
				datawrite:=ram(i);
				write(outline, datawrite);
				writeline(outfile,outline);
				if (i<=imageWidth*imageHeight-1) then
					i<=i+1;
				else
					i<=0;
				end if;
				wait until rising_edge(clk);
			end loop;
			file_close(outfile);
			ram_out_finish<='1';
		end if;
		wait; -- will wait forever
	end process tb;
  --  End Test Bench 
END;
