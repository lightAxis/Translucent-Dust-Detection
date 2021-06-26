%% 국룰
clear;
clc;

calc_ref = false;

%% 이미지 처리

A = imread("시편사진들2\테스트사진1.jpg");
A = imresize(A,[720,1280]);
A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_gray = rgb2gray(A_denoised);
figure(1)
imshow(A_gray);

[A_mmedi, A_medisizes] = modified_median_filter(A_gray);

figure(2)
imshow(A_mmedi);

A_sub = A_gray - A_mmedi;
A_subinv = A_mmedi - A_gray;
A_merged = A_sub + A_subinv;

resultImg = zeros(size(A_merged));
diff = 30;

for i=1:1:size(A_merged,1)
    for j=1:1:size(A_merged,2)
        px = A_merged(i,j);
        if (px<diff)
            resultImg(i,j) = 0;
        else
            resultImg(i,j) = 1;
        end
    end
end

figure(3)
imshow(resultImg);

%% 일반 메디안 필터 방식이라면?
dust = DustDetection_v2;
medi_size = 3;
[A_merged2, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);
diff = 30;
A_merged_th = dust.thresholding(A_merged2,diff);

figure(4)
imshow(A_gray)
figure(5)
imshow(A_medi)
figure(6)
imshow(A_merged_th)


