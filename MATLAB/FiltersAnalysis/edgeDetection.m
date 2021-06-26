function [sobel_, prewitt_, canny_, median_,gauss_, image] = edgeDetection(image,medianfilterThresh,is_gray)

if (is_gray == false)
    image = rgb2gray(image);
end

sobel_kernal_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_kernal_y = [1 2 1; 0 0 0; -1 -2 -1];
sobel_x = filter2(sobel_kernal_x,image);
sobel_y = filter2(sobel_kernal_y,image);
sobel_ = uint8(sqrt(sobel_x.*sobel_x + sobel_y.*sobel_y));

prewitt_kernal_x = [-1 0 1; -1 0 1; -1 0 1];
prewitt_kernal_y = [1 1 1;0 0 0; -1 -1 -1];
prewitt_x = filter2(prewitt_kernal_x,image);
prewitt_y = filter2(prewitt_kernal_y,image);
prewitt_ = uint8(sqrt(prewitt_x.*prewitt_x + prewitt_y.*prewitt_y));

%[sobel_ th] = edge(image,'Sobel','nothinning');
%prewitt_ = edge(image, 'Prewitt');
canny_ = edge(image, 'Canny');

median_ = medfilt2(image,[5 5]);
median_ = uint8(abs(double(median_) - double(image)));

gauss_ = imgaussfilt(image,'FilterSize',5);
gauss_ = abs(gauss_ - image);

%median_ = im2bw(median_, medianfilterThresh/255.0);

end