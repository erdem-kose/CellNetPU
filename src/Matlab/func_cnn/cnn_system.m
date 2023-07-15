function [x,x_normal,x_cpu_time,x_diff] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_0, Ts, iter, gpu_cpu)
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

    x=x_0;
    
    x_=x;
    
    tic;
    for loop=1:iter

        switch gpu_cpu
            case 'gpu'
                %GPU Computing
                Ax=imfilter(gpuArray(x),gpuArray(A),x_bnd,'same','corr');
                Bu=imfilter(gpuArray(u),gpuArray(B),u_bnd,'same','corr');
                x_=gather(gpuArray(x)-gpuArray(Ts)*(gpuArray(x)-(Ax+Bu+gpuArray(I))));
            case 'cpu'
                %CPU Computing
                Ax=imfilter(x,A,x_bnd,'same','corr');
                Bu=imfilter(u,B,u_bnd,'same','corr');
                x_=x-Ts*(x-(Ax+Bu+I));
        end
        
        xx=x_;
        xx(x_>1)=1;
        xx(x_<-1)=-1;
        x=xx;
        
        xx=x_;
        xx((x_<1)&(x_>-1))=1;
        xx(x_>1)=0;
        xx(x_<-1)=0;
        x_diff=xx;
        x_cpu_time=toc;
    end
    x_normal=(x+1)/2;
end

