library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;
	
entity cnn_alu is
	port (
		clk, div_clk, calc, err_rst : in  std_logic;
		a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		i_line: in  std_logic_vector (busWidth-1 downto 0);
		x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
		x_out_ready : out std_logic:='1';
		x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		Ts : in integer range 0 to busUSMax;
			
		image_size: in  std_logic_vector (busWidth-1 downto 0);
		ideal_line: in  std_logic_vector (busWidth-1 downto 0);
		
		error: out std_logic_vector (busWidth-1 downto 0);
		error_norm_sum: out std_logic_vector (errorWidth-1 downto 0);
		error_squa_sum: out std_logic_vector (errorWidth-1 downto 0)
	);
end cnn_alu;

architecture Behavioral of cnn_alu is
	--CNN Calculation
	signal a_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal b_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal i_line_old : std_logic_vector (busWidth-1 downto 0):=(others => '0');
	signal x_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal u_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
			
	type patch is array (0 to patchWH-1, 0 to patchWH-1) of signed (busWidth-1 downto 0);
	signal A: patch := (others => (others => (others => '0')));
	signal B: patch := (others => (others => (others => '0')));
	signal I: signed (busWidth-1 downto 0):= (others => '0');
	signal x: patch := (others => (others => (others => '0')));
	signal u: patch := (others => (others => (others => '0')));
	
	signal x_temp_0 : signed ((2*busWidth+18-busF) downto 0)  := (others => '0');
	signal x_temp_1 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_2 : signed ((busWidth) downto 0)  := (others => '0');
	signal x_temp_3 : signed ((2*busWidth+1) downto 0)  := (others => '0');
	signal x_temp_4 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_5 : signed ((busWidth) downto 0)  := (others => '0');

	type muls is array (0 to 2*(patchWH*patchWH)) of signed ((2*busWidth+18) downto 0);
	signal mul : muls := (others => (others => '0'));
	signal mul_init : signed (2*busWidth+18 downto 0):=(others => '0');
	
	--Error Calculation
	signal ideal: signed (busWidth-1 downto 0):=(others => '0');
	
	signal error_step0: signed (busWidth downto 0);
	signal error_step1: signed (busWidth-1 downto 0);
	
	signal error_norm_sum_reg: signed (errorWidth-1 downto 0);
	signal error_norm_sum_step0: signed (errorWidth-1 downto 0);
	signal error_norm_sum_step1: signed (errorWidth downto 0);
	signal error_norm_sum_step2: signed (errorWidth-1 downto 0);
	
	signal error_squa_sum_reg: signed (errorWidth-1 downto 0);
	signal error_squa_sum_step0: signed (errorWidth+1 downto 0);
	signal error_squa_sum_step1: signed (errorWidth-busF downto 0);
	signal error_squa_sum_step2: signed (errorWidth-1 downto 0);
	signal error_squa_sum_step3: signed (errorWidth downto 0);
	signal error_squa_sum_step4: signed (errorWidth-1 downto 0);
