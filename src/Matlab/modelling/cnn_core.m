%input must be double and in range [-1:1]
%output is double and in range [-1:1]
function y_new = cnn_core(B,A,I,u,y_old,Ts)%CNN core in double format 
    N=3;
    Nn=N+1;
    
    y_temp=0;
    
    for k=1:N
        for l=1:N
            y_temp=y_temp+A(k,l)*y_old(Nn-k,Nn-l)+B(k,l)*u(Nn-k,Nn-l);
        end
    end
    
    y_temp=y_old(Nn/2,Nn/2)-Ts*(y_old(Nn/2,Nn/2)-(y_temp+I));
    
    if y_temp>1
        y_new=1;
    elseif y_temp<-1
        y_new=-1;
    else
        y_new=y_temp;
    end
end