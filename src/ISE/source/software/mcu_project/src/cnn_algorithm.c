#include "cnn_algorithm.h"

extern XIOModule uart_io, control_o, ready_i;
extern u8 data_uart, ack_uart;
extern u32 control, ready;

void algorithm()
{
	data_uart=4;
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1)) == 0);

	control=((6<<16) | 1);
	XIOModule_DiscreteWrite(&control_o, 3, control);
	control=((6<<16) | 0);
	XIOModule_DiscreteWrite(&control_o, 3, control);

	while ((ready = XIOModule_DiscreteRead(&ready_i, 2)&0x00000001) == 0);
	while ((ack_uart = XIOModule_Send(&uart_io,&data_uart,1)) == 0);
}
