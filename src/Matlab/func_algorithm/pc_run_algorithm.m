function [ x_cpu, error_val, cpu_time ] = pc_run_algorithm(cnn_commands, x_new, u, ideal, alg_no )
    im_height=size(u,1);
    im_width=size(u,2);
    
    switch (alg_no)
        case 1 %direct cnn
            [A,B,I,x_bnd,u_bnd]=cnn_template(cnn_commands.template_no,0);
            [x_new,x_cpu,cpu_time]=cnn_system( A,B,I,x_bnd,u_bnd, u, 0, cnn_commands.Ts, cnn_commands.iter, 1);
            
        case 2
            cpu_time=0;
            
            [ A,B,I,x_bnd,u_bnd ]=cnn_template(2,0);
            [x_new,~,cpu_time_temp] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, 0.1, 100, 1);
            cpu_time=cpu_time+cpu_time_temp;
            
            [ A,B,I,x_bnd,u_bnd ]=cnn_template(12,[0 1 0; 1 1 1; 0 1 0]);
            [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, 1, 1, 1);
            cpu_time=cpu_time+cpu_time_temp;
            
            [ A,B,I,x_bnd,u_bnd ]=cnn_template(8,0);
            [x_new,~,~] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, 1, 1, 1);
            cpu_time=cpu_time+cpu_time_temp;
            
            [ A,B,I,x_bnd,u_bnd ]=cnn_template(4,0);
            [x_new,x_cpu,~] = cnn_system( A,B,I,x_bnd,u_bnd, x_new, 0, 1, 1, 1);
            cpu_time=cpu_time+cpu_time_temp;
            
        case 3 %real 1d learning
            A=[0 0 0;0 0 0;0 0 0];
            B=[0 0 0;0 0 0;0 0 0];
            I=0;
            x_bnd=0;
            u_bnd=0;

            cpu_time=0;
            x_new=0;
            for i=1:cnn_commands.learn_loop
                [x_new,x_cpu,cpu_time_temp] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                cpu_time=cpu_time+cpu_time_temp;
                tic;
                error_map=((1/2)*(ideal-x_new));

                delta=(cnn_commands.learn_rate*error_map)/(size(error_map,1)*size(error_map,2));

                DA1=sum(sum(delta.*circshift(x_new,[0 1])));
                DA2=sum(sum(delta.*circshift(x_new,[0 0])));
                DA3=sum(sum(delta.*circshift(x_new,[0 -1])));
                DB1=sum(sum(delta.*circshift(u,[0 1])));
                DB2=sum(sum(delta.*circshift(u,[0 0])));
                DB3=sum(sum(delta.*circshift(u,[0 -1])));
                DI=sum(sum(delta));

                A(2,1)=A(2,1)+DA1; A(2,2)=A(2,2)+DA2; A(2,3)=A(2,3)+DA3;
                B(2,1)=B(2,1)+DB1; B(2,2)=B(2,2)+DB2; B(2,3)=B(2,3)+DB3;
                I=I+DI;
                cpu_time=cpu_time+toc;
            end
            
        case 4 %real 1d multilayer learning
            patch_size=3;
            patch_mid=(patch_size+1)/2;
            A=zeros(patch_size,patch_size,5);
            B=zeros(patch_size,patch_size,5);
            I=zeros(1,5);
            x_bnd=0;
            u_bnd=0;

            x=zeros(size(u,1),size(u,2),5);

            da=zeros(patch_size,patch_size);
            db=zeros(patch_size,patch_size);
            
            cpu_time=0;
            for i=1:cnn_commands.learn_loop
            %kademe 1
                [x(:,:,1),~,cpu_time_temp] = cnn_system( A(:,:,1),B(:,:,1),I(1),x_bnd,u_bnd, u, x(:,:,2), cnn_commands.Ts, cnn_commands.iter, 1);
                cpu_time=cpu_time+cpu_time_temp;
                tic;
                
                error_map=(1/2)*(ideal-x(:,:,1));
                delta=(cnn_commands.learn_rate*error_map)/(size(error_map,1)*size(error_map,2));

                for k=patch_mid
                    for l=1:patch_size
                        da(k,l)=sum(sum(delta.*circshift(x(:,:,1),[patch_mid-k patch_mid-l])));
                        A(k,l,1)=A(k,l,1)+da(k,l);

                        db(k,l)=sum(sum(delta.*circshift(u,[patch_mid-k patch_mid-l])));
                        B(k,l,1)=B(k,l,1)+db(k,l);
                    end
                end
                
                di=sum(sum(delta));
                I(1)=I(1)+di;
                
                cpu_time=cpu_time+toc;
            %kademe 2
                [x(:,:,2),x_cpu,cpu_time_temp] = cnn_system( A(:,:,2),B(:,:,2),I(2),x_bnd,u_bnd, u, x(:,:,1), cnn_commands.Ts, cnn_commands.iter, 1);
                cpu_time=cpu_time+cpu_time_temp;
                tic;
                
                error_map=(1/2)*(ideal-x(:,:,2));
                delta=(cnn_commands.learn_rate*error_map)/(size(error_map,1)*size(error_map,2));

                for k=patch_mid
                    for l=1:patch_size
                        da(k,l)=sum(sum(delta.*circshift(x(:,:,2),[patch_mid-k patch_mid-l])));
                        A(k,l,2)=A(k,l,2)+da(k,l);

                        db(k,l)=sum(sum(delta.*circshift(u,[patch_mid-k patch_mid-l])));
                        B(k,l,2)=B(k,l,2)+db(k,l);
                    end
                end
                
                di=sum(sum(delta));
                I(2)=I(2)+di;
                
                cpu_time=cpu_time+toc;
            end
            
        case 5 %real 2d learning
            A=[0 0 0;0 0 0;0 0 0];
            B=[0 0 0;0 0 0;0 0 0];
            I=0;
            x_bnd=0;
            u_bnd=0;

            cpu_time=0;
            x_new=0;
            for i=1:cnn_commands.learn_loop
                [x_new,x_cpu,cpu_time_temp] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_new, cnn_commands.Ts, cnn_commands.iter, 1);
                cpu_time=cpu_time+cpu_time_temp;
                tic;
                error_map=((1/2)*(ideal-x_new));

                delta=(cnn_commands.learn_rate*error_map)/(size(error_map,1)*size(error_map,2));
                
                for k=1:3
                    for l=1:3
                        da=sum(sum(delta.*circshift(x_new,[2-k 2-l])));
                        A(k,l)=A(k,l)+da;
                        db=sum(sum(delta.*circshift(u,[2-k 2-l])));
                        B(k,l)=B(k,l)+db;
                    end
                end

                di=sum(sum(delta));
                I=I+di;
                
                cpu_time=cpu_time+toc;
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
            error_val(i,j,1)=sum(sum(delta.*circshift(x_new,[i-2 j-2])))/(size(error_map,1)*size(error_map,2));
        end
    end
    for i=1:3
        for j=1:3
            error_val(i,j,2)=sum(sum(delta.*circshift(u,[i-2 j-2])))/(size(error_map,1)*size(error_map,2));
        end
    end
    error_val(:,:,3)=sum(sum(delta))/(size(error_map,1)*size(error_map,2));
end

