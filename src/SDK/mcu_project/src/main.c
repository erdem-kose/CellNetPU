#include "sys/sys_init.h"
#include "sys/sys_func.h"
#include "cnn/cnn_algorithm.h"

extern struct image_struct image;
extern struct cnn_struct cnn;

int main()
{
	init_system();

	u8 cmd=0;
	while (1)
	{
		cmd=read_uart();
		switch(cmd)
		{
			case 0://Header kismi
				read_header();
				break;
			case 1://Durum goruntusunu alma
				read_image(image.x_base);
				break;
			case 2://Giris goruntusunu alma
				read_image(image.u_base);
				break;
			case 3://Ideal goruntuyu alma
				read_image(image.ideal_base);
				break;
			case 4://Hesaplama-Algoritma burada olacak
				algorithm2();
				break;
			case 5://Durum goruntusunu yollama
				send_image(image.x_base);
				break;
			case 6://Hata goruntusunu yollama
				send_image(image.error_base);
				break;
			case 7://Hata degerini yollama
				send_error_sum();
				break;
			case 8://Hata degerini yollama
				send_template(cnn.template_no);
				break;
			default:
				break;
		}
	}

	disable_caches();
	return 0;


}
