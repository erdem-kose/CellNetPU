clear;clc;
%reading image
machine_height=128;
machine_width=machine_height;

bus_q=16;
bus_m=5;
bus_f=11;

image=rgb2gray(imread('images/lenna.png','png'));
image=imresize(image,[machine_height machine_width]);
image=(double(image)/255);
y_ideal = edge(image,'Canny',0.1);
ideal=(2*y_ideal-1);

u=image*2-1;
iter=2;
Ts=0.1;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(1,0);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 0);

a16bitfixed_x=zeros(size(image,1),size(image,2));
a16bitfixed_u=zeros(size(image,1),size(image,2));
a16bitfixed_ideal=zeros(size(image,1),size(image,2));

for i=1:size(image,1)
    for j=1:size(image,2)
        a16bitfixed_x(i,j)=typecast(int16(x(i,j)*(2^bus_f)),'int16');
        a16bitfixed_u(i,j)=typecast(int16(u(i,j)*(2^bus_f)),'int16');
        a16bitfixed_ideal(i,j)=typecast(int16(ideal(i,j)*(2^bus_f)),'int16');
    end
end

figure(2)
subplot(1,2,1)
imshow(x_normal)
title('CNN')
subplot(1,2,2)
imshow(y_ideal)
title('Canny')

asd=[0 0 0;514 530 530;514 498 514];

for i=2:size(a16bitfixed_u,1)-1
    for j=2:size(a16bitfixed_u,2)-1
        tot=0;
        for k=-1:1
            for l=-1:1
                if a16bitfixed_u(i+k,j+l)==asd(2+k,2+l)
                    tot=tot+1;
                end
            end
        end
        if tot==9;
            pos_i=i;
            pos_j=j;
        end
    end
end
