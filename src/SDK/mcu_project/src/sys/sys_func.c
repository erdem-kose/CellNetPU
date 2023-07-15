#include "sys_func.h"

extern struct general_struct general;
extern struct image_struct image;
extern struct cnn_struct cnn;
extern struct mcs_struct mcs;

u8 read_uart()
{
	u8 data;
	while (((*mcs.uart_status)&0b00000001)==0);//if rx available
	data=(*mcs.uart_rx)&0xFF;
	return data;
}

void write_uart(u8 data)
{
	while (((*mcs.uart_status)&0b00001000)==0b00001000);//if tx available
	*mcs.uart_tx=data;
}

void read_header()
{
	*mcs.control=((7<<16) | 1);

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

	*mcs.control=((1<<16) | image.width);
	*mcs.control=((2<<16) | image.height);
	*mcs.control=((3<<16) | cnn.Ts);
	*mcs.control=((4<<16) | cnn.iter_cnt);
	*mcs.control=((5<<16) | cnn.template_no);
	*mcs.control=((6<<16) | cnn.learn_rate);

	*mcs.control=((10<<16) |image.x_base);
	*mcs.control=((11<<16) |image.u_base);
	*mcs.control=((12<<16) |image.ideal_base);
	*mcs.control=((13<<16) |image.error_base);

	image.shift=image.width*image.height;
}

void read_image(int pos)
{
	general.i=pos*image.shift;
	general.j=general.i+image.shift;
	while(general.i<general.j)
	{
		mcs.bram_var=(general.i<<16);
		mcs.bram_var|=(read_uart()<<8);
		mcs.bram_var|=read_uart();

		*mcs.bram=mcs.bram_var;

		*mcs.control=((8<<16) | 1);
		*mcs.control=((8<<16) | 0);

		general.i=general.i+1;
	}
}

void send_image(int pos)
{
	general.i=pos*image.shift;
	general.j=general.i+image.shift;
	while(general.i<general.j)
	{
		*mcs.bram=(general.i<<16);

		write_uart(((*mcs.bram_temp_dataout)&0x0000FF00)>>8);
		write_uart(((*mcs.bram_temp_dataout)&0x000000FF));

		general.i=general.i+1;
	}
}

void send_error_sum()
{
	write_uart((*mcs.errorval&0xFF000000)>>24);
	write_uart((*mcs.errorval&0x00FF0000)>>16);
	write_uart((*mcs.errorval&0x0000FF00)>>8);
	write_uart((*mcs.errorval&0x000000FF));
}

void send_template(u16 template_no)
{
	general.i=0+21*template_no;
	general.j=general.i+9+21*template_no;
	while(general.i<general.j)
	{
		*mcs.template=(general.i<<16);

		write_uart(((*mcs.bram_temp_dataout)&0xFF000000)>>24);
		write_uart(((*mcs.bram_temp_dataout)&0x00FF0000)>>16);

		general.i=general.i+1;
	}
	general.i=9+21*template_no;
	general.j=general.i+9+21*template_no;
	while(general.i<general.j)
	{
		*mcs.template=(general.i<<16);

		write_uart(((*mcs.bram_temp_dataout)&0xFF000000)>>24);
		write_uart(((*mcs.bram_temp_dataout)&0x00FF0000)>>16);

		general.i=general.i+1;
	}

	*mcs.template=18+21*template_no;
	write_uart(((*mcs.bram_temp_dataout)&0xFF000000)>>24);
	write_uart(((*mcs.bram_temp_dataout)&0x00FF0000)>>16);

	*mcs.template=19+21*template_no;
	write_uart(((*mcs.bram_temp_dataout)&0xFF000000)>>24);
	write_uart(((*mcs.bram_temp_dataout)&0x00FF0000)>>16);

	*mcs.template=20+21*template_no;
	write_uart(((*mcs.bram_temp_dataout)&0xFF000000)>>24);
	write_uart(((*mcs.bram_temp_dataout)&0x00FF0000)>>16);
}
