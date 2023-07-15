%input must be double and in range [-1:1]
%output is double and in range [-1:1]
function x_new = cnn_core(B,A,I,u,x_old,Ts)%CNN core in double format 
    N=3;
    Nn=N+1;
    
    Ax=0;
	Bu=0;
    for k=1:N
        for l=1:N
			Ax=Ax+A(k,l)*x_old(Nn-k,Nn-l);
			Bu=Bu+B(k,l)*u(Nn-k,Nn-l);
        end
    end
    
    x_temp=x_old(Nn/2,Nn/2)-Ts*(x_old(Nn/2,Nn/2)-(Ax+Bu+I));
    
    if x_temp>1
        x_new=1;
    elseif x_temp<-1
        x_new=-1;
    else
        x_new=x_temp;
    end
end