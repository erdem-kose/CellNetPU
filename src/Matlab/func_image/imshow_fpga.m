function [] = imshow_fpga(u, iter, y_uart, cnn_time, x_cpu, x_cpu_time, y_ideal,...
                            error_val, error_val_uart)
    figure
    set(gcf,'numbertitle','off','name','FPGA Results') 
    
    [ss_val,ss_map]=ssim((y_ideal+1)/2,u);
    subplot(3,4,1)
    imshow(u)
    title('Input Image')
    
    subplot(3,4,2)
    imshow((y_ideal+1)/2)
    title('Ideal Image')
    
    ax3=subplot(3,4,3);
    imshow(ss_map)
    colormap(ax3,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))
    
    [ss_val,ss_map]=ssim((y_ideal+1)/2,x_cpu);
    subplot(3,4,5)
    imshow(x_cpu)%x_cpu)
    title(sprintf('%s\nPerf=%f s',winqueryreg('HKEY_LOCAL_MACHINE',...
        'HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString'),x_cpu_time))

    subplot(3,4,6)
    imshow((y_ideal+1)/2)
    title('Ideal Image')
    
    subplot(3,4,7);
    imshow(ss_map)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f\n Error Sum=%f',100*ss_val,error_val))
        
    [ss_val,ss_map]=ssim((y_ideal+1)/2,y_uart);
    subplot(3,4,9)
    imshow(y_uart)
    title(sprintf('Xilinx Spartan 6 100 MHz UART\nPerf=%f s',cnn_time))
    
    subplot(3,4,10)
    imshow((y_ideal+1)/2)
    title('Ideal Image')

    subplot(3,4,11);
    imshow(ss_map)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f\nError Sum=%f',100*ss_val,error_val_uart))
    
    [ss_val,ss_map]=ssim(x_cpu,y_uart);
    ax5=subplot(3,4,[8,12]);
    imshow(ss_map)
    colormap(ax5,hot)
    title(sprintf('Structural Similarity Map\nSS Ratio=%%%f',100*ss_val))
end

