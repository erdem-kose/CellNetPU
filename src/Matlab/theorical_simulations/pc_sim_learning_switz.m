clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/1d/midpoint_input.png');
gray_im=gray_read('images/others/lenna.png');
gray_im=imresize(gray_im,[128 128],'bicubic');
u=2*(gray_im)-1;

%reading ideal
ideal=gray_read('images/1d/edge_ideal.png');
ideal=im2bw(u,graythresh(u));
ideal=2*(ideal)-1;

%cnn calculation
iter=10;
Ts=0.01;
learn_loop=1000;
learn_rate=0.1;

patch_size=3;
patch_mid=(patch_size+1)/2;
A=zeros(patch_size,patch_size);
B=zeros(patch_size,patch_size);
I=0;
x_bnd=0;
u_bnd=0;

x_new=0;

err=zeros(1,learn_loop);

for i=1:learn_loop
    [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, Ts, iter, 1);

    error_map=((1/2)*(ideal-x_new));
    
    delta=(learn_rate*error_map)/(size(error_map,1)*size(error_map,2));

    for k=1:patch_size
        for l=1:patch_size
            da=sum(sum(delta.*circshift(x_new,[patch_mid-k patch_mid-l])));
            A(k,l)=A(k,l)+da;
            db=sum(sum(delta.*circshift(u,[patch_mid-k patch_mid-l])));
            B(k,l)=B(k,l)+db;
        end
    end
    DI=sum(sum(delta));
    I=I+DI;
    
    err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));
end
[x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, 0.1, 1000, 1);

error_map=((1/2)*(ideal-x_new)).^2;
[ssimval, ssimmap] = ssim(x_new,double(ideal));

figure(2)
subplot(2,3,1)
imshow((u+1)/2)
title('Input')
subplot(2,3,2)
imshow(x_normal)
title('CNN')
subplot(2,3,3)
imshow(ideal)
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
