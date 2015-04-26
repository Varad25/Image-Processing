%% 4th Order PDE
clear all;
close all;

%% Reading Image and adding gaussian noise
I_read = imread('lena.jpg');
I = double(I_read);
i_n = imnoise(I_read,'gaussian', 0,0.005);
i_n = double(i_n);
imshow(uint8(i_n));
%SNR of the noisy Image
Noisy_Image_snr = SNR(I,i_n-I)
title('Noisy Image')

%% Declaring stopping criteria and other parameters
tol = -Inf;
dt=0.25;
T = 9500;
%T = 500:1000:10000;

%% Running algorithm
tic
for i = 1:1:size(T,2)
    I1=i_n;
    for  t=1:T(i)
        [Ix,Iy]=gradient(I1); 
        [Ixx,Iyt]=gradient(Ix);
        [Ixt,Iyy]=gradient(Iy);
        c = (Ixx + Iyy)./(1 + (2*(Ixx+Iyy)).^2);
        [div1, div2] = gradient(c);
        [div11,div12] = gradient(div1);
        [div21,div22] = gradient(div2);
        div = div11+div22;
        I1 = I1 - dt.*(div);
    end
    Denoised_Image_snr(i) = SNR(I,I1-I);
     if(Denoised_Image_snr(i)>tol)
            tol = Denoised_Image_snr(i);
            I_best = I1;
     end
end
toc

%% Displaying the best result

figure
imshow(uint8(I_best));
title('Denoised Image')

%% Plotting SNR versus number of iterations

figure
plot(500:1000:10000,Denoised_Image_snr)
title('SNR versus number of iterations')
xlabel('Number of iterations')
ylabel('SNR')

%% Removal of speckle noise and displaying the result
 I_speckle = medfilt2(I_best);
 
 figure
 imshow(uint8(I_speckle));
 title('Denoised Image with Median filter')