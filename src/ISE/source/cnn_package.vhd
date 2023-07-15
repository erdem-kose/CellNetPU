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
	constant ALULagMAX: integer;
	constant bramLagMAX: integer;
	constant templateLagMAX: integer;

	constant busM: integer;
	constant busF: integer;
	constant busWidth : integer;

	constant imageWidth: integer;
	constant imageHeight: integer;		

	constant fifoCoreAddressWidth: integer;

	constant ramAddressCount: integer;
	constant ramAddressWidth: integer;
	constant ramAddressShift: integer;

	constant patchWH : integer;
	constant patchSize : integer;
	constant patchTop : integer;
	constant patchBot : integer;
	
	constant templateCount: integer;
	constant templateWidth: integer;
	constant templatePieces: integer;
	constant templateAddressWidth: integer;
	
	constant iterMAX: integer;
	constant Ts : integer range 0 to 65535;
end cnn_package;

package body cnn_package is
	--degistirilebilir sabitler
	constant iterMAX: integer:= 2;
	constant Ts : integer range 0 to 65535:= 205;
	
	constant imageWidth: integer := 128;--en: en fazla 1920
	constant imageHeight: integer := 128;--boy: en fazla 1080
	
	--bu satirdan sonrasini degistirme
	constant ALULagMAX: integer:= 5;--step - 1
	constant bramLagMAX: integer:= 3;
	constant templateLagMAX: integer:= 3;

	constant busM: integer := 5;--bus tamsayi kismi
	constant busF: integer := 11;--bus virgulden sonra kismi
	constant busWidth : integer := busM+busF;
	
	constant fifoCoreWidth: integer := 1920;--max goruntu eni, degistirme
	constant fifoCoreAddressWidth: integer := integer(ceil(log2(real(fifoCoreWidth+1))));

	constant ramAddressCount: integer := 3*imageWidth*imageHeight;
	constant ramAddressWidth: integer := integer(ceil(log2(real(ramAddressCount))));
	constant ramAddressShift: integer := imageWidth*imageHeight;

	constant patchWH : integer := 3;
	constant patchSize : integer := patchWH**2;
	constant patchTop : integer := patchWH-1;
	constant patchBot : integer := 0;
	
	constant templateCount: integer := 50;--template sayisi
	constant templateWidth: integer := patchSize*2+3;
	constant templatePieces: integer := 5;
	constant templateAddressWidth: integer := integer(ceil(log2(real(templateCount*templateWidth))));
end cnn_package;
