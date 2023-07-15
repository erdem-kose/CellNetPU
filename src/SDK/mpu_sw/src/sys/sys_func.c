#include "sys_func.h"

extern general_struct general;
extern image_struct image;
extern cnn_struct cnn;
extern mpu_struct mpu;

u8 read_uart()
{
	u8 data;
	while (((*mpu.uart_status)&0b00000001)==0);//if rx available
	data=(*mpu.uart_rx)&0xFF;
	return data;
}

void write_uart(u8 data)
{
	while (((*mpu.uart_status)&0b00001000)==0b00001000);//if tx available
	*mpu.uart_tx=data;
}

void setdimensions_l2cache_bram(u16 width, u16 height)
{
	if ((width>0) && (width<l2cacheWidthMAX))
	{
		if ((height>0) && (height<l2cacheHeightMAX))
		{
			write_control(1, width);
			write_control(2, height);
		}
	}
}

u16 read_l2cache_bram(u16 address)
{
	u16 value;
	*mpu.bram=(address<<16);
	value=((*mpu.bram_temp_dataout)&0x0000FFFF);
	return value;
}

void write_l2cache_bram(u16 address, u16 data)
{
	*mpu.bram=(address<<16)|data;

	write_control(8, 1);
	write_control(8, 0);
}

u16 read_template_bram(u16 address)
{
	u16 value;
	*mpu.template=(address<<16);
	value=(((*mpu.bram_temp_dataout)&0xFFFF0000)>>16);
	return value;
}

void write_template_bram(u16 address, u16 data)
{
	*mpu.template=(address<<16)|data;

	write_control(9, 1);
	write_control(9, 0);
}

void write_control(u16 address, u16 data)
{
	*mpu.control=((address<<16) | data);
}

s16 read_rand_num()
{
	return (((s32)*mpu.feedback)>>16);
}

u8 read_ready()
{
	return ((*mpu.feedback)&0x00000001);
}

s32 read_error(char type, u8 i, u8 j)
{
	s32 result=0;
	switch(type)
	{
		case 'I': result=((s32)*mpu.error_i); break;

		case 'x':
			switch(i)
			{
				case 0:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_x00); break;
						case 1: result=((s32)*mpu.error_x01); break;
						case 2: result=((s32)*mpu.error_x02); break;
					} break;
				case 1:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_x10); break;
						case 1: result=((s32)*mpu.error_x11); break;
						case 2: result=((s32)*mpu.error_x12); break;
					} break;
				case 2:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_x20); break;
						case 1: result=((s32)*mpu.error_x21); break;
						case 2: result=((s32)*mpu.error_x22); break;
					} break;
			} break;

		case 'u':
			switch(i)
			{
				case 0:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_u00); break;
						case 1: result=((s32)*mpu.error_u01); break;
						case 2: result=((s32)*mpu.error_u02); break;
					} break;
				case 1:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_u10); break;
						case 1: result=((s32)*mpu.error_u11); break;
						case 2: result=((s32)*mpu.error_u12); break;
					} break;
				case 2:
					switch(j)
					{
						case 0: result=((s32)*mpu.error_u20); break;
						case 1: result=((s32)*mpu.error_u21); break;
						case 2: result=((s32)*mpu.error_u22); break;
					} break;
			} break;
		default: break;
	}
	return result;

}

void read_header()
{
	write_control(7, 1);

	image.width = (read_uart()<<8);
	image.width |= read_uart();

	image.height = (read_uart()<<8);
	image.height |= read_uart();

	cnn.Ts = (read_uart()<<8);
	cnn.Ts |= read_uart();

	cnn.iter_cnt = (read_uart()<<8);
	cnn.iter_cnt |= read_uart();
	cnn.iter_cnt=cnn.iter_cnt-1;

	cnn.template_no = (read_uart()<<8);
	cnn.template_no |= read_uart();

	cnn.learn_loop = (read_uart()<<8);
	cnn.learn_loop |= read_uart();

	cnn.learn_rate = (read_uart()<<8);
	cnn.learn_rate |= read_uart();

	write_control(1, image.width);
	write_control(2, image.height);
	write_control(3, cnn.Ts);
	write_control(4, cnn.iter_cnt);
	write_control(5, cnn.template_no);
	write_control(6, cnn.learn_rate);

	write_control(10, image.x_base);
	write_control(11, image.u_base);
	write_control(12, image.ideal_base);
	write_control(13, image.error_base);

	image.shift=image.width*image.height;
}

void read_image(int pos)
{
	general.i=pos*image.shift;
	general.j=general.i+image.shift;
	while(general.i<general.j)
	{
		mpu.bram_var=(read_uart()<<8);
		mpu.bram_var|=read_uart();

		write_l2cache_bram(general.i, mpu.bram_var);

		general.i=general.i+1;
	}
}

void send_image(int pos)
{
	general.i=pos*image.shift;
	general.j=general.i+image.shift;
	while(general.i<general.j)
	{
		mpu.bram_var=read_l2cache_bram(general.i);

		write_uart((mpu.bram_var&0x0000FF00)>>8);
		write_uart((mpu.bram_var&0x000000FF));

		general.i=general.i+1;
	}
}

void send_error_sum()
{
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			write_uart(((read_error('x',general.i,general.j))&0xFF000000)>>24);
			write_uart(((read_error('x',general.i,general.j))&0x00FF0000)>>16);
			write_uart(((read_error('x',general.i,general.j))&0x0000FF00)>>8);
			write_uart(((read_error('x',general.i,general.j))&0x000000FF));
		}
	}
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			write_uart(((read_error('u',general.i,general.j))&0xFF000000)>>24);
			write_uart(((read_error('u',general.i,general.j))&0x00FF0000)>>16);
			write_uart(((read_error('u',general.i,general.j))&0x0000FF00)>>8);
			write_uart(((read_error('u',general.i,general.j))&0x000000FF));
		}
	}
	write_uart(((read_error('I',0,0))&0xFF000000)>>24);
	write_uart(((read_error('I',0,0))&0x00FF0000)>>16);
	write_uart(((read_error('I',0,0))&0x0000FF00)>>8);
	write_uart(((read_error('I',0,0))&0x000000FF));
}


void send_template()
{
	u16 template_no;
	template_no = (read_uart()<<8);
	template_no |= read_uart();

	general.i=0+21*template_no;
	general.j=general.i+9+21*template_no;
	while(general.i<general.j)
	{
		mpu.template_var=read_template_bram(general.i);

		write_uart((mpu.template_var&0x0000FF00)>>8);
		write_uart((mpu.template_var&0x000000FF));

		general.i=general.i+1;
	}

	general.i=9+21*template_no;
	general.j=general.i+9+21*template_no;
	while(general.i<general.j)
	{
		mpu.template_var=read_template_bram(general.i);

		write_uart((mpu.template_var&0x0000FF00)>>8);
		write_uart((mpu.template_var&0x000000FF));

		general.i=general.i+1;
	}

	mpu.template_var=read_template_bram((18+21*template_no));
	write_uart((mpu.template_var&0x0000FF00)>>8);
	write_uart((mpu.template_var&0x000000FF));

	mpu.template_var=read_template_bram((19+21*template_no));
	write_uart((mpu.template_var&0x0000FF00)>>8);
	write_uart((mpu.template_var&0x000000FF));

	mpu.template_var=read_template_bram((20+21*template_no));
	write_uart((mpu.template_var&0x0000FF00)>>8);
	write_uart((mpu.template_var&0x000000FF));
}
