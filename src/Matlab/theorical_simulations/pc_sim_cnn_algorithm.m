clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/others/lenna.png');
im_width=64;
im_height=64;
gray_im=imresize(gray_im,[im_height im_width],'bicubic');
u=2*gray_im-1;

%cnn calculation

x_new=u*0;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(2,0);
[x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, 0.1, 100, 'cpu');
[ A,B,I,x_bnd,u_bnd ]=cnn_template(12,[0 1 0; 1 1 1; 0 1 0]);
[x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, 1, 1, 'cpu');
[ A,B,I,x_bnd,u_bnd ]=cnn_template(8,0);
[x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, 1, 1, 'cpu');

figure(2)
subplot(1,2,1)
imshow(gray_im)
title('Input')
subplot(1,2,2)
imshow(x_normal)
title('CNN')