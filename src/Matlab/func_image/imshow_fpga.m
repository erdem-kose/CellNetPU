function [] = imshow_fpga(iter, y_uart, cnn_time, x_cpu, x_cpu_time, y_ideal,...
                            error_map, error_val, error_map_uart, error_val_uart)
    figure
    set(gcf,'numbertitle','off','name','FPGA Results') 
    
    [ss_val,ss_map]=ssim(y_uart,x_cpu);
    subplot(3,3,1)
    imshow(x_cpu)%x_cpu)
    title(sprintf('%s, Perf=%f iter/s',winqueryreg('HKEY_LOCAL_MACHINE',...
        'HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),iter/x_cpu_time))

    subplot(3,3,2)
    imshow(y_uart)
    title(sprintf('Xilinx Spartan 6 100 MHz UART, Perf=%f iter/s',iter/cnn_time))

    ax3=subplot(3,3,3);
    imshow(ss_map)
    colormap(ax3,hot)
    title(sprintf('Structural Similarity Map, SS Ratio=%%%f',100*ss_val))

    [ss_val,ss_map]=ssim((y_ideal+1)/2,y_uart);
    subplot(3,3,4)
    imshow((y_ideal+1)/2)
    title('Ideal Output Image')

    subplot(3,3,5)
    imshow(y_uart)
    title('Xilinx Spartan 6 Output Image')

    ax6=subplot(3,3,6);
    imshow(ss_map)
    colormap(ax6,hot)
    title(sprintf('Structural Similarity Map, SS Ratio=%%%f',100*ss_val))

    [ss_val,ss_map]=ssim(error_map_uart,error_map);
    subplot(3,3,7)
    imshow(error_map)
    title(sprintf('%s, Error Map\n Error Sum:%f',...
            winqueryreg('HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'), error_val))

    subplot(3,3,8)
    imshow(error_map_uart)
    title(sprintf('Xilinx Spartan 6 Error Map\n Error Sum:%f', error_val_uart))

    ax6=subplot(3,3,9);
    imshow(ss_map)
    colormap(ax6,hot)
    title(sprintf('Structural Similarity Map, SS Ratio=%%%f',100*ss_val))
end

