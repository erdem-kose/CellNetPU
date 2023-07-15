--width:satir genisligi-kac sutun var
--heigth:sutun uzunlugu-kac satir var
--i:satir numarasi
--j:sutun numarasi

--Qm.f: Q6.10
--m:tam sayi bit sayisi = 6
--f:virgulden sonra bit sayisi = 1
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
	
package cnn_constants is
	--Parametreler
	constant busM: integer;
	constant busF: integer;
	
	constant patchWH : integer;
	
	constant cacheWidthMAX: integer;
	constant cacheHeightMAX: integer;
	
	constant ALULagMAX: integer;
	
	--Sabitler
	constant busWidth : integer;
	constant busUSMax : integer;
	constant busMax : integer;
	constant busMin : integer;
	
	constant errorM: integer;
	constant errorF: integer;
	constant errorWidth: integer;
	constant errorMax : integer;
	constant errorMin : integer;
	
	constant modeWidth: integer;

	constant ALUBorderTop: integer;
	constant ALUBorderBottom: integer;

	constant iterMAX: integer;
	
	constant cacheLagMAX: integer;
	constant cacheWrLagMAX: integer;

	constant fifoCoreWidth: integer;
	constant fifoCoreAddressWidth: integer;

	constant cacheAddressCount: integer;
	constant cacheAddressWidth: integer;
	
	constant patchSize : integer;
	constant patchTop : integer;
	constant patchMid : integer;
	constant patchBot : integer;
end cnn_constants;

package body cnn_constants is
	--Parametreler
	constant busM: integer := 6;--bus tamsayi kismi
	constant busF: integer := 10;--bus virgulden sonra kismi
	
	constant patchWH : integer := 3;--3'ten buyuk ve tek sayi olmali
	
	constant cacheWidthMAX: integer := 128;
	constant cacheHeightMAX: integer := 128;
	
	constant ALULagMAX: integer:= 4;--(ALULagMAX=alufreq - 1), minalufreq:5
	
	--Sabitler
	constant busWidth : integer := busM+busF;
	constant busUSMax : integer := 2**busWidth-1;
	constant busMax : integer := 2**(busWidth-1)-1;
	constant busMin : integer := -2**(busWidth-1);
	
	constant errorM: integer := busM*2+busF;--bus tamsayi kismi
	constant errorF: integer := busF;--bus virgulden sonra kismi
	constant errorWidth: integer := errorM+errorF;
	constant errorMax : integer := 2**(errorWidth-1)-1;
	constant errorMin : integer := -2**(errorWidth-1);
	
	constant modeWidth: integer := 2;

	constant ALUBorderTop: integer := 2**busF;
	constant ALUBorderBottom: integer := -2**busF;

	constant iterMAX: integer:= busUSMax;
	
	constant cacheLagMAX: integer:= 2;
	constant cacheWrLagMAX: integer:= 2;

	constant fifoCoreWidth: integer := cacheWidthMAX;--max goruntu eni, degistirme
	constant fifoCoreAddressWidth: integer := integer(ceil(log2(real(fifoCoreWidth+1))));

	constant cacheAddressCount: integer := cacheWidthMAX*cacheHeightMAX;
	constant cacheAddressWidth: integer := integer(ceil(log2(real(cacheAddressCount))));
	
	constant patchSize : integer := patchWH**2;
	constant patchTop : integer := patchWH-1;
	constant patchMid : integer := patchTop/2;
	constant patchBot : integer := 0;
end cnn_constants;
