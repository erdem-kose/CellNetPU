function [] = imshow_fpga(u, iter, y_uart, cnn_time, x_cpu, x_cpu_time, y_ideal,...
                            error_map, error_val, error_map_uart, error_val_uart)
    figure
    set(gcf,'numbertitle','off','name','FPGA Results') 
    
    [ss_val,ss_map]=ssim((y_ideal+1)/2,u);
    subplot(3,5,1)
    imshow(u)
    title('Input Image')
    
    subplot(3,5,2)
    imshow((y_ideal+1)/2)
    title('Ideal Image')
    
    ax3=subplot(3,5,3);
    imshow(ss_map)
    colormap(ax3,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))
    
    [ss_val,ss_map]=ssim((y_ideal+1)/2,x_cpu);
    subplot(3,5,6)
    imshow(x_cpu)%x_cpu)
    title(sprintf('%s\nPerf=%f iter/s',winqueryreg('HKEY_LOCAL_MACHINE',...
        'HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),iter/x_cpu_time))

    subplot(3,5,7)
    imshow((y_ideal+1)/2)
    title('Ideal Image')
    
    ax8=subplot(3,5,8);
    imshow(ss_map)
    colormap(ax8,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))
    
    subplot(3,5,9)
    imshow(error_map)
    title(sprintf('%s Error Map\n Error Sum:%f',...
            winqueryreg('HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'), error_val))
        
    [ss_val,ss_map]=ssim((y_ideal+1)/2,y_uart);
    subplot(3,5,11)
    imshow(y_uart)
    title(sprintf('Xilinx Spartan 6 100 MHz UART\nPerf=%f iter/s',iter/cnn_time))
    
    subplot(3,5,12)
    imshow((y_ideal+1)/2)
    title('Ideal Image')

    ax13=subplot(3,5,13);
    imshow(ss_map)
    colormap(ax13,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))

    subplot(3,5,14)
    imshow(error_map_uart)
    title(sprintf('Xilinx Spartan 6 Error Map\nError Sum:%f', error_val_uart))
    
    [ss_val,ss_map]=ssim(x_cpu,y_uart);
    ax5=subplot(3,5,[10,15]);
    imshow(ss_map)
    colormap(ax5,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))
end

