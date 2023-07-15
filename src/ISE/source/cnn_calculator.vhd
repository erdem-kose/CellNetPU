library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;
	
entity cnn_calculator is
	port (
		clk, calc, err_rst : in  std_logic;
			
		a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		i_line: in  std_logic_vector (busWidth-1 downto 0);
		x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
		x_out_ready : out std_logic:='1';
		x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
		u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			
		Ts : in integer range 0 to busUSMax;
		learn_rate : in integer range 0 to busUSMax;
		
		image_size: in  std_logic_vector (busWidth-1 downto 0);
		ideal_line: in  std_logic_vector (busWidth-1 downto 0);
			
		error: out std_logic_vector (busWidth-1 downto 0):=(others=>'0');
		
		error_i : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u00 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u01 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u02 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u10 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u12 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u11 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u20 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u21 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_u22 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x00 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x02 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x01 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x11 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x10 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x12 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x20 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x22 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0');
		error_x21 : out std_logic_vector(errorWidth-1 downto 0):=(others=>'0')
	);
end cnn_calculator;

architecture Behavioral of cnn_calculator is
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
	
	signal error_reg: signed (busWidth-1 downto 0):=(others=>'0');
	signal error_step0: signed (busWidth downto 0):=(others=>'0');
	signal error_step1: signed (busWidth-1 downto 0):=(others => '0');
	
	signal error_sum_step0: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_sum_step1: signed (busWidth-1 downto 0):=(others => '0');
	
	signal error_i_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_i_step0: signed (errorWidth downto 0):=(others => '0'); signal error_i_step1: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u00_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u00_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u00_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u00_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u00_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u01_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u01_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u01_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u01_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u01_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u02_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u02_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u02_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u02_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u02_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u10_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u10_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u10_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u10_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u10_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u11_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u11_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u11_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u11_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u11_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u12_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u12_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u12_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u12_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u12_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u20_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u20_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u20_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u20_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u20_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u21_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u21_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u21_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u21_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u21_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_u22_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_u22_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_u22_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_u22_step2: signed (errorWidth downto 0):=(others => '0'); signal error_u22_step3: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x00_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x00_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x00_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x00_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x00_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x01_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x01_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x01_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x01_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x01_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x02_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x02_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x02_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x02_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x02_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x10_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x10_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x10_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x10_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x10_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x11_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x11_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x11_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x11_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x11_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x12_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x12_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x12_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x12_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x12_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x20_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x20_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x20_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x20_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x20_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x21_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x21_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x21_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x21_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x21_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
	signal error_x22_reg: signed (errorWidth-1 downto 0):=(others => '0');
	signal error_x22_step0: signed (errorWidth-1 downto 0):=(others => '0'); signal error_x22_step1: signed (busWidth-1 downto 0):=(others => '0');
	signal error_x22_step2: signed (errorWidth downto 0):=(others => '0'); signal error_x22_step3: signed (errorWidth-1 downto 0):=(others => '0');
	
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
					
	x_temp_2<=resize(x(1,1),busWidth+1)-resize(x_temp_1,busWidth+1);
	x_temp_3<=x_temp_2*to_signed(Ts,busWidth+1);
	x_temp_4<=	to_signed(busMax,busWidth) when x_temp_3>to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMax,(busWidth+1))  else
					to_signed(busMin,busWidth) when x_temp_3<to_signed(ALUBorderTop,(busWidth+1))*to_signed(busMin,(busWidth+1))  else
					to_signed(1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(0,(2*busWidth+2-busF)) else
					to_signed(-1,busWidth) when x_temp_3((2*busWidth+1) downto busF)=to_signed(-1,(2*busWidth+2-busF)) else
					x_temp_3((busWidth-1+busF) downto busF);
	x_temp_5<=resize(x(1,1),busWidth+1)-resize(x_temp_4,busWidth+1);
	
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
	
	error_step0<=resize(ideal,busWidth+1)-resize(x(1,1),busWidth+1) when err_rst='0' else to_signed(0, busWidth+1);
	error_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_step0(busWidth downto 1))>ALUBorderTop else
						to_signed(ALUBorderBottom,busWidth) when to_integer(error_step0(busWidth downto 1))<ALUBorderBottom else
						error_step0(busWidth downto 1);
	error<=std_logic_vector(error_reg);
	
