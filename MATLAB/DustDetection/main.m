%% 국룰
clear;
clc;

%% 기본적인 클래스 내 처리
dust = DustDetection;
A = imread("시편사진들2\레퍼런스1.jpg");
%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;
figure(99);
imshow(A_denoised);
imwrite(A_denoised,"main images\denoised.jpg");
% 메디안 필터 사이즈 파라미터
medi_size = 31;
[A_medi, merim] = dust.seperate_dust(A_denoised,medi_size);

% 쓰레시홀드 파라미터
diff = 10;
mer_th_im = dust.thresholding(merim,diff);

%% 오리지날 사진
figure(1);
imshow(A);
imwrite(A,"main images\original.jpg")
%% 메디안 필터 적용됨
figure(2);

imwrite(A_medi,"main images\G_medi.jpg");
imshow(A_medi);
%% 머지드
figure(3);
imshow(merim);
imwrite(merim,"main images\G_merged.jpg");
%% 쓰레숄드 적용
figure(4);
imshow(mer_th_im)
imwrite(mer_th_im,"main images\G_mergedThresh.jpg");

%% 통계 관련
% 히스토그램 합칠 너비 파라미터
histMerge_size =31;
[dustandpx_hist_ori, dustandpx_hist, dustperpx_hist] = dust.histograms(A_medi,mer_th_im,histMerge_size);

%% total, none-dust, dust 히스토그램
figure(5);
areas = dustandpx_hist';
hold off;
area(areas(:,1));
hold on;
area(areas(:,2));
area(areas(:,3));
title(strcat("total-dust pixels histogram, mergeSize=",num2str(histMerge_size,2)));
legend("Total","Not Dust","Dust");
xlabel("background brightness");
ylabel("pixel count");
hold off;


%% 모비율, 99% 확률추정
figure(6);
areas = dustperpx_hist';
hold off;
area(areas(:,3));
hold on;
area(areas(:,1));
area(areas(:,2));
title("dust-total pixel 모비율 graph");
legend("모비율 99% 추정 최대","모평균 중앙","모비율 99% 추정 최소");
xlabel("background brightness");
ylabel("dust probability");

%% 확률추정구간 길이에 threshold 적용
figure(7);
% 99%추정구간 길이 문턱값 파라미터
sectionThresh = 0.001;
dustperpx_hist_thresh = dust.sectionThresholding(dustperpx_hist,sectionThresh);

areas = dustperpx_hist_thresh';
hold off;
area(areas(:,3));
hold on;
area(areas(:,1));
area(areas(:,2));
title(strcat("dust-total pixel 모비율 graph, 추정구간 Thresh=",num2str(sectionThresh,3)));
legend("모비율 99% 추정 최대","모평균 중앙","모비율 99% 추정 최소");
xlabel("background brightness");
ylabel("dust probability");


%% 99%확률추정 최소값이 젤 높은거의 p를 선택, g는 해당 grayscale level
figure(8);
[p,g] = dust.selectP(dustperpx_hist_thresh);
[p,g]

%% 해당 p를 계산하는데 사용된 grayscale 레벨을 가진 영역 표시
area_logical = zeros(size(mer_th_im),'logical');
area_outline = zeros(size(mer_th_im),'logical');

% 해당 구역 반전시킨 디텍션 결과
for i=1:1:size(mer_th_im,1)
    for j=1:1:size(mer_th_im,2)
        temppx = mer_th_im(i,j);
        tempbg = A_medi(i,j);
        if (g-(histMerge_size-1)/2 <=tempbg) && (tempbg<=g+(histMerge_size-1)/2)
            area_logical(i,j) = true;
        end
    end
end
imshow(area_logical);

% 해당 구역 표시한 사진
figure(9);
area_withbg = cat(3,A_medi,A_medi,A_medi);
A_gray = rgb2gray(A);
imwrite(A_gray,"main images\A_gray.jpg");
area_original = cat(3,A_gray,A_gray,A_gray);
area_detection = cat(3,mer_th_im,mer_th_im,mer_th_im);

for i=2:1:size(mer_th_im,1)-1
    for j=2:1:size(mer_th_im,2)-1
        curlog = area_logical(i,j);
        curlog_up = area_logical(i-1,j);
        curlog_left = area_logical(i,j-1);
        
        if curlog~=curlog_up 
           if(curlog == true)
              area_outline(i-1,j) = true; 
           else
               area_outline(i,j) = true; 
           end
        end
        
        if curlog ~= curlog_left
           if curlog == true
              area_outline(i,j-1) = true; 
           else
               area_outline(i,j) = true;
           end
        end
    end
end

for i=1:1:size(area_outline,1)
   for j=1:1:size(area_outline,2) 
       if(area_outline(i,j) == true)
          area_withbg(i,j,:) = [255 0 0];
          area_original(i,j,:) = [255 0 0];
          area_detection(i,j,:) = [255 0 0];
       end
       
       if(area_logical(i,j) == true)
           area_withbg(i,j,:) = [area_withbg(i,j,1)*1.5,area_withbg(i,j,2) area_withbg(i,j,3)];
          area_original(i,j,:) = [area_original(i,j,1)*1.5 area_original(i,j,2) area_original(i,j,3)];
          area_detection(i,j,:) = [0.4 area_detection(i,j,2) area_detection(i,j,3)];

       end
   end
end

imshow(area_original);
imwrite(area_original,"main images\area_original.jpg");
figure(10);
imshow(area_withbg);
imwrite(area_withbg,"main images\area_withbg.jpg");
figure(11)
imshow(area_detection);
imwrite(area_detection,"main images\area_detection.jpg");







