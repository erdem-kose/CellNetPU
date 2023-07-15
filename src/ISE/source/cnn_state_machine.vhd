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
	
entity cnn_state_machine is
	port
	(
		sys_clk, rst, en : in  std_logic;
		ready: out std_logic:='0';
		alu_calc: out std_logic:='0';
		alu_err_rst: out std_logic:='0';
		
		u_we : out std_logic_vector(0 downto 0):=(others=>'0');
		u_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
		u_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		u_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		x_we : out std_logic_vector(0 downto 0):=(others=>'0');
		x_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
		x_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		x_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		ideal_we : out std_logic_vector(0 downto 0):=(others=>'0');
		ideal_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
		ideal_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		ideal_data_out : in std_logic_vector(busWidth-1 downto 0);
		
		x_bnd: in std_logic_vector(busWidth-1 downto 0);
		u_bnd: in std_logic_vector(busWidth-1 downto 0);
		
		x_old_out: out patch_unsigned:=(others => (others => (others => '0')));
		u_out: out patch_unsigned:=(others => (others => (others => '0')));
		
		x_new: in std_logic_vector (busWidth-1 downto 0);
		x_new_ready : in std_logic;
		
		ideal: out  std_logic_vector (busWidth-1 downto 0):=(others=>'0');
		
		cacheWidth: in integer range 0 to cacheWidthMAX;
		cacheHeight: in integer range 0 to cacheHeightMAX;
		
		iter_cnt: in integer range 0 to iterMAX
	);
end cnn_state_machine;


architecture Behavioral of cnn_state_machine is
	signal x_old: patch_unsigned:=(others => (others => (others => '0')));
	signal u: patch_unsigned:=(others => (others => (others => '0')));
		
	--for FIFOs 0:fifo_u 1:fifo_x_old
	signal fifo_data_in : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_data_out : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_clk_en : fifo_single := (others =>(others => '0'));
	
	-- for State Machine
	signal state: fsm_states;
	
	signal iter : integer range 0 to iterMAX := 0;
	signal cacheAddressShift: integer := cacheWidth*cacheHeight;
	--
	
