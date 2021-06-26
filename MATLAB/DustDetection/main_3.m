%% 국룰
clear;
%clc;

calc_ref = false;

%% 기본적인 클래스 내 처리
dust = DustDetection_v3_1;
A = imread("실제창문사진들\실제창문_더러움3.jpg");
A = imresize(A,[720,1280]);

% denoising 진행
%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;

% 메디안 필터 사이즈 파라미터
medi_size = 5;
[A_merged, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);

% 쓰레시홀드 파라미터
diff = 6;
A_merged_th = dust.thresholding(A_merged,diff);


% mean-shift 돌려본 거
[A_finalPos, A_finalPos_Struct, A_means, radius_] = dust.mean_shift(A_merged_th,15,20,-1,1);






%% 오리지날 사진
figure(1);
imshow(A);
imwrite(A,"main images\original.jpg")

%% 디노이징 알고리즘 적용했던거
figure(2);
imshow(A_denoised);
imwrite(A_denoised,"main images\original_denoised.jpg");
%% 디노이징을 흑백으로
figure(3)
imshow(A_gray);
imwrite(A_gray,"main images\gray.jpg");
%% 메디안 필터 적용됨
figure(4);
imwrite(A_medi,"main images\G_medi.jpg");
imshow(A_medi);
%% 머지드
figure(5);
imshow(A_merged);
imwrite(A_merged,"main images\G_merged.jpg");

%% 쓰레숄드 적용
figure(6);
imshow(A_merged_th);
imwrite(A_merged_th,"main images\G_mergedThresh.jpg");






