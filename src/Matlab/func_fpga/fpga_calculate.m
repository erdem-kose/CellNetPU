function [ cnn_time ] = fpga_calculate( serial_obj, alg_no)
    fwrite(serial_obj,2,'uint8');
    fwrite(serial_obj,alg_no,'uint8');
    while(fread(serial_obj,1,'uint8')~=2)
    end
    tic;
    while(fread(serial_obj,1,'uint8')~=2)
    end
    cnn_time=toc;
end

