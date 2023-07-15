--width:satir genisligi-kac sutun var
--heigth:sutun uzunlugu-kac satir var
--i:satir numarasi
--j:sutun numarasi

--Qm.f: Q5.11
--m:tam sayi bit sayisi = 5
--f:virgulden sonra bit sayisi = 11
library ieee;
	use ieee.math_real.all;
	use ieee.math_real."ceil";
	use ieee.math_real."log2";
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;

package cnn_package is
	constant busM: integer;
	constant busF: integer;
	constant busWidth : integer;
	constant busUSMax : integer;
	constant busMax : integer;
	constant busMin : integer;
	
	constant errorM: integer;
	constant errorF: integer;
	constant errorWidth: integer;
	constant errorMax : integer;
	constant errorMin : integer;
	
	constant ALUBorderTop: integer;
	constant ALUBorderBottom: integer;
	
	constant imageWidthMAX: integer;
	constant imageHeightMAX: integer;

	constant iterMAX: integer;

	constant ALULagMAX: integer;
	constant bramLagMAX: integer;
	constant templateLagMAX: integer;

	constant fifoCoreAddressWidth: integer;

	constant ramAddressCount: integer;
	constant ramAddressWidth: integer;

	constant patchWH : integer;
	constant patchSize : integer;
	constant patchTop : integer;
	constant patchBot : integer;
	
	constant templateCount: integer;
	constant templateWidth: integer;
	constant templatePieces: integer;
	constant templateAddressWidth: integer;

end cnn_package;

package body cnn_package is
--IEEE 754 half-precision binary floating-point format: binary16[edit]
--The IEEE 754 standard specifies a binary16 as having the following format:
--
--Sign bit: 1 bit
--Exponent width: 5 bits
--Significand precision: 11 bits (10 explicitly stored)

	constant busM: integer := 6;--bus tamsayi kismi
	constant busF: integer := 10;--bus virgulden sonra kismi
	constant busWidth : integer := busM+busF;
	constant busUSMax : integer := 2**busWidth-1;
	constant busMax : integer := 2**(busWidth-1)-1;
	constant busMin : integer := -2**(busWidth-1);
	
	constant errorM: integer := 22;--bus tamsayi kismi
	constant errorF: integer := 10;--bus virgulden sonra kismi
	constant errorWidth: integer := errorM+errorF;
	constant errorMax : integer := 2**(errorWidth-1)-1;
	constant errorMin : integer := -2**(errorWidth-1);
	
	constant ALUBorderTop: integer := 2**busF;
	constant ALUBorderBottom: integer := -2**busF;
	
	constant imageWidthMAX: integer := 128;
	constant imageHeightMAX: integer := 128;

	constant iterMAX: integer:= busUSMax;
	
	constant ALULagMAX: integer:= 5;--step - 1
	constant bramLagMAX: integer:= 3;
	constant templateLagMAX: integer:= 3;

	constant fifoCoreWidth: integer := 128;--max goruntu eni, degistirme
	constant fifoCoreAddressWidth: integer := integer(ceil(log2(real(fifoCoreWidth+1))));

	constant ramAddressCount: integer := 4*imageWidthMAX*imageHeightMAX;
	constant ramAddressWidth: integer := integer(ceil(log2(real(ramAddressCount))));

	constant patchWH : integer := 3;
	constant patchSize : integer := patchWH**2;
	constant patchTop : integer := patchWH-1;
	constant patchBot : integer := 0;
	
	constant templateCount: integer := 50;--template sayisi
	constant templateWidth: integer := patchSize*2+3;
	constant templatePieces: integer := 5;
	constant templateAddressWidth: integer := integer(ceil(log2(real(templateCount*templateWidth))));
end cnn_package;
