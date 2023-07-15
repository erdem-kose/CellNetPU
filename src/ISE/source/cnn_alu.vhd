library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

	use work.cnn_package.all;
	
entity cnn_alu is
	port (
			en, clk : in  std_logic;
			a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: in  std_logic_vector (busWidth-1 downto 0);
			x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
			x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0)
	);
end cnn_alu;

architecture Behavioral of cnn_alu is
	type patch is array (0 to patchWH-1, 0 to patchWH-1) of signed (busWidth-1 downto 0);
	signal A: patch := (others => (others => (others => '0')));
	signal B: patch := (others => (others => (others => '0')));
	signal I: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x: patch := (others => (others => (others => '0')));
	signal u: patch := (others => (others => (others => '0')));
	
	signal x_temp_1 : signed ((2*busWidth-1) downto 0)  := (others => '0');
	signal x_temp_2 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_3 : signed ((2*busWidth-1) downto 0)  := (others => '0');
	signal x_temp_4 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal Bu : signed ((2*busWidth-1) downto 0)  := (others => '0');
	signal Ax : signed ((2*busWidth-1) downto 0)  := (others => '0');
	
begin
	line2ABIxu_height:for i in 0 to patchWH-1 generate --i. satir
		line2ABIxu_width:for j in 0 to patchWH-1 generate --j. sutun
			A(i,j)<=signed(a_line(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			B(i,j)<=signed(b_line(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			x(i,j)<=signed(x_line(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
			u(i,j)<=signed(u_line(
									j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1)
									downto
									j*(busWidth)+i*(busWidth*patchWH)
									));
		end generate line2ABIxu_width;
	end generate line2ABIxu_height;
	I<=i_line;
	
	Ax<=		A(2,2)*x(0,0) + A(2,1)*x(0,1) + A(2,0)*x(0,2)
			+	A(1,2)*x(1,0) + A(1,1)*x(1,1) + A(1,0)*x(1,2)
			+	A(0,2)*x(2,0) + A(0,1)*x(2,1) + A(0,0)*x(2,2) when (en='1') else (others=>'0');

	Bu<=		B(2,2)*u(0,0) + B(2,1)*u(0,1) + B(2,0)*u(0,2)
			+	B(1,2)*u(1,0) + B(1,1)*u(1,1) + B(1,0)*u(1,2)
			+	B(0,2)*u(2,0) + B(0,1)*u(2,1) + B(0,0)*u(2,2) when (en='1') else (others=>'0');
	
	x_temp_1<=Bu+Ax+signed(I)*2048 when (en='1') else (others=>'0');
	x_temp_2<=x_temp_1(2*busWidth-1) & x_temp_1((busM-1)+(busF*2-1) downto (busF));
	x_temp_3<=(x(1,1)-x_temp_2)*Ts;
	x_temp_4<=x(1,1)-(x_temp_3(2*busWidth-1) & x_temp_3((busM-1)+(busF*2-1) downto (busF)));
	
	process(en,clk)
		
	begin
		if (clk='1' and clk'event) then
			if (en='1') then
				if (x_temp_4 > 2048) then
					x_out <= "0000100000000000";
				elsif (x_temp_4 < -2048) then
					x_out <= "1111100000000000";
				else
					x_out <= std_logic_vector(x_temp_4);
				end if;
			end if;
		end if;
	end process;

end Behavioral;

