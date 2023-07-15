#include <stdio.h>
#include <stdlib.h>
#include "../cnn/cnn_package.h"
#include "xparameters.h"
#include "xil_cache.h"

#ifndef SYS_INIT_H_
#define SYS_INIT_H_

//u32 *ptr = (int *) 0x67a9;
//*ptr = 0xaa55;  // MBR signature ?
/*
struct {
	unsigned int widthValidated : 1;
	unsigned int heightValidated : 1;
} status1;
*/

struct general_struct
{
	u32 i,j,k;
};

struct image_struct {
	u16 width;//128
	u16 height;//128
	u16 shift;//128*128

	u8 x_base;//0
	u8 u_base;//1
	u8 ideal_base;//2
	u8 error_base;//3
};

struct cnn_struct {
	u16 Ts;//1
	u16 iter_cnt;//3
	u16 template_no;//0
	u16 learn_loop;//100
	u16 learn_rate;//10
};

struct mcs_struct {
	volatile u32 *uart_rx;
	volatile u32 *uart_tx;
	volatile u32 *uart_status;
	volatile u32 *bram;//gpo1(bram_address,bram_data_in)
	volatile u32 *template;//gpo2(template_address,template_data_in)
	volatile u32 *control;//gpo3(control_address,control_value)
	volatile u32 *bram_temp_dataout;//gpi1()
	volatile u32 *feedback;//gpi2(rand_num,ready)
	volatile u32 *errorval;//gpi3

	u32 bram_var;
	u32 template_var;
	u32 control_var;
};

void enable_caches();
void disable_caches();
void init_general();
void init_image();
void init_cnn();
void init_uart();
void init_gpio();
void init_system();

#endif
