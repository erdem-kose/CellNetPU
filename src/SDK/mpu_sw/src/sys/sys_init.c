#include "sys_init.h"
#include "sys_func.h"
#include "xparameters.h"

general_struct general;
cache_struct cache;
image_struct image;
cnn_struct cnn;
mpu_struct mpu;
template_struct templates[] = {
    #include "template_init.txt"
};
error_struct errors;

void ddr2_caches_enable()
{
	Xil_ICacheEnable();
	Xil_DCacheEnable();
}

void ddr2_caches_disable()
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
	image.count=20;
	image.shift=image.width*image.height;

	free(image.image);
    image.image = (u16***)malloc(image.count * sizeof(u16**));
    for (general.i=0; general.i<20; general.i=general.i+1)
    {
    	image.image[general.i] = (u16**)malloc(image.height * sizeof(u16*));
        for (general.j=0; general.j<image.height; general.j=general.j+1)
        {
        	image.image[general.i][general.j] = (u16*)calloc(image.width, sizeof(u16));
        }

    }
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
	mpu.command = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x10);
	mpu.feedback = (volatile u32*)(XPAR_IOMODULE_0_BASEADDR|0x20);

	mpu.template_A00= (volatile s16*)(XPAR_TEMPLATE_A00_A01_BASEADDR|0x00);
	mpu.template_A01= (volatile s16*)(XPAR_TEMPLATE_A00_A01_BASEADDR|0x08);
	mpu.template_A02= (volatile s16*)(XPAR_TEMPLATE_A02_A10_BASEADDR|0x00);
	mpu.template_A10= (volatile s16*)(XPAR_TEMPLATE_A02_A10_BASEADDR|0x08);
	mpu.template_A11= (volatile s16*)(XPAR_TEMPLATE_A11_A12_BASEADDR|0x00);
	mpu.template_A12= (volatile s16*)(XPAR_TEMPLATE_A11_A12_BASEADDR|0x08);
	mpu.template_A20= (volatile s16*)(XPAR_TEMPLATE_A20_A21_BASEADDR|0x00);
	mpu.template_A21= (volatile s16*)(XPAR_TEMPLATE_A20_A21_BASEADDR|0x08);
	mpu.template_A22= (volatile s16*)(XPAR_TEMPLATE_A22_B00_BASEADDR|0x00);
	mpu.template_B00= (volatile s16*)(XPAR_TEMPLATE_A22_B00_BASEADDR|0x08);
	mpu.template_B01= (volatile s16*)(XPAR_TEMPLATE_B01_B02_BASEADDR|0x00);
	mpu.template_B02= (volatile s16*)(XPAR_TEMPLATE_B01_B02_BASEADDR|0x08);
	mpu.template_B10= (volatile s16*)(XPAR_TEMPLATE_B10_B11_BASEADDR|0x00);
	mpu.template_B11= (volatile s16*)(XPAR_TEMPLATE_B10_B11_BASEADDR|0x08);
	mpu.template_B12= (volatile s16*)(XPAR_TEMPLATE_B12_B20_BASEADDR|0x00);
	mpu.template_B20= (volatile s16*)(XPAR_TEMPLATE_B12_B20_BASEADDR|0x08);
	mpu.template_B21= (volatile s16*)(XPAR_TEMPLATE_B21_B22_BASEADDR|0x00);
	mpu.template_B22= (volatile s16*)(XPAR_TEMPLATE_B21_B22_BASEADDR|0x08);
	mpu.template_I= (volatile s16*)(XPAR_TEMPLATE_I_BASE_BASEADDR|0x00);
	mpu.template_xbnd= (volatile s16*)(XPAR_TEMPLATE_XBND_UBND_BASEADDR|0x00);
	mpu.template_ubnd= (volatile s16*)(XPAR_TEMPLATE_XBND_UBND_BASEADDR|0x08);

	mpu.x_data_in = (volatile u16*)(XPAR_X_DATA_IN_OUT_BASEADDR|0x00);
	mpu.x_data_out = (volatile u16*)(XPAR_X_DATA_IN_OUT_BASEADDR|0x08);
	mpu.x_address = (volatile u16*)(XPAR_X_ADDRESS_WE_BASEADDR|0x00);
	mpu.x_we = (volatile u8*)(XPAR_X_ADDRESS_WE_BASEADDR|0x08);

	mpu.u_data_in = (volatile u16*)(XPAR_U_DATA_IN_OUT_BASEADDR|0x00);
	mpu.u_data_out = (volatile u16*)(XPAR_U_DATA_IN_OUT_BASEADDR|0x08);
	mpu.u_address = (volatile u16*)(XPAR_U_ADDRESS_WE_BASEADDR|0x00);
	mpu.u_we = (volatile u8*)(XPAR_U_ADDRESS_WE_BASEADDR|0x08);

	mpu.ideal_data_in = (volatile u16*)(XPAR_IDEAL_DATA_IN_OUT_BASEADDR|0x00);
	mpu.ideal_data_out = (volatile u16*)(XPAR_IDEAL_DATA_IN_OUT_BASEADDR|0x08);
	mpu.ideal_address = (volatile u16*)(XPAR_IDEAL_ADDRESS_WE_BASEADDR|0x00);
	mpu.ideal_we = (volatile u8*)(XPAR_IDEAL_ADDRESS_WE_BASEADDR|0x08);

	mpu.error_i= (volatile s32*)(XPAR_ERROR_I_BASE_BASEADDR|0x00);
	mpu.error_u00= (volatile s32*)(XPAR_ERROR_U00_U01_BASEADDR|0x00);
	mpu.error_u01= (volatile s32*)(XPAR_ERROR_U00_U01_BASEADDR|0x08);
	mpu.error_u02= (volatile s32*)(XPAR_ERROR_U02_U10_BASEADDR|0x00);
	mpu.error_u10= (volatile s32*)(XPAR_ERROR_U02_U10_BASEADDR|0x08);
	mpu.error_u11= (volatile s32*)(XPAR_ERROR_U11_U12_BASEADDR|0x00);
	mpu.error_u12= (volatile s32*)(XPAR_ERROR_U11_U12_BASEADDR|0x08);
	mpu.error_u20= (volatile s32*)(XPAR_ERROR_U20_U21_BASEADDR|0x00);
	mpu.error_u21= (volatile s32*)(XPAR_ERROR_U20_U21_BASEADDR|0x08);
	mpu.error_u22= (volatile s32*)(XPAR_ERROR_U22_X00_BASEADDR|0x00);
	mpu.error_x00= (volatile s32*)(XPAR_ERROR_U22_X00_BASEADDR|0x08);
	mpu.error_x01= (volatile s32*)(XPAR_ERROR_X01_X02_BASEADDR|0x00);
	mpu.error_x02= (volatile s32*)(XPAR_ERROR_X01_X02_BASEADDR|0x08);
	mpu.error_x10= (volatile s32*)(XPAR_ERROR_X10_X11_BASEADDR|0x00);
	mpu.error_x11= (volatile s32*)(XPAR_ERROR_X10_X11_BASEADDR|0x08);
	mpu.error_x12= (volatile s32*)(XPAR_ERROR_X12_X20_BASEADDR|0x00);
	mpu.error_x20= (volatile s32*)(XPAR_ERROR_X12_X20_BASEADDR|0x08);
	mpu.error_x21= (volatile s32*)(XPAR_ERROR_X21_X22_BASEADDR|0x00);
	mpu.error_x22= (volatile s32*)(XPAR_ERROR_X21_X22_BASEADDR|0x08);
}

void init_l2cache()
{
	l2cache_setdimensions(l2cacheWidthMAX, l2cacheHeightMAX);
}

void init_system()
{
	ddr2_caches_enable();

	init_general();
	init_image();
	init_cnn();

	init_uart();
	init_gpio();
	init_l2cache();

	command_write(CMD_STATE_RST, 1);
}
