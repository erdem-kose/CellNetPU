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
template_no=0;%max:63
iter=10;
Ts=0.01;%max:31.9995 min:4.8828e-04

learn_loop=100;
learn_rate=0.01;

im_width=30;%max:128
im_height=3;%max:128
port='COM3';

%reading image
gray_im=gray_read('images/1d/bin_input.png');
gray_im=imresize(gray_im,[im_height im_width],'bicubic');
gray_im=2*gray_im-1;
x_0=0*ones(im_height,im_width);

%reading ideal
y_ideal=gray_read('images/1d/bin_ideal.png');
y_ideal=imresize(y_ideal,[im_height im_width],'bicubic');
y_ideal=2*y_ideal-1;

%computer calculation
[ A,B,I,x_bnd,u_bnd ]=cnn_template(template_no,0);
x_past=0*ones(im_height,im_width);
x_new=gray_im;
for i=1:learn_loop
    [x_new,x_cpu,x_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, gray_im, x_past, Ts, iter, 1);
    %error calc
    
    error_map=2*(((y_ideal-x_new)*(1/2)).^2);
    dir=error_map.*(x_new-x_past);
    delta=learn_rate.*dir.*x_new;
    
    D=sum(sum(delta))/(size(delta,1)*size(delta,2));
    A(2,1)=A(2,1)+D; A(2,3)=A(2,3)+D;
    B(2,1)=B(2,1)+D; B(2,3)=B(2,3)+D;
    x_past=x_new;
end

%error calculation
error_map=(((y_ideal-(2*x_cpu-1)))/2+1)/2;
delta=learn_rate.*((2*error_map-1).^2).*(2*x_cpu-1);%.*((2*x_cpu-1)-(2*x_cpu_old-1))
error_val=sum(sum(delta));

%ready uart
uart_start;

%send header
fpga_send_header(serial_obj, bus_f, im_width, im_height, Ts, iter, template_no, learn_loop, learn_rate);

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
[error_map_uart, error_val_uart]=fpga_get_error(serial_obj, bus_f, im_width, im_height);

%get template
[A_fpga,B_fpga,I_fpga,x_bnd_fpga,u_bnd_fpga] = fpga_get_template(serial_obj, bus_f);

%plot results
imshow_fpga(iter, y_uart, cnn_time, x_cpu, x_cpu_time, y_ideal,...
                            error_map, error_val, error_map_uart, error_val_uart);
