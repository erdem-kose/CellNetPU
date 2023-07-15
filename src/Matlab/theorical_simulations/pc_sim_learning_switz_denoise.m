clc;clearvars -except serial_obj;format('long');
addpath(genpath('..'));
addpath(genpath('../func_cnn'));
addpath(genpath('../func_fpga'));
addpath(genpath('../func_image'));

%cnn configuration
iter=10;
Ts=0.01;
learn_loop=1000;
learn_rate=0.1;

patch_size=3;
patch_mid=(patch_size+1)/2;
A=zeros(patch_size,patch_size);
B=zeros(patch_size,patch_size);
I=0;
x_bnd=0;
u_bnd=0;

%reading image and ideal
imagefiles = dir('../images/standard/*.tif');      
nfiles = length(imagefiles);

for i=1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = gray_read(currentfilename);
   
   %read input
   gray_im{i} = currentimage;
   gray_im{i}=imresize(gray_im{i},[128 128],'bicubic');
   %generate input
   u{i}=imnoise(gray_im{i},'gaussian',0,0.025);
   u{i}=2*(u{i})-1;
   %generate ideal
   ideal{i}=wiener2((u{i}+1)/2,[patch_size patch_size]);
   %ideal{i}=gray_im{i};
   ideal{i}=2*ideal{i}-1;
end


%figure configuration
ssarray=zeros(1,nfiles);

f = figure;
tabgp = uitabgroup(f);

%cnn calculation
for i=1:nfiles
    x_new=0;
    
    for j=1:learn_loop
        x_new=0;
        [x_new,x_normal,~] = cnn_system( A,B,I,x_bnd,u_bnd, u{i}, x_new, Ts, iter, 'cpu');
        
        error_map=((1/2)*(ideal{i}-x_new));
        
        delta=(learn_rate*error_map)/(size(error_map,1)*size(error_map,2));
        
        for k=1:patch_size
            for l=1:patch_size
                da=sum(sum(delta.*circshift(x_new,[patch_mid-k patch_mid-l])));
                A(k,l)=A(k,l)+da;
                db=sum(sum(delta.*circshift(u{i},[patch_mid-k patch_mid-l])));
                B(k,l)=B(k,l)+db;
            end
        end
        DI=sum(sum(delta));
        I=I+DI;
    end
    
    [ssimval, ssimmap] = ssim(x_new,double(ideal{i}));
    ssarray(i)=100*ssimval;
    
    tab{i} = uitab(tabgp,'Title',imagefiles(i).name);
    tab{i}.BackgroundColor = [1 1 1];
    axes('parent', tab{i});
    
    subplot(2,3,1)
    imshow((u{i}+1)/2)
    title('Input')
    
    subplot(2,3,2)
    imshow(x_normal)
    title('CNN')
    
    subplot(2,3,3)
    imshow((ideal{i}+1)/2)
    title('Ideal')
    
    subplot(2,2,3)
    imshow(ssimmap)
    title('Structural Similarity Map')
    
    subplot(2,2,4)
    plot(ssarray(1:i))
    axis([1 nfiles 0 100])
    grid on
    ylabel('% Structural Similarity');
    xlabel('Sample Count');
    title(sprintf('Structural Similarity=%%%f%',ssarray(i)))
end
