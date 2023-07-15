clc;clearvars -except serial_obj; format('long');
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));
addpath(genpath('func_algorithm'));

%customizable parameters
%cnn=cnn_class(template_no, iter, Ts, learn_loop, learn_rate);
cnn_commands=cnn_class(2, 25, 0.1, 30, 0.1);
alg_no=2;
if alg_no==1 || alg_no==2 || alg_no==5
    im_width=128;%max:128
    im_height=128;%max:128
    input_address='images/others/lenna.png';
    ideal_address='images/others/lenna.png';
else
    im_width=30;%max:128
    im_height=3;%max:128
    input_address='images/1d/midpoint_input.png';
    ideal_address='images/1d/midpoint_ideal.png';
end
%reading image
u=gray_read(input_address);
u=imresize(u,[im_height im_width],'bicubic');
if alg_no==5
    u=imnoise(u,'gaussian',0,0.025);
end
gray_im=2*u-1;
x_0=0*ones(im_height,im_width);

if alg_no==1 || alg_no==2
    ideal=0*u;
elseif alg_no==5
    ideal=wiener2(u,[3 3]);
    ideal=2*ideal-1;
else
    ideal=gray_read(ideal_address);
    ideal=imresize(ideal,[im_height im_width],'bicubic');
    ideal=2*ideal-1;
end

%computer calculation
[ x_cpu, error_val, cpu_time ] = pc_run_algorithm(cnn_commands, x_0, gray_im, ideal, alg_no );

%fpga calculation
port='COM3';
uart_start;
[ y_uart, error_val_uart, cnn_time] = fpga_run_algorithm( serial_obj, cnn_commands, x_0, gray_im, ideal, alg_no);
[A,B,I,x_bnd,u_bnd] = fpga_get_template(serial_obj, cnn_commands.bus_f, cnn_commands.template_no);

%plot results
imshow_fpga((gray_im+1)/2, cnn_commands.iter, y_uart, cnn_time, x_cpu, cpu_time, ideal,...
                            error_val(1,1,3), error_val_uart(1,1,3));
