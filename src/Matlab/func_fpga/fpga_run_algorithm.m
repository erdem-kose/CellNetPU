function [ y_uart, error_val_uart, cnn_time] = fpga_run_algorithm( serial_obj, cnn_commands, x_0, u, ideal, alg_no)
    im_height=size(u,1);
    im_width=size(u,2);
    
    %send header
    fpga_send_header(serial_obj, cnn_commands.bus_f, im_width, im_height, cnn_commands.Ts, cnn_commands.iter, cnn_commands.template_no, cnn_commands.learn_loop, cnn_commands.learn_rate, alg_no);

    % send x_0
    fpga_send_image(serial_obj, cnn_commands.bus_f, 'x_0', x_0, im_width, im_height);

    %send image
    fpga_send_image(serial_obj, cnn_commands.bus_f, 'u', u, im_width, im_height);

    %send ideal
    fpga_send_image(serial_obj, cnn_commands.bus_f, 'y_ideal', ideal, im_width, im_height);

    %calculate
    cnn_time=fpga_calculate(serial_obj, alg_no);

    %get image
    y_uart=fpga_get_image(serial_obj, cnn_commands.bus_f, 'x_0', im_width, im_height);

    %get error
    [error_val_uart]=fpga_get_error(serial_obj, cnn_commands.bus_f);
end

