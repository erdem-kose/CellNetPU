function [error_map_uart, error_norm_val_uart, error_squa_val_uart] = fpga_get_error(serial_obj, bus_f, im_width, im_height)
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

    %get error_norm_val
    fwrite(serial_obj,7,'uint8');
    error_norm_val_uart=fread(serial_obj,1,'uint8')*(2^24);
    error_norm_val_uart=bitor(error_norm_val_uart,fread(serial_obj,1,'uint8')*(2^16));
    error_norm_val_uart=bitor(error_norm_val_uart,fread(serial_obj,1,'uint8')*(2^8));
    error_norm_val_uart=bitor(error_norm_val_uart,fread(serial_obj,1,'uint8'));
    error_norm_val_uart=typecast(uint32(error_norm_val_uart),'int32');
    error_norm_val_uart=double(error_norm_val_uart/(2^bus_f));
    %

    %get error_squa_val
    fwrite(serial_obj,8,'uint8');
    error_squa_val_uart=fread(serial_obj,1,'uint8')*(2^24);
    error_squa_val_uart=bitor(error_squa_val_uart,fread(serial_obj,1,'uint8')*(2^16));
    error_squa_val_uart=bitor(error_squa_val_uart,fread(serial_obj,1,'uint8')*(2^8));
    error_squa_val_uart=bitor(error_squa_val_uart,fread(serial_obj,1,'uint8'));
    error_squa_val_uart=typecast(uint32(error_squa_val_uart),'int32');
    error_squa_val_uart=double(error_squa_val_uart/(2^bus_f));
    %
end

