clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/1d/leftpoint_input.png');
im_width=size(gray_im,2);
im_height=size(gray_im,1);
gray_im=imresize(gray_im,[im_height im_width],'bicubic');

u=2*gray_im-1;

%reading ideal
y_ideal=gray_read('images/1d/edge_ideal.png');
im_width=size(y_ideal,2);
im_height=size(y_ideal,1);
y_ideal=imresize(y_ideal,[im_height im_width],'bicubic');

y_ideal=2*y_ideal-1;

%cnn calculation
iter=10;
Ts=0.01;
learn_loop=1000;
learn_rate=0.01;

A=[0 0 0;0 1 0;0 0 0];
B=[0 0 0;0 0 0;0 0 0];
I=0;
x_bnd=0;
u_bnd=0;

x_new=0;

for i=1:learn_loop
    [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, Ts, iter, 1);

    error_map=((1/2)*(y_ideal-x_new));
    
    delta=learn_rate*error_map.*circshift(x_new,[0 -1]);
    DA1=sum(sum(delta))/(size(delta,1)*size(delta,2));
    delta=learn_rate*error_map.*x_new;
    DA2=sum(sum(delta))/(size(delta,1)*size(delta,2));
    delta=learn_rate*error_map.*circshift(x_new,[0 1]);
    DA3=sum(sum(delta))/(size(delta,1)*size(delta,2));
    
    delta=learn_rate*error_map.*circshift(u,[0 -1]);
    DB1=sum(sum(delta))/(size(delta,1)*size(delta,2));
    delta=learn_rate*error_map.*u;
    DB2=sum(sum(delta))/(size(delta,1)*size(delta,2));
    delta=learn_rate*error_map.*circshift(u,[0 1]);
    DB3=sum(sum(delta))/(size(delta,1)*size(delta,2));
    
    delta=learn_rate*error_map;
    DI=sum(sum(delta))/(size(delta,1)*size(delta,2));
    
    err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
    
    A(2,1)=A(2,1)+DA1; A(2,3)=A(2,3)+DA3;
    B(2,1)=B(2,1)+DB1; B(2,2)=B(2,2)+DB2; B(2,3)=B(2,3)+DB3;
    I=I+DI;
end

[x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, 10000, 1);
error_map=((1/2)*(y_ideal-x_new)).^2;
[ssimval, ssimmap] = ssim(x_normal,double(y_ideal));

figure(2)
subplot(2,3,1)
imshow(u)
title('Input')
subplot(2,3,2)
imshow(x_normal)
title('CNN')
subplot(2,3,3)
imshow(y_ideal)
title('Ideal')
subplot(2,2,3)
imshow(abs(error_map))
title('Absolute Error Map')
subplot(2,2,4)
plot(err)
grid on
ylabel('% Error ');
xlabel('Learning Count');
title(sprintf('Error=%%%f%',err(end)))
