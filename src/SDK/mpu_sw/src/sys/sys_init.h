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

typedef struct cache_struct
{
	u16 width;//128
	u16 height;//128
} cache_struct;

typedef struct image_struct
{
	u16*** image;
	u16 width;//goruntu eni
	u16 height;//goruntu boyu
	u16 count;//goruntu sayisi
	u32 shift;//goruntu alani
} image_struct;

typedef struct cnn_struct
{
	u16 Ts;//zaman araligi
	u16 iter_cnt;//iterasyon sayisi
	u16 template_no;//sablon indisi
	u16 learn_loop;//ogrenme azami dongu sayisi
	u16 learn_rate;//ogrenme orani
} cnn_struct;

typedef struct template_struct
{
	s16 A[patchWH][patchWH];
	s16 B[patchWH][patchWH];
	s16 I;
	s16 x_bnd;
	s16 u_bnd;
} template_struct;

typedef struct error_struct
{
	s16 u[patchWH][patchWH];
	s16 x[patchWH][patchWH];
	s16 i;
} error_struct;

typedef struct mpu_struct
{
	volatile u8 *uart_rx;
	volatile u8 *uart_tx;
	volatile u8 *uart_status;

	volatile u32 *command;//gpo1(command_address,command_value)
	volatile u32 *feedback;//gpi1(rand_num,ready)

	u32 command_var;
	enum command_enum
	{
	    CMD_NULL = 0,
	    CMD_CACHE_WIDTH = 1,
	    CMD_CACHE_HEIGHT = 2,
	    CMD_TS = 3,
	    CMD_ITER_CNT = 4,
	    CMD_RAND_GEN = 5,
	    CMD_STATE_RST = 6
	} command_enum;

	volatile s16 *template_A00;
	volatile s16 *template_A01;
	volatile s16 *template_A02;
	volatile s16 *template_A10;
	volatile s16 *template_A11;
	volatile s16 *template_A12;
	volatile s16 *template_A20;
	volatile s16 *template_A21;
	volatile s16 *template_A22;
	volatile s16 *template_B00;
	volatile s16 *template_B01;
	volatile s16 *template_B02;
	volatile s16 *template_B10;
	volatile s16 *template_B11;
	volatile s16 *template_B12;
	volatile s16 *template_B20;
	volatile s16 *template_B21;
	volatile s16 *template_B22;
	volatile s16 *template_I;
	volatile s16 *template_xbnd;
	volatile s16 *template_ubnd;

	s32 template_var;

	volatile u16 *x_data_in;
	volatile u16 *x_data_out;
	volatile u16 *x_address;
	volatile u8 *x_we;

	volatile u16 *u_data_in;
	volatile u16 *u_data_out;
	volatile u16 *u_address;
	volatile u8 *u_we;

	volatile u16 *ideal_data_in;
	volatile u16 *ideal_data_out;
	volatile u16 *ideal_address;
	volatile u8 *ideal_we;

	s32 bram_var;

	volatile s32 *error_i;
	volatile s32 *error_u00;
	volatile s32 *error_u01;
	volatile s32 *error_u02;
	volatile s32 *error_u10;
	volatile s32 *error_u11;
	volatile s32 *error_u12;
	volatile s32 *error_u20;
	volatile s32 *error_u21;
	volatile s32 *error_u22;
	volatile s32 *error_x00;
	volatile s32 *error_x01;
	volatile s32 *error_x02;
	volatile s32 *error_x10;
	volatile s32 *error_x11;
	volatile s32 *error_x12;
	volatile s32 *error_x20;
	volatile s32 *error_x21;
	volatile s32 *error_x22;
} mpu_struct;

void ddr2_caches_enable();
void ddr2_caches_disable();

void init_general();
void init_image();
void init_cnn();

void init_uart();
void init_gpio();
void init_l2cache();

void init_system();

#endif
