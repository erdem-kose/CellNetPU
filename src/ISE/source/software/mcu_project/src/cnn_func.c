#include "cnn_func.h"

extern u32 i,j;
extern u16 imageWidth,imageHeight, image_shift;
extern u16 Ts, iter_cnt, template_no;

extern XIOModule uart_io, bram_add_datain_o, bram_temp_data_out_i, control_o, error_i;
extern u8 data_uart, ack_uart;
extern u32 bram_add_datain, bram_temp_data_out, control, error;

u8 wait_for_cmd()
{
	u8 cmd;
	while ((ack_uart = XIOModule_Recv(&uart_io, &cmd, 1)) == 0);
	return cmd;
}
void read_header()
{
	control=((6<<16) | 1);
	XIOModule_DiscreteWrite(&control_o, 3, control);

	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	imageWidth = (data_uart<<8);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	imageWidth |= (data_uart);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	imageHeight = (data_uart<<8);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	imageHeight |= (data_uart);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	Ts = (data_uart<<8);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	Ts |= (data_uart);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	iter_cnt = (data_uart<<8);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	iter_cnt |= (data_uart);
	iter_cnt=iter_cnt-1;
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	template_no = (data_uart<<8);
	while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
	template_no |= (data_uart);

	control=((1<<16) | imageWidth);
	XIOModule_DiscreteWrite(&control_o, 3, control);
	control=((2<<16) | imageHeight);
	XIOModule_DiscreteWrite(&control_o, 3, control);
	control=((3<<16) | Ts);
	XIOModule_DiscreteWrite(&control_o, 3, control);
	control=((4<<16) | iter_cnt);
	XIOModule_DiscreteWrite(&control_o, 3, control);
	control=((5<<16) | template_no);
	XIOModule_DiscreteWrite(&control_o, 3, control);

	image_shift=imageWidth*imageHeight;
}

void read_image(int pos)
{
	i=pos*image_shift; j=i+image_shift;
	while(i<j)
	{
		bram_add_datain = (i<<16);

		while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
		bram_add_datain |= (data_uart<<8);

		while ((ack_uart = XIOModule_Recv(&uart_io, &data_uart, 1)) == 0);
		bram_add_datain |= (data_uart);

		XIOModule_DiscreteWrite(&bram_add_datain_o, 1, bram_add_datain);

		control=((7<<16) | 1);
		XIOModule_DiscreteWrite(&control_o, 3, control);
		control=((7<<16) | 0);
		XIOModule_DiscreteWrite(&control_o, 3, control);

		i=i+1;
	}
}

void send_image(int pos)
{
	i=pos*image_shift; j=i+image_shift;
	while(i<j)
	{
		bram_add_datain=(i<<16);
		XIOModule_DiscreteWrite(&bram_add_datain_o, 1, bram_add_datain);
		bram_temp_data_out = XIOModule_DiscreteRead(&bram_temp_data_out_i, 1);

		data_uart = (bram_temp_data_out&0x0000FF00)>>8;
		while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1) == 0));

		data_uart = (bram_temp_data_out&0x000000FF);
		while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1)) == 0);

		i=i+1;
	}
}

void send_error_sum(u8 slc)
{
	control=((9<<16) | slc);
	XIOModule_DiscreteWrite(&control_o, 3, control);

	error = XIOModule_DiscreteRead(&error_i, 3);

	data_uart = (error&0xFF000000)>>24;
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1) == 0));

	data_uart = (error&0x00FF0000)>>16;
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1) == 0));

	data_uart = (error&0x0000FF00)>>8;
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1) == 0));

	data_uart = (error&0x000000FF);
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1)) == 0);
}
