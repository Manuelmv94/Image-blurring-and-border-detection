close all;
clear;
r=20;
alpha=100;

im=imread('8_it.jpg');
imBW=rgb2gray(im);
%imshow(imBW);
imageSize=size(imBW);
ConvSize=imageSize*2-1;

ImZeroPadded=[imBW;zeros(imageSize(1)-1,imageSize(2))];%%concatenar filas de ceros
ImZeroPadded=[ImZeroPadded zeros(2*imageSize(1)-1,imageSize(2)-1)];%%concatenar columnas de ceros
imshow(ImZeroPadded);

imspec=fft2(double(ImZeroPadded));
imspec=fftshift(imspec);
%%figure;imagesc(20*log10(abs(imSpec)));

CenPos=(ConvSize+mod(ConvSize,2))/2;

LowPassSQR=zeros(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if((abs(j-CenPos(2))<r) && (abs(i-CenPos(1))<r))
            LowPassSQR(i,j)=1;
        end
    end
end

HighPassSqr=ones(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if((abs(j-CenPos(2))<r) && (abs(i-CenPos(1))<r))
            HighPassSqr(i,j)=0;
        end
    end
end


LowPassCIRCLE=zeros(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if(((j-CenPos(2))^2+(i-CenPos(1))^2)<=r^2)
            LowPassCIRCLE(i,j)=1;
        end
    end
end

HighPassCIRCLE=ones(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if(((j-CenPos(2))^2+(i-CenPos(1))^2)<=r^2)
            HighPassCIRCLE(i,j)=0;
        end
    end
end


LowPassDerivative=zeros(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if(abs(j-CenPos(2))-abs(i-CenPos(1))>r)
            LowPassDerivative(i,j)=1;
        end
    end
end

HighPassDerivative=ones(ConvSize);
for i = 1:ConvSize(1)
    for j = 1:ConvSize(2)
        if(abs(j-CenPos(2))-abs(i-CenPos(1))>r)
            HighPassDerivative(i,j)=0;
        end
    end
end


LowPassGaussian=(gausswin(ConvSize(1),alpha))*(gausswin(ConvSize(2),alpha))';


HighPassGaussian=ones(ConvSize)-LowPassGaussian;

figure();
%%imagesc(LowPassSQR);          %%Blurr
%%imagesc(HighPassSqr);
%%imagesc(LowPassCIRCLE);       %%Blurr
%%imagesc(HighPassCIRCLE);
%%imagesc(LowPassGaussian);       %%Blurr
imagesc(HighPassGaussian);
%%imagesc(LowPassDerivative);   %%detección de bordes
%%imagesc(HighPassDerivative);



ImFiltSpec=(HighPassGaussian.*imspec);
ImFilt=ifft2(ifftshift(ImFiltSpec));
figure();imagesc(real(ImFilt));
colormap gray
% 
colorbar

imsum=ImFilt+double(ImZeroPadded);
figure();imagesc(imsum)
