#include "sys_init.h"
#include "sys_func.h"
#include "xparameters.h"

general_struct general;
image_struct image;
cnn_struct cnn;
mpu_struct mpu;

void enable_caches()
{
	Xil_ICacheEnable();
	Xil_DCacheEnable();
}

void disable_caches()
{
    Xil_DCacheDisable();
    Xil_ICacheDisable();
}

void init_general()
{
	general.i=0;
	general.j=0;
	general.k=0;
}

void init_image()
{
	image.width=128;
	image.height=128;
	image.shift=image.width*image.height;

	image.x_base=0;
	image.u_base=1;//1
	image.ideal_base=2;//2
	image.error_base=3;//3

}

void init_cnn()
{
	cnn.Ts=1;
	cnn.iter_cnt=3;
	cnn.template_no=0;
	cnn.learn_loop=100;
	cnn.learn_rate=10;
}

void init_uart()
{
	mpu.uart_rx = (volatile u8*)(XPAR_IOMODULE_0_BASEADDR|0x0);
	mpu.uart_tx = (volatile u8*)(XPAR_IOMODULE_0_BASEADDR|0x4);
	mpu.uart_status = (volatile u8*)(XPAR_IOMODULE_0_BASEADDR|0x8);
}

void init_gpio()
{
	mpu.bram = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x10);
	mpu.template = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x14);
	mpu.control = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x18);
	mpu.bram_temp_dataout = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x20);
	mpu.feedback = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x24);

	mpu.error_i = (volatile u32*)(XPAR_ERROR_I_BASE_BASEADDR|0x00);
	mpu.error_u00= (volatile u32*)(XPAR_ERROR_U00_U01_BASEADDR|0x00);
	mpu.error_u01= (volatile u32*)(XPAR_ERROR_U00_U01_BASEADDR|0x08);
	mpu.error_u02= (volatile u32*)(XPAR_ERROR_U02_U10_BASEADDR|0x00);
	mpu.error_u10= (volatile u32*)(XPAR_ERROR_U02_U10_BASEADDR|0x08);
	mpu.error_u11= (volatile u32*)(XPAR_ERROR_U11_U12_BASEADDR|0x00);
	mpu.error_u12= (volatile u32*)(XPAR_ERROR_U11_U12_BASEADDR|0x08);
	mpu.error_u20= (volatile u32*)(XPAR_ERROR_U20_U21_BASEADDR|0x00);
	mpu.error_u21= (volatile u32*)(XPAR_ERROR_U20_U21_BASEADDR|0x08);
	mpu.error_u22= (volatile u32*)(XPAR_ERROR_U22_X00_BASEADDR|0x00);
	mpu.error_x00= (volatile u32*)(XPAR_ERROR_U22_X00_BASEADDR|0x08);
	mpu.error_x01= (volatile u32*)(XPAR_ERROR_X01_X02_BASEADDR|0x00);
	mpu.error_x02= (volatile u32*)(XPAR_ERROR_X01_X02_BASEADDR|0x08);
	mpu.error_x10= (volatile u32*)(XPAR_ERROR_X10_X11_BASEADDR|0x00);
	mpu.error_x11= (volatile u32*)(XPAR_ERROR_X10_X11_BASEADDR|0x08);
	mpu.error_x12= (volatile u32*)(XPAR_ERROR_X12_X20_BASEADDR|0x00);
	mpu.error_x20= (volatile u32*)(XPAR_ERROR_X12_X20_BASEADDR|0x08);
	mpu.error_x21= (volatile u32*)(XPAR_ERROR_X21_X22_BASEADDR|0x00);
	mpu.error_x22= (volatile u32*)(XPAR_ERROR_X21_X22_BASEADDR|0x08);
}

void init_l2cache()
{
	setdimensions_l2cache_bram(l2cacheWidthMAX, l2cacheHeightMAX);
}

void init_system()
{
	enable_caches();

	init_general();
	init_image();
	init_cnn();

	init_uart();
	init_gpio();
	init_l2cache();

	write_control(7, 1);
}
