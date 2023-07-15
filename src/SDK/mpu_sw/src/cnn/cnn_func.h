#include <stdio.h>
#include <stdlib.h>
#include "../sys/sys_func.h"

#ifndef CNN_FUNCH_H_
#define CNN_FUNCH_H_

void cnn_driver(u8 u_loc, u8 x_loc, u8 ideal_loc, u16 template_no, u16 iter_cnt, u16 Ts);

void template_pixel_create(u16 template_no, char loc, u32 i,u32 j, s16 val);
void template_create(u16 template_no);

void template_pixel_update(u16 template_no, char loc, u32 i,u32 j, s32 error);
void template_update_1d(u16 template_no);
void template_update_2d(u16 template_no);
#endif
