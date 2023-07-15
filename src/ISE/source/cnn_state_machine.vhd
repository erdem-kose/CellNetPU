library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_state_machine is
	port (
			clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			alu_en: out std_logic:='0';
			alu_clk: out std_logic:='0';
			
			template_address :out std_logic_vector (templateAddressWidth-1 downto 0):=(others=>'0');
			template_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			template_we :out std_logic_vector(0 downto 0):=(others=>'0');
			template_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			bram_address :out std_logic_vector (ramAddressWidth-1 downto 0):=(others=>'0');
			bram_data_in :out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			bram_we :out std_logic_vector(0 downto 0):=(others=>'0');
			bram_data_out :in std_logic_vector (busWidth-1 downto 0);
			
			a_line: out std_logic_vector ((busWidth*patchSize-1) downto 0):=(others=>'0');
			b_line: out std_logic_vector ((busWidth*patchSize-1) downto 0):=(others=>'0');
			i_line: out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			
			x_old_line: out std_logic_vector ((busWidth*patchSize-1) downto 0):=(others=>'0');
			u_line: out std_logic_vector ((busWidth*patchSize-1) downto 0):=(others=>'0');
			x_new: in std_logic_vector (busWidth-1 downto 0)
	);
end cnn_state_machine;

architecture Behavioral of cnn_state_machine is
	component fifo
		port (
			clk : in std_logic;
			din : in std_logic_vector(busWidth-1 downto 0);
			wr_en : in std_logic;
			rd_en : in std_logic;
			dout : out std_logic_vector(busWidth-1 downto 0);
			full : out std_logic;
			empty : out std_logic
		);
	end component;
	--for FIFOs
	type fifo_type is (fifo_u,fifo_x);
	
	type fifo_vector is array(0 to 1,0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	type fifo_data is array(0 to 1,0 to patchWH-1) of std_logic;
	
	signal fifo_data_in : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_we : fifo_data := (others =>(others => '0'));
	signal fifo_re : fifo_data := (others =>(others => '0'));
	signal fifo_data_out : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_full : fifo_data := (others =>(others => '0'));
	signal fifo_empty : fifo_data := (others =>(others => '0'));
	
	--for CNN_TEMPLATES
	type patch is array (0 to patchWH-1, 0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	signal A: patch := (others => (others => (others => '0')));
	signal B: patch := (others => (others => (others => '0')));
	signal I: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_bnd: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal u_bnd: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	
	signal x_old: patch  := (others => (others => (others => '0')));
	signal u: patch  := (others => (others => (others => '0')));
	--
	
	-- for State Machine
	type fsm_states is (
								TEMPLATE_READ_INIT, TEMPLATE_READ,
								X_OLD_U_INIT, X_OLD_REQUEST_U_WRITE, X_OLD_WRITE, X_NEW_WRITE,
								CALCULATE_ERROR, CALCULATE_TEMPLATE, REWRITE_TEMPLATE,
								SUCCESS
								);
	signal state: fsm_states;
	attribute enum_encoding : string; 
	attribute enum_encoding of fsm_states: type is "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001";
	--
	
	--for Simulation
	signal sim_tmp: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	--
begin
	--Create FIFOs
	fifo_type_select:for i in 0 to 1 generate --satir
		fifo_order_select:for j in 0 to patchWH-1 generate --sutun
			FIFO_XU: fifo				port map (clk,fifo_data_in(i,j),fifo_we(i,j),fifo_re(i,j),fifo_data_out(i,j),fifo_full(i,j),fifo_empty(i,j));
		end generate fifo_order_select;
	end generate fifo_type_select;
	--Signal Conversion 2d to 1d for ALU
	abixu2line_height:for i in 0 to patchWH-1 generate --satir
		abixu2line_width:for j in 0 to patchWH-1 generate --sutun
			a_line(
						j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
						downto
						j*(busWidth)+i*(busWidth*patchWH)
			)<=A(i,j);
			b_line(
						j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
						downto
						j*(busWidth)+i*(busWidth*patchWH)
			)<=B(i,j);
			x_old_line(
						j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
						downto
						j*(busWidth)+i*(busWidth*patchWH)
			)<=x_old(i,j);
			u_line(
						j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
						downto
						j*(busWidth)+i*(busWidth*patchWH)
			)<=u(i,j);
		end generate abixu2line_width;
	end generate abixu2line_height;
	i_line<=I;
	----------
	
	--Behavioral--------
	process (clk,rst,en)
	--------------------
		variable ii : integer range 0 to imageWidth-1 := 0; --i. satir
		variable jj : integer range 0 to imageHeight-1 := 0; --j. sutun
		variable kk : integer range 0 to patchWH-1 := 0;
		variable ll : integer range 0 to patchWH-1 := 0;
		
		variable lag : integer range 0 to lagMAX := 0;
		
		variable address : integer range 0 to imageWidth*imageHeight-1 := 0;
		variable address_kl : integer range -imageWidth-1 to imageWidth+1 := 0;
		
		variable templateNo : integer range 0 to 6:= 0;
		variable template_state : integer range 0 to 5:= 0;
		
		variable read_image_patch_done : std_logic := '0';
		variable read_image_done : std_logic := '0';
		
	begin
		if (clk'event and clk='1') then
			if (rst='1') then
				bram_we<="0";template_we<="0";
				ii:= 0; jj:= 0; kk:= 0; ll:= 0; lag:=0;
				state<=TEMPLATE_READ_INIT;
				bram_address<=(others => '0'); template_address<=(others => '0');
			elsif (en='1') then
				----------------------------------
				case (state) is --start of machina
				----------------------------------
					
					--TEMPLATE READ-----------
					when TEMPLATE_READ_INIT =>
					--------------------------
						ii:=0; jj:=0; kk:=0; ll:=0; lag:=0;
						bram_we<="0";template_we<="0";
						template_state:=0;  state<=TEMPLATE_READ;
						
					when TEMPLATE_READ =>
						case (template_state) is
							when 0 =>
								address:=templateWidth*templateNo+(ii)*patchWH+(jj);
								A(ii,jj)<=template_data_out;
							when 1 =>
								address:=templateWidth*templateNo+(ii)*patchWH+(jj)+patchSize;
								B(ii,jj)<=template_data_out;
							when 2 =>
								address:=templateWidth*templateNo+2*patchSize;
								I<=template_data_out;
							when 3 =>
								address:=templateWidth*templateNo+2*patchSize+1;
								x_bnd<=template_data_out;
							when 4 =>
								address:=templateWidth*templateNo+2*patchSize+2;
								u_bnd<=template_data_out;
							when others =>
								address:=0;
						end case;
						template_address<=std_logic_vector(to_unsigned(address,templateAddressWidth));
						lag:=lag+1;
						if(lag=bramLagMAX) then
							lag:=0;
							if (template_state=0 or template_state=1) then
								if (jj=patchWH-1) then
									jj:=0;
									if (ii=patchWH-1) then
										ii:=0;
										template_state:=template_state+1;
									else
										ii:=ii+1;
									end if;
								else
									jj:=jj+1;
								end if;
							else
								template_state:=template_state+1;
							end if;
						end if;
						
						if (template_state=5) then
							state<=X_OLD_U_INIT;
						else
							state<=TEMPLATE_READ;
						end if;

					--IMAGE READ-----------
					when X_OLD_U_INIT =>
					-----------------------
						bram_we<="0";template_we<="0";
						ii:=0; jj:=0; kk:=0; ll:=0; address:=0; address_kl:=0;
						read_image_patch_done:='0';
						read_image_done:='0';
						state<=X_OLD_REQUEST_U_WRITE;
						
					when X_OLD_REQUEST_U_WRITE =>
						lag:=lag+1;
						address:=(ii)*imageWidth+(jj);
						address_kl:=(kk-1)*imageWidth+(ll-1);
						if ( (ii+kk-1)>=0 and (ii+kk-1)<=(imageWidth-1)
								and (jj+ll-1)>=0 and (jj+ll-1)<=(imageHeight-1) ) then
							bram_address<=std_logic_vector(to_unsigned(address+address_kl+ramAddressShift,ramAddressWidth));--request u
							if (lag=bramLagMAX) then
								u(kk,ll)<=bram_data_out;--read u
								bram_address<=std_logic_vector(to_unsigned(address+address_kl,ramAddressWidth));--request x
							end if;
						else
							if (lag=bramLagMAX) then
								u(kk,ll)<=u_bnd;--read u
							end if;
						end if;
						if (lag=bramLagMAX) then
							lag:=0;
							state<=X_OLD_WRITE;
						end if;

					when X_OLD_WRITE =>
						lag:=lag+1;
						if ( (ii+kk-1)>=0 and (ii+kk-1)<=(imageWidth-1)
								and (jj+ll-1)>=0 and (jj+ll-1)<=(imageHeight-1) ) then
							if (lag=bramLagMAX-1) then
								x_old(kk,ll)<=bram_data_out;--read u
							end if;
						else
							if (lag=bramLagMAX-1) then
								x_old(kk,ll)<=x_bnd;--read u
							end if;
						end if;
						if (lag=bramLagMAX-1) then
							lag:=0;
							if (ll=patchWH-1) then
								ll:=0;
								if (kk=patchWH-1) then
									kk:=0;
									read_image_patch_done:='1';
									if (jj=imageWidth-1) then
										jj:=0;
										if (ii=imageWidth-1) then
											ii:=0;
											read_image_done:='1';
										else
											ii:=ii+1;
										end if;
									else
										jj:=jj+1;
									end if;
								else
									kk:=kk+1;
								end if;
							else
								ll:=ll+1;
							end if;
							if (read_image_patch_done='1') then
								lag:=0;
								state<=X_NEW_WRITE;
								read_image_patch_done:='0';
							else
								state<=X_OLD_REQUEST_U_WRITE;
							end if;
						end if;
						
					when X_NEW_WRITE =>
						lag:=lag+1;
						alu_en<='1';
						alu_clk<='0';
						bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						bram_data_in<=x_new;
						bram_we<="1";
						if (lag=ALULagMAX-1) then
							alu_clk<='1';
						elsif (lag=ALULagMAX) then
							lag:=0;
							alu_en<='0';
							alu_clk<='0';
							bram_we<="0";
							if (read_image_done='1') then
								state<=CALCULATE_ERROR;
								read_image_done:='0';
							else
								state<=X_OLD_REQUEST_U_WRITE;
							end if;
						end if;
					
					when CALCULATE_ERROR =>
						state<=REWRITE_TEMPLATE;
					when REWRITE_TEMPLATE =>
						state<=SUCCESS;
					when SUCCESS =>
						state<=SUCCESS;
					when others =>
						state<=SUCCESS;
				end case;
			end if;
		end if;
	end process;
	ready<=	'1' when (state=SUCCESS) else
				'0';
	
end Behavioral;




