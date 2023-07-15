function [x,x_normal,x_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_0, Ts, iter, gpu_cpu)
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
    % gpu_cpu: 0:gpu 1:cpu computing
    format('short');

    if size(x_0)==size(u)
        x=x_0;
    else
        x=ones(size(u,1),size(u,2))*x_0;
    end

    xx=x;

    p=gcp();
    
    tic;
    for loop=1:iter

        if (gpu_cpu==0)
            %GPU Computing
            Ax=imfilter(gpuArray(x),gpuArray(A),x_bnd,'same','corr');
            Bu=imfilter(gpuArray(u),gpuArray(B),u_bnd,'same','corr');
            xx=gather(gpuArray(x)-gpuArray(Ts)*(gpuArray(x)-(Ax+Bu+gpuArray(I))));
        elseif (gpu_cpu==1)
            Ax=imfilter(x,A,x_bnd,'same','corr');
            Bu=imfilter(u,B,u_bnd,'same','corr');
            xx=x-Ts*(x-(Ax+Bu+I));
        end
        xx(xx>1)=1;
        xx(xx<-1)=-1;
        x=xx;
        x_cpu_time=toc;
    end
    x_normal=(x+1)/2;
end

