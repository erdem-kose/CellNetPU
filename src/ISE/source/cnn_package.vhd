--width:satir genisligi
--heigth:sutun uzunlugu
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
		constant busWidth : Integer;
		constant busM: Integer;
		constant busF: Integer;
		
		constant romAddressWidth: Integer;
		constant ramAddressWidth: Integer;
		
		constant imageWidth: Integer;
		constant imageHeight: Integer;
		
		constant templateAddressWidth: Integer;
		constant templateWidth: Integer;
		constant templatePieces: Integer;
		
		constant patchSize : Integer;
		constant patchWH : Integer;
		constant patchTop : Integer;
		constant patchBot : Integer;

end cnn_package;

package body cnn_package is
		constant busWidth : Integer := 16;
		constant busM: Integer := 5;
		constant busF: Integer := 11;
		
		constant romAddressWidth: Integer := 14;
		constant ramAddressWidth: Integer := 14;

		constant templateAddressWidth: Integer := 8;
		constant templateWidth: Integer := 9*2+3;
		constant templatePieces: Integer := 5;
		
		constant imageWidth: Integer := 128;
		constant imageHeight: Integer := 128;
		
		constant patchSize : Integer := 9;
		constant patchWH : Integer := 3;
		constant patchTop : Integer := 2;
		constant patchBot : Integer := 0;
end cnn_package;
