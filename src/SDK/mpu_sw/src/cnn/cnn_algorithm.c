#include "cnn_algorithm.h"

extern general_struct general;
extern image_struct image;
extern cnn_struct cnn;

void algorithm1()//direct cnn
{
	write_uart(4);
	/* for random x0*/
	//rand_x(image.x_base);


	cnn_fix(image.x_base, image.u_base, image.ideal_base, image.error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);

	write_uart(4);
}

void algorithm2()//one stage 1d learning-nagakawa
{
	write_uart(4);

	write_control(6, cnn.learn_rate);
	template_create_1d_nagakawa(cnn.template_no);

	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		cnn_fix(image.x_base, image.u_base, image.ideal_base, image.error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);

		//calculate template
		template_update_1d_nagakawa(cnn.template_no);
		general.k=general.k+1;
	}

	write_uart(4);
}

void algorithm3()//decomposition 1d learning-nagakawa
{
	write_uart(4);

	write_control(6, cnn.learn_rate);
	template_create_1d_nagakawa(0);
	template_create_1d_nagakawa(1);
	template_create_1d_nagakawa(2);
	template_create_1d_nagakawa(3);

	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		//cnn_fix(x_base, u_base, ideal_base, error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);
		cnn_fix(0, 1, 2, 3, 0, cnn.iter_cnt, cnn.Ts);
		cnn_fix(0, 1, 2, 4, 1, cnn.iter_cnt, cnn.Ts);
		cnn_fix(0, 1, 2, 5, 2, cnn.iter_cnt, cnn.Ts);
		cnn_fix(0, 1, 2, 6, 3, cnn.iter_cnt, cnn.Ts);

		//calculate template
		template_update_1d_nagakawa(0);
		template_update_1d_nagakawa(1);
		template_update_1d_nagakawa(2);
		template_update_1d_nagakawa(3);
		general.k=general.k+1;
	}
	image.error_base=6;

	write_uart(4);
}

void algorithm4()//real 1d learning
{
	write_uart(4);

	write_control(6, cnn.learn_rate);
	template_create_1d(0);

	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		//cnn_fix(x_base, u_base, ideal_base, error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);
		cnn_fix(0, 1, 2, 3, 0, cnn.iter_cnt, cnn.Ts);

		//calculate template
		template_update_1d(0);
		general.k=general.k+1;
	}

	write_uart(4);
}
