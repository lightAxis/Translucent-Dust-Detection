%% 국룰
clc;
clear all;

%% 변수 세팅

mask_full = "DustGenerator\";
original_full = "촬영사진들\";
save_full = "촬영사진들_dusted\";

mask_num = 8;
pictype = 2;
focus = 8;

base_alpha = 255;

%% 메인


for i = 1:1:pictype
    for j=0:1:focus
        for k=1:1:mask_num
        dust_mask = imread(strcat(mask_full,'DustMask_',num2str(k),'.png'));
        % 이미지 로딩
        filename = strcat('사진',num2str(i),'_흐림',num2str(j));
        filename_full = strcat(original_full,filename,'.jpg');
        image = imread(filename_full);
        
        % none local maximum 필터 사용. 웹캠이 이상하게 나옴      
        image = imnlmfilt(image,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
        
        % 이미지에 인조 dustmask 씌움
        image_gray = rgb2gray(image);
        blended_image = blendBackgroundWithDustMask(image_gray,dust_mask,base_alpha);
        imwrite(blended_image, strcat(save_full,filename,'_M',num2str(k),'.png'),'Mode','Lossless');
        
        figure(1);
        imshow(blended_image);
        figure(2);
        imshow(image_gray);
        filename_full
        
        end
    end
end

