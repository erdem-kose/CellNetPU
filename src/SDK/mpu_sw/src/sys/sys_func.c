#include "sys_func.h"

extern general_struct general;
//extern cache_struct cache;
extern image_struct image;
extern cnn_struct cnn;
extern mpu_struct mpu;
extern template_struct templates[];
extern error_struct errors;

u8 uart_read()
{
	u8 data;
	while (((*mpu.uart_status)&0b00000001)==0);//if rx available
	data=(*mpu.uart_rx)&0xFF;
	return data;
}

void uart_write(u8 data)
{
	while (((*mpu.uart_status)&0b00001000)==0b00001000);//if tx available
	*mpu.uart_tx=data;
}

void l2cache_setdimensions(u16 width, u16 height)
{
	if ((width>0) && (width<l2cacheWidthMAX))
	{
		if ((height>0) && (height<l2cacheHeightMAX))
		{
			command_write(CMD_CACHE_WIDTH, width);
			command_write(CMD_CACHE_HEIGHT, height);
		}
	}
}

u16 l2cache_u_read(u16 address)
{
	u16 value;
	*mpu.u_address=address;
	value=(*mpu.u_data_out);
	return value;
}

void l2cache_u_write(u16 address, u16 data)
{
	*mpu.u_address=address;
	*mpu.u_data_in=data;
	*mpu.u_we=1;
	*mpu.u_we=0;
}

u16 l2cache_x_read(u16 address)
{
	u16 value;
	*mpu.x_address=address;
	value=(*mpu.x_data_out);
	return value;
}

void l2cache_x_write(u16 address, u16 data)
{
	*mpu.x_address=address;
	*mpu.x_data_in=data;
	*mpu.x_we=1;
	*mpu.x_we=0;
}

u16 l2cache_ideal_read(u16 address)
{
	u16 value;
	*mpu.ideal_address=address;
	value=(*mpu.ideal_data_out);
	return value;
}

void l2cache_ideal_write(u16 address, u16 data)
{
	*mpu.ideal_address=address;
	*mpu.ideal_data_in=data;
	*mpu.ideal_we=1;
	*mpu.ideal_we=0;
}

void command_write(u16 address, u16 data)
{
	*mpu.command=((address<<16) | data);
}

s16 rand_num_generate()
{
	command_write(CMD_RAND_GEN, 1);
	command_write(CMD_RAND_GEN, 0);
	return (((s32)*mpu.feedback)>>16);
}

s16 rand_num_read()
{
	return (((s32)*mpu.feedback)>>16);
}

u8 ready_read()
{
	return ((*mpu.feedback)&0x00000001);
}

void header_read()
{
	command_write(CMD_STATE_RST, 1);

	image.width = (uart_read()<<8);
	image.width |= uart_read();

	image.height = (uart_read()<<8);
	image.height |= uart_read();

	cnn.Ts = (uart_read()<<8);
	cnn.Ts |= uart_read();

	cnn.iter_cnt = (uart_read()<<8);
	cnn.iter_cnt |= uart_read();
	cnn.iter_cnt=cnn.iter_cnt-1;

	cnn.template_no = (uart_read()<<8);
	cnn.template_no |= uart_read();

	cnn.learn_loop = (uart_read()<<8);
	cnn.learn_loop |= uart_read();

	cnn.learn_rate = (uart_read()<<8);
	cnn.learn_rate |= uart_read();

	command_write(CMD_CACHE_WIDTH, image.width);
	command_write(CMD_CACHE_HEIGHT, image.height);
	command_write(CMD_TS, cnn.Ts);
	command_write(CMD_ITER_CNT, cnn.iter_cnt);

	//duzelt iç realloclar malloc olabilir, ya da free de baþtan baþla
	free(image.image);
    image.image = (u16***)malloc(image.count * sizeof(u16**));
    for (general.i=0; general.i<20; general.i=general.i+1)
    {
    	image.image[general.i] = (u16**)malloc(image.height * sizeof(u16*));
        for (general.j=0; general.j<image.height; general.j=general.j+1)
        {
        	image.image[general.i][general.j] = (u16*)calloc(image.width, sizeof(u16));
        }

    }
	image.shift=image.width*image.height;
	uart_write(1);
}

void image_fill(u16 index, float data)
{
    for (general.i=0; general.i<image.height; general.i=general.i+1)
    {
        for (general.j=0; general.j<image.width; general.j=general.j+1)
        {
        	image.image[index][general.i][general.j] = (u16)(data*pow(2,busF));
        }
    }
}

void image_read()
{
	u8 pos;
	pos=uart_read();

	for (general.i=0;general.i<image.height;general.i=general.i+1)
	{
		for (general.j=0;general.j<image.width;general.j=general.j+1)
		{
			image.image[pos][general.i][general.j]=(uart_read()<<8);
			image.image[pos][general.i][general.j]|=uart_read();
		}
	}
}

