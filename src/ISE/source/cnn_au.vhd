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
	
entity cnn_au is
	port
	(
		clk, calc, err_rst : in  std_logic;
			
		A_in: in patch_unsigned;
		B_in: in patch_unsigned;
		I_in: in std_logic_vector(busWidth-1 downto 0);
		x_in: in patch_unsigned;
		u_in: in patch_unsigned;
		
		x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
		x_out_ready : out std_logic:='1';
			
		Ts : in integer range 0 to busUSMax;
		
		ideal_line: in  std_logic_vector (busWidth-1 downto 0);
		
		error_u: out error_patch:= (others => (others => (others => '0')));
		error_x: out error_patch:= (others => (others => (others => '0')));
		error_i: out std_logic_vector(errorWidth-1 downto 0):= (others => '0')
	);
end cnn_au;

architecture Behavioral of cnn_au is
	--CNN Calculation
			
	signal A: patch_signed := (others => (others => (others => '0')));
	signal B: patch_signed := (others => (others => (others => '0')));
	signal I: signed (busWidth-1 downto 0):= (others => '0');
	signal x: patch_signed := (others => (others => (others => '0')));
	signal u: patch_signed := (others => (others => (others => '0')));
	
	signal x_temp_0 : signed ((2*busWidth+2*(patchWH*patchWH)+1-busF) downto 0)  := (others => '0');
	signal x_temp_1 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_2 : signed ((busWidth) downto 0)  := (others => '0');
	signal x_temp_3 : signed ((2*busWidth+1) downto 0)  := (others => '0');
	signal x_temp_4 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_5 : signed ((busWidth) downto 0)  := (others => '0');

	signal mul : muls := (others => (others => '0'));
	
	--Error Calculation
	signal ideal: signed (busWidth-1 downto 0):=(others => '0');
	
	signal error_step0: signed (busWidth downto 0):=(others=>'0');
	signal error_step1: signed (busWidth-1 downto 0):=(others => '0');
	
	signal error_i_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_i_step0: signed (errorWidth downto 0):=(others => '0'); signal error_i_step1: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u_reg: error_ux_reg :=(others => (others => (others => '0')));
	signal error_u_step0: error_ux_step0 :=(others => (others => (others => '0'))); signal error_u_step1: error_ux_step1 :=(others => (others => (others => '0')));
	signal error_u_step2: error_ux_step2 :=(others => (others => (others => '0'))); signal error_u_step3: error_ux_step3 :=(others => (others => (others => '0')));

	signal error_x_reg: error_ux_reg :=(others => (others => (others => '0')));
	signal error_x_step0: error_ux_step0 :=(others => (others => (others => '0'))); signal error_x_step1: error_ux_step1 :=(others => (others => (others => '0')));
	signal error_x_step2: error_ux_step2 :=(others => (others => (others => '0'))); signal error_x_step3: error_ux_step3 :=(others => (others => (others => '0')));
	
begin
	--CNN Calculation
	
	A_calc_height:for i in 0 to patchWH-1 generate --i. satir
		A_calc_width:for j in 0 to patchWH-1 generate --j. sutun
			mul(i*patchWH+j+1)<=A(i,j)*x(i,j)+mul(i*patchWH+j);
		end generate A_calc_width;
	end generate A_calc_height;
	B_calc_height:for i in 0 to patchWH-1 generate --i. satir
		B_calc_width:for j in 0 to patchWH-1 generate --j. sutun
			mul(patchWH*patchWH+i*patchWH+j+1)<=B(i,j)*u(i,j)+mul(patchWH*patchWH+i*patchWH+j);
		end generate B_calc_width;
	end generate B_calc_height;
	mul(2*(patchWH*patchWH)+1)<=I*ALUBorderTop+mul(2*(patchWH*patchWH));
	
	x_temp_0<=mul(2*(patchWH*patchWH)+1)((2*busWidth+2*(patchWH*patchWH)+1) downto (busF));
	x_temp_1<=	to_signed(busMax,busWidth) when x_temp_0>to_signed(busMax,(2*busWidth+2*(patchWH*patchWH)+1-busF))  else
					to_signed(busMin,busWidth) when x_temp_0<to_signed(busMin,(2*busWidth+2*(patchWH*patchWH)+1-busF))  else
					x_temp_0(busWidth-1 downto 0);
					
	x_temp_2<=resize(x((patchWH-1)/2,(patchWH-1)/2),busWidth+1)-resize(x_temp_1,busWidth+1);
	x_temp_3<=x_temp_2*to_signed(Ts,busWidth+1);
	x_temp_4<=	to_signed(busMax,busWidth) when x_temp_3>to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMax,(busWidth+1))  else
					to_signed(busMin,busWidth) when x_temp_3<to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMin,(busWidth+1))  else
