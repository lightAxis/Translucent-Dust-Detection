%% 국룰
clear;
clc;
%% 웹캠 인풋
cam = webcam(1);

%% 기본적인 클래스 내 처리
dust = DustDetection;

while(true)
    A = snapshot(cam);
    A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
    A_denoised = A;
    imwrite(A_denoised,"main images\denoised.jpg");
    % 메디안 필터 사이즈 파라미터
    medi_size = 5;
    [A_medi, A_merged] = dust.seperate_dust(A_denoised,medi_size);
    
    % 쓰레시홀드 파라미터
    diff = 20;
    A_merged_th = dust.thresholding(A_merged,diff);
    %figure(1);
   % imshow(A_denoised);
    figure(2);
    imshow(A_merged_th);
end

clear('cam');
