function [error_map_uart, error_val_uart] = fpga_get_error(serial_obj, bus_f, im_width, im_height)
    fwrite(serial_obj,6,'uint8');
    
    error_map_uart=zeros(im_height,im_width);
    for i=1:im_height
        for j=1:im_width
            error_map_uart(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            error_map_uart(i,j)=bitor(error_map_uart(i,j),fread(serial_obj,1,'uint8'));
            error_map_uart(i,j)=typecast(uint16(error_map_uart(i,j)),'int16');
            error_map_uart(i,j)=(double(error_map_uart(i,j)/(2^bus_f))+1)/2;
        end
    end
    %

    %get error_values
    fwrite(serial_obj,7,'uint8');
    
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