void image_send()
{
	u8 pos;
	pos=uart_read();

	for (general.i=0;general.i<image.height;general.i=general.i+1)
	{
		for (general.j=0;general.j<image.width;general.j=general.j+1)
		{
			uart_write((image.image[pos][general.i][general.j]&0x0000FF00)>>8);
			uart_write((image.image[pos][general.i][general.j]&0x000000FF));
		}
	}
}

void error_get()
{
	errors.u[0][0]=(*mpu.error_u00*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[0][1]=(*mpu.error_u01*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[0][2]=(*mpu.error_u02*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[1][0]=(*mpu.error_u10*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[1][1]=(*mpu.error_u11*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[1][2]=(*mpu.error_u12*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[2][0]=(*mpu.error_u20*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[2][1]=(*mpu.error_u21*cnn.learn_rate)/(busFMax*image.shift);
	errors.u[2][2]=(*mpu.error_u22*cnn.learn_rate)/(busFMax*image.shift);

	errors.x[0][0]=(*mpu.error_x00*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[0][1]=(*mpu.error_x01*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[0][2]=(*mpu.error_x02*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[1][0]=(*mpu.error_x10*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[1][1]=(*mpu.error_x11*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[1][2]=(*mpu.error_x12*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[2][0]=(*mpu.error_x20*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[2][1]=(*mpu.error_x21*cnn.learn_rate)/(busFMax*image.shift);
	errors.x[2][2]=(*mpu.error_x22*cnn.learn_rate)/(busFMax*image.shift);

	errors.i=(*mpu.error_i*cnn.learn_rate)/(busFMax*image.shift);
}

void error_send()
{
	error_get();

	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			uart_write(((errors.x[general.i][general.j])&0xFF000000)>>24);
			uart_write(((errors.x[general.i][general.j])&0x00FF0000)>>16);
			uart_write(((errors.x[general.i][general.j])&0x0000FF00)>>8);
			uart_write(((errors.x[general.i][general.j])&0x000000FF));
		}
	}
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			uart_write(((errors.u[general.i][general.j])&0xFF000000)>>24);
			uart_write(((errors.u[general.i][general.j])&0x00FF0000)>>16);
			uart_write(((errors.u[general.i][general.j])&0x0000FF00)>>8);
			uart_write(((errors.u[general.i][general.j])&0x000000FF));
		}
	}
	uart_write(((errors.i)&0xFF000000)>>24);
	uart_write(((errors.i)&0x00FF0000)>>16);
	uart_write(((errors.i)&0x0000FF00)>>8);
	uart_write(((errors.i)&0x000000FF));
}

void template_set(u16 template_no)
{
	*mpu.template_A00=templates[template_no].A[0][0]; *mpu.template_A01=templates[template_no].A[0][1];
	*mpu.template_A02=templates[template_no].A[0][2]; *mpu.template_A10=templates[template_no].A[1][0];
	*mpu.template_A11=templates[template_no].A[1][1]; *mpu.template_A12=templates[template_no].A[1][2];
	*mpu.template_A20=templates[template_no].A[2][0]; *mpu.template_A21=templates[template_no].A[2][1];
	*mpu.template_A22=templates[template_no].A[2][2]; *mpu.template_B00=templates[template_no].B[0][0];

	*mpu.template_B01=templates[template_no].B[0][1]; *mpu.template_B02=templates[template_no].B[0][2];
	*mpu.template_B10=templates[template_no].B[1][0]; *mpu.template_B11=templates[template_no].B[1][1];
	*mpu.template_B12=templates[template_no].B[1][2]; *mpu.template_B20=templates[template_no].B[2][0];
	*mpu.template_B21=templates[template_no].B[2][1]; *mpu.template_B22=templates[template_no].B[2][2];

	*mpu.template_I=templates[template_no].I;

	*mpu.template_xbnd=templates[template_no].x_bnd;
	*mpu.template_ubnd=templates[template_no].u_bnd;
}

void template_send()
{
	u16 template_no;
	template_no = (uart_read()<<8);
	template_no |= uart_read();

	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			mpu.template_var=templates[template_no].A[general.i][general.j];

			uart_write((mpu.template_var&0x0000FF00)>>8);
			uart_write((mpu.template_var&0x000000FF));
		}
	}

	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			mpu.template_var=templates[template_no].B[general.i][general.j];

			uart_write((mpu.template_var&0x0000FF00)>>8);
			uart_write((mpu.template_var&0x000000FF));
		}
	}

	mpu.template_var=templates[template_no].I;
	uart_write((mpu.template_var&0x0000FF00)>>8);
	uart_write((mpu.template_var&0x000000FF));

	mpu.template_var=templates[template_no].x_bnd;
	uart_write((mpu.template_var&0x0000FF00)>>8);
	uart_write((mpu.template_var&0x000000FF));

	mpu.template_var=templates[template_no].u_bnd;
	uart_write((mpu.template_var&0x0000FF00)>>8);
	uart_write((mpu.template_var&0x000000FF));
}
