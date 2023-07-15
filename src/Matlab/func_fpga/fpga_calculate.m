function [ cnn_time ] = fpga_calculate( serial_obj )
    fwrite(serial_obj,4,'uint8');
    while(fread(serial_obj,1,'uint8')~=4)
    end
    tic;
    while(fread(serial_obj,1,'uint8')~=4)
    end
    cnn_time=toc-10/(serial_obj.BaudRate);
end

