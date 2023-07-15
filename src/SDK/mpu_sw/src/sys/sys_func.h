#include <stdio.h>
#include <stdlib.h>
#include "sys_init.h"

#ifndef SYS_FUNC_H_
#define SYS_FUNC_H_

u8 read_uart();
void write_uart(u8 data);

void setdimensions_l2cache_bram(u16 width, u16 height);
u16 read_l2cache_bram(u16 address);
void write_l2cache_bram(u16 address, u16 data);

u16 read_template_bram(u16 address);
void write_template_bram(u16 address, u16 data);

void write_control(u16 address, u16 data);

s16 read_rand_num();
u8 read_ready();
s32 read_error(char type, u8 i, u8 j);

void read_header();
void read_image(int pos);
void send_image(int pos);
void send_error_sum();
void send_template();

#endif
