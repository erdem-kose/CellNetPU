library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_state_machine is
	port (
			sys_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			alu_rst: out std_logic:='0';
			
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
			x_new: in std_logic_vector (busWidth-1 downto 0);
			x_new_ready : in std_logic
	);
end cnn_state_machine;


architecture Behavioral of cnn_state_machine is
	component cnn_fifo
		port (
			d : in std_logic_vector(busWidth-1 downto 0);
			clk : in std_logic;
			ce : in std_logic;
			q : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	--for Clocking
	signal inv_sys_clk : std_logic:='0';
	
	--for FIFOs 0:fifo_u 1:fifo_x_old
	type fifo_vector is array(0 to 1,0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	type fifo_single is array(0 to 1,0 to patchWH-1) of std_logic;
	
	signal fifo_data_in : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_data_out : fifo_vector := (others =>(others => (others => '0')));
	signal fifo_clk_en : fifo_single := (others =>(others => '0'));
	
	--for CNN_TEMPLATES
	type patch is array (0 to patchWH-1, 0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	signal A: patch := (others => (others => (others => '0')));
	signal B: patch := (others => (others => (others => '0')));
	signal I: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x_bnd: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	signal u_bnd: std_logic_vector (busWidth-1 downto 0)  := (others => '0');
	
	type xu_patch is array (0 to patchWH-1, 0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	signal x_old: xu_patch  := (others => (others => (others => '0')));
	signal u: xu_patch  := (others => (others => (others => '0')));
	
	signal template_no : integer range 0 to templateCount-1:= 0;
	--
	
	-- for State Machine
	type fsm_states is (
								TEMPLATE_READ_INIT, TEMPLATE_READ,
								X_OLD_U_INIT, X_OLD_U_READ, X_NEW_WRITE,
								CALCULATE_TEMPLATE, REWRITE_TEMPLATE,
								SUCCESS
								);
	signal state: fsm_states;
	attribute enum_encoding : string; 
	attribute enum_encoding of fsm_states: type is "0000 0001 0010 0011 0100 0101 0110 0111";
	
	signal iter : integer range 0 to iterMAX := 0;
	
	--
	
begin
	--Clocking
	inv_sys_clk<=not sys_clk;
	--Create FIFOs
	fifo_type_select:for i in 0 to 1 generate --satir
		fifo_order_select:for j in 0 to patchWH-1 generate --sutun
			FIFO_XU: cnn_fifo				port map (fifo_data_in(i,j),inv_sys_clk,fifo_clk_en(i,j),fifo_data_out(i,j));
		end generate fifo_order_select;
	end generate fifo_type_select;
	
	--Signal Conversion 2d to 1d for ALU
	abi2line_height:for i in 0 to patchWH-1 generate --satir
		abi2line_width:for j in 0 to patchWH-1 generate --sutun
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
		end generate abi2line_width;
	end generate abi2line_height;
	i_line<=I;
	--Signal Conversion 2d to 1d for x_old and u patches
	xu2line_height:for i in 0 to patchWH-1 generate --satir
		xu2line_width:for j in 0 to patchWH-1 generate --sutun
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
		end generate xu2line_width;
	end generate xu2line_height;
	fifo2line_height:for i in 0 to patchWH-1 generate --satir
		fifo2line_width:for j in patchWH-1 to patchWH-1 generate --sutun
			x_old(i,j)<=fifo_data_out(1,i);
			u(i,j)<=fifo_data_out(0,i);
		end generate fifo2line_width;
	end generate fifo2line_height;
	----------
	
	--Behavioral--------
	process (sys_clk,rst,en)
	--------------------
		variable init_state : integer range 0 to 1 := 0;
		
		variable ii : integer range 0 to imageHeight := 0; --i. satir
		variable ii_1d : integer range 0 to imageHeight := 0; --i. satir
		variable jj : integer range 0 to imageWidth := 0; --j. sutun
		
		variable lag : integer range 0 to lagMAX := 0;
		
		variable address : integer range 0 to imageWidth*imageHeight-1 := 0;
		
		variable template_state : integer range 0 to 5:= 0;
		variable template_A_position : integer range 0 to templateWidth*(templateCount-1) := 0;
		variable template_B_position : integer range 0 to templateWidth*(templateCount-1)+patchSize := 0;
		variable bias_bound_position : integer range 0 to templateWidth*(templateCount-1)+2*patchSize := 0;
		
		variable read_init_state : integer range 0 to 3:= 0;
		variable read_image_patch_done : std_logic := '0';
		variable read_image_done : std_logic := '0';
		
	begin
		if (rising_edge(sys_clk)) then
			if (rst='1') then
				bram_we<="0";template_we<="0";
				ii:= 0; ii_1d:=0; jj:= 0; lag:=0;
				state<=TEMPLATE_READ_INIT;
				bram_address<=(others => '0'); template_address<=(others => '0');
			elsif (en='1') then
				----------------------------------
				case (state) is --start of machina
				----------------------------------
					
					--TEMPLATE READ-----------
					when TEMPLATE_READ_INIT =>
					--------------------------
						ii:=0; ii_1d:=0; jj:=0; lag:=0;
						bram_we<="0";template_we<="0";
						template_A_position:=templateWidth*template_no;
						template_B_position:=templateWidth*template_no+patchSize;
						bias_bound_position:=templateWidth*template_no+2*patchSize;
						template_state:=0;  state<=TEMPLATE_READ;
					when TEMPLATE_READ =>
						case (template_state) is
							when 0 =>
								address:=template_A_position+(ii_1d)+(jj);
								A(ii,jj)<=template_data_out;
							when 1 =>
								address:=template_B_position+(ii_1d)+(jj);
								B(ii,jj)<=template_data_out;
							when 2 =>
								address:=bias_bound_position;
								I<=template_data_out;
							when 3 =>
								address:=bias_bound_position+1;
								x_bnd<=template_data_out;
							when 4 =>
								address:=bias_bound_position+2;
								u_bnd<=template_data_out;
							when others =>
								address:=0;
						end case;
						template_address<=std_logic_vector(to_unsigned(address,templateAddressWidth));
						lag:=lag+1;
						if(lag=templateLagMAX) then
							lag:=0;
							if (template_state=0 or template_state=1) then
								if (jj=patchWH-1) then
									jj:=0;
									if (ii=patchWH-1) then
										ii:=0;ii_1d:=0;
										template_state:=template_state+1;
									else
										ii:=ii+1;
										ii_1d:=ii_1d+patchWH;
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
						ii:=0;ii_1d:=0;jj:=0;
						lag:=0;
						state<=X_OLD_U_READ;
						init_state:=1;
					when X_OLD_U_READ =>
						alu_rst<='0';
						bram_we<="0";
						if lag=0 then
							if (ii>=1 and ii<=imageHeight and jj>=1 and jj<=imageWidth) then
								address:=(ii-1)*imageWidth+(jj-1);
								bram_address<=std_logic_vector(to_unsigned(address+ramAddressShift,ramAddressWidth));
							end if;
						elsif lag=2 then
							fifo_clk_en(0,2)<='1';
							if (ii>=1 and ii<=imageHeight and jj>=1 and jj<=imageWidth) then
								fifo_data_in(0,2)<=bram_data_out;
							else
								fifo_data_in(0,2)<=u_bnd;
							end if;
							fifo_data_in(0,0)<=fifo_data_out(0,1); fifo_clk_en(0,0)<='1';
							fifo_data_in(0,1)<=fifo_data_out(0,2); fifo_clk_en(0,1)<='1';
							u(0,0)<=u(0,1);u(0,1)<=fifo_data_out(0,0);
							u(1,0)<=u(1,1);u(1,1)<=fifo_data_out(0,1);
							u(2,0)<=u(2,1);u(2,1)<=fifo_data_out(0,2);
							if (ii>=1 and ii<=imageHeight and jj>=1 and jj<=imageWidth) then
								address:=(ii-1)*imageWidth+(jj-1);
								bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
							end if;
						elsif lag=3 then
							fifo_clk_en(0,0)<='0'; fifo_clk_en(0,1)<='0';fifo_clk_en(0,2)<='0';
						elsif lag=4 then
							fifo_clk_en(1,2)<='1';
							if (ii>=1 and ii<=imageHeight and jj>=1 and jj<=imageWidth) then
								fifo_data_in(1,2)<=bram_data_out;
							else
								fifo_data_in(1,2)<=x_bnd;
							end if;
							fifo_data_in(1,0)<=fifo_data_out(1,1); fifo_clk_en(1,0)<='1';
							fifo_data_in(1,1)<=fifo_data_out(1,2); fifo_clk_en(1,1)<='1';
							x_old(0,0)<=x_old(0,1);x_old(0,1)<=fifo_data_out(1,0);
							x_old(1,0)<=x_old(1,1);x_old(1,1)<=fifo_data_out(1,1);
							x_old(2,0)<=x_old(2,1);x_old(2,1)<=fifo_data_out(1,2);
							state<=X_NEW_WRITE;
							
						end if;
						if lag>=bramLagMAX then
							lag:=0;
						else 
							lag:=lag+1;
						end if;
						
					when X_NEW_WRITE =>
						fifo_clk_en(1,0)<='0'; fifo_clk_en(1,1)<='0'; fifo_clk_en(1,2)<='0';
						if (ii>=0 and ii<=1 and jj>=2 and jj<=imageWidth and init_state=0) then
							address:=(imageWidth+ii-2)*imageWidth+(jj-2);
							bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						elsif (ii>=1 and ii<=2 and jj=0 and init_state=0) then
							address:=(imageHeight+ii-3)*imageWidth+(imageWidth-1);
							bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						elsif (ii>=3 and ii<=imageHeight and jj>=2 and jj<=imageWidth) then
							address:=(ii-3)*imageWidth+(jj-2);
							bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						elsif (ii>=4 and ii<=imageHeight and jj=0) then
							address:=(ii-4)*imageWidth+(imageWidth);
							bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						elsif (ii=0 and jj=0) then
							address:=(imageWidth+ii-3)*imageWidth+(imageWidth-1);
							bram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						else
							lag:=1;
						end if;
						if (lag=0 and x_new_ready='1') then
							bram_we<="1";
							bram_data_in<=x_new;
							alu_rst<='1';
						end if;
						if ((lag=0 and x_new_ready='1') or (lag=1)) then
							if (jj=imageWidth) then --imageHeight
								jj:=0;
								if (ii=imageHeight) then --imageWidth
									ii:=0;
								else
									ii:=ii+1;
								end if;
							else
								jj:=jj+1;
							end if;
							if (ii=patchWH and jj=1) then
								if(init_state=1) then
									init_state:=0;
									state<=X_OLD_U_READ;
								else
									if (iter=iterMAX) then
										iter<=0;
										state<=CALCULATE_TEMPLATE;
									else
										iter<=iter+1;
										state<=X_OLD_U_READ;
									end if;
								end if;
							else
								state<=X_OLD_U_READ;
							end if;
						end if;
						
					when CALCULATE_TEMPLATE =>
						alu_rst<='0';
						bram_we<="0";
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




