#include "cnn_algorithm.h"

extern struct general_struct general;
extern struct image_struct image;
extern struct cnn_struct cnn;
extern struct mcs_struct mcs;

void algorithm1()
{
	write_uart(4);
	/* for noisy x0
	rand_x(image.x_base);
	 */

	cnn_fix(image.x_base, image.u_base, image.ideal_base, image.error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);

	write_uart(4);
}

void algorithm2()
{
	write_uart(4);

	//start learning loop
	*mcs.control=((6<<16) | cnn.learn_rate);
	template_create_1d(cnn.template_no);
	general.k=0;
	while(general.k<cnn.learn_loop)
	{
		//start calculation
		cnn_fix(image.x_base, image.u_base, image.ideal_base, image.error_base, cnn.template_no, cnn.iter_cnt, cnn.Ts);

		//calculate template
		template_update_1d(cnn.template_no,((s32)*mcs.errorval)/image.shift);
		general.k=general.k+1;
	}
	write_uart(4);
}
