function gray_im = gray_read(image_address)
    temp_im=imread(image_address);
    if size(temp_im,3)==3
        gray_im=(cast(rgb2gray(temp_im),'double')/255);
    else
        gray_im=(cast(temp_im,'double')/255);
    end
end