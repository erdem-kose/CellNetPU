function [image] = fpga_get_image(serial_obj, bus_f, type, im_width, im_height)
    image=zeros(im_height,im_width);
    fwrite(serial_obj,3,'uint8');
    switch type
        case 'u'
            type_ind=0;
        case 'x_0'
            type_ind=1;
        case 'y_ideal'
            type_ind=2;
        otherwise
            type_ind=type;
    end
    fwrite(serial_obj,type_ind,'uint8');
    for i=1:im_height
        for j=1:im_width
            image(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            image(i,j)=bitor(image(i,j),fread(serial_obj,1,'uint8'));
            image(i,j)=typecast(uint16(image(i,j)),'int16');
            image(i,j)=(double(image(i,j)/(2^bus_f))+1)/2;
        end
    end
end

