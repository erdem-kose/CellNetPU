clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%reading image
gray_im=gray_read('images/1d/midpoint_input.png');
u=2*(gray_im)-1;

%reading ideal
ideal=gray_read('images/1d/midpoint_ideal.png');
ideal=2*(ideal)-1;

%cnn calculation
iter=10;
Ts=0.1;
learn_loop=1000;
learn_rate=0.1;

patch_size=3;
patch_mid=(patch_size+1)/2;
A1=zeros(patch_size,patch_size);
B1=zeros(patch_size,patch_size);
I1=zeros(1,1);
A2=zeros(patch_size,patch_size);
B2=zeros(patch_size,patch_size);
I2=zeros(1,1);
x_bnd=0;
u_bnd=0;

err=zeros(1,learn_loop);
learnProg=waitbar(0,'Learn Progress');
for i=1:learn_loop
    %layer 1
    [x_1,~,~,x_1_diff] = cnn_system( A1,B1,I1,x_bnd,u_bnd, u, 0, Ts, iter, 'cpu');
    %layer 2
    [x_2,~,~,x_2_diff] = cnn_system( A2,B2,I2,x_bnd,u_bnd, x_1, 0, Ts, iter, 'cpu');

    %learn layer 2 because of backpropagation
    error_map2=(ideal-x_2);
    dirac2=-error_map2.*x_2_diff;
    
    delta2=(-learn_rate*dirac2)/(size(dirac2,1)*size(dirac2,2));

    for k=1:patch_size
        for l=1:patch_size
            da2=sum(sum(delta2.*circshift(x_2,[patch_mid-k patch_mid-l])));
            A2(k,l)=A2(k,l)+da2;
            db2=sum(sum(delta2.*circshift(x_1,[patch_mid-k patch_mid-l])));
            B2(k,l)=B2(k,l)+db2;
        end
    end
    di2=sum(sum(delta2));
    I2=I2+di2;

    %learn layer 1
    dirac1=imfilter(dirac2,A2,x_bnd,'same','corr').*x_1_diff;
    delta1=(-learn_rate*dirac1)/(size(dirac1,1)*size(dirac1,2));
    
    for k=1:patch_size
        for l=1:patch_size
            da1=sum(sum(delta1.*circshift(x_1,[patch_mid-k patch_mid-l])));
            A1(k,l)=A1(k,l)+da1;
            db1=sum(sum(delta1.*circshift(u,[patch_mid-k patch_mid-l])));
            B1(k,l)=B1(k,l)+db1;
        end
    end
    di1=sum(sum(delta1));
    I1=I1+di1;
    
    %error summary per iteration
    err(i)=100*sum(sum(error_map2))/(size(error_map2,1)*size(error_map2,2));
    
    waitbar(i/learn_loop);
    if(isgraphics(learnProg)==0)
        break;
    end
end
close(learnProg);
%CNN calculation with learned weights
%layer 1
[x_1,~] = cnn_system( A1,B1,I1,x_bnd,u_bnd, u, 0, Ts, iter, 'cpu');
%layer 2
[x_2,x_normal] = cnn_system( A2,B2,I2,x_bnd,u_bnd, x_1, 0, Ts, iter, 'cpu');
    
%error map and structural similarity calculation
error_map2=((1/2)*(ideal-x_2)).^2;
[ssimval, ssimmap] = ssim(x_1,double(ideal));

%plot figures
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
imshow(abs(error_map2))
title('Absolute Error Map')
subplot(2,2,4)
plot(err)
grid on
ylabel('% Error ');
xlabel('Learning Count');
title(sprintf('Error=%%%f%',err(end)))