begin
	--ALU
	xu_buff_i:for i in 0 to patchWH-1 generate
		xu_buff_j:for j in 0 to patchWH-2 generate
			u_out(i,j)<=u(i,j);
			x_old_out(i,j)<=x_old(i,j);
		end generate xu_buff_j;
	end generate xu_buff_i;
	
	--Create FIFOs
	fifo_line_select:for j in 0 to patchWH-1 generate
		L1CACHE_FIFO_U: cnn_fifo			port map
			(
				fifo_data_in(0,j), sys_clk, fifo_clk_en(0,j), fifo_data_out(0,j), cacheWidth
			);
		L1CACHE_FIFO_X: cnn_fifo			port map
			(
				fifo_data_in(1,j), sys_clk, fifo_clk_en(1,j), fifo_data_out(1,j), cacheWidth
			);
	end generate fifo_line_select;
	
	fifo2line:for i in 0 to patchWH-1 generate--Connect Output of FIFO to CNN-AU Input Patch
		u_out(i,patchWH-1)<= fifo_data_out(0,i);
		x_old_out(i,patchWH-1)<=fifo_data_out(1,i);
	end generate fifo2line;
	----------
	
	--Behavioral--------
	process (sys_clk,rst,en)
	--------------------
		variable init_state : integer range 0 to 1 := 0;
		
		variable ii : integer range 0 to cacheHeightMAX := 0; --i. satir
		variable ii_1d : integer range 0 to cacheHeightMAX*cacheWidthMAX := 0; --i. satir
		variable jj : integer range 0 to cacheWidthMAX := 0; --j. sutun
		
		variable cache_lag : integer range 0 to cacheLagMAX := 0;
		variable cache_wr_lag : integer range 0 to cacheWrLagMAX := 0;
		
		variable address : integer range 0 to cacheWidthMAX*cacheHeightMAX-1 := 0;
		
		variable read_init_state : integer range 0 to 3:= 0;
		variable read_image_patch_done : std_logic := '0';
		variable read_image_done : std_logic := '0';
		
	begin
		if (rising_edge(sys_clk)) then
			if (rst='1') then
				cacheAddressShift <= cacheWidth*cacheHeight;
				
				u_we<="0";x_we<="0";ideal_we<="0";
				ii:= 0; ii_1d:=0; jj:= 0; cache_lag:=0; cache_wr_lag:=0;
				state<=X_OLD_U_INIT;
				
				u_address<=(others => '0'); x_address<=(others => '0'); ideal_address<=(others => '0'); 
			elsif (en='1') then
				----------------------------------
				case (state) is --start of machina
				----------------------------------
					--IMAGE READ-----------
					when X_OLD_U_INIT =>
					-----------------------
						ii:=0;ii_1d:=0;jj:=0;
						cache_lag:=0; cache_wr_lag:=0;
						cacheAddressShift <= cacheWidth*cacheHeight;
						state<=X_OLD_U_READ;
						init_state:=1;
					when X_OLD_U_READ =>
						x_we<="0";
						if iter<(iter_cnt) then
							alu_err_rst<='1';
						elsif iter=(iter_cnt) then
							alu_err_rst<='0';
						end if;
						if cache_lag=0 then--Assign Read Addresses
							if (ii>=1 and ii<=cacheHeight and jj>=1 and jj<=cacheWidth) then
								address:=ii_1d-cacheWidth+(jj-1);--(ii-1)*cacheWidth+(jj-1);
								u_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							end if;
							if (ii>=0 and ii<=1 and jj>=1 and jj<=cacheWidth and init_state=0) then
								address:=cacheAddressShift+ii_1d-cacheWidth-cacheWidth+(jj-1);
								--(cacheHeight+ii-2)*cacheWidth+(jj-2);
								ideal_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (ii>=3 and ii<=cacheHeight and jj>=1 and jj<=cacheWidth) then
								address:=ii_1d-cacheWidth-cacheWidth-cacheWidth+(jj-1);
								--(ii-3)*cacheWidth+(jj-2);
								ideal_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							end if;
						elsif cache_lag=1 then--Assign Write Address
							cache_wr_lag:=0;
							if (ii>=0 and ii<=1 and jj>=2 and jj<=cacheWidth and init_state=0) then
								address:=cacheAddressShift+ii_1d-cacheWidth-cacheWidth+(jj-2);
								--(cacheHeight+ii-2)*cacheWidth+(jj-2);
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (ii>=1 and ii<=2 and jj=0 and init_state=0) then
								address:=cacheAddressShift+ii_1d-cacheWidth-cacheWidth-1;
								--(cacheHeight+ii-3)*cacheWidth+(cacheWidth-1);
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (ii>=3 and ii<=cacheHeight and jj>=2 and jj<=cacheWidth) then
								address:=ii_1d-cacheWidth-cacheWidth-cacheWidth+(jj-2);
								--(ii-3)*cacheWidth+(jj-2);
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (ii>=4 and ii<=cacheHeight and jj=0) then
								address:=ii_1d-cacheWidth-cacheWidth-cacheWidth-1;
								--(ii-4)*cacheWidth+(cacheWidth-1);
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (ii=0 and jj=0) then
								address:=cacheAddressShift+ii_1d-cacheWidth-cacheWidth-1;
								--(cacheHeight+ii-3)*cacheWidth+(cacheWidth-1);
								x_address<=std_logic_vector(to_unsigned(address,cacheAddressWidth));
							elsif (jj=1) then
							else
								cache_wr_lag:=2;
							end if;
							
						elsif cache_lag=2 then--Assign FIFOs and CNN-AU X and U patches
							for i in 0 to patchWH-1 loop --i. satir
								fifo_clk_en(0,i)<='1'; fifo_clk_en(1,i)<='1';
							end loop;
							if (ii>=1 and ii<=cacheHeight and jj>=1 and jj<=cacheWidth) then
								fifo_data_in(0,patchWH-1)<=u_data_out;
								fifo_data_in(1,patchWH-1)<=x_data_out;
							else
								fifo_data_in(0,patchWH-1)<=u_bnd;
								fifo_data_in(1,patchWH-1)<=x_bnd;
							end if;
							for i in 0 to patchWH-1 loop --i. satir
								for j in 0 to patchWH-1 loop --j. sutun
									if (i<patchWH-1) then
										fifo_data_in(0,i)<=fifo_data_out(0,i+1);
										fifo_data_in(1,i)<=fifo_data_out(1,i+1);
									end if;
									if (j<patchWH-2) then
										u(i,j)<=u(i,j+1);
										x_old(i,j)<=x_old(i,j+1);
									elsif (j=patchWH-2) then
										u(i,j)<=fifo_data_out(0,i);
										x_old(i,j)<=fifo_data_out(1,i);
									end if;
								end loop;
							end loop;
							ideal<=ideal_data_out;
							state<=X_NEW_WRITE;
						end if;
						if cache_lag>=cacheLagMAX then
							cache_lag:=0;
						else 
							cache_lag:=cache_lag+1;
						end if;
						
					when X_NEW_WRITE =>
						fifo_clk_en(0,0)<='0'; fifo_clk_en(0,1)<='0'; fifo_clk_en(0,2)<='0';
						fifo_clk_en(1,0)<='0'; fifo_clk_en(1,1)<='0'; fifo_clk_en(1,2)<='0';
						
						if (cache_wr_lag=0 and x_new_ready='1') then
							alu_calc<='1';
							cache_wr_lag:=1;
						elsif (cache_wr_lag=1) then
							alu_calc<='0';
							if (jj/=1) then 
								x_we<="1";
								x_data_in<=x_new;
							end if;
							cache_wr_lag:=2;
						end if;
						if (cache_wr_lag=2) then
							if (jj=cacheWidth) then --cacheHeight
								jj:=0;
								if (ii=cacheHeight) then --cacheWidth
									ii:=0;
									ii_1d:=0;
								else
									ii:=ii+1;
									ii_1d:=ii_1d+cacheWidth;
								end if;
							else
								jj:=jj+1;
							end if;
							if (ii=patchWH and jj=1) then
								if(init_state=1) then
									init_state:=0;
									state<=X_OLD_U_READ;
								else
									if (iter=iter_cnt) then
										iter<=0;
										alu_err_rst<='1';
										state<=SUCCESS;
									else
										iter<=iter+1;
										state<=X_OLD_U_READ;
									end if;
								end if;
							else
								state<=X_OLD_U_READ;
							end if;
							cache_wr_lag:=0;
						end if;
					when SUCCESS =>
						x_we<="0";
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