--					to_signed(1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(0,(2*busWidth+2-busF)) else
--					to_signed(-1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(-1,(2*busWidth+2-busF)) else
					x_temp_3((busWidth-1+busF) downto busF);
	x_temp_5<=resize(x((patchWH-1)/2,(patchWH-1)/2),busWidth+1)-resize(x_temp_4,busWidth+1);
	
	ABIxu_signconv_height:for i in 0 to patchWH-1 generate --i. satir
		ABIxu_signconv_width:for j in 0 to patchWH-1 generate --j. sutun
			process(calc)
			begin
				if (rising_edge(calc)) then
					A(i,j)<=signed(A_in(i,j)); B(i,j)<=signed(B_in(i,j));
					x(i,j)<=signed(x_in(i,j)); u(i,j)<=signed(u_in(i,j));
				end if;
			end process;
		end generate ABIxu_signconv_width;
	end generate ABIxu_signconv_height;
	
	process(calc)
	begin
		I<=signed(I_in);
		if (rising_edge(calc)) then
			if (x_temp_5 > to_signed(ALUBorderTop,busWidth+1)) then
				x_out <= std_logic_vector(to_signed(ALUBorderTop,busWidth));
			elsif (x_temp_5 < to_signed(ALUBorderBottom,busWidth+1)) then
				x_out <= std_logic_vector(to_signed(ALUBorderBottom,busWidth));
			else
				x_out <= std_logic_vector(x_temp_5((busWidth-1) downto 0));
			end if;
		end if;
	end process;
	
	--Error Calculation
	
	error_step0<=resize(ideal,busWidth+1)-resize(x((patchWH-1)/2,(patchWH-1)/2),busWidth+1) when err_rst='0' else to_signed(0, busWidth+1);
	error_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_step0(busWidth downto 1))>ALUBorderTop else
						to_signed(ALUBorderBottom,busWidth) when to_integer(error_step0(busWidth downto 1))<ALUBorderBottom else
						error_step0(busWidth downto 1);

	error_i_step0<=resize(error_i_reg,errorWidth+1)+resize(error_step1,errorWidth+1);
	error_i_step1<=	to_signed(errorMax,errorWidth) when to_integer(error_i_step0)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_i_step0)<errorMin else
							error_i_step0(errorWidth-1 downto 0);
	error_i<=std_logic_vector(error_i_reg);
	
	error_u_height:for i in 0 to patchWH-1 generate
		error_u_width:for j in 0 to patchWH-1 generate
			error_u_step0(i,j)<=u(i,j)*error_step1;
			error_u_step1(i,j)<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u_step0(i,j)((busWidth-1+busF) downto busF))>ALUBorderTop else
										to_signed(ALUBorderBottom,busWidth) when to_integer(error_u_step0(i,j)((busWidth-1+busF) downto busF))<ALUBorderBottom else
										error_u_step0(i,j)((busWidth-1+busF) downto busF);
			error_u_step2(i,j)<=resize(error_u_reg(i,j),errorWidth+1)+resize(error_u_step1(i,j),errorWidth+1);
			error_u_step3(i,j)<=	to_signed(errorMax,errorWidth) when to_integer(error_u_step2(i,j))>errorMax else
										to_signed(errorMin,errorWidth) when to_integer(error_u_step2(i,j))<errorMin else
										error_u_step2(i,j)(errorWidth-1 downto 0);
			error_u(i,j)<=std_logic_vector(error_u_reg(i,j));
		end generate error_u_width;
	end generate error_u_height;
	
	error_x_height:for i in 0 to patchWH-1 generate
		error_x_width:for j in 0 to patchWH-1 generate
			error_x_step0(i,j)<=x(i,j)*error_step1;
			error_x_step1(i,j)<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x_step0(i,j)((busWidth-1+busF) downto busF))>ALUBorderTop else
										to_signed(ALUBorderBottom,busWidth) when to_integer(error_x_step0(i,j)((busWidth-1+busF) downto busF))<ALUBorderBottom else
										error_x_step0(i,j)((busWidth-1+busF) downto busF);
			error_x_step2(i,j)<=resize(error_x_reg(i,j),errorWidth+1)+resize(error_x_step1(i,j),errorWidth+1);
			error_x_step3(i,j)<=	to_signed(errorMax,errorWidth) when to_integer(error_x_step2(i,j))>errorMax else
										to_signed(errorMin,errorWidth) when to_integer(error_x_step2(i,j))<errorMin else
										error_x_step2(i,j)(errorWidth-1 downto 0);
			error_x(i,j)<=std_logic_vector(error_x_reg(i,j));
		end generate error_x_width;
	end generate error_x_height;

	error_ux_reg_height:for i in 0 to patchWH-1 generate
		error_ux_reg_width:for j in 0 to patchWH-1 generate
			process(calc)
			begin
				if (rising_edge(calc)) then
					ideal<=signed(ideal_line);
					
					if(err_rst='1') then
						error_i_reg<=to_signed(0,errorWidth);
						
						error_u_reg(i,j)<=to_signed(0,errorWidth);
						error_x_reg(i,j)<=to_signed(0,errorWidth);
					else
						error_i_reg<=error_i_step1;
						
						error_u_reg(i,j)<=error_u_step3(i,j);
						error_x_reg(i,j)<=error_x_step3(i,j);
					end if;
				end if;
			end process;
		end generate error_ux_reg_width;
	end generate error_ux_reg_height;
	
	--Common Process
	process(clk)
		variable alu_state: integer range 0 to ALULagMax:=ALULagMax;
	begin
		if (rising_edge(clk)) then
			if (calc='1') then
				alu_state:=0;
				x_out_ready<='0';
			end if;
			if (alu_state=ALULagMax-1) then
				x_out_ready<='1';
			end if;
			if (alu_state < ALULagMax) then
				alu_state:=alu_state+1;
			end if;
		end if;
	end process;

end Behavioral;

