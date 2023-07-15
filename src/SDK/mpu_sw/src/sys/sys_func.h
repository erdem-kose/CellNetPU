#include <stdio.h>
#include <stdlib.h>
#include "sys_init.h"

#ifndef SYS_FUNC_H_
#define SYS_FUNC_H_

u8 uart_read();
void uart_write(u8 data);

void l2cache_setdimensions(u16 width, u16 height);
u16 l2cache_u_read(u16 address);
void l2cache_u_write(u16 address, u16 data);
u16 l2cache_x_read(u16 address);
void l2cache_x_write(u16 address, u16 data);
u16 l2cache_ideal_read(u16 address);
void l2cache_ideal_write(u16 address, u16 data);

void command_write(u16 address, u16 data);

s16 rand_num_generate();
s16 rand_num_read();

u8 ready_read();

void header_read();

void image_fill(u16 index, float data);
void image_read();
void image_send();

void error_get();
void error_send();

void template_set(u16 template_no);
void template_send();

#endif
