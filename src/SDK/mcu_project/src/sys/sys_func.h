#include <stdio.h>
#include <stdlib.h>
#include "sys_init.h"

#ifndef SYS_FUNC_H_
#define SYS_FUNC_H_

u8 read_uart();
void write_uart(u8 data);
void read_header();
void read_image(int pos);
void send_image(int pos);
void send_error_sum();
void send_template(u16 template_no);
#endif
