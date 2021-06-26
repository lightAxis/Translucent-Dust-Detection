function [sharpness graph]=imgSharpness(image, outputfftImage,is_gray)

if nargin <= 1
    outputfftImage = false;
else
    outputfftImage = true;
end

%image = imnlmfilt(image);

if( is_gray == false)
    image = rgb2gray(image);
end
image = double(image)/255.0;

fftimage = fft2(image);
fftimage = abs(fftshift(fftimage));

graph = log(fftimage);

M = max(fftimage);
th = M/1000;
sizes = size(image);
T_H = 0;
for y = 1:1:sizes(1)
   for x = 1:1:sizes(2)
      if (fftimage(y,x)>th)
         T_H = T_H + 1; 
      end
   end
end

sharpness = (T_H) / (sizes(1) * sizes(2)); % Image Quality Measure (FM)

end