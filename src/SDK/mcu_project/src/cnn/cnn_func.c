#include "cnn_func.h"

extern struct general_struct general;
extern struct image_struct image;
extern struct mcs_struct mcs;

void rand_x(u8 x_loc, u8 type)
{
	*mcs.control=((1<<16) | image.width);
	*mcs.control=((2<<16) | image.height);

	*mcs.control=((10<<16) |x_loc);

	*mcs.control=((7<<16) | (1<<1) | 1);
	*mcs.control=((7<<16) | (1<<1) | 0);
	while (((*mcs.feedback)&0x00000001) == 0);
}

void cnn_fix(u8 x_loc, u8 u_loc, u8 ideal_loc, u8 error_loc, u16 template_no, u16 iter_cnt, u16 Ts)
{
	*mcs.control=((1<<16) | image.width);
	*mcs.control=((2<<16) | image.height);
	*mcs.control=((3<<16) | Ts);
	*mcs.control=((4<<16) | iter_cnt);
	*mcs.control=((5<<16) | template_no);

	*mcs.control=((10<<16) |x_loc);
	*mcs.control=((11<<16) |u_loc);
	*mcs.control=((12<<16) |ideal_loc);
	*mcs.control=((13<<16) |error_loc);

	*mcs.control=((7<<16) | (0<<1) | 1);
	*mcs.control=((7<<16) | (0<<1) | 0);
	while (((*mcs.feedback)&0x00000001) == 0);
}

void template_pixel_create(u16 template_no, char loc, u32 i,u32 j, s16 val)
{
	switch(loc)
	{
		case 'A':
			mcs.template_var = ((i*3+j+template_no*21)<<16);
			break;
		case 'B':
			mcs.template_var = ((patchSize+i*3+j+template_no*21)<<16);
			break;
		case 'I':
			mcs.template_var = ((2*patchSize+template_no*21)<<16);
			break;
		case 'x':
			mcs.template_var = ((2*patchSize+1+template_no*21)<<16);
			break;
		case 'u':
			mcs.template_var = ((2*patchSize+2+template_no*21)<<16);
			break;
		default:
			return;
	}

	if (val>busMax) mcs.template_var |=busMax;
	else if ((val<busMin)) mcs.template_var |=busMin;
	else mcs.template_var |= val;
	*mcs.template=mcs.template_var;

	*mcs.control=((9<<16) | 1);
	*mcs.control=((9<<16) | 0);
}

void template_create_1d(u16 template_no)
{
	for(general.i=patchBot;general.i<=2;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=2;general.j=general.j+1)
		{
			if((general.i==1) && (general.j!=1))
			{
				template_pixel_create(template_no, 'A', general.i, general.j, abs(((s32)*mcs.feedback)>>16));
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
				template_pixel_create(template_no, 'B', general.i, general.j, abs(((s32)*mcs.feedback)>>16));
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

void template_pixel_update(u16 template_no, char loc, u32 i,u32 j, s32 error)
{
	s16 template_val;
	s64 template_sum;
	switch(loc)
	{
		case 'A':
			mcs.template_var = ((i*3+j+template_no*21)<<16);
			break;
		case 'B':
			mcs.template_var = ((patchSize+i*3+j+template_no*21)<<16);
			break;
		case 'I':
			mcs.template_var = ((2*patchSize+template_no*21)<<16);
			break;
		case 'x':
			mcs.template_var = ((2*patchSize+1+template_no*21)<<16);
			break;
		case 'u':
			mcs.template_var = ((2*patchSize+2+template_no*21)<<16);
			break;
		default:
			return;
	}
	*mcs.template=mcs.template_var;
	template_val=((s32)*mcs.bram_temp_dataout)>>16;

	template_sum=(template_val+error);
	if (template_sum>busMax) mcs.template_var |=busMax;
	else if ((template_sum<busMin)) mcs.template_var |=busMin;
	else mcs.template_var |= (s16)template_sum;
	*mcs.template=mcs.template_var;

	*mcs.control=((9<<16) | 1);
	*mcs.control=((9<<16) | 0);
}

void template_update_1d(u16 template_no, s32 error)
{
	for(general.i=patchBot;general.i<=patchTop;general.i=general.i+1)
	{
		for(general.j=patchBot;general.j<=patchTop;general.j=general.j+1)
		{
			if((general.i==1) && (general.j!=1))
			{
					template_pixel_update(template_no, 'A', general.i, general.j, error);
					template_pixel_update(template_no, 'B', general.i, general.j, error);
			}
		}
	}
	template_pixel_update(template_no, 'I', 0, 0, 0);
	template_pixel_update(template_no, 'x', 0, 0, 0);
	template_pixel_update(template_no, 'u', 0, 0, 0);
}
