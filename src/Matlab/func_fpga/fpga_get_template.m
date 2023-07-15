function [A,B,I,x_bnd,u_bnd] = fpga_get_template(serial_obj, bus_f)
    A=zeros(3,3);
    B=zeros(3,3);
    fwrite(serial_obj,8,'uint8');
    for i=1:3
        for j=1:3
            A(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            A(i,j)=bitor(A(i,j),fread(serial_obj,1,'uint8'));
            A(i,j)=(double(A(i,j)/(2^bus_f)));
        end
    end
    for i=1:3
        for j=1:3
            B(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            B(i,j)=bitor(B(i,j),fread(serial_obj,1,'uint8'));
            B(i,j)=(double(B(i,j)/(2^bus_f)));
        end
    end
    I=fread(serial_obj,1,'uint8')*(2^8);
    I=bitor(I,fread(serial_obj,1,'uint8'))/2^bus_f;
    I=(double(I/(2^bus_f)));
    x_bnd=fread(serial_obj,1,'uint8')*(2^8);
    x_bnd=bitor(x_bnd,fread(serial_obj,1,'uint8'));
    x_bnd=(double(x_bnd/(2^bus_f)));
    u_bnd=fread(serial_obj,1,'uint8')*(2^8);
    u_bnd=bitor(u_bnd,fread(serial_obj,1,'uint8'));
    u_bnd=(double(u_bnd/(2^bus_f)));
end

