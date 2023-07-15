clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/1d/midpoint_input.png');
% gray_im=im2bw(gray_read('images/others/lara.png'));
% gray_im=imresize(gray_im,[128 128],'bicubic');
u=2*(gray_im)-1;

%reading ideal
ideal=gray_read('images/1d/midpoint_ideal.png');
% ideal=edge(gray_im,'canny');
ideal=2*(ideal)-1;

%cnn calculation
iter=1;
Ts=0.2;
learn_loop=2000;
learn_rate=0.1;

patch_size=3;
patch_mid=(patch_size+1)/2;
A=zeros(patch_size,patch_size,5);
B=zeros(patch_size,patch_size,5);
I=zeros(1,5);
x_bnd=0;
u_bnd=0;

x=zeros(size(u,1),size(u,2),5);

delta=0*u;
error_map=0*u;
da=zeros(patch_size,patch_size);
db=zeros(patch_size,patch_size);

err=zeros(1,learn_loop);

for i=1:learn_loop
%kademe 1
    [x(:,:,1),~,~] = cnn_system( A(:,:,1),B(:,:,1),I(1),x_bnd,u_bnd, u, x(:,:,2), Ts, iter, 1);
    
    for k=1:patch_size
        for l=1:patch_size
            delta_a=learn_rate*cnn_system( A(:,:,2),0,0,x_bnd,0, delta, delta, 1, 1, 1)/(size(delta,1)*size(delta,2));
            da(k,l)=sum(sum(delta_a.*circshift(x(:,:,1),[patch_mid-k patch_mid-l])));
            A(k,l,1)=A(k,l,1)+da(k,l);
            
            delta_b=learn_rate*cnn_system( B(:,:,2),0,0,x_bnd,0, delta, delta, 1, 1, 1)/(size(delta,1)*size(delta,2));
            db(k,l)=sum(sum(delta_b.*circshift(u,[patch_mid-k patch_mid-l])));
            B(k,l,1)=B(k,l,1)+db(k,l);
        end
    end
    delta_i=learn_rate*I(2)*delta/(size(delta,1)*size(delta,2));
    di=sum(sum(delta_i));
    I(1)=I(1)+di;
    
%kademe 2
    [x(:,:,2),~,~] = cnn_system( A(:,:,2),B(:,:,2),I(2),x_bnd,u_bnd, u, x(:,:,1), Ts, iter, 1);

    error_map=(1/2)*(ideal-x(:,:,2));
    
    delta=(learn_rate*error_map)/(size(error_map,1)*size(error_map,2));

    for k=1:patch_size
        for l=1:patch_size
            da(k,l)=sum(sum(delta.*circshift(x(:,:,2),[patch_mid-k patch_mid-l])));
            A(k,l,2)=A(k,l,2)+da(k,l);
            
            db(k,l)=sum(sum(delta.*circshift(u,[patch_mid-k patch_mid-l])));
            B(k,l,2)=B(k,l,2)+db(k,l);
        end
    end
    di=sum(sum(delta));
    I(2)=I(2)+di;
    
    err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
    
end
x=zeros(size(u,1),size(u,2),5);
for i=1:learn_loop
    [x(:,:,1),~,~] = cnn_system( A(:,:,1),B(:,:,1),I(1),x_bnd,u_bnd, u, x(:,:,2), Ts, iter, 1);
    [x(:,:,2),x_normal,~] = cnn_system( A(:,:,2),B(:,:,2),I(2),x_bnd,u_bnd, u, x(:,:,1), Ts, iter, 1);
end
error_map=((1/2)*(ideal-x(:,:,2))).^2;
[ssimval, ssimmap] = ssim(x(:,:,2),double(ideal));

figure(2)
subplot(2,3,1)
imshow((u+1)/2)
title('Input')
subplot(2,3,2)
imshow(x_normal)
title('CNN')
subplot(2,3,3)
imshow((ideal+1)/2)
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

