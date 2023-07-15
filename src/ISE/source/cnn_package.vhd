--width:satir genisligi-kac sutun var
--heigth:sutun uzunlugu-kac satir var
--i:satir numarasi
--j:sutun numarasi

--Qm.f: Q5.11
--m:tam sayi bit sayisi = 5
--f:virgulden sonra bit sayisi = 11

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

package cnn_package is
		constant iterMAX: integer;

		constant ALULagMAX: integer;
		constant bramLagMAX: integer;
		constant lagMAX: integer;
		constant templateLagMAX: integer;
		
		constant busWidth : integer;
		constant busM: integer;
		constant busF: integer;
		
		constant fifoCoreAddressWidth: integer;

		constant imageWidth: integer;
		constant imageHeight: integer;
		
		constant ramAddressWidth: integer;
		constant ramAddressShift: integer;
		
		constant templateAddressWidth: integer;
		constant templateWidth: integer;
		constant templatePieces: integer;
		constant templateCount: integer;
		
		constant patchSize : integer;
		constant patchWH : integer;
		constant patchTop : integer;
		constant patchBot : integer;
		constant Ts : integer range 0 to 65535;

end cnn_package;

package body cnn_package is
		constant iterMAX: integer:= 2;

		constant ALULagMAX: integer:= 5;
		constant bramLagMAX: integer:= 4;
		constant templateLagMAX: integer:= 3;
		constant lagMAX: integer:=ALULagMAX;
		
		constant busWidth : integer := 16;
		constant busM: integer := 5;
		constant busF: integer := 11;
		
		constant fifoCoreAddressWidth: integer := 8;
		
		constant imageWidth: integer := 128;
		constant imageHeight: integer := 128;		
		
		constant ramAddressWidth: integer := 16;
		constant ramAddressShift: integer := imageWidth*imageHeight;

		constant templateAddressWidth: integer := 8;
		constant templateWidth: integer := 9*2+3;
		constant templatePieces: integer := 5;
		constant templateCount: integer := 7;
		
		constant patchSize : integer := 9;
		constant patchWH : integer := 3;
		constant patchTop : integer := 2;
		constant patchBot : integer := 0;
		constant Ts : integer range 0 to 65535:= 205;
end cnn_package;
