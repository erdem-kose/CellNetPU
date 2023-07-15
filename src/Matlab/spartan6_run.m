clc;clearvars -except serial_obj; format('long');
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));
addpath(genpath('func_algorithm'));

%customizable parameters
%cnn=cnn_class(template_no, iter, Ts, learn_loop, learn_rate);
cnn_commands=cnn_class(0, 200, 0.01, 100, 0.01);
alg_no=4;
% im_width=16;%max:128
% im_height=16;%max:128
% input_address='images/others/lenna.png';
% ideal_address='images/others/lenna.png';
im_width=30;%max:128
im_height=3;%max:128
input_address='images/1d/edge_input.png';
ideal_address='images/1d/leftpoint_ideal.png';

%reading image
gray_im=gray_read(input_address);
gray_im=imresize(gray_im,[im_height im_width],'bicubic');
gray_im=2*gray_im-1;
x_0=0*ones(im_height,im_width);

%reading ideal
ideal=gray_read(ideal_address);
ideal=imresize(ideal,[im_height im_width],'bicubic');
%ideal=edge(gray_im,'canny');
ideal=2*ideal-1;

%computer calculation
[ x_cpu, error_val, error_map, cpu_time ] = pc_run_algorithm(cnn_commands, x_0, gray_im, ideal, alg_no );

%fpga calculation
port='COM3';
uart_start;
[ y_uart, error_val_uart, error_map_uart, cnn_time] = fpga_run_algorithm( serial_obj, cnn_commands, x_0, gray_im, ideal, alg_no);
[A,B,I,x_bnd,u_bnd] = fpga_get_template(serial_obj, cnn_commands.bus_f, cnn_commands.template_no);

%plot results
imshow_fpga((gray_im+1)/2, cnn_commands.iter, y_uart, cnn_time, x_cpu, cpu_time, ideal,...
                            error_map, error_val(1,1,3), error_map_uart, error_val_uart(1,1,3));
