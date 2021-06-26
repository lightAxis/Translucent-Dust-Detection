%% 국룰
clear;
clc;

%% 기본적인 클래스 내 처리
dust = DustDetection;
A = imread("실제창문사진들\실제창문_더러움1_a.jpg");
%A = imresize(A,[720,1280]);
%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;
imwrite(A_denoised,"main images\denoised.jpg");
% 메디안 필터 사이즈 파라미터
medi_size = 5;
[A_medi, A_merged, A_gray] = dust.seperate_dust(A_denoised,medi_size);

% 쓰레시홀드 파라미터
diff = 8;
A_merged_th = dust.thresholding(A_merged,diff);

% k-means 돌려본 거




%% 오리지날 사진
figure(1);
imshow(A);
imwrite(A,"main images\original.jpg")
%% 흑백된거
figure(2)
imshow(A_gray)
imwrite(A_gray,"main images\gray.png")

%% 메디안 필터 적용됨
figure(3);
imwrite(A_medi,"main images\G_medi.jpg");
imshow(A_medi);
%% 머지드
figure(4);
imshow(A_merged);
imwrite(A_merged,"main images\G_merged.jpg");
%% 쓰레숄드 적용
figure(5);
imshow(A_merged_th)
imwrite(A_merged_th,"main images\G_mergedThresh.jpg");
%% 디노이징 알고리즘 적용했던거
figure(6);
imshow(A_denoised);

%% 





