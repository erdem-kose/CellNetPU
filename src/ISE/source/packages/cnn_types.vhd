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
library cnn_library;
	use cnn_library.cnn_constants.all;
	
package cnn_types is
	type fifo_core is array(0 to (fifoCoreWidth+(patchWH-1)/2)-1) of std_logic_vector (busWidth-1 downto 0);
	type fifo_vector is array(0 to 1,0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	type fifo_single is array(0 to 1,0 to patchWH-1) of std_logic;
	
	type patch_unsigned is array (0 to patchWH-1, 0 to patchWH-1) of std_logic_vector (busWidth-1 downto 0);
	type patch_signed is array (0 to patchWH-1, 0 to patchWH-1) of signed (busWidth-1 downto 0);
	
	type fsm_states is (
								X_OLD_U_INIT, X_OLD_U_READ, X_NEW_WRITE,
								X_FILL_ADDRESS_INIT, X_FILL_INIT, X_FILL_WRITE,
								SUCCESS
								);
	attribute enum_encoding : string; 
	attribute enum_encoding of fsm_states: type is "000 001 010 011 100 101 110";
	
	type muls is array (0 to 2*(patchWH*patchWH)+1) of signed ((2*busWidth+2*(patchWH*patchWH)+1) downto 0);
	
	type error_patch is array (0 to patchWH-1, 0 to patchWH-1) of std_logic_vector(errorWidth-1 downto 0);
	type error_ux_reg is array(0 to patchWH-1,0 to patchWH-1) of signed (errorWidth-1 downto 0);
	type error_ux_step0 is array(0 to patchWH-1,0 to patchWH-1) of signed (errorWidth-1 downto 0);
	type error_ux_step1 is array(0 to patchWH-1,0 to patchWH-1) of signed (busWidth-1 downto 0);
	type error_ux_step2 is array(0 to patchWH-1,0 to patchWH-1) of signed (errorWidth downto 0);
	type error_ux_step3 is array(0 to patchWH-1,0 to patchWH-1) of signed (errorWidth-1 downto 0);
end cnn_types;

package body cnn_types is
end cnn_types;
