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
			clk, alu_calc : in  std_logic;
			a_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			b_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			i_line: in  std_logic_vector (busWidth-1 downto 0);
			x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
			x_out_ready : out std_logic:='1';
			x_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			u_line : in  std_logic_vector ((busWidth*patchSize-1) downto 0);
			Ts : in integer range 0 to (2**busWidth)-1
	);
end cnn_alu;

architecture Behavioral of cnn_alu is
	signal a_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal b_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal i_line_old : std_logic_vector (busWidth-1 downto 0):=(others => '0');
	signal x_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
	signal u_line_old : std_logic_vector ((busWidth*patchSize-1) downto 0):=(others => '0');
			
	type patch is array (0 to patchWH-1, 0 to patchWH-1) of signed (busWidth-1 downto 0);
	signal A: patch := (others => (others => (others => '0')));
	signal B: patch := (others => (others => (others => '0')));
	signal I: std_logic_vector (busWidth-1 downto 0):= (others => '0');
	signal x: patch := (others => (others => (others => '0')));
	signal u: patch := (others => (others => (others => '0')));
	
	signal x_temp_1 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_2 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_3 : signed ((2*busWidth-1) downto 0)  := (others => '0');
	signal x_temp_4 : signed ((busWidth-1) downto 0)  := (others => '0');
	signal x_temp_5 : signed ((busWidth-1) downto 0)  := (others => '0');

	type muls is array (0 to 2*(patchWH*patchWH)) of signed (2*busWidth-1 downto 0);
	signal mul : muls := (others => (others => '0'));
begin
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
	I<=i_line_old;

	mul(0)<=A(2,2)*x(0,0);
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
	mul(18)<=signed(I)*2048+mul(17);

	x_temp_1<=mul(18)(2*busWidth-1) & mul(18)((busM-1)+(busF*2-1) downto (busF));
	x_temp_2<=x(1,1)-x_temp_1;
	x_temp_3<=x_temp_2*Ts;
	x_temp_4<=x_temp_3(2*busWidth-1) & x_temp_3((busM-1)+(busF*2-1) downto (busF));
	x_temp_5<=x(1,1)-x_temp_4;
	

	process(alu_calc)
	begin
		if (rising_edge(alu_calc)) then
			a_line_old<=a_line; b_line_old<=b_line; i_line_old<=i_line;
			x_line_old<=x_line; u_line_old<=u_line;
			if (x_temp_5 > 2048) then
				x_out <= "0000100000000000";
			elsif (x_temp_5 < -2048) then
				x_out <= "1111100000000000";
			else
				x_out <= std_logic_vector(x_temp_5);
			end if;
		end if;
	end process;

	process(clk)
		variable alu_state: integer range 0 to ALULagMax:=ALULagMax;
	begin
		if (rising_edge(clk)) then
			if (alu_calc='1') then
				alu_state:=0;
				x_out_ready<='0';
			end if;
			case (alu_state) is
				when ALULagMax-1 =>
					x_out_ready<='1';
				when others =>
			end case;
			if (alu_state < ALULagMax) then
				alu_state:=alu_state+1;
			end if;
		end if;
	end process;

end Behavioral;

