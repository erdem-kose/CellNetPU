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
	use cnn_library.cnn_types.all;
	use cnn_library.cnn_constants.all;
	
package cnn_components is
	component cnn_clocking is
		port
		(-- Clock in ports
			clk_in : in std_logic;
			-- Clock out ports
			sys_clk : out std_logic;
			mcu_clk : out std_logic
		);
	end component;

	component cnn_processor is
		port
		(
			sys_clk, mcu_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			
			A: in patch_unsigned;
			B: in patch_unsigned;
			I: in std_logic_vector(busWidth-1 downto 0);
			x_bnd: in std_logic_vector(busWidth-1 downto 0);
			u_bnd: in std_logic_vector(busWidth-1 downto 0);
			
			u_interface_we : in std_logic_vector(0 downto 0);
			u_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
			u_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			u_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
		
			x_interface_we : in std_logic_vector(0 downto 0);
			x_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
			x_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			x_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
		
			ideal_interface_we : in std_logic_vector(0 downto 0);
			ideal_interface_address : in std_logic_vector(cacheAddressWidth-1 downto 0);
			ideal_interface_data_in : in std_logic_vector(busWidth-1 downto 0);
			ideal_interface_data_out : out std_logic_vector(busWidth-1 downto 0);
			
			error_u: out error_patch;
			error_x: out error_patch;
			error_i: out std_logic_vector(errorWidth-1 downto 0);
			
			cacheWidth: in std_logic_vector(busWidth-1 downto 0);
			cacheHeight: in std_logic_vector(busWidth-1 downto 0);
			
			Ts : in std_logic_vector(busWidth-1 downto 0);
			iter_cnt: in std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component ram_generic is
		port
		(
			clka   : in  std_logic;
			wea    : in  std_logic_vector(0 downto 0);
			addra  : in  std_logic_vector(cacheAddressWidth-1 downto 0);
			dina   : in  std_logic_vector(busWidth-1 downto 0);
			douta  : out std_logic_vector(busWidth-1 downto 0);
			clkb   : in  std_logic;
			web    : in  std_logic_vector(0 downto 0);
			addrb  : in  std_logic_vector(cacheAddressWidth-1 downto 0);
			dinb   : in  std_logic_vector(busWidth-1 downto 0);
			doutb  : out std_logic_vector(busWidth-1 downto 0)
		);
	end component;
	
	component cnn_au is
		port
		(
			clk, calc, err_rst : in  std_logic;
			
			A_in: in patch_unsigned;
			B_in: in patch_unsigned;
			I_in: in std_logic_vector(busWidth-1 downto 0);
			x_in: in patch_unsigned;
			u_in: in patch_unsigned;
			
			x_out : out  std_logic_vector ((busWidth-1) downto 0):=(others=>'0');
			x_out_ready : out std_logic:='1';
			
			Ts : in integer range 0 to busUSMax;
		
			ideal_line: in  std_logic_vector (busWidth-1 downto 0);
			
			error_u: out error_patch;
			error_x: out error_patch;
			error_i: out std_logic_vector(errorWidth-1 downto 0)
		);
	end component;

	component cnn_rand is
		port (
			clk: in  std_logic;
			rand_gen: in  std_logic;
			rand_num: out std_logic_vector (busWidth-1 downto 0):=(others=>'0')
		);
	end component;

	component cnn_state_machine is
		port
		(
			sys_clk, rst, en : in  std_logic;
			ready: out std_logic:='0';
			alu_calc: out std_logic:='0';
			alu_err_rst: out std_logic:='0';
			
			u_we : out std_logic_vector(0 downto 0):=(others=>'0');
			u_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
			u_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
			u_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			x_we : out std_logic_vector(0 downto 0):=(others=>'0');
			x_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
			x_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
			x_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			ideal_we : out std_logic_vector(0 downto 0):=(others=>'0');
			ideal_address : out std_logic_vector(cacheAddressWidth-1 downto 0):=(others=>'0');
			ideal_data_in : out std_logic_vector(busWidth-1 downto 0):=(others=>'0');
			ideal_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			x_bnd: in std_logic_vector(busWidth-1 downto 0);
			u_bnd: in std_logic_vector(busWidth-1 downto 0);
			
			x_old_out: out patch_unsigned:=(others => (others => (others => '0')));
			u_out: out patch_unsigned:=(others => (others => (others => '0')));
			
			x_new: in std_logic_vector (busWidth-1 downto 0);
			x_new_ready : in std_logic;
			
			ideal: out  std_logic_vector (busWidth-1 downto 0):=(others=>'0');
			
			cacheWidth: in integer range 0 to cacheWidthMAX;
			cacheHeight: in integer range 0 to cacheHeightMAX;
			
			iter_cnt: in integer range 0 to iterMAX
		);
	end component;
	
	component cnn_fifo is
		port
		(
			d : in std_logic_vector(busWidth-1 downto 0);
			clk : in std_logic;
			ce : in std_logic;
			q : out std_logic_vector(busWidth-1 downto 0);
			
			cacheWidth: in integer range 0 to 1920
		);
	end component;

	component fifo_bram_core is
	  port
	  (
		 clka : in std_logic;
		 wea : in std_logic_vector(0 downto 0);
		 addra : in std_logic_vector(fifoCoreAddressWidth-1 downto 0);
		 dina : in std_logic_vector(busWidth-1 downto 0);
		 douta : out std_logic_vector(busWidth-1 downto 0);
		 clkb : in std_logic;
		 web : in std_logic_vector(0 downto 0);
		 addrb : in std_logic_vector(fifoCoreAddressWidth-1 downto 0);
		 dinb : in std_logic_vector(busWidth-1 downto 0);
		 doutb : out std_logic_vector(busWidth-1 downto 0)
	  );
	end component;
	
	component cnn_interface is
		port
		(
			mcu_clk , rst : in std_logic;
			ready: in std_logic;
			
			uart_rx : in std_logic;
			uart_tx : out std_logic;

			mcbx_dram_we_n : out std_logic;
			mcbx_dram_udm : out std_logic;
			mcbx_dram_ras_n : out std_logic;
			mcbx_dram_odt : out std_logic;
			mcbx_dram_ldm : out std_logic;
			mcbx_dram_clk_n : out std_logic;
			mcbx_dram_clk : out std_logic;
			mcbx_dram_cke : out std_logic;
			mcbx_dram_cas_n : out std_logic;
			mcbx_dram_ba : out std_logic_vector(2 downto 0);
			mcbx_dram_addr : out std_logic_vector(12 downto 0);
			mcbx_dram_udqs_n : inout std_logic;
			mcbx_dram_udqs : inout std_logic;
			mcbx_dram_dqs_n : inout std_logic;
			mcbx_dram_dqs : inout std_logic;
			mcbx_dram_dq : inout std_logic_vector(15 downto 0);
			mcbx_zio : inout std_logic;
			mcbx_rzq : inout std_logic;

			Ethernet_Lite_TX_CLK : in std_logic;
			Ethernet_Lite_RX_ER : in std_logic;
			Ethernet_Lite_RX_DV : in std_logic;
			Ethernet_Lite_RX_CLK : in std_logic;
			Ethernet_Lite_RXD : in std_logic_vector(3 downto 0);
			Ethernet_Lite_CRS : in std_logic;
			Ethernet_Lite_COL : in std_logic;
			Ethernet_Lite_TX_EN : out std_logic;
			Ethernet_Lite_TXD : out std_logic_vector(3 downto 0);
			Ethernet_Lite_PHY_RST_N : out std_logic;
			Ethernet_Lite_MDC : out std_logic;
			Ethernet_Lite_MDIO : inout std_logic;

			QSPI_FLASH_SS : inout std_logic;
			QSPI_FLASH_SCLK : inout std_logic;
			QSPI_FLASH_IO1 : inout std_logic;
			QSPI_FLASH_IO0 : inout std_logic;
			
			A: out patch_unsigned;
			B: out patch_unsigned;
			I: out std_logic_vector(busWidth-1 downto 0);
			x_bnd: out std_logic_vector(busWidth-1 downto 0);
			u_bnd: out std_logic_vector(busWidth-1 downto 0);
			
			u_interface_we : out std_logic_vector(0 downto 0);
			u_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
			u_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
			u_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			x_interface_we : out std_logic_vector(0 downto 0);
			x_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
			x_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
			x_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			ideal_interface_we : out std_logic_vector(0 downto 0);
			ideal_interface_address : out std_logic_vector(cacheAddressWidth-1 downto 0);
			ideal_interface_data_in : out std_logic_vector(busWidth-1 downto 0);
			ideal_interface_data_out : in std_logic_vector(busWidth-1 downto 0);
			
			error_u: in error_patch;
			error_x: in error_patch;
			error_i: in std_logic_vector(errorWidth-1 downto 0);
			
			cacheWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
			cacheHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
			
			Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
			iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
			
			cnn_rst: out std_logic:='1'
		);
	end component;
	
	component mpu
		port
		(
			RESET : IN std_logic;
			GCLK : IN std_logic;
			Ethernet_Lite_TX_CLK : IN std_logic;
			Ethernet_Lite_RX_ER : IN std_logic;
			Ethernet_Lite_RX_DV : IN std_logic;
			Ethernet_Lite_RX_CLK : IN std_logic;
			Ethernet_Lite_RXD : IN std_logic_vector(3 downto 0);
			Ethernet_Lite_CRS : IN std_logic;
			Ethernet_Lite_COL : IN std_logic;
			iomodule_0_UART_Rx : IN std_logic;
			iomodule_0_GPI1 : IN std_logic_vector(31 downto 0);
			error_i : IN std_logic_vector(31 downto 0);
			error_u00 : IN std_logic_vector(31 downto 0);
			error_u01 : IN std_logic_vector(31 downto 0);
			error_u02 : IN std_logic_vector(31 downto 0);
			error_u10 : IN std_logic_vector(31 downto 0);
			error_u12 : IN std_logic_vector(31 downto 0);
			error_u11 : IN std_logic_vector(31 downto 0);
			error_u20 : IN std_logic_vector(31 downto 0);
			error_u21 : IN std_logic_vector(31 downto 0);
			error_u22 : IN std_logic_vector(31 downto 0);
			error_x00 : IN std_logic_vector(31 downto 0);
			error_x02 : IN std_logic_vector(31 downto 0);
			error_x01 : IN std_logic_vector(31 downto 0);
			error_x11 : IN std_logic_vector(31 downto 0);
			error_x10 : IN std_logic_vector(31 downto 0);
			error_x12 : IN std_logic_vector(31 downto 0);
			error_x20 : IN std_logic_vector(31 downto 0);
			error_x22 : IN std_logic_vector(31 downto 0);
			error_x21 : IN std_logic_vector(31 downto 0);
			u_data_out : IN std_logic_vector(15 downto 0);
			x_data_out : IN std_logic_vector(15 downto 0);
			ideal_data_out : IN std_logic_vector(15 downto 0);    
			zio : INOUT std_logic;
			rzq : INOUT std_logic;
			mcbx_dram_udqs_n : INOUT std_logic;
			mcbx_dram_udqs : INOUT std_logic;
			mcbx_dram_dqs_n : INOUT std_logic;
			mcbx_dram_dqs : INOUT std_logic;
			mcbx_dram_dq : INOUT std_logic_vector(15 downto 0);
			QSPI_FLASH_SS : INOUT std_logic;
			QSPI_FLASH_SCLK : INOUT std_logic;
			QSPI_FLASH_IO1 : INOUT std_logic;
			QSPI_FLASH_IO0 : INOUT std_logic;
			Ethernet_Lite_MDIO : INOUT std_logic;      
			mcbx_dram_we_n : OUT std_logic;
			mcbx_dram_udm : OUT std_logic;
			mcbx_dram_ras_n : OUT std_logic;
			mcbx_dram_odt : OUT std_logic;
			mcbx_dram_ldm : OUT std_logic;
			mcbx_dram_clk_n : OUT std_logic;
			mcbx_dram_clk : OUT std_logic;
			mcbx_dram_cke : OUT std_logic;
			mcbx_dram_cas_n : OUT std_logic;
			mcbx_dram_ba : OUT std_logic_vector(2 downto 0);
			mcbx_dram_addr : OUT std_logic_vector(12 downto 0);
			Ethernet_Lite_TX_EN : OUT std_logic;
			Ethernet_Lite_TXD : OUT std_logic_vector(3 downto 0);
			Ethernet_Lite_PHY_RST_N : OUT std_logic;
			Ethernet_Lite_MDC : OUT std_logic;
			iomodule_0_UART_Tx : OUT std_logic;
			iomodule_0_GPO1 : OUT std_logic_vector(31 downto 0);
			u_data_in : OUT std_logic_vector(15 downto 0);
			u_address : OUT std_logic_vector(13 downto 0);
			u_we : OUT std_logic;
			x_data_in : OUT std_logic_vector(15 downto 0);
			x_address : OUT std_logic_vector(13 downto 0);
			x_we : OUT std_logic;
			ideal_address : OUT std_logic_vector(13 downto 0);
			ideal_we : OUT std_logic;
			ideal_data_in : OUT std_logic_vector(15 downto 0);
			template_A00 : OUT std_logic_vector(15 downto 0);
			template_A01 : OUT std_logic_vector(15 downto 0);
			template_A02 : OUT std_logic_vector(15 downto 0);
			template_A10 : OUT std_logic_vector(15 downto 0);
			template_A11 : OUT std_logic_vector(15 downto 0);
			template_A12 : OUT std_logic_vector(15 downto 0);
			template_A20 : OUT std_logic_vector(15 downto 0);
			template_A21 : OUT std_logic_vector(15 downto 0);
			template_A22 : OUT std_logic_vector(15 downto 0);
			template_B00 : OUT std_logic_vector(15 downto 0);
			template_B01 : OUT std_logic_vector(15 downto 0);
			template_B02 : OUT std_logic_vector(15 downto 0);
			template_B10 : OUT std_logic_vector(15 downto 0);
			template_B11 : OUT std_logic_vector(15 downto 0);
			template_B12 : OUT std_logic_vector(15 downto 0);
			template_B20 : OUT std_logic_vector(15 downto 0);
			template_B21 : OUT std_logic_vector(15 downto 0);
			template_B22 : OUT std_logic_vector(15 downto 0);
			template_I : OUT std_logic_vector(15 downto 0);
			template_xbnd : OUT std_logic_vector(15 downto 0);
			template_ubnd : OUT std_logic_vector(15 downto 0)
		);
	end component;
	attribute box_type : string;
	attribute box_type of mpu : component is "user_black_box";
	
	component cnn_commands is
	port
	(
		clk : in std_logic;
		
		control_data_in : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
		control_address : in std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
		cacheWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(cacheWidthMAX,busWidth));
		cacheHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(cacheHeightMAX,busWidth));
		
		Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
		iter_cnt: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(2,busWidth));
		
		cnn_rst: out std_logic:='1';
		
		rand_gen: out std_logic:='0'
	);
	end component;
end cnn_components;

package body cnn_components is
end cnn_components;
