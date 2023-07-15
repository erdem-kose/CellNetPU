if exist('serial_obj','var')==0
    serial_obj = serial(port);
    serial_obj.BaudRate=921600;
    serial_obj.BytesAvailableFcnCount=2*im_width*im_height;
    serial_obj.TimerPeriod=10;
    serial_obj.Timeout=100.0;
    serial_obj.InputBufferSize=2*im_width*im_height;
    serial_obj.OutputBufferSize=2*im_width*im_height;
    fopen(serial_obj);
else
    uart_stop;
    serial_obj.BaudRate=921600;
    serial_obj.BytesAvailableFcnCount=2*im_width*im_height;
    serial_obj.TimerPeriod=10;
    serial_obj.Timeout=100.0;
    serial_obj.InputBufferSize=2*im_width*im_height;
    serial_obj.OutputBufferSize=2*im_width*im_height;
    fopen(serial_obj);
end