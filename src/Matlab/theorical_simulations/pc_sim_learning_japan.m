clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/1d/bin_input.png');
im_width=size(gray_im,2);
im_height=size(gray_im,1);
gray_im=imresize(gray_im,[im_height im_width],'bicubic');

u=2*gray_im-1;

%reading ideal
y_ideal=gray_read('images/1d/bin_ideal.png');
im_width=size(y_ideal,2);
im_height=size(y_ideal,1);
y_ideal=imresize(y_ideal,[im_height im_width],'bicubic');

y_ideal=2*y_ideal-1;

%cnn calculation
iter=10;
Ts=0.1;
learn_loop=1000;
learn_rate=0.1;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(0,0);
A(2,:)=abs(rand);
A(2,2)=1;
B(2,1)=abs(rand);
B(2,2)=abs(rand);
B(2,3)=abs(rand);
I=0;
x_past=0*ones(im_height,im_width);
x_new=u;
for i=1:learn_loop
    [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_past, Ts, iter, 1);
    %error calc
    
    error_map=((1/4)*(y_ideal-x_new)).^2;
    delta=learn_rate.*error_map.*x_new;
    D=sum(sum(delta))/(size(delta,1)*size(delta,2));
    
    err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
    
    A(2,1)=A(2,1)+D; A(2,3)=A(2,3)+D;
    B(2,1)=B(2,1)+D; B(2,2)=B(2,2)+D; B(2,3)=B(2,3)+D;
end

[x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_past, Ts, 2000, 1);
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