--
	error_sum_step0<=to_signed(learn_rate,busWidth)*error_step1;
	error_sum_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_sum_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_sum_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_sum_step0((busWidth-1+busF) downto busF);
--
	error_i_step0<=resize(error_i_reg,errorWidth+1)+resize(error_sum_step1,errorWidth+1);
	error_i_step1<=	to_signed(errorMax,errorWidth) when to_integer(error_i_step0)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_i_step0)<errorMin else
							error_i_step0(errorWidth-1 downto 0);
	
	error_u00_step0<=u(2,2)*error_sum_step1;
	error_u00_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u00_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u00_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u00_step0((busWidth-1+busF) downto busF);
	error_u00_step2<=resize(error_u00_reg,errorWidth+1)+resize(error_u00_step1,errorWidth+1);
	error_u00_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u00_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u00_step2)<errorMin else
							error_u00_step2(errorWidth-1 downto 0);

	error_u01_step0<=u(2,1)*error_sum_step1;
	error_u01_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u01_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u01_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u01_step0((busWidth-1+busF) downto busF);
	error_u01_step2<=resize(error_u01_reg,errorWidth+1)+resize(error_u01_step1,errorWidth+1);
	error_u01_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u01_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u01_step2)<errorMin else
							error_u01_step2(errorWidth-1 downto 0);
							
	error_u02_step0<=u(2,0)*error_sum_step1;
	error_u02_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u02_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u02_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u02_step0((busWidth-1+busF) downto busF);
	error_u02_step2<=resize(error_u02_reg,errorWidth+1)+resize(error_u02_step1,errorWidth+1);
	error_u02_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u02_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u02_step2)<errorMin else
							error_u02_step2(errorWidth-1 downto 0);
							
	error_u10_step0<=u(1,2)*error_sum_step1;
	error_u10_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u10_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u10_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u10_step0((busWidth-1+busF) downto busF);
	error_u10_step2<=resize(error_u10_reg,errorWidth+1)+resize(error_u10_step1,errorWidth+1);
	error_u10_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u10_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u10_step2)<errorMin else
							error_u10_step2(errorWidth-1 downto 0);
							
	error_u11_step0<=u(1,1)*error_sum_step1;
	error_u11_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u11_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u11_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u11_step0((busWidth-1+busF) downto busF);
	error_u11_step2<=resize(error_u11_reg,errorWidth+1)+resize(error_u11_step1,errorWidth+1);
	error_u11_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u11_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u11_step2)<errorMin else
							error_u11_step2(errorWidth-1 downto 0);
							
	error_u12_step0<=u(1,0)*error_sum_step1;
	error_u12_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u12_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u12_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u12_step0((busWidth-1+busF) downto busF);
	error_u12_step2<=resize(error_u12_reg,errorWidth+1)+resize(error_u12_step1,errorWidth+1);
	error_u12_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u12_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u12_step2)<errorMin else
							error_u12_step2(errorWidth-1 downto 0);
							
	error_u20_step0<=u(0,2)*error_sum_step1;
	error_u20_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u20_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u20_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u20_step0((busWidth-1+busF) downto busF);
	error_u20_step2<=resize(error_u20_reg,errorWidth+1)+resize(error_u20_step1,errorWidth+1);
	error_u20_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u20_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u20_step2)<errorMin else
							error_u20_step2(errorWidth-1 downto 0);
							
	error_u21_step0<=u(0,1)*error_sum_step1;
	error_u21_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u21_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u21_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u21_step0((busWidth-1+busF) downto busF);
	error_u21_step2<=resize(error_u21_reg,errorWidth+1)+resize(error_u21_step1,errorWidth+1);
	error_u21_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u21_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u21_step2)<errorMin else
							error_u21_step2(errorWidth-1 downto 0);
							
	error_u22_step0<=u(0,0)*error_sum_step1;
	error_u22_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_u22_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_u22_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_u22_step0((busWidth-1+busF) downto busF);
	error_u22_step2<=resize(error_u22_reg,errorWidth+1)+resize(error_u22_step1,errorWidth+1);
	error_u22_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_u22_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_u22_step2)<errorMin else
							error_u22_step2(errorWidth-1 downto 0);
							
	error_x00_step0<=x(2,2)*error_sum_step1;
	error_x00_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x00_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x00_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x00_step0((busWidth-1+busF) downto busF);
	error_x00_step2<=resize(error_x00_reg,errorWidth+1)+resize(error_x00_step1,errorWidth+1);
	error_x00_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x00_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x00_step2)<errorMin else
							error_x00_step2(errorWidth-1 downto 0);

	error_x01_step0<=x(2,1)*error_sum_step1;
	error_x01_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x01_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x01_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x01_step0((busWidth-1+busF) downto busF);
	error_x01_step2<=resize(error_x01_reg,errorWidth+1)+resize(error_x01_step1,errorWidth+1);
	error_x01_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x01_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x01_step2)<errorMin else
							error_x01_step2(errorWidth-1 downto 0);
							
	error_x02_step0<=x(2,0)*error_sum_step1;
	error_x02_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x02_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x02_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x02_step0((busWidth-1+busF) downto busF);
	error_x02_step2<=resize(error_x02_reg,errorWidth+1)+resize(error_x02_step1,errorWidth+1);
	error_x02_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x02_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x02_step2)<errorMin else
							error_x02_step2(errorWidth-1 downto 0);
							
	error_x10_step0<=x(1,2)*error_sum_step1;
	error_x10_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x10_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x10_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x10_step0((busWidth-1+busF) downto busF);
	error_x10_step2<=resize(error_x10_reg,errorWidth+1)+resize(error_x10_step1,errorWidth+1);
	error_x10_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x10_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x10_step2)<errorMin else
							error_x10_step2(errorWidth-1 downto 0);
							
	error_x11_step0<=x(1,1)*error_sum_step1;
	error_x11_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x11_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x11_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x11_step0((busWidth-1+busF) downto busF);
	error_x11_step2<=resize(error_x11_reg,errorWidth+1)+resize(error_x11_step1,errorWidth+1);
	error_x11_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x11_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x11_step2)<errorMin else
							error_x11_step2(errorWidth-1 downto 0);
							
	error_x12_step0<=x(1,0)*error_sum_step1;
	error_x12_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x12_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x12_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x12_step0((busWidth-1+busF) downto busF);
	error_x12_step2<=resize(error_x12_reg,errorWidth+1)+resize(error_x12_step1,errorWidth+1);
	error_x12_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x12_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x12_step2)<errorMin else
							error_x12_step2(errorWidth-1 downto 0);
							
	error_x20_step0<=x(0,2)*error_sum_step1;
	error_x20_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x20_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x20_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x20_step0((busWidth-1+busF) downto busF);
	error_x20_step2<=resize(error_x20_reg,errorWidth+1)+resize(error_x20_step1,errorWidth+1);
	error_x20_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x20_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x20_step2)<errorMin else
							error_x20_step2(errorWidth-1 downto 0);
							
	error_x21_step0<=x(0,1)*error_sum_step1;
	error_x21_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x21_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x21_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x21_step0((busWidth-1+busF) downto busF);
	error_x21_step2<=resize(error_x21_reg,errorWidth+1)+resize(error_x21_step1,errorWidth+1);
	error_x21_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x21_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x21_step2)<errorMin else
							error_x21_step2(errorWidth-1 downto 0);
							
	error_x22_step0<=x(0,0)*error_sum_step1;
	error_x22_step1<=	to_signed(ALUBorderTop,busWidth) when to_integer(error_x22_step0((busWidth-1+busF) downto busF))>ALUBorderTop else
							to_signed(ALUBorderBottom,busWidth) when to_integer(error_x22_step0((busWidth-1+busF) downto busF))<ALUBorderBottom else
							error_x22_step0((busWidth-1+busF) downto busF);
	error_x22_step2<=resize(error_x22_reg,errorWidth+1)+resize(error_x22_step1,errorWidth+1);
	error_x22_step3<=	to_signed(errorMax,errorWidth) when to_integer(error_x22_step2)>errorMax else
							to_signed(errorMin,errorWidth) when to_integer(error_x22_step2)<errorMin else
							error_x22_step2(errorWidth-1 downto 0);
