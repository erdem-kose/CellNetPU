#include "cnn_func.h"

extern general_struct general;
//extern cache_struct cache;
extern image_struct image;
//extern cnn_struct cnn;
extern mpu_struct mpu;
extern template_struct templates[];
extern error_struct errors;

void cnn_driver(u8 u_loc, u8 x_loc, u8 ideal_loc, u16 template_no, u16 iter_cnt, u16 Ts)
{
	command_write(CMD_CACHE_WIDTH, image.width);
	command_write(CMD_CACHE_HEIGHT, image.height);
	command_write(CMD_TS, Ts);
	command_write(CMD_ITER_CNT, iter_cnt);

	template_set(template_no);

	for (general.i=0;general.i<image.height;general.i=general.i+1)
	{
		for (general.j=0;general.j<image.width;general.j=general.j+1)
		{
    		l2cache_u_write(general.j+general.i*image.width, image.image[u_loc][general.i][general.j]);
    		l2cache_x_write(general.j+general.i*image.width, image.image[x_loc][general.i][general.j]);
    		l2cache_ideal_write(general.j+general.i*image.width, image.image[ideal_loc][general.i][general.j]);
        }
    }

	command_write(CMD_STATE_RST, (0<<1) | 1);
	command_write(CMD_STATE_RST, (0<<1) | 0);
	while (ready_read() == 0);

	for (general.i=0;general.i<image.height;general.i=general.i+1)
	{
		for (general.j=0;general.j<image.width;general.j=general.j+1)
		{
        	image.image[x_loc][general.i][general.j]=l2cache_x_read(general.j+general.i*image.width);
        }
    }
}

void template_pixel_create(u16 template_no, char loc, u32 i,u32 j, s16 val)
{
	if (val>busMax) mpu.template_var =busMax;
	else if ((val<busMin)) mpu.template_var =busMin;
	else mpu.template_var = val;

	switch(loc)
	{
		case 'A':
			templates[template_no].A[i][j]=(s32)mpu.template_var;
			break;
		case 'B':
			templates[template_no].B[i][j]=(s32)mpu.template_var;
			break;
		case 'I':
			templates[template_no].I=(s32)mpu.template_var;
			break;
		case 'x':
			templates[template_no].x_bnd=(s32)mpu.template_var;
			break;
		case 'u':
			templates[template_no].u_bnd=(s32)mpu.template_var;
			break;
		default:
			return;
	}
}

void template_create(u16 template_no)
{
	for(general.i=patchBot;general.i<=2;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=2;general.j=general.j+1)
		{
			template_pixel_create(template_no, 'A', general.i, general.j, 0);
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
			mpu.template_var=templates[template_no].A[i][j];
			break;
		case 'B':
			mpu.template_var=templates[template_no].B[i][j];
			break;
		case 'I':
			mpu.template_var=templates[template_no].I;
			break;
		case 'x':
			mpu.template_var=templates[template_no].x_bnd;
			break;
		case 'u':
			mpu.template_var=templates[template_no].u_bnd;
			break;
		default:
			return;
	}

	template_sum=(((s16)(mpu.template_var&0xFFFF))+error);
	if (template_sum>errorMax) mpu.template_var =errorMax;
	else if ((template_sum<errorMin)) mpu.template_var =errorMin;
	else mpu.template_var = (s16)template_sum;

	switch(loc)
	{
		case 'A':
			templates[template_no].A[i][j]=mpu.template_var;
			break;
		case 'B':
			templates[template_no].B[i][j]=mpu.template_var;
			break;
		case 'I':
			templates[template_no].I=mpu.template_var;
			break;
		case 'x':
			templates[template_no].x_bnd=mpu.template_var;
			break;
		case 'u':
			templates[template_no].u_bnd=mpu.template_var;
			break;
		default:
			return;
	}
}

void template_update_1d(u16 template_no)
{
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			if(general.i==1)
			{
				template_pixel_update(template_no, 'A', general.i, general.j, errors.x[general.i][general.j]);
				template_pixel_update(template_no, 'B', general.i, general.j, errors.u[general.i][general.j]);
			}
		}
	}
	template_pixel_update(template_no, 'I', 0, 0, errors.i);
	template_pixel_update(template_no, 'x', 0, 0, 0);
	template_pixel_update(template_no, 'u', 0, 0, 0);
}

void template_update_2d(u16 template_no)
{
	error_get();
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			template_pixel_update(template_no, 'A', general.i, general.j, errors.x[general.i][general.j]);
			template_pixel_update(template_no, 'B', general.i, general.j, errors.u[general.i][general.j]);
		}
	}
	template_pixel_update(template_no, 'I', 0, 0, errors.i);
	template_pixel_update(template_no, 'x', 0, 0, 0);
	template_pixel_update(template_no, 'u', 0, 0, 0);
}
