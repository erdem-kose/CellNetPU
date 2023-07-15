function [ y_uart, error_val_uart, error_map_uart, cnn_time] = fpga_run_algorithm( serial_obj, cnn, x_0, u, ideal, alg_no)
    im_height=size(u,1);
    im_width=size(u,2);
    
    %send header
    fpga_send_header(serial_obj, cnn.bus_f, im_width, im_height, cnn.Ts, cnn.iter, cnn.template_no, cnn.learn_loop, cnn.learn_rate, alg_no);

    % send x_0
    fpga_send_image(serial_obj, cnn.bus_f, 'x_0', x_0, im_width, im_height);

    %send image
    fpga_send_image(serial_obj, cnn.bus_f, 'u', u, im_width, im_height);

    %send ideal
    fpga_send_image(serial_obj, cnn.bus_f, 'y_ideal', ideal, im_width, im_height);

    %calculate
    cnn_time=fpga_calculate(serial_obj);

    %get image
    y_uart=fpga_get_image(serial_obj, cnn.bus_f, im_width, im_height);

    %get error
    [error_map_uart, error_val_uart]=fpga_get_error(serial_obj, cnn.bus_f,im_width, im_height);
end

