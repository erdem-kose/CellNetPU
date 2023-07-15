function [image] = fpga_get_image(serial_obj, bus_f, im_width, im_height)
    image=zeros(im_height,im_width);
    fwrite(serial_obj,5,'uint8');
    for i=1:im_height
        for j=1:im_width
            image(i,j)=fread(serial_obj,1,'uint8')*(2^8);
            image(i,j)=bitor(image(i,j),fread(serial_obj,1,'uint8'));
            image(i,j)=typecast(uint16(image(i,j)),'int16');
            image(i,j)=(double(image(i,j)/(2^bus_f))+1)/2;
        end
    end
end

