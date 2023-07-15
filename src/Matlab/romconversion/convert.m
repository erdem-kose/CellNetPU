clear;clc;

machine_height=128;
machine_width=128;
machine_threshold=0.1;

image=rgb2gray(imread('images/input.png','png'));
image=imresize(image,[machine_height machine_width]);
ideal=edge(image,'Canny',machine_threshold);

subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(ideal)

bus_q=16;
bus_m=5;
bus_f=11;

image=((double(image)/255)*2-1)*(2^bus_f);
ideal=(2*ideal-1)*(2^bus_f);

%images
fileID = fopen('rom_files/ram_generic.init','w');

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

for m=[1 2 3 4 6 7 8 9 10 12 13]
    m_end=13;
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
    if ~(m==m_end)
        fprintf(fileID,'\n');
    end
end
fprintf(fileID,';');
fclose(fileID);
%
Ts=0.1*(2^bus_f);
Ts=sprintf('Ts=%d',uint16(Ts));
disp(Ts);
%zeroes FIFO init file
fileID = fopen('rom_files/fifo_init.coe','w');

fprintf(fileID,'memory_initialization_radix=2;\n');
fprintf(fileID,'memory_initialization_vector=\n');

for i=1:(size(ideal,2)+1)
    fprintf(fileID,'%s',dec2bin(typecast(int16(0),'uint16'),16));
    if ~(i==(size(ideal,2)+1))
        fprintf(fileID,'\n');
    end
end

fprintf(fileID,';');
fclose(fileID);
%