--
	error_i<=std_logic_vector(error_i_reg);
	
	error_u00<=std_logic_vector(error_u00_reg); error_u01<=std_logic_vector(error_u01_reg); error_u02<=std_logic_vector(error_u02_reg);
	error_u10<=std_logic_vector(error_u10_reg); error_u12<=std_logic_vector(error_u12_reg); error_u11<=std_logic_vector(error_u11_reg);
	error_u20<=std_logic_vector(error_u20_reg); error_u21<=std_logic_vector(error_u21_reg); error_u22<=std_logic_vector(error_u22_reg);
	
	error_x00<=std_logic_vector(error_x00_reg); error_x02<=std_logic_vector(error_x02_reg); error_x01<=std_logic_vector(error_x01_reg);
	error_x11<=std_logic_vector(error_x11_reg); error_x10<=std_logic_vector(error_x10_reg); error_x12<=std_logic_vector(error_x12_reg);
	error_x20<=std_logic_vector(error_x20_reg); error_x22<=std_logic_vector(error_x22_reg); error_x21<=std_logic_vector(error_x21_reg);
			
	process(calc)
	begin
		if (rising_edge(calc)) then
			ideal<=signed(ideal_line);
			
			if(err_rst='1') then
				error_reg<=to_signed(0,busWidth);
				
				error_i_reg<=to_signed(0,errorWidth);
				
				error_u00_reg<=to_signed(0,errorWidth); error_u01_reg<=to_signed(0,errorWidth); error_u02_reg<=to_signed(0,errorWidth);
				error_u10_reg<=to_signed(0,errorWidth); error_u12_reg<=to_signed(0,errorWidth); error_u11_reg<=to_signed(0,errorWidth);
				error_u20_reg<=to_signed(0,errorWidth); error_u21_reg<=to_signed(0,errorWidth); error_u22_reg<=to_signed(0,errorWidth);
				
				error_x00_reg<=to_signed(0,errorWidth); error_x02_reg<=to_signed(0,errorWidth); error_x01_reg<=to_signed(0,errorWidth);
				error_x11_reg<=to_signed(0,errorWidth); error_x10_reg<=to_signed(0,errorWidth); error_x12_reg<=to_signed(0,errorWidth);
				error_x20_reg<=to_signed(0,errorWidth); error_x22_reg<=to_signed(0,errorWidth); error_x21_reg<=to_signed(0,errorWidth);
			else
				error_reg<=error_step1;
				
				error_i_reg<=error_i_step1;
				
				error_u00_reg<=error_u00_step3; error_u01_reg<=error_u01_step3; error_u02_reg<=error_u02_step3;
				error_u10_reg<=error_u10_step3; error_u12_reg<=error_u12_step3; error_u11_reg<=error_u11_step3;
				error_u20_reg<=error_u20_step3; error_u21_reg<=error_u21_step3; error_u22_reg<=error_u22_step3;
				
				error_x00_reg<=error_x00_step3; error_x02_reg<=error_x02_step3; error_x01_reg<=error_x01_step3;
				error_x11_reg<=error_x11_step3; error_x10_reg<=error_x10_step3; error_x12_reg<=error_x12_step3;
				error_x20_reg<=error_x20_step3; error_x22_reg<=error_x22_step3; error_x21_reg<=error_x21_step3;
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

