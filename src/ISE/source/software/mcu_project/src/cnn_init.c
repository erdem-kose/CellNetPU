#include "cnn_init.h"

u32 i,j;
u16 imageWidth=128;
u16 imageHeight=128;
u16 image_shift=128*128;

u16 Ts=1;
u16 iter_cnt=3;
u16 template_no=0;

u8 x_base=0;
u8 u_base=1;
u8 ideal_base=2;
u8 error_base=3;

XIOModule uart_io; u8 data_uart=0; u8 ack_uart=0;
XIOModule bram_add_datain_o; u32 bram_add_datain=0;
XIOModule bram_temp_data_out_i; u32 bram_temp_data_out=0;
XIOModule control_o; u32 control=0;
XIOModule ready_i; u32 ready=0;
XIOModule error_i; u32 error=0;

void init_uart()
{
	#ifdef STDOUT_IS_16550
		XUartNs550_SetBaud(STDOUT_BASEADDR, XPAR_XUARTNS550_CLOCK_HZ, UART_BAUD);
		XUartNs550_SetLineControlReg(STDOUT_BASEADDR, XUN_LCR_8_DATA_BITS);
	#endif
	#ifdef STDOUT_IS_PS7_UART
		/* Bootrom/BSP configures PS7 UART to 115200 bps */
	#endif

	ack_uart = XIOModule_Initialize(&uart_io, XPAR_IOMODULE_0_DEVICE_ID);
	ack_uart = XIOModule_Start(&uart_io);
	ack_uart = XIOModule_CfgInitialize(&uart_io, NULL, 1);
}
void init_bram()
{
	bram_add_datain = XIOModule_Initialize(&bram_add_datain_o, XPAR_IOMODULE_0_DEVICE_ID);
	bram_add_datain = XIOModule_Start(&bram_add_datain_o);
}

void init_templates()
{
	bram_temp_data_out = XIOModule_Initialize(&bram_temp_data_out_i, XPAR_IOMODULE_0_DEVICE_ID);
	bram_temp_data_out = XIOModule_Start(&bram_temp_data_out_i);
}

void init_control()
{
	control = XIOModule_Initialize(&control_o, XPAR_IOMODULE_0_DEVICE_ID);
	control = XIOModule_Start(&control_o);

	ready = XIOModule_Initialize(&ready_i, XPAR_IOMODULE_0_DEVICE_ID);
	ready = XIOModule_Start(&ready_i);

	error = XIOModule_Initialize(&error_i, XPAR_IOMODULE_0_DEVICE_ID);
	error = XIOModule_Start(&error_i);
}

void init_system()
{
	init_uart();
	init_bram();
	init_templates();
	init_control();
	control=((6<<16) | 1);
	XIOModule_DiscreteWrite(&control_o, 3, control);
}
