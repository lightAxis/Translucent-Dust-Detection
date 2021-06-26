%% 국룰
clc;
clear all;

%% 파라미터들
sigma = 0.5;

%% main setting

image_size = [ 512 512];

A = ones(image_size) * 255;
A = uint8(A);


asdf = circle(256,256,128,A);
asdf_1 = imgaussfilt(asdf, sigma);


%% image edge filtering
sobel_ = edge(asdf_1,'sobel');
prewitt_ = edge(asdf_1, 'prewitt');
canny_ = edge(asdf_1, 'canny');

labkernal=[1 1 1;1 -8 1; 1 1 1];
laplacian_=uint8(filter2(labkernal,A,'same'));

median_ = medfilt2(asdf_1,[13 13]);
median_ = abs(median_ - asdf_1);
median_ = im2bw(median_, 0.05);

figure(1)
imshow(asdf_1);

figure(2)
imshow(sobel_);

figure(3)
imshow(prewitt_);

figure(4)
imshow(canny_);

figure(5)
%imshow(laplacian_);

figure(6)
imshow(median_);


%% fill functions

function img= circle(x,y,r,image)
size_y = size(image,1);
size_x = size(image,2);

for y_=1:1:size_y
   for x_=1:1:size_x
       if sqrt((x-x_)*(x-x_) + (y-y_)*(y-y_)) <= r
          image(y_,x_) = 0; 
       end
   end
end

img = image;
end