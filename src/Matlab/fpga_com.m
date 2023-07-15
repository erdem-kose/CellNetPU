clc;clearvars -except serial_obj; format('long');
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));

% IEEE 754 half-precision binary floating-point format: binary16[edit]
% The IEEE 754 standard specifies a binary16 as having the following format:
% 
% Sign bit: 1 bit
% Exponent width: 5 bits
% Significand precision: 11 bits (10 explicitly stored)

bus_m=6;
bus_f=10;
bus_q=bus_m+bus_f;

%customizable parameters
template_no=2;%max:63
iter=80;
Ts=0.1;%max:31.9995 min:4.8828e-04
image_address='images/others/lara.png';
im_width=128;%max:128
im_height=128;%max:128
port='COM3';

%reading image
gray_im=gray_read(image_address);
gray_im=imresize(gray_im,[im_height im_width],'bicubic');
gray_im=2*gray_im-1;
x_0=0*ones(im_height,im_width);

%computer calculation
[A,B,I,x_bnd,u_bnd]=cnn_template(template_no,0);
[~,x_cpu,x_cpu_time]=cnn_system( A,B,I,x_bnd,u_bnd, gray_im, 0, Ts, iter, 1);

%ideal calculation
y_ideal=2*double(edge(gray_im,'Canny_old'))-1;

%error calculation
error_map=(((y_ideal-(2*x_cpu-1)))/2+1)/2;
error_norm_val=fix(sum(sum((error_map*2)-1)));
error_squa_val=fix(sum(sum(2*((error_map*2)-1).*((error_map*2)-1))));

%ready uart
uart_start;

%send header
fpga_send_header(serial_obj, bus_f, im_width, im_height, Ts, iter, template_no);

% send x_0
fpga_send_image(serial_obj, bus_f, 'x_0', x_0, im_width, im_height);

%send image
fpga_send_image(serial_obj, bus_f, 'u', gray_im, im_width, im_height);

%send ideal
fpga_send_image(serial_obj, bus_f, 'y_ideal', y_ideal, im_width, im_height);

%calculate
cnn_time=fpga_calculate(serial_obj);

%get image
y_uart=fpga_get_image(serial_obj, bus_f, im_width, im_height);

%get error
[error_map_uart, error_norm_val_uart, error_squa_val_uart]=fpga_get_error(serial_obj, bus_f, im_width, im_height);

%plot results
imshow_fpga(iter, y_uart, cnn_time, x_cpu, x_cpu_time, y_ideal,...
                            error_map, error_norm_val, error_squa_val, error_map_uart,...
                                error_norm_val_uart, error_squa_val_uart);
