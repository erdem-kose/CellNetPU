clc;clearvars -except serial_obj;
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));
%degistirilebilir parametreler
bus_m=6;
bus_f=10;
bus_q=bus_m+bus_f;

iter=200;
Ts=0.01;

machine_height=16;
machine_width=16;

%gerisini degistirme

%cpu calculation
pc_input='images/others/lenna.png';
image=gray_read(pc_input);
image=imresize(image,[machine_height machine_width]);

u=image*2-1;

[A,B,I,x_bnd,u_bnd]=cnn_template(2,0);
[~,x_cpu,x_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 'cpu');

[A,B,I,x_bnd,u_bnd]=cnn_template(2,0);
[~,x_gpu,x_gpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 'gpu');

ideal=edge(u,'canny');
ideal=2*ideal-1;

%reading fpga sim calculation
simulation_output='images/cnn_simulation.out';
x_spartan=zeros(machine_height,machine_width);
binary_x=0;
fileID = fopen(simulation_output,'r');
for i=1:size(image,1)
    for j=1:size(image,2)
        binary_x=fgetl(fileID);
        if(binary_x(1)=='0')
            x_spartan(i,j)=bin2dec(binary_x(2:end));
        else
            x_spartan(i,j)=bin2dec(binary_x(2:end))-2^(length(binary_x)-1);
        end
        x_spartan(i,j)=x_spartan(i,j)/(2^bus_f);
        x_spartan(i,j)=(x_spartan(i,j)+1)/2;
    end
end
fclose(fileID);

figure(5)
subplot(2,2,1)
imshow(x_cpu)
title(sprintf('%s, Perf=%f iter/s',winqueryreg('HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),iter/x_cpu_time))
subplot(2,2,2)
imshow(x_gpu)
title(sprintf('GTX 970 1200 MHz, Perf=%f iter/s SS=%%%f',iter/x_gpu_time,100*ssim(x_gpu,x_cpu)))
subplot(2,2,3)
imshow(x_spartan)
title(sprintf('Xilinx Spartan 6 100 MHz Simulation\nSS=%%%f',100*ssim(x_spartan,x_cpu)))
subplot(2,2,4)
imshow(ideal)
title(sprintf('Ideal Canny Image\nSS=%%%f',100*ssim(ideal,x_cpu)))
