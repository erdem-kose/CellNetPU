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
iter=100;
Ts=0.1;
learn_loop=500;
learn_rate=0.1;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(0,0);
A(2,:)=abs(rand);
A(2,2)=1;
B(2,1)=abs(rand);
B(2,2)=abs(rand);
B(2,3)=abs(rand);
I=0;

for i=1:learn_loop
    x_past=0;
    [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_past, Ts, iter, 'cpu');
    %error calc
    
    error_map=((1/2)*(y_ideal-x_new)).^2;
    delta=learn_rate.*error_map.*x_new;
    D=sum(sum(delta))/(size(delta,1)*size(delta,2));
    
    err_japan(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
    
    A(2,1)=A(2,1)+D; A(2,3)=A(2,3)+D;
    B(2,1)=B(2,1)+D; B(2,2)=B(2,2)+D; B(2,3)=B(2,3)+D;
end

[~,x_normal_japan,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_past, Ts, iter, 'cpu');

A=zeros(3,3);
B=zeros(3,3);
I=0;
x_bnd=0;
u_bnd=0;

cpu_time=0;
for i=1:learn_loop
    x_new=0;
    [x_new,~,cpu_time_temp] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, Ts, iter, 'cpu');
    cpu_time=cpu_time+cpu_time_temp;
    tic;
    error_map=((1/2)*(y_ideal-x_new));
    
    delta=(learn_rate*error_map)/(size(error_map,1)*size(error_map,2));
    
    for k=1:3
        for l=1:3
            da=sum(sum(delta.*circshift(x_new,[2-k 2-l])));
            A(k,l)=A(k,l)+da;
            db=sum(sum(delta.*circshift(u,[2-k 2-l])));
            B(k,l)=B(k,l)+db;
        end
    end
    DI=sum(sum(delta));
    I=I+DI;
    
    err_switz(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));

    cpu_time=cpu_time+toc;
end
[x_new,x_normal_switz,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, Ts, iter, 'cpu');

[ssimval, ssimmap] = ssim(x_normal_japan,x_normal_switz);

figure(2)
subplot(2,3,1)
imshow(x_normal_japan)
title('CNN Japan')
subplot(2,3,2)
imshow(x_normal_switz)
title('CNN Switz')
subplot(2,3,3)
imshow(y_ideal)
title('Ideal')
subplot(2,2,3)
imshow(abs(ssimmap))
title('Structural Similarity Map')
subplot(2,2,4)
plot(err_japan)
hold on
plot(err_switz)
grid on
ylabel('% Error ');
xlabel('Learning Count');