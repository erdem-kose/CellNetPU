#include "cnn_algorithm.h"

extern general_struct general;
//extern cache_struct cache;
//extern image_struct image;
extern cnn_struct cnn;
//extern mpu_struct mpu;
//extern template_struct templates[];
//extern error_struct errors;

void algorithm_run()
{
	u8 cmd;
	cmd=uart_read();
	switch(cmd)
	{
		case 1:
			algorithm1();
			break;
		case 2:
			algorithm2();
			break;
		case 3:
			algorithm3();
			break;
		case 4:
			algorithm4();
			break;
		case 5:
			algorithm5();
			break;
		default:
			break;
	}
}

void algorithm1()//direct cnn
{
	uart_write(2);

	cnn_driver(0, 1, 2, cnn.template_no, cnn.iter_cnt, cnn.Ts);
	uart_write(2);
}

void algorithm2()//cnn-algorithm
{
	uart_write(2);

	image_fill(1, 0);
	cnn_driver(0, 1, 2, 2, 100, 0.1*busFMax);
	image_fill(3, 0);
	cnn_driver(1, 3, 2, 12, 1, 1*busFMax);
	image_fill(4, 0);
	cnn_driver(3, 4, 2, 8, 1, 1*busFMax);
	cnn_driver(4, 1, 2, 4, 1, 1*busFMax);
	uart_write(2);
}

void algorithm3()//1d learning
{
	uart_write(2);
	template_create(1);

	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		//cnn_driver(u_base, x_base, ideal_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);
		cnn_driver(0, 1, 2, 1, cnn.iter_cnt, cnn.Ts);

		//calculate template
		error_get();
		template_update_1d(1);
		general.k=general.k+1;
	}

	uart_write(2);
}

void algorithm4()//1d multilayer learning
{
	uart_write(2);
	template_create(1);
	template_create(2);
	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		//cnn_driver(x_base, u_base, ideal_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);
		cnn_driver(0, 1, 2, 1, cnn.iter_cnt, cnn.Ts);

		//calculate template
		error_get();
		template_update_1d(1);

		cnn_driver(0, 1, 2, 2, cnn.iter_cnt, cnn.Ts);

		//calculate template
		//error_get();
		template_update_1d(2);

		general.k=general.k+1;
	}

	uart_write(2);
}

void algorithm5()//2d learning
{
	uart_write(2);
	template_create(1);

	//start learning loop
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		//cnn_driver(x_base, u_base, ideal_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);
		cnn_driver(0, 1, 2, 1, cnn.iter_cnt, cnn.Ts);

		//calculate template
		error_get();
		template_update_2d(1);
		general.k=general.k+1;
	}

	uart_write(2);
}


