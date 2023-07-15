clc;clearvars -except serial_obj;

%degistirilebilir parametreler
iter=3;
Ts=0.1;

machine_height=128;
machine_width=128;

simulation_output='images/cnn_simulation.out';
x_simulation_time=3011620*(10^(-9)); %3011620*(10^(-9)); 128*128 image %55575480*(10^(-9)); %640*480 image

fpga_output='images/cnn_fpga.png';
x_fpga_time=69; %3011620*(10^(-9)); 128*128 image %55575480*(10^(-9)); %640*480 image
x_fpga=imread(fpga_output);
if size(fpga_output,3)==3
    x_fpga=(cast(rgb2gray(x_fpga),'double')/255);
else
    x_fpga=(cast(x_fpga,'double')/255);
end

pc_input='images/lenna.png';

%gerisini degistirme
bus_q=16;
bus_m=5;
bus_f=11;

%cpu calculation
image=imread(pc_input);
if size(image,3)==3
    image=(cast(rgb2gray(image),'double')/255);
else
    image=(cast(image,'double')/255);
end
image=imresize(image,[machine_height machine_width]);

u=image*2-1;

[A,B,I,x_bnd,u_bnd]=cnn_template(1,0);
[~,x_cpu,x_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 1);

[A,B,I,x_bnd,u_bnd]=cnn_template(1,0);
[~,x_gpu,x_gpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 0);


%%%%%%%%%%%%%%%%%%%%%
%reading fpga sim calculation
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
%%%%%%%%%%%%%%%%%%%%%
%structural similarity calculation
[ssimval, ssimmap] = ssim(x_spartan,x_cpu);
%%%%%%%%%%%%%%%%%%%%%

figure(5)
subplot(2,2,1)
imshow(x_cpu)
title(sprintf('%s, Perf=%f iter/s',winqueryreg('HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),iter/x_cpu_time))
subplot(2,2,2)
imshow(x_gpu)
title(sprintf('GTX 970 1200 MHz, Perf=%f iter/s SS=%%%f',iter/x_gpu_time,100*ssim(x_gpu,x_cpu)))
subplot(2,2,3)
imshow(x_spartan)
title(sprintf('Xilinx Spartan 6 100 MHz Simulation, Perf=%f iter/s SS=%%%f',iter/x_simulation_time,100*ssim(x_spartan,x_cpu)))
subplot(2,2,4)
imshow(x_fpga)
title(sprintf('Xilinx Spartan 6 100 MHz UART, Perf=%f impl/s SS=%%%f',1/x_fpga_time,100*ssim(x_fpga,x_cpu)))
