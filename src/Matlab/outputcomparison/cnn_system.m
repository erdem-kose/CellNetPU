function [x,x_normal] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_0, Ts, iter, shw_img)
    % image and state values must be double and between -1 to 1
    % A: feedback patch
    % B: feedforward patch
    % I: bias constant
    % x_bnd: state image boundary conditions
    % u_bnd: input image boundary conditions
    % u: input image
    % x_0: state image first state
    % Ts: time step for iterations
    % iter: iteration count
    % shw_img: if 1 it will show output images
    im_height=size(u,1);
    im_width=size(u,2);
    
    if size(x_0)==[1,1]
        x=x_bnd*ones(im_height+2,im_width+2);
        x(2:(im_height+1),2:(im_width+1))=x_0*ones(im_height,im_width);
    else
        x=x_bnd*ones(im_height+2,im_width+2);
        x(2:(im_height+1),2:(im_width+1))=x_0;
    end
    x_normal=x_bnd*ones(im_height+2,im_width+2);

    u_temp=u_bnd*ones(im_height+2,im_width+2);
    u_temp(2:(im_height+1),2:(im_width+1))=u;

    un=zeros(im_height+2,im_width+2);

    tic;

    for loop=1:iter
        for i=2:im_height+1
            for j=2:im_width+1
                x(i,j)=cnn_core(B,A,I,u_temp(i-1:i+1,j-1:j+1),x(i-1:i+1,j-1:j+1),Ts);
            end
        end

        cnn_time=toc;

        x_normal=(x(2:(im_height+1),2:(im_width+1))+1)/2;
        if shw_img==1
            subplot(ceil(iter/5)+(mod(iter+1,5)~=0),5,1+loop)
            imshow(x_normal)
            title(sprintf('Iteration:%d\nTime:%f secs',loop,cnn_time));
        end
    end
    if shw_img==1
        subplot(ceil(iter/5)+(mod(iter+1,5)~=0),5,1)
        imshow((u+1)/2)
    end
    x=x(2:(im_height+1),2:(im_width+1));
end

