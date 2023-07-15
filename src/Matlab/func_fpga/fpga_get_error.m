function [error_val_uart] = fpga_get_error(serial_obj, bus_f)
    %get error_values
    fwrite(serial_obj,4,'uint8');
    
    error_val_uart=zeros(3,3,3);
    for i=1:3
        for j=1:3
            error_val_uart(i,j,1)=fread(serial_obj,1,'uint8')*(2^24);
            error_val_uart(i,j,1)=bitor(error_val_uart(i,j,1),fread(serial_obj,1,'uint8')*(2^16));
            error_val_uart(i,j,1)=bitor(error_val_uart(i,j,1),fread(serial_obj,1,'uint8')*(2^8));
            error_val_uart(i,j,1)=bitor(error_val_uart(i,j,1),fread(serial_obj,1,'uint8'));
            error_val_uart(i,j,1)=typecast(uint32(error_val_uart(i,j,1)),'int32');
            error_val_uart(i,j,1)=double(error_val_uart(i,j,1))/(2^bus_f);
        end
    end
    
    for i=1:3
        for j=1:3
            error_val_uart(i,j,2)=fread(serial_obj,1,'uint8')*(2^24);
            error_val_uart(i,j,2)=bitor(error_val_uart(i,j,2),fread(serial_obj,1,'uint8')*(2^16));
            error_val_uart(i,j,2)=bitor(error_val_uart(i,j,2),fread(serial_obj,1,'uint8')*(2^8));
            error_val_uart(i,j,2)=bitor(error_val_uart(i,j,2),fread(serial_obj,1,'uint8'));
            error_val_uart(i,j,2)=typecast(uint32(error_val_uart(i,j,2)),'int32');
            error_val_uart(i,j,2)=double(error_val_uart(i,j,2))/(2^bus_f);
        end
    end
    
    error_val_uart(:,:,3)=fread(serial_obj,1,'uint8')*(2^24);
    error_val_uart(:,:,3)=bitor(error_val_uart(1,1,3),fread(serial_obj,1,'uint8')*(2^16));
    error_val_uart(:,:,3)=bitor(error_val_uart(1,1,3),fread(serial_obj,1,'uint8')*(2^8));
    error_val_uart(:,:,3)=bitor(error_val_uart(1,1,3),fread(serial_obj,1,'uint8'));
    error_val_uart(:,:,3)=typecast(uint32(error_val_uart(1,1,3)),'int32');
    error_val_uart(:,:,3)=double(error_val_uart(1,1,3))/(2^bus_f);
    %
end

