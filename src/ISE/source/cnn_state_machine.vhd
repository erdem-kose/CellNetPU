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
			ready: out std_logic;
			template_address :out std_logic_vector (templateAddressWidth-1 downto 0);
			template_data_in :out std_logic_vector (busWidth-1 downto 0);
			template_we :out std_logic;
			template_data_out :in std_logic_vector (busWidth-1 downto 0);
			ram_address :out std_logic_vector (ramAddressWidth-1 downto 0);
			ram_data_in :out std_logic_vector (busWidth-1 downto 0);
			ram_we :out std_logic;
			ram_data_out :in std_logic_vector (busWidth-1 downto 0);
			rom_image_out : in std_logic_vector (busWidth-1 downto 0);
			rom_image_address : out std_logic_vector (romAddressWidth-1 downto 0);
			rom_ideal_out : in std_logic_vector (busWidth-1 downto 0);
			rom_ideal_address : out std_logic_vector (romAddressWidth-1 downto 0);
			a_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: out std_logic_vector (busWidth-1 downto 0);
			x_old_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line: out std_logic_vector ((busWidth*patchSize-1) downto 0);
			x_new: in std_logic_vector (busWidth-1 downto 0)
	);
end cnn_state_machine;

architecture Behavioral of cnn_state_machine is
	
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
	type FSM_States is (
								read_template_init, read_template_request, read_template_write,
								read_image_init, read_image_request, read_image_write,
								process_image,
								write_image_request, write_image_write,
								read_images_request, calculate_error,
								calculate_template, rewrite_template,
								success
								);
	signal state: FSM_States;
	ATTRIBUTE ENUM_ENCODING : STRING; 
	ATTRIBUTE ENUM_ENCODING OF FSM_States: TYPE IS "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101";
	--
	
begin
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
	
	process (clk,rst,en)
		variable ii : integer range 0 to imageWidth-1 := 0; --i. satir
		variable jj : integer range 0 to imageHeight-1 := 0; --j. sutun
		variable kk : integer range 0 to imageWidth-1 := 0;
		variable ll : integer range 0 to imageHeight-1 := 0;
		
		variable address : integer := 0;
		variable address_kl : integer := 0;
		
		variable templateNo : integer := 0;
		variable template_state : integer := 0;
		
		variable read_image_patch_done : std_logic := '0';
		variable read_image_done : std_logic := '0';
		
	begin
		if (clk'event and clk='1') then
			if (rst='1') then
				ii:= 0; jj:= 0; kk:= 0; ll:= 0;
				state<=read_template_init;
				rom_image_address<=(others => '0'); rom_ideal_address<=(others => '0');
				ram_address<=(others => '0'); template_address<=(others => '0');
			elsif (en='1') then
				----------------------------------
				case (state) is --start of machina
				----------------------------------
				
					--TEMPLATE READ-----------
					when read_template_init =>
					--------------------------
						ii:=0; jj:=0; kk:=0; ll:=0; template_state:=0;
						state<=read_template_request;
						
					when read_template_request =>
						case (template_state) is
							when 0 =>
								address:=templateWidth*templateNo+(ii)*patchWH+(jj);
							when 1 =>
								address:=templateWidth*templateNo+(ii)*patchWH+(jj)+patchSize;
							when 2 =>
								address:=templateWidth*templateNo+2*patchSize;
							when 3 =>
								address:=templateWidth*templateNo+2*patchSize+1;
							when 4 =>
								address:=templateWidth*templateNo+2*patchSize+2;
							when others =>
								address:=0;
						end case;

						template_address<=std_logic_vector(to_unsigned(address,templateAddressWidth));
						state<=read_template_write;
						
					when read_template_write =>
						case (template_state) is
							when 0 =>
								A(ii,jj)<=template_data_out;
								state<=read_template_request;
							when 1 =>
								B(ii,jj)<=template_data_out;
								state<=read_template_request;
							when 2 =>
								I<=template_data_out;
								state<=read_template_request;
							when 3 =>
								x_bnd<=template_data_out;
								state<=read_template_request;
							when 4 =>
								u_bnd<=template_data_out;
								state<=read_image_init;
							when others =>

						end case;
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
						
					--IMAGE READ-----------
					when read_image_init =>
					-----------------------
						ii:=0; jj:=0; kk:=0; ll:=0; address:=0; address_kl:=0; read_image_patch_done:='0';
						state<=read_image_request;
						
					when read_image_request =>
						ram_we<='0';
						address:=(ii)*imageWidth+(jj);
						address_kl:=(kk-1)*imageWidth+(ll-1);
						if ( (ii+kk-1)>=0 and (ii+kk-1)<=(imageWidth-1) and (jj+ll-1)>=0 and (jj+ll-1)<=(imageHeight-1) ) then
							rom_image_address<=std_logic_vector(to_unsigned(address+address_kl,romAddressWidth));
							ram_address<=std_logic_vector(to_unsigned(address+address_kl,ramAddressWidth));
						end if;
						state<=read_image_write;
						
					when read_image_write =>
						if ( (ii+kk-1)>=0 and (ii+kk-1)<=(imageWidth-1) and (jj+ll-1)>=0 and (jj+ll-1)<=(imageHeight-1) ) then
							u(kk,ll)<=rom_image_out;
							x_old(kk,ll)<=ram_data_out;
						else
							u(kk,ll)<=u_bnd;
							x_old(kk,ll)<=x_bnd;
						end if;
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
						state<=process_image;
						
					when process_image =>
						if (read_image_patch_done='1') then
							state<=write_image_request;
							read_image_patch_done:='0';
						else
							state<=read_image_request;
						end if;
						
					when write_image_request =>
						ram_address<=std_logic_vector(to_unsigned(address,ramAddressWidth));
						state<=write_image_write;
						
					when write_image_write =>
						ram_data_in<=x_new;
						ram_we<='1';
						if (read_image_done='1') then
							state<=calculate_error;
							read_image_done:='0';
						else
							state<=read_image_request;
						end if;
					when calculate_error =>
						ram_we<='0';
						state<=rewrite_template;
					when rewrite_template =>
						state<=success;
					when success =>
						state<=success;
					when others =>
						state<=success;
				end case;
			end if;
		end if;
	end process;
	ready<=	'1' when (state=success) else
				'0';
	
end Behavioral;



