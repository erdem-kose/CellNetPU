function [] = fpga_send_header(serial_obj, bus_f, im_width, im_height, Ts, iter, template_no, learn_loop, learn_rate)
    fwrite(serial_obj,0,'uint8');

    fwrite(serial_obj,bitand((int16(floor((im_width)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(im_width),255),'uint8');

    fwrite(serial_obj,bitand((int16(floor((im_height)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(im_height),255),'uint8');
    
    Ts=int16(Ts*(2^bus_f));
    fwrite(serial_obj,bitand((floor((Ts)/(2^8))),255),'uint8');
    fwrite(serial_obj,bitand(Ts,255),'uint8');

    fwrite(serial_obj,bitand((int16(floor((iter)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(iter),255),'uint8');
    
    fwrite(serial_obj,bitand((int16(floor((template_no)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(template_no),255),'uint8');
    
    fwrite(serial_obj,bitand((int16(floor((learn_loop)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(learn_loop),255),'uint8');
    
    learn_rate=int16(learn_rate*(2^bus_f));
    fwrite(serial_obj,bitand((int16(floor((learn_rate)/(2^8)))),255),'uint8');
    fwrite(serial_obj,bitand(int16(learn_rate),255),'uint8');
end

