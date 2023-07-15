clc;clearvars -except serial_obj; format('long');
addpath(genpath('func_cnn'));
addpath(genpath('func_fpga'));
addpath(genpath('func_image'));

machine_height=16;
machine_width=16;
machine_threshold=0.1;

temp_im=imread('images/others/lenna.png');
if size(temp_im,3)==3
    image=(cast(rgb2gray(temp_im),'double')/255);
else
    image=(cast(temp_im,'double')/255);
end
image=imresize(image,[machine_height machine_width],'bicubic');
ideal=edge(image,'Canny',machine_threshold);

subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(ideal)

bus_m=6;
bus_f=10;
bus_q=bus_m+bus_f;

image=(2*image-1)*(2^bus_f);
ideal=(2*ideal-1)*(2^bus_f);

%images-simulation
fileID = fopen('rom_files/ram_sim.init','w');

for i=1:size(image,1)
    for j=1:size(image,2)
        fprintf(fileID,'%s',dec2bin(typecast(int16(0),'uint16'),16));
        fprintf(fileID,'\n');
    end
end

for i=1:size(image,1)
    for j=1:size(image,2)
        fprintf(fileID,'%s',dec2bin(typecast(int16(image(i,j)),'uint16'),16));
        fprintf(fileID,'\n');
    end
end

for i=1:size(ideal,1)
    for j=1:size(ideal,2)
        fprintf(fileID,'%s',dec2bin(typecast(int16(ideal(i,j)),'uint16'),16));
        if ~((i==size(ideal,1)) && (j==size(ideal,2)))
            fprintf(fileID,'\n');
        end
    end
end
fclose(fileID);
%
%templates
fileID = fopen('rom_files/ram_templates.coe','w');

fprintf(fileID,'memory_initialization_radix=2;\n');
fprintf(fileID,'memory_initialization_vector=\n');

for m=0:13
    [A,B,I,x_bnd,u_bnd] = cnn_template(m,0);
    for i=1:size(A,1)
        for j=1:size(A,2)
            fprintf(fileID,'%s\n',dec2bin(typecast(int16(A(i,j)*(2^bus_f)),'uint16'),16));
        end
    end
    for i=1:size(B,1)
        for j=1:size(B,2)
            fprintf(fileID,'%s\n',dec2bin(typecast(int16(B(i,j)*(2^bus_f)),'uint16'),16));
        end
    end
    fprintf(fileID,'%s\n',dec2bin(typecast(int16(I*(2^bus_f)),'uint16'),16));
    fprintf(fileID,'%s\n',dec2bin(typecast(int16(x_bnd*(2^bus_f)),'uint16'),16));
    fprintf(fileID,'%s',dec2bin(typecast(int16(u_bnd*(2^bus_f)),'uint16'),16));
    if ~(m==13)
        fprintf(fileID,'\n');
    end
end
fprintf(fileID,';');
fclose(fileID);
%
