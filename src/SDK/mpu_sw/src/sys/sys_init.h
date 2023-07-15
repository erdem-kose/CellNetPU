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

typedef struct general_struct
{
	u32 i,j,k;
} general_struct;

typedef struct image_struct
{
	u16 width;//128
	u16 height;//128
	u16 shift;//128*128

	u8 x_base;//0
	u8 u_base;//1
	u8 ideal_base;//2
	u8 error_base;//3
} image_struct;

typedef struct cnn_struct
{
	u16 Ts;//1
	u16 iter_cnt;//3
	u16 template_no;//0
	u16 learn_loop;//100
	u16 learn_rate;//10
} cnn_struct;

typedef struct mpu_struct
{
	volatile u8 *uart_rx;
	volatile u8 *uart_tx;
	volatile u8 *uart_status;
	volatile u32 *bram;//gpo1(bram_address,bram_data_in)
	volatile u32 *template;//gpo2(template_address,template_data_in)
	volatile u32 *control;//gpo3(control_address,control_value)
	volatile u32 *bram_temp_dataout;//gpi1()
	volatile u32 *feedback;//gpi2(rand_num,ready)

	volatile u32 *error_i;
	volatile u32 *error_u00;
	volatile u32 *error_u01;
	volatile u32 *error_u02;
	volatile u32 *error_u10;
	volatile u32 *error_u11;
	volatile u32 *error_u12;
	volatile u32 *error_u20;
	volatile u32 *error_u21;
	volatile u32 *error_u22;
	volatile u32 *error_x00;
	volatile u32 *error_x01;
	volatile u32 *error_x02;
	volatile u32 *error_x10;
	volatile u32 *error_x11;
	volatile u32 *error_x12;
	volatile u32 *error_x20;
	volatile u32 *error_x21;
	volatile u32 *error_x22;

	u32 bram_var;
	u32 template_var;
	u32 control_var;
} mpu_struct;

void enable_caches();
void disable_caches();

void init_general();
void init_image();
void init_cnn();

void init_uart();
void init_gpio();
void init_l2cache();

void init_system();

#endif
