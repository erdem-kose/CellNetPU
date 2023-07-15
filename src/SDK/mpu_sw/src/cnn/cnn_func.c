#include "cnn_func.h"

extern general_struct general;
extern image_struct image;
extern mpu_struct mpu;

void rand_x(u8 x_loc)
{
	write_control(1, image.width);
	write_control(2, image.height);

	write_control(10, x_loc);

	write_control(7, (1<<1) | 1);
	write_control(7, (1<<1) | 0);

	while (read_ready() == 0);
}

void cnn_fix(u8 x_loc, u8 u_loc, u8 ideal_loc, u8 error_loc, u16 template_no, u16 iter_cnt, u16 Ts)
{
	write_control(1, image.width);
	write_control(2, image.height);
	write_control(3, Ts);
	write_control(4, iter_cnt);
	write_control(5, template_no);

	write_control(10, x_loc);
	write_control(11, u_loc);
	write_control(12, ideal_loc);
	write_control(13, error_loc);

	write_control(7, (0<<1) | 1);
	write_control(7, (0<<1) | 0);
	while (read_ready() == 0);
}

void template_pixel_create(u16 template_no, char loc, u32 i,u32 j, s16 val)
{
	if (val>busMax) mpu.template_var =busMax;
	else if ((val<busMin)) mpu.template_var =busMin;
	else mpu.template_var = val;

	switch(loc)
	{
		case 'A':
			write_template_bram((i*3+j+template_no*21), mpu.template_var);
			break;
		case 'B':
			write_template_bram((patchSize+i*3+j+template_no*21), mpu.template_var);
			break;
		case 'I':
			write_template_bram((2*patchSize+template_no*21), mpu.template_var);
			break;
		case 'x':
			write_template_bram((2*patchSize+1+template_no*21), mpu.template_var);
			break;
		case 'u':
			write_template_bram((2*patchSize+2+template_no*21), mpu.template_var);
			break;
		default:
			return;
	}
}

void template_create_1d_nagakawa(u16 template_no)
{
	for(general.i=patchBot;general.i<=2;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=2;general.j=general.j+1)
		{
			if((general.i==1) && (general.j!=1))
			{
				template_pixel_create(template_no, 'A', general.i, general.j, abs(read_rand_num()));
			}
			else if ((general.i==1) && (general.j==1))
			{
				template_pixel_create(template_no, 'A', general.i, general.j, ALUBorderTop);
			}
			else
			{
				template_pixel_create(template_no, 'A', general.i, general.j, 0);
			}
			if(general.i==1)
			{
				template_pixel_create(template_no, 'B', general.i, general.j, abs(read_rand_num()));
			}
			else
			{
				template_pixel_create(template_no, 'B', general.i, general.j, 0);
			}
		}
	}
	template_pixel_create(template_no, 'I', 0, 0, 0);
	template_pixel_create(template_no, 'x', 0, 0, 0);
	template_pixel_create(template_no, 'u', 0, 0, 0);
}

void template_create_1d(u16 template_no)
{
	for(general.i=patchBot;general.i<=2;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=2;general.j=general.j+1)
		{
			if((general.i==1) && (general.j==1))
			{
				template_pixel_create(template_no, 'A', general.i, general.j, ALUBorderTop);
			}
			else
			{
				template_pixel_create(template_no, 'A', general.i, general.j, 0);
			}
			template_pixel_create(template_no, 'B', general.i, general.j, 0);
		}
	}
	template_pixel_create(template_no, 'I', 0, 0, 0);
	template_pixel_create(template_no, 'x', 0, 0, 0);
	template_pixel_create(template_no, 'u', 0, 0, 0);
}

void template_pixel_update(u16 template_no, char loc, u32 i,u32 j, s32 error)
{
	s64 template_sum;

	switch(loc)
	{
		case 'A':
			mpu.template_var=read_template_bram(i*3+j+template_no*21);
			break;
		case 'B':
			mpu.template_var=read_template_bram(patchSize+i*3+j+template_no*21);
			break;
		case 'I':
			mpu.template_var=read_template_bram(2*patchSize+template_no*21);
			break;
		case 'x':
			mpu.template_var=read_template_bram(2*patchSize+1+template_no*21);
			break;
		case 'u':
			mpu.template_var=read_template_bram(2*patchSize+2+template_no*21);
			break;
		default:
			return;
	}

	template_sum=(((s16)(mpu.template_var&0xFFFF))+error);
	if (template_sum>busMax) mpu.template_var =busMax;
	else if ((template_sum<busMin)) mpu.template_var =busMin;
	else mpu.template_var = (s16)template_sum;

	switch(loc)
	{
		case 'A':
			write_template_bram((i*3+j+template_no*21), mpu.template_var);
			break;
		case 'B':
			write_template_bram((patchSize+i*3+j+template_no*21), mpu.template_var);
			break;
		case 'I':
			write_template_bram((2*patchSize+template_no*21), mpu.template_var);
			break;
		case 'x':
			write_template_bram((2*patchSize+1+template_no*21), mpu.template_var);
			break;
		case 'u':
			write_template_bram((2*patchSize+2+template_no*21), mpu.template_var);
			break;
		default:
			return;
	}
}

void template_update_1d_nagakawa(u16 template_no)
{
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			if((general.i==1) && (general.j!=1))
			{
					template_pixel_update(template_no, 'A', general.i, general.j, read_error('I', 0, 0));
					template_pixel_update(template_no, 'B', general.i, general.j, read_error('I', 0, 0));
			}
		}
	}
	template_pixel_update(template_no, 'I', 0, 0, read_error('I',0,0));
	template_pixel_update(template_no, 'x', 0, 0, 0);
	template_pixel_update(template_no, 'u', 0, 0, 0);
}

void template_update_1d(u16 template_no)
{
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			if((general.i==1) && (general.j!=1))
			{
					template_pixel_update(template_no, 'A', general.i, general.j, read_error('x',general.i,general.j));
			}
			if(general.i==1)
			{
					template_pixel_update(template_no, 'B', general.i, general.j, read_error('u',general.i,general.j));
			}
		}
	}
	template_pixel_update(template_no, 'I', 0, 0, read_error('I',0,0));
	template_pixel_update(template_no, 'x', 0, 0, 0);
	template_pixel_update(template_no, 'u', 0, 0, 0);
}