begin
	--CNN Calculation
	line2ABIxu_height:for i in 0 to patchWH-1 generate --i. satir
		line2ABIxu_width:for j in 0 to patchWH-1 generate --j. sutun
			A(i,j)<=signed(a_line_old(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			B(i,j)<=signed(b_line_old(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			x(i,j)<=signed(x_line_old(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			u(i,j)<=signed(u_line_old(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
		end generate line2ABIxu_width;
	end generate line2ABIxu_height;
	I<=signed(i_line_old);

	mul(0)<=A(2,2)*x(0,0)+mul_init;
	mul(1)<=A(2,1)*x(0,1)+mul(0);
	mul(2)<=A(2,0)*x(0,2)+mul(1);
	mul(3)<=A(1,2)*x(1,0)+mul(2);
	mul(4)<=A(1,1)*x(1,1)+mul(3);
	mul(5)<=A(1,0)*x(1,2)+mul(4);
	mul(6)<=A(0,2)*x(2,0)+mul(5);
	mul(7)<=A(0,1)*x(2,1)+mul(6);
	mul(8)<=A(0,0)*x(2,2)+mul(7);
	mul(9)<=B(2,2)*u(0,0)+mul(8);
	mul(10)<=B(2,1)*u(0,1)+mul(9);
	mul(11)<=B(2,0)*u(0,2)+mul(10);
	mul(12)<=B(1,2)*u(1,0)+mul(11);
	mul(13)<=B(1,1)*u(1,1)+mul(12);
	mul(14)<=B(1,0)*u(1,2)+mul(13);
	mul(15)<=B(0,2)*u(2,0)+mul(14);
	mul(16)<=B(0,1)*u(2,1)+mul(15);
	mul(17)<=B(0,0)*u(2,2)+mul(16);
	mul(18)<=I*ALUBorderTop+mul(17);
	
	x_temp_0<=mul(18)((2*busWidth+18) downto (busF));
	x_temp_1<=	to_signed(busMax,busWidth) when x_temp_0>to_signed(busMax,(2*busWidth+18-busF))  else
					to_signed(busMin,busWidth) when x_temp_0<to_signed(busMin,(2*busWidth+18-busF))  else
					x_temp_0(busWidth-1 downto 0);
	x_temp_2<=(x(1,1)(busWidth-1) & x(1,1))-(x_temp_1(busWidth-1) & x_temp_1);
	x_temp_3<=x_temp_2*to_signed(Ts,busWidth+1);
	x_temp_4<=	to_signed(busMax,busWidth) when x_temp_3>to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMax,(busWidth+1))  else
					to_signed(busMin,busWidth) when x_temp_3<to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMin,(busWidth+1))  else
					to_signed(1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(0,(2*busWidth+2-busF)) else
					to_signed(-1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(-1,(2*busWidth+2-busF)) else
					x_temp_3((busWidth-1+busF) downto busF);
	x_temp_5<=(x(1,1)(busWidth-1) & x(1,1))-(x_temp_4(busWidth-1) & x_temp_4);
	
	process(calc)
	begin
		if (rising_edge(calc)) then
			a_line_old<=a_line; b_line_old<=b_line; i_line_old<=i_line;
			x_line_old<=x_line; u_line_old<=u_line;
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
	error_step0<=((ideal(busWidth-1) & ideal)-(x(1,1)(busWidth-1) & x(1,1)));
	error_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_step0(busWidth downto 1))>ALUBorderTop else
						to_signed(ALUBorderBottom,busWidth) when to_integer(error_step0(busWidth downto 1))<ALUBorderBottom else
						error_step0(busWidth downto 1);

	error_norm_sum_step0<=resize(error_step1,errorWidth);
	error_norm_sum_step1<=(error_norm_sum_reg(errorWidth-1)&error_norm_sum_reg)+(error_norm_sum_step0(errorWidth-1)&error_norm_sum_step0);
	error_norm_sum_step2<=	to_signed(errorMax,errorWidth) when to_integer(error_norm_sum_step1)>errorMax else
									to_signed(errorMin,errorWidth) when to_integer(error_norm_sum_step1)<errorMin else
									error_norm_sum_step1(errorWidth-1 downto 0);
	error_norm_sum<=std_logic_vector(error_norm_sum_reg);

	error_squa_sum_step0<=(error_step1&error_step1(0))*(error_step1&error_step1(0));
	error_squa_sum_step1<=error_squa_sum_step0(errorWidth+1 downto busF+1);
	error_squa_sum_step2<=resize(error_squa_sum_step1,errorWidth);
	error_squa_sum_step3<=(error_squa_sum_reg(errorWidth-1)&error_squa_sum_reg)+(error_squa_sum_step2(errorWidth-1)&error_squa_sum_step2);
	error_squa_sum_step4<=	to_signed(errorMax,errorWidth) when to_integer(error_squa_sum_step3)>errorMax else
									to_signed(errorMin,errorWidth) when to_integer(error_squa_sum_step3)<errorMin else
									error_squa_sum_step3(errorWidth-1 downto 0);
	error_squa_sum<=std_logic_vector(error_squa_sum_reg);
	
	process(calc)

	begin
		if (rising_edge(calc)) then
			ideal<=signed(ideal_line);
			
			error<=std_logic_vector(error_step1);
			if(err_rst='1') then
				error_norm_sum_reg<=to_signed(0,errorWidth);
				error_squa_sum_reg<=to_signed(0,errorWidth);
			else
				error_norm_sum_reg<=error_norm_sum_step2;
				error_squa_sum_reg<=error_squa_sum_step4;
			end if;
		end if;
	end process;
	
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

