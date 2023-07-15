%input must be double and in range [-1:1]
%output is double and in range [-1:1]
function error = cnn_error_calc(y_ideal,y_output)%CNN core in double format 
    if size(y_ideal)==size(y_ideal)
        error=0;
        [m,n]=size(y_ideal);
        for i=1:m
            for j=1:n
                error=error+((y_ideal(i,j)-y_output(i,j))^2)/(n*m);
            end
        end
    else
        error=0;
    end
end