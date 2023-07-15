function [ x_cpu, error_val, error_map, cpu_time ] = pc_run_algorithm(cnn_commands, x_new, u, ideal, alg_no )
    im_height=size(u,1);
    im_width=size(u,2);
    
    switch (alg_no)
        case 1 %direct cnn
            [A,B,I,x_bnd,u_bnd]=cnn_template(cnn_commands.template_no,0);
            [x_new,x_cpu,cpu_time]=cnn_system( A,B,I,x_bnd,u_bnd, u, 0, cnn_commands.Ts, cnn_commands.iter, 1);
            
        case 2 %one stage 1d learning-nagakawa
            [ A,B,I,x_bnd,u_bnd ]=cnn_template(cnn_commands.template_no,0);
            x_new=0;
            for i=1:cnn_commands.learn_loop
                %cnn calculation
                [x_new,x_cpu,cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);

                %error calc
                error_map=2*(((ideal-x_new)*(1/2)).^2);
                delta=cnn_commands.learn_rate.*error_map.*x_new;

                %template update
                D=sum(sum(delta))/(size(delta,1)*size(delta,2));
                A(2,1)=A(2,1)+D; A(2,3)=A(2,3)+D;
                B(2,1)=B(2,1)+D; B(2,3)=B(2,3)+D;
            end
   
        case 3 %decomposition 1d learning-nagakawa
            A1=[0 0 0;rand 1 rand;0 0 0];
            B1=[0 0 0;rand rand rand;0 0 0];
            A2=[0 0 0;rand 1 rand;0 0 0];
            B2=[0 0 0;rand rand rand;0 0 0];
            A3=[0 0 0;rand 1 rand;0 0 0];
            B3=[0 0 0;rand rand rand;0 0 0];
            A4=[0 0 0;rand 1 rand;0 0 0];
            B4=[0 0 0;rand rand rand;0 0 0];
            
            I=0;
            x_bnd=0;
            u_bnd=0;

            x_new=0;
            for i=1:cnn_commands.learn_loop
                %cnn calculation
                [x_new,~,x_cpu_time_1] = cnn_system( A1,B1,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                [x_new,~,x_cpu_time_2] = cnn_system( A2,B2,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                [x_new,~,x_cpu_time_3] = cnn_system( A3,B3,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                [x_new,x_cpu,x_cpu_time_4] = cnn_system( A4,B4,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                
                cpu_time=x_cpu_time_1+x_cpu_time_2+x_cpu_time_3+x_cpu_time_4;

                %error calc
                error_map=2*(((ideal-x_new)*(1/2)).^2);
                delta=cnn_commands.learn_rate.*error_map.*x_new;
                D=sum(sum(delta))/(size(delta,1)*size(delta,2));

                %template update
                A1(2,1)=A1(2,1)+D; A1(2,3)=A1(2,3)+D;
                B1(2,1)=B1(2,1)+D; B1(2,3)=B1(2,3)+D;

                A2(2,1)=A2(2,1)+D; A2(2,3)=A2(2,3)+D;
                B2(2,1)=B2(2,1)+D; B2(2,3)=B2(2,3)+D;

                A3(2,1)=A3(2,1)+D; A3(2,3)=A3(2,3)+D;
                B3(2,1)=B3(2,1)+D; B3(2,3)=B3(2,3)+D;

                A4(2,1)=A4(2,1)+D; A4(2,3)=A4(2,3)+D;
                B4(2,1)=B4(2,1)+D; B4(2,3)=B4(2,3)+D;
            end
            
        case 4 %real 1d learning

        A=[0 0 0;0 1 0;0 0 0];
        B=[0 0 0;0 0 0;0 0 0];
        I=0;
        x_bnd=0;
        u_bnd=0;

        x_new=0;

        for i=1:cnn_commands.learn_loop
            [x_new,x_cpu,cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);

            error_map=((1/2)*(ideal-x_new));

            delta=cnn_commands.learn_rate*error_map;
            
            DA1=sum(sum(delta.*circshift(x_new,[0 -1])));
            DA2=sum(sum(delta.*circshift(x_new,[0 0])));
            DA3=sum(sum(delta.*circshift(x_new,[0 1])));
            DB1=sum(sum(delta.*circshift(u,[0 -1])));
            DB2=sum(sum(delta.*circshift(u,[0 0])));
            DB3=sum(sum(delta.*circshift(u,[0 1])));
            DI=sum(sum(delta));

            err(i)=100*sum(sum(error_map))/(size(error_map,1)*size(error_map,2));

            A(2,1)=A(2,1)+DA1; A(2,3)=A(2,3)+DA3;
            B(2,1)=B(2,1)+DB1; B(2,2)=B(2,2)+DB2; B(2,3)=B(2,3)+DB3;
            I=I+DI;
        end
            
        otherwise
            x_cpu=zeros(size(u,1),size(u,2));
            cpu_time=0;
    end
    
    error_map=(((ideal-x_new))/2+1)/2;
    delta=cnn_commands.learn_rate.*(2*error_map-1);%.*((2*x_cpu-1)-(2*x_cpu_old-1))
    
    error_val=zeros(3,3,3);
    for i=1:3
        for j=1:3
            error_val(i,j,1)=sum(sum(delta.*circshift(x_new,[i-2 j-2])));
        end
    end
    for i=1:3
        for j=1:3
            error_val(i,j,2)=sum(sum(delta.*circshift(u,[i-2 j-2])));
        end
    end
    error_val(:,:,3)=sum(sum(delta));
end

