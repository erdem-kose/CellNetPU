#include "cnn_init.h"
#include "cnn_func.h"
#include "cnn_algorithm.h"

extern u8 x_base, u_base, ideal_base, error_base;

int main()
{
	init_platform();
	init_system();

	u8 cmd=0;
	while (1)
	{
		cmd=wait_for_cmd();
		switch(cmd)
		{
			case 0://Header kismi
				read_header();
				break;
			case 1://Durum goruntusunu alma
				read_image(x_base);
				break;
			case 2://Giris goruntusunu alma
				read_image(u_base);
				break;
			case 3://Ideal goruntuyu alma
				read_image(ideal_base);
				break;
			case 4://Hesaplama-Algoritma burada olacak
				algorithm();
				break;
			case 5://Durum goruntusunu yollama
				send_image(x_base);
				break;
			case 6://Hata goruntusunu yollama
				send_image(error_base);
				break;
			case 7://Hata degerini yollama
				send_error_sum(0);
				break;
			case 8://Hata degerini yollama
				send_error_sum(1);
				break;
			default:
				break;
		}
	}

	cleanup_platform();
	return 0;


}
