#include "sys/sys_init.h"
#include "sys/sys_func.h"
#include "cnn/cnn_algorithm.h"

//extern general_struct general;
//extern cache_struct cache;
//extern image_struct image;
//extern cnn_struct cnn;
//extern mpu_struct mpu;
//extern template_struct templates[];
//extern error_struct errors;

int main()
{
	init_system();

	u8 cmd;
	while (1)
	{
		cmd=uart_read();
		switch(cmd)
		{
			case 0://Header kismi
				header_read();
				break;
			case 1://Goruntu alma
				image_read();
				break;
			case 2://Algoritma calistirma
				algorithm_run();
				break;
			case 3://Goruntu yollama
				image_send();
				break;
			case 4://Hata degerini yollama
				error_send();
				break;
			case 5://Hata degerini yollama
				template_send();
				break;
			default:
				break;
		}
	}

	ddr2_caches_disable();
	return 0;


}
