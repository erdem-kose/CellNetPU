function [] = fpga_send_image(serial_obj, bus_f, type, image, im_width, im_height)
    switch type
        case 'x_0'
            type_ind=1;
        case 'u'
            type_ind=2;
        case 'y_ideal'
            type_ind=3;
        otherwise
            display('not available!')
            return;
    end
    fwrite(serial_obj,type_ind,'uint8');
    
    image_fix=zeros(im_height,im_width);
    for i=1:im_height
        for j=1:im_width
            image_fix(i,j)=int16(image(i,j)*(2^bus_f));
        end
    end
    
    send_buffer=zeros(1,2*im_width*im_height);
    for i=1:im_height
        for j=1:im_width
            send_buffer(1,(i-1)*2*im_width+2*j-1)=bitand((int16(floor(image_fix(i,j)/(2^8)))),255);
            send_buffer(1,(i-1)*2*im_width+2*j)=bitand(int16(image_fix(i,j)),255);
        end
    end
    fwrite(serial_obj,send_buffer,'uint8');
end

