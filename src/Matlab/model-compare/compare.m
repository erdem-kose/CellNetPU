
clear;clc;

%degistirilebilir parametreler
iter=3;
Ts=0.1;

machine_height=128;
machine_width=128;

fpga_output='images/output128128.out';
x_spartan_time=3011620*(10^(-9)); %3011620*(10^(-9)); 128*128 image %55575480*(10^(-9)); %640*480 image

pc_input='images/lenna.png';
pc_calc_type=0;%0 for GPU, 1 for CPU, 2 for FPGA Like CPU Computing

switch pc_calc_type
   case 0
      pc_calc_type_text='GTX 970 1200 MHz';
   case 1
      pc_calc_type_text='I7 4790 3600 MHz';
   otherwise
      pc_calc_type_text='I7 4790 Spartan 6 Like 3600 MHz';
end

%gerisini degistirme
bus_q=16;
bus_m=5;
bus_f=11;

%computer calculation
image=rgb2gray(imread(pc_input));
image=imresize(image,[machine_height machine_width]);
image=(double(image)/255);

u=image*2-1;

tic;
[A,B,I,x_bnd,u_bnd]=cnn_template(1,0);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 0, pc_calc_type);
x_normal_time=toc;
%%%%%%%%%%%%%%%%%%%%%
%reading fpga sim calculation
x_spartan=zeros(machine_height,machine_width);
binary_x=0;
fileID = fopen(fpga_output,'r');
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
[ssimval, ssimmap] = ssim(x_spartan,x_normal);
%%%%%%%%%%%%%%%%%%%%%

figure(2)
subplot(2,2,1)
imshow(x_spartan)
title(sprintf('Xilinx Spartan 6 100 MHz, Performance=%f iter/s',iter/x_spartan_time))
subplot(2,2,2)
imshow(x_normal)
title(sprintf('%s, Performance=%f iter/s',pc_calc_type_text,iter/x_normal_time))
subplot(2,1,2)
imshow(ssimmap)
title(sprintf('Structural Similarity Percentage=%%%f',100*ssimval))