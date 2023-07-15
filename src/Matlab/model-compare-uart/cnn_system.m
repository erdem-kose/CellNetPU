function [y,y_normal,y_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_0, Ts, iter, gpu_cpu)
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
    format('long');
    
    im_height=size(u,1);
    im_width=size(u,2);
    
    if size(x_0)==[1,1]
        x=x_bnd*ones(im_height+2,im_width+2);
        x(2:(im_height+1),2:(im_width+1))=x_0*ones(im_height,im_width);
        y=x_bnd*ones(im_height+2,im_width+2);
        y(2:(im_height+1),2:(im_width+1))=x_0*ones(im_height,im_width);
    else
        x=x_bnd*ones(im_height+2,im_width+2);
        x(2:(im_height+1),2:(im_width+1))=x_0;
        y=x_bnd*ones(im_height+2,im_width+2);
        y(2:(im_height+1),2:(im_width+1))=x_0;
    end
    y_normal=x_bnd*ones(im_height+2,im_width+2);

    u_temp=u_bnd*ones(im_height+2,im_width+2);
    u_temp(2:(im_height+1),2:(im_width+1))=u;

    tic;
    for loop=1:iter

        if (gpu_cpu==0)
            %GPU Computing
            Ax=imfilter(gpuArray(x(2:(im_height+1),2:(im_width+1))),gpuArray(A),x_bnd,'same','conv');
            Bu=imfilter(gpuArray(u_temp(2:(im_height+1),2:(im_width+1))),gpuArray(B),u_bnd,'same','conv');
            x(2:(im_height+1),2:(im_width+1))=gather(gpuArray(y(2:(im_height+1),2:(im_width+1)))-gpuArray(Ts)*(gpuArray(y(2:(im_height+1),2:(im_width+1)))-(Ax+Bu+gpuArray(I))));
        elseif (gpu_cpu==1)
            %CPU Computing
            Ax=imfilter(x(2:(im_height+1),2:(im_width+1)),A,x_bnd,'same','conv');
            Bu=imfilter(u_temp(2:(im_height+1),2:(im_width+1)),B,u_bnd,'same','conv');    
            x(2:(im_height+1),2:(im_width+1))=y(2:(im_height+1),2:(im_width+1))-Ts*(y(2:(im_height+1),2:(im_width+1))-(Ax+Bu+I));
        elseif (gpu_cpu==2)
            %FPGA Like CPU Computing
            for i=2:im_height+1
                for j=2:im_width+1
                    x(i,j)=cnn_core(B,A,I,u_temp(i-1:i+1,j-1:j+1),y(i-1:i+1,j-1:j+1),Ts);
                end
            end
            
        end
        x(x>1)=1;
        x(x<-1)=-1;
        y=x;
        y_cpu_time=toc;

        y_normal=(y(2:(im_height+1),2:(im_width+1))+1)/2;
    end

    y=y(2:(im_height+1),2:(im_width+1));
end