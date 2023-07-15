#include "sys_init.h"

struct general_struct general;
struct image_struct image;
struct cnn_struct cnn;
struct mcs_struct mcs;

void enable_caches()
{
	#ifdef __PPC__
		Xil_ICacheEnableRegion(CACHEABLE_REGION_MASK);
		Xil_DCacheEnableRegion(CACHEABLE_REGION_MASK);
	#elif __MICROBLAZE__
	#ifdef XPAR_MICROBLAZE_USE_ICACHE
		Xil_ICacheEnable();
	#endif
	#ifdef XPAR_MICROBLAZE_USE_DCACHE
		Xil_DCacheEnable();
	#endif
	#endif
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
	mcs.uart_rx = (volatile u32*)0x80000000;
	mcs.uart_tx = (volatile u32*)0x80000004;
	mcs.uart_status = (volatile u32*)0x80000008;
}

void init_gpio()
{
	mcs.bram = (volatile u32*)0x80000010;
	mcs.template = (volatile u32*)0x80000014;
	mcs.control = (volatile u32*)0x80000018;
	mcs.bram_temp_dataout = (volatile u32*)0x80000020;
	mcs.feedback = (volatile u32*)0x80000024;
	mcs.errorval = (volatile u32*)0x80000028;
}

void init_system()
{

	enable_caches();
	init_general();
	init_image();
	init_cnn();
	init_uart();
	init_gpio();
	*mcs.control=((7<<16) | 1);
}
