library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
library std;
	use std.textio.all;
library cnn_library;
	use cnn_library.cnn_package.all;


entity cnn_interface is
	port (
		sys_clk, mcu_clk , rst : in std_logic;
		ready: in std_logic;
		
		uart_rx : in std_logic;
		uart_tx : out std_logic;
		
		cnn_rst: out std_logic:='0';
		
		iter_cnt: out std_logic_vector(busWidth/2-2 downto 0) := std_logic_vector(to_unsigned(2,busWidth/2-1));
		template_no : out std_logic_vector(busWidth/2-3 downto 0) := std_logic_vector(to_unsigned(0,busWidth/2-2));
		Ts : out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(205,busWidth));
	
		imageWidth: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		imageHeight: out std_logic_vector(busWidth-1 downto 0) := std_logic_vector(to_unsigned(128,busWidth));
		
		bram_we : in std_logic_vector(0 downto 0);
		bram_address : in std_logic_vector(ramAddressWidth-1 downto 0);
		bram_data_in : in std_logic_vector(busWidth-1 downto 0);
		bram_data_out : out std_logic_vector(busWidth-1 downto 0);
		
		template_we : out std_logic_vector(0 downto 0);
		template_address : out std_logic_vector(templateAddressWidth-1 downto 0);
		template_data_in : out std_logic_vector(busWidth-1 downto 0);
		template_data_out : in std_logic_vector(busWidth-1 downto 0)
	);
end cnn_interface;

architecture Behavioral of cnn_interface is
	component mcu
		port (
			Clk : in std_logic;
			Reset : in std_logic;
			IO_Addr_Strobe : out std_logic;
			IO_Read_Strobe : out std_logic;
			IO_Write_Strobe : out std_logic;
			IO_Address : out std_logic_vector(31 downto 0);
			IO_Byte_Enable : out std_logic_vector(3 downto 0);
			IO_Write_Data : out std_logic_vector(31 downto 0);
			IO_Read_Data : in std_logic_vector(31 downto 0);
			IO_Ready : in std_logic;
			UART_Rx : in std_logic;
			UART_Tx : out std_logic;
			GPO1 : out std_logic_vector(2*busWidth-1 downto 0);
			GPO2 : out std_logic_vector(2*busWidth-1 downto 0);
			GPO3 : out std_logic_vector(2*busWidth-1 downto 0);
			GPO4 : out std_logic_vector(2*busWidth-1 downto 0);
			GPI1 : in std_logic_vector(2*busWidth-1 downto 0);
			GPI2 : in std_logic_vector(2*busWidth-1 downto 0);
			GPI1_Interrupt : out std_logic;
			GPI2_Interrupt : out std_logic
		);
	end component;
	
	component ram_generic
		port (
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(15 downto 0);
			dina : in std_logic_vector(15 downto 0);
			douta : out std_logic_vector(15 downto 0);
			clkb : in std_logic;
			web : in std_logic_vector(0 downto 0);
			addrb : in std_logic_vector(15 downto 0);
			dinb : in std_logic_vector(15 downto 0);
			doutb : out std_logic_vector(15 downto 0)
		);
	end component;

	signal interface_bram_we : std_logic_vector(0 downto 0):=(others=>'0');
	signal interface_bram_address : std_logic_vector(ramAddressWidth-1 downto 0):=(others=>'0');
	signal interface_bram_data_in : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	signal interface_bram_data_out : std_logic_vector(busWidth-1 downto 0):=(others=>'0');
	
	signal IO_Addr_Strobe : std_logic;
	signal IO_Read_Strobe : std_logic;
	signal IO_Write_Strobe : std_logic;
	signal IO_Address : std_logic_vector(31 downto 0);
	signal IO_Byte_Enable : std_logic_vector(3 downto 0);
	signal IO_Write_Data : std_logic_vector(31 downto 0);
	signal IO_Read_Data : std_logic_vector(31 downto 0);
	signal IO_Ready : std_logic;
			
	signal gpo1 : std_logic_vector(2*busWidth-1 downto 0);--bram:bram_address,bram_data_in
	signal gpo2 : std_logic_vector(2*busWidth-1 downto 0);--image dim:imageWidth,imageHeight
	signal gpo3 : std_logic_vector(2*busWidth-1 downto 0);--template:template_address,template_data_in
	signal gpo4 : std_logic_vector(2*busWidth-1 downto 0);--control register: 31:16:Ts,15:9:iter_cnt,8:3:template_no,2:cnn_rst,1:bram_we,0:template_we
	signal gpi1 : std_logic_vector(2*busWidth-1 downto 0);--template_data_out,bram_data_out
	signal gpi2 : std_logic_vector(2*busWidth-1 downto 0);--ready
	signal gpi1_interrupt : std_logic :='0';
	signal gpi2_interrupt : std_logic :='0';
begin

	interface_bram_address<=gpo1(16+ramAddressWidth-1 downto 16);
	interface_bram_data_in<=gpo1(15 downto 0);
	
	imageWidth<=gpo2(31 downto 16);
	imageHeight<=gpo2(15 downto 0);
	
	template_address<=gpo3(16+templateAddressWidth-1 downto 16);
	template_data_in<=gpo3(15 downto 0);
	
	Ts<=gpo4(31 downto 16);
	iter_cnt<=gpo4(15 downto 9);
	template_no<=gpo4(8 downto 3);
	cnn_rst<=gpo4(2);
	interface_bram_we<=gpo4(1 downto 1);
	template_we<=gpo4(0 downto 0);
	
	gpi1(31 downto 16)<=template_data_out;
	gpi1(15 downto 0)<=interface_bram_data_out;
	gpi2(31 downto 1)<=(others=>'0');
	gpi2(0)<=ready;
	
	INTERFACE_MCU: mcu
		port map (
			mcu_clk, rst,
			IO_Addr_Strobe, IO_Read_Strobe, IO_Write_Strobe, IO_Address, IO_Byte_Enable, IO_Write_Data, IO_Read_Data, IO_Ready,
			uart_rx, uart_tx,
			gpo1, gpo2, gpo3, gpo4,
			gpi1, gpi2,
			gpi1_interrupt,gpi2_interrupt
		);
	INTERFACE_BRAM: ram_generic
		port map (
			sys_clk, interface_bram_we,
			interface_bram_address, interface_bram_data_in, interface_bram_data_out,
			sys_clk, bram_we,
			bram_address, bram_data_in, bram_data_out
		);
end Behavioral;

