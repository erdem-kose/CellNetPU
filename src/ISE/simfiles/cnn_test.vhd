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
	
entity testbench is
end testbench;

architecture behavior of testbench is 
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal en : std_logic := '0';
	signal ready : std_logic := '0';
	
	signal A: patch_unsigned:= (others => (others => (others => '0')));
	signal B: patch_unsigned:= (others => (others => (others => '0')));
	signal I: std_logic_vector(busWidth-1 downto 0):= (others => '0') ;
	signal x_bnd: std_logic_vector(busWidth-1 downto 0):= (others => '0') ;
	signal u_bnd: std_logic_vector(busWidth-1 downto 0):= (others => '0') ;
	
	signal u_we :std_logic_vector (0 downto 0) := (others => '0') ;
	signal u_address :  std_logic_vector (cacheAddressWidth-1 downto 0) := (others => '0');
	signal u_data_in : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	signal u_data_out : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	
	signal x_we :std_logic_vector (0 downto 0) := (others => '0') ;
	signal x_address :  std_logic_vector (cacheAddressWidth-1 downto 0) := (others => '0');
	signal x_data_in : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	signal x_data_out : std_logic_vector (busWidth-1 downto 0) := (others => '0') ;
	
	signal ideal_we :std_logic_vector (0 downto 0) := (others => '0') ;
	signal ideal_address :  std_logic_vector (cacheAddressWidth-1 downto 0) := (others => '0');
	signal ideal_data_in : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	signal ideal_data_out : std_logic_vector (busWidth-1 downto 0) := (others => '0');
	
	signal error_u: error_patch := (others => (others => (others => '0')));
	signal error_x: error_patch := (others => (others => (others => '0')));
	signal error_i: std_logic_vector(errorWidth-1 downto 0) := (others => '0');
	
	signal rand_num: std_logic_vector (busWidth-1 downto 0) := (others => '0');
	
	signal cacheWidth: std_logic_vector(busWidth-1 downto 0);
	signal cacheHeight: std_logic_vector(busWidth-1 downto 0);
	
	signal Ts : std_logic_vector(busWidth-1 downto 0);
	signal iter_cnt: std_logic_vector(busWidth-1 downto 0);
	signal template_no : std_logic_vector(busWidth-1 downto 0);

	signal ram_init_finish : std_logic := '0';
	signal ram_out_finish : std_logic := '0';
	constant clk_100M_period : time := 10 ns;
	
	signal cache_size: signed (2*busWidth-1 downto 0) := (others=>'0');
	signal ii: integer range 0 to cacheWidthMAX*cacheHeightMAX*4-1 := 0;
begin
	-- Component Instantiation
	uut: cnn_processor
		port map(
			clk, clk, rst, en, ready,
			
			A, B, I, x_bnd, u_bnd,
			u_we, u_address, u_data_in, u_data_out,
			x_we, x_address, x_data_in, x_data_out,
			ideal_we, ideal_address, ideal_data_in, ideal_data_out,
			
			error_u, error_x, error_i,
			
			cacheWidth, cacheHeight,
			Ts, iter_cnt
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
		
		
	begin
		wait for 100 ns; -- wait until global set/reset completes
		
		A(0,0)<=std_logic_vector(to_signed(0,busWidth)); A(0,1)<=std_logic_vector(to_signed(0,busWidth)); A(0,2)<=std_logic_vector(to_signed(0,busWidth));
		A(1,0)<=std_logic_vector(to_signed(0,busWidth)); A(1,1)<=std_logic_vector(to_signed(2048,busWidth)); A(1,2)<=std_logic_vector(to_signed(0,busWidth));
		A(2,0)<=std_logic_vector(to_signed(0,busWidth)); A(2,1)<=std_logic_vector(to_signed(0,busWidth)); A(2,2)<=std_logic_vector(to_signed(0,busWidth));

		B(0,0)<=std_logic_vector(to_signed(-1024,busWidth)); B(0,1)<=std_logic_vector(to_signed(-1024,busWidth)); B(0,2)<=std_logic_vector(to_signed(-1024,busWidth));
		B(1,0)<=std_logic_vector(to_signed(-1024,busWidth)); B(1,1)<=std_logic_vector(to_signed(8192,busWidth)); B(1,2)<=std_logic_vector(to_signed(-1024,busWidth));
		B(2,0)<=std_logic_vector(to_signed(-1024,busWidth)); B(2,1)<=std_logic_vector(to_signed(-1024,busWidth)); B(2,2)<=std_logic_vector(to_signed(-1024,busWidth));

		I<=std_logic_vector(to_signed(-512,busWidth));
		x_bnd<=std_logic_vector(to_signed(0,busWidth));
		u_bnd<=std_logic_vector(to_signed(0,busWidth));
		
		cacheWidth<=std_logic_vector(to_unsigned(16,busWidth));
		cacheHeight<=std_logic_vector(to_unsigned(16,busWidth));
		
		Ts<=std_logic_vector(to_unsigned(10,busWidth));
		iter_cnt<=std_logic_vector(to_unsigned(199,busWidth));
		
		wait for clk_100M_period;
		cache_size<=signed(cacheWidth)*signed(cacheHeight);
		
		if (ram_init_finish='0') then
			file_open(infile,"simfiles/ram_sim.init",read_mode);
			while not endfile(infile) loop
				readline(infile,inline);
				read(inline, dataread);
				if (ii<cache_size) then
					x_address<=std_logic_vector(to_unsigned(ii,cacheAddressWidth));
					x_data_in<=dataread;
					x_we<="1";
				elsif (ii<2*cache_size) then
					u_address<=std_logic_vector(to_unsigned(ii-to_integer(cache_size),cacheAddressWidth));
					u_data_in<=dataread;
					u_we<="1";
				elsif (ii<3*cache_size) then
					ideal_address<=std_logic_vector(to_unsigned(ii-2*to_integer(cache_size),cacheAddressWidth));
					ideal_data_in<=dataread;
					ideal_we<="1";
				end if;
				wait until rising_edge(clk);
				if (ii<cache_size) then
					x_we<="0";
				elsif (ii<2*cache_size) then
					u_we<="0";
				elsif (ii<3*cache_size) then
					ideal_we<="0";
				end if;
				if (not endfile(infile)) then
					ii<=ii+1;
				else
					ii<=0;
				end if;
				wait until rising_edge(clk);
			end loop;
			file_close(infile);
			ram_init_finish<='1';
		end if;
		
		wait until rising_edge(clk);
		en<='1';
		rst<='1';
		wait until rising_edge(clk);
		rst<='0';
		wait until rising_edge(clk);
		
		wait until ready = '1';
		
		if (ram_out_finish='0') then
			file_open(outfile,"simfiles/cnn_simulation.out",write_mode);
			while ii<=cacheWidth*cacheHeight-1 loop
				x_address<=std_logic_vector(to_unsigned(ii,cacheAddressWidth));
				wait until rising_edge(clk);wait until rising_edge(clk);
				datawrite:=x_data_out;
				write(outline, datawrite);
				writeline(outfile,outline);
				if (ii<=cacheWidth*cacheHeight-1) then
					ii<=ii+1;
				else
					ii<=0;
				end if;
				wait until rising_edge(clk);
			end loop;
			file_close(outfile);
			ram_out_finish<='1';
		end if;
		wait;--wait till end
	end process tb;
  --  End Test Bench 
END;
