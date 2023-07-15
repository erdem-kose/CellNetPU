clear;clc;
%reading image
temp_im=imread('images/others/lara.png','png');

%original gray image
if size(temp_im,3)==3
    gray_im=(cast(rgb2gray(temp_im),'double')/256);
else
    gray_im=(cast(temp_im,'double')/256);
end

y_ideal = edge(gray_im,'Canny',0.1);

u=gray_im*2-1;
iter=20;
Ts=0.1;

[ A,B,I,x_bnd,u_bnd ]=cnn_template(3,0);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, u, 0, Ts, iter, 0, 1);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(4,0.3);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, u, x, Ts, iter, 0, 1);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(8,0);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, x, 0, Ts, iter, 0, 1);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(11,6);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, x, x, Ts, iter, 0, 1);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(7, 0);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, x, 0, Ts, iter, 0, 1);

[ A,B,I,x_bnd,u_bnd ]=cnn_template(13,[1 0 1;0 1 0;1 0 1]);
[x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, x, 0, Ts, iter, 0, 1);



figure(2)
subplot(1,2,1)
imshow(x_normal)
title('CNN')
subplot(1,2,2)
imshow(y_ideal)
title('Canny')