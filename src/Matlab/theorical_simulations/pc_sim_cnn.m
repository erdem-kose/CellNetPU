clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    poolsize = parpool();
else
    poolsize = p.NumWorkers;
end
p = gcp();
%reading image
gray_im=gray_read('images/others/lenna.png');
im_width=size(gray_im,2);
im_height=size(gray_im,1);
gray_im=imresize(gray_im,[im_height im_width],'bicubic');

u=2*gray_im-1;

%cnn calculation
iter=100;
Ts=0.1;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(2,0);
%[x_new,x_normal,time1] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 1);
job=parfeval(p,'cnn_system',3,A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 1);
[x_new,x_normal,time1] = fetchOutputs(job);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(12,[0 1 0; 1 1 1; 0 1 0]);
%[x_new,x_normal,time2] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, Ts, iter, 1);
job=parfeval(p,'cnn_system',3,A,B,I,x_bnd,u_bnd, x_new, 0, Ts, iter, 1);
[x_new,x_normal,time2] = fetchOutputs(job);

time1+time2

figure(2)
subplot(1,2,1)
imshow(gray_im)
title('Input')
subplot(1,2,2)
imshow(x_normal)
title('CNN')
