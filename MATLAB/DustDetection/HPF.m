clc;
clear all;
close all;

Filter = [-1 -1 -1
    -1 9 -1
    -1 -1 -1];

A_ = imread("original images\사진1.jpg");
A = rgb2gray(A_);
B_ = imread("original images\사진2.jpg");
B = rgb2gray(B_);

figure(1);
imshow(B_);
imwrite(B_,"HPF code image\B_.jpg");


figure(2);
%subplot(3,1,1);
imshow(B);
imwrite(B,"HPF code image\B.jpg");

figure(3);
B_Filtered = imfilter(B,Filter);
%subplot(3,1,2);
imshow(B_Filtered);
imwrite(B_Filtered,"HPF code image\B_Filtered.jpg");

figure(4);
B_sub = B_Filtered - B;
%subplot(3,1,3);
imshow(B_sub)
imwrite(B_sub,"HPF code image\B_sub.jpg");

figure(5);
B_medi = medfilt2(B,[15 15]);
imshow(B_medi)
imwrite(B_medi,"HPF code image\B_medi.jpg");

figure(6);
B_sub2 = B - B_medi;
imshow(B_sub2);
imwrite(B_sub2,"HPF code image\B_sub2.jpg");

figure(7);
B_sharp = imfilter(B_sub2,Filter);
imshow(B_sharp);
imwrite(B_sharp,"HPF code image\B_sharp.jpg");

figure(10);
B_sub2inv = B_medi - B;
imshow(B_sub2inv)
imwrite(B_sub2inv,"HPF code image\B_sub2inv.jpg");

figure(11);
B_sharpinv = imfilter(B_sub2inv,Filter);
imshow(B_sharpinv)
imwrite(B_sharpinv,"HPF code image\B_sharpinv.jpg")

figure(12);
B_merged = B_sharp + B_sharpinv;
imshow(B_merged);

figure(13);
B_merged2 = B_sub2 + B_sub2inv;
imshow(B_merged2);
imwrite(B_merged2,"HPF code image\B_merged2.jpg");

figure(14);
B_merged2sharp = imfilter(B_merged2,Filter);
imshow(B_merged2sharp)
imwrite(B_merged2sharp,"HPF code image\B_merged2sharp.jpg");

figure(15);
B_merged2sharpThreshold = zeros(size(B_merged2sharp));
for i=1:1:size(B_merged2sharp,1)
    for j=1:1:size(B_merged2sharp,2)
        px = B_merged2sharp(i,j);
        
        if (px<50)
            B_merged2sharpThreshold(i,j) = 0;
        else
            B_merged2sharpThreshold(i,j) = px;
        end
    end
end
imshow(B_merged2sharpThreshold)
imwrite(B_merged2sharpThreshold,"HPF code image\B_merged2sharpThreshold.jpg")

figure(16)
B_binary = imbinarize(B_merged2sharp);
imshow(B_binary);
imwrite(B_binary,"HPF code image\B_binary.png")




