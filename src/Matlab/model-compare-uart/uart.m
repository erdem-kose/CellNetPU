clc;clearvars -except serial_obj; format('long');

bus_q=16;
bus_m=5;
bus_f=11;

%customizable parameters
%control register: 31:16:Ts,15:9:iter_cnt,8:3:template_no,2:cnn_rst,1:bram_we,0:template_we
template_no=0;%max:63
iter=50;%max:127
Ts= 0.01;%max:31.9995 min:4.8828e-04
Ts=double(int16(Ts*(2^bus_f)))/(2^bus_f);
image_address='images/others/lenna.png';
im_width=128;%max:128
im_height=128;%max:128

%reading image

temp_im=imread(image_address);
if size(temp_im,3)==3
    gray_im=(cast(rgb2gray(temp_im),'double')/255);
else
    gray_im=(cast(temp_im,'double')/255);
end

gray_im=imresize(gray_im,[im_height im_width],'bicubic');
gray_im=2*gray_im-1;

%computer calculation
[A,B,I,x_bnd,u_bnd]=cnn_template(1,0);
[~,x_cpu,x_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, gray_im, 0, Ts, iter, 1);

%reformat input image

x_0=0*(2^bus_f)*ones(im_height,im_width);
gray_im_fix=zeros(im_height,im_width);
for i=1:im_height
    for j=1:im_width
        gray_im_fix(i,j)=int16(gray_im(i,j)*(2^bus_f));
    end
end
y_uart=zeros(im_height,im_width);

%ready uart
port='COM3';
if exist('serial_obj','var')==0
    serial_obj = serial(port);
    serial_obj.BaudRate=921600;
    serial_obj.BytesAvailableFcnCount=2*im_width*im_height;
    serial_obj.TimerPeriod=0.01;
    serial_obj.Timeout=1.0;
    serial_obj.InputBufferSize=2*im_width*im_height;
    serial_obj.OutputBufferSize=2*im_width*im_height;
    fopen(serial_obj);
else
    fclose(serial_obj);
    serial_obj.BaudRate=921600;
    serial_obj.BytesAvailableFcnCount=2*im_width*im_height;
    serial_obj.TimerPeriod=0.01;
    serial_obj.Timeout=1.0;
    serial_obj.InputBufferSize=2*im_width*im_height;
    serial_obj.OutputBufferSize=2*im_width*im_height;
    fopen(serial_obj);
end

%send header
fwrite(serial_obj,0,'uint8');
fwrite(serial_obj,im_width,'uint8');
fwrite(serial_obj,im_height,'uint8');
fwrite(serial_obj,bitand((int16(floor((Ts*(2^bus_f))/(2^8)))),255),'uint8');
fwrite(serial_obj,bitand(int16(Ts*(2^bus_f)),255),'uint8');
fwrite(serial_obj,iter,'uint8');
fwrite(serial_obj,template_no,'uint8');

%send ideal
fwrite(serial_obj,1,'uint8');
send_buffer=zeros(1,2*im_width*im_height);
for i=1:im_height
    for j=1:im_width
        send_buffer(1,(i-1)*2*im_width+2*j-1)=bitand((int16(floor(x_0(i,j)/(2^8)))),255);
        send_buffer(1,(i-1)*2*im_width+2*j)=bitand(int16(x_0(i,j)),255);
    end
end
fwrite(serial_obj,send_buffer,'uint8');
%send image
fwrite(serial_obj,2,'uint8');
send_buffer=zeros(1,2*im_width*im_height);
for i=1:im_height
    for j=1:im_width
        send_buffer(1,(i-1)*2*im_width+2*j-1)=bitand((int16(floor(gray_im_fix(i,j)/(2^8)))),255);
        send_buffer(1,(i-1)*2*im_width+2*j)=bitand(int16(gray_im_fix(i,j)),255);
    end
end
fwrite(serial_obj,send_buffer,'uint8');
%calculate
fwrite(serial_obj,3,'uint8');
fread(serial_obj,1,'uint8');
tic;
fread(serial_obj,1,'uint8');
cnn_time=toc-(20/serial_obj.BaudRate);

%get image
fwrite(serial_obj,4,'uint8');
for i=1:im_height
    for j=1:im_width
        y_uart(i,j)=fread(serial_obj,1,'uint8')*(2^8);
        y_uart(i,j)=bitor(y_uart(i,j),fread(serial_obj,1,'uint8'));
        y_uart(i,j)=typecast(uint16(y_uart(i,j)),'int16');
        y_uart(i,j)=((y_uart(i,j)/(2^bus_f))+1)/2;
    end
end
[ss_val,ss_map]=ssim(y_uart,x_cpu);
figure(1)
subplot(1,3,1)
imshow(x_cpu)%x_cpu)
title(sprintf('%s, Perf=%f iter/s',winqueryreg('HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),iter/x_cpu_time))
subplot(1,3,2)
imshow(y_uart)
title(sprintf('Xilinx Spartan 6 100 MHz UART, Perf=%f iter/s',iter/cnn_time))
ax3=subplot(1,3,3);
imshow(ss_map)
colormap(ax3,hot)
title(sprintf('Structural Similarity Map, SS Ratio=%%%f',100*ss_val))