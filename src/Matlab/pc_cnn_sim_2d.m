clc;clearvars -except serial_obj;format('long');
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));

%reading image
gray_im=gray_read('images/others/lara.png');
im_width=size(gray_im,2);%max:128
im_height=size(gray_im,1);%max:128
gray_im=imresize(gray_im,[im_height im_width],'bicubic');

gray_im=im2bw(gray_im);
u=2*gray_im-1;

%ideal calculation
y_ideal=edge(gray_im,'Canny');
%cnn calculation
iter=10;
Ts=0.01;
learn_loop=1000;
learn_rate=0.01;

[ A,B_coeff,I,x_bnd,u_bnd ]=cnn_template(2,0);
B=zeros(3,3);
x_past=0*ones(im_height,im_width);
x_new=u;
for i=1:learn_loop
    [x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_past, Ts, iter, 1);
    %error calc
    
    error_map=(1/2)*((2*y_ideal-1)-x_new);
    err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
    dir=(1/2)*((2*y_ideal-1)-x_new).^2;
    delta=learn_rate.*dir.*x_new;
    
    D=sum(sum(delta))/(size(delta,1)*size(delta,2));

    B=B+B_coeff*D;
    x_past=x_new;
end

[ssimval, ssimmap] = ssim(x_normal,double(y_ideal));

figure(2)
subplot(2,2,1)
imshow(x_normal)
title('CNN')
subplot(2,2,2)
imshow(y_ideal)
title('Canny')
subplot(2,2,3)
imshow(abs(error_map))
title('Absolute Error Map')
subplot(2,2,4)
plot(err)
grid on
ylabel('% Error ');
xlabel('Iteration Count');
title(sprintf('Error=%%%f%',err(end)))