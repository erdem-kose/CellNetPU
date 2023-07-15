function [A,B,I,x_bnd,u_bnd] = fpga_get_template(serial_obj, bus_f, template_no)
    A=zeros(3,3);
    B=zeros(3,3);
    
    fwrite(serial_obj,5,'uint8');
    fwrite(serial_obj,bitand((int16(floor((template_no)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(template_no),255),'uint8');
    
    for i=1:3
        for j=1:3
            A(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            A(i,j)=bitor(A(i,j),fread(serial_obj,1,'uint8'));
            A(i,j)=typecast(uint16(A(i,j)),'int16');
            A(i,j)=(double(A(i,j)/(2^bus_f)));
        end
    end
    for i=1:3
        for j=1:3
            B(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            B(i,j)=bitor(B(i,j),fread(serial_obj,1,'uint8'));
            B(i,j)=typecast(uint16(B(i,j)),'int16');
            B(i,j)=(double(B(i,j)/(2^bus_f)));
        end
    end
    I=fread(serial_obj,1,'uint8')*(2^8);
    I=bitor(I,fread(serial_obj,1,'uint8'));
    I=typecast(uint16(I),'int16');
    I=(double(I)/(2^bus_f));
    x_bnd=fread(serial_obj,1,'uint8')*(2^8);
    x_bnd=bitor(x_bnd,fread(serial_obj,1,'uint8'));
    x_bnd=typecast(uint16(x_bnd),'int16');
    x_bnd=(double(x_bnd)/(2^bus_f));
    u_bnd=fread(serial_obj,1,'uint8')*(2^8);
    u_bnd=bitor(u_bnd,fread(serial_obj,1,'uint8'));
    u_bnd=typecast(uint16(u_bnd),'int16');
    u_bnd=(double(u_bnd)/(2^bus_f));
end

