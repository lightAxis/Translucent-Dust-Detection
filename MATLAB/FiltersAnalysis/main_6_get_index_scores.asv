%% 국룰
clc;
clear all;

%% 파라미터들
medianfilterThresh = 0;

masknum = 8;
focusnum = 8;
bg_num = 2;
method_num = 4;

picNum = 2;
focusNum = 8;


%% 메인
all_detection_results = {};
all_histogram = {};

images = get_all_dusted_arimage(picNum, focusNum, masknum);
images_bg = get_all_bgimage(picNum, focusNum);

dustmaskPath = "DustGenerator\";
dustmaskName = "DustMask";

%% 모든 이미지 임포트 후, threshold accuracy plot 계산
for b=1:1:bg_num
    for f=1:1:focusnum
        for M=1:1:masknum
        b,f,M
        image = images{b,f,M};
        [sobel_, prewitt_, canny_, median_,gauss_, image] = edgeDetection(image,medianfilterThresh,true);
        all_detection_results{b,f,M,1} = sobel_;
        all_detection_results{b,f,M,2} = prewitt_;
        % all_detection_results{i,j,3} = canny_;
        all_detection_results{b,f,M,3} = median_;
        all_detection_results{b,f,M,4} = gauss_;
        % all_detection_results{i,j,5} = image;
        
        dust_mask_binary = get_dustmask_binary(dustmaskPath, dustmaskName, M);
        for m=1:1:method_num
            all_histogram{b,f,M,m} = imhist(all_detection_results{b,f,M,m});
            
            all_threshold_accuracy_plots{b,f,M,m} = threshold_accuracy_plot(all_detection_results{b,f,M,m}, dust_mask_binary);
            [min_th, max_th, representative_accuracy] = threshold_accuracy_plot_anlys(all_threshold_accuracy_plots{b,f,M,m});
            all_representative_accuracy{b,f,M,m} = representative_accuracy;
            
        end
        
        end
    end
end

%% average_accracy- threshold plot을 계산하고, 이를 바탕으로 dust seperation score를 계산함
for b=1:1:bg_num
    for m=1:1:method_num
        
        average_accuracy_plot = zeros([1 256]);
        
        for t=1:1:256
            temp_sum2 = 0;

            for M=1:1:masknum
                temp_sum = 0;
                for f=1:1:focusNum
                    temp_sum = temp_sum + all_threshold_accuracy_plots{b,f,M,m}(t);
                end
                temp_sum2 = temp_sum2 + (temp_sum / focusNum);
            end
            average_accuracy = temp_sum2/masknum;
            average_accuracy_plot(t) = average_accuracy;
        end
        
        
        
        all_average_accuracy{b, m} = average_accuracy_plot;
        
    end
end

for m=1:1:method_num
    
    temp_plot = zeros([1 256]);
    for b=1:1:bg_num
        temp_plot = temp_plot + all_average_accuracy{b, m};
    end
    temp_plot = temp_plot / bg_num;
    
    all_threshold_accuracy_mean_plot{m} = temp_plot;
    
    a = [];
    [a.score, a.threshold] = max(temp_plot);
    all_dust_seperation_score{m} = a;
    
end


%% 계산된 dust-seperation scores 한번 보여주기 ㅋㅋ


temp_plot = zeros([1 method_num]);
temp_gray = zeros([1 method_num]);

for m=1:1:method_num
    temp_plot(m) = all_dust_seperation_score{m}.score;
    temp_gray(m) = all_dust_seperation_score{m}.threshold;
end

bar([1:method_num],temp_plot);
xlabel('method');
ylabel('dust seperation score');
ylim([ 0.85 0.95]);
title('dust seperation score');
names = ["sobel" "prewitt" "median" "gaussian"];
set(gca,'xtick',[1:method_num],'xticklabel',names);

temp_gray


%% background sharpness - seperation accuracy계산
% seperation accuracy의 binary image 기준을 잡을 threshold는 dust_seperation
% score꺼로 해봄
all_image_sharpness = {};

for b=1:1:bg_num
    for f=1:1:8
        all_image_sharpness{b,f} = imgSharpness(images_bg{b,f}, false,true);
    end
end


for m=1:1:method_num
    
    for b=1:1:bg_num
        temp_plot2 = zeros([bg_num focusNum]);
        for M=1:1:masknum
            temp_plot = zeros([2 8]);
            for f=1:1:focusNum
                t = all_dust_seperation_score{m}.threshold;
                temp_plot(1,f) = all_threshold_accuracy_plots{b,f,M,m}(t);
                temp_plot(2,f) = all_image_sharpness{b,f};
            end
            temp_plot2 = temp_plot2 + temp_plot;
        end
        
        temp_plot2 = temp_plot2/masknum;
        all_sharpness_accuracy_plot{b,m} = temp_plot2;
        
        
        
    end
    
end

%% background sharpness - seperation accuracy plot 하기

for b=1:1:bg_num
    figure(b);
    sgtitle(strcat('FM-SA plot (bg set ',num2str(b),')'));
    
    methods_name = ["sobel","prewitt","median","gaussian"];
    for m=1:1:method_num
        
        subplot(2,2,m);
        temp_plot = all_sharpness_accuracy_plot{b,m}(1,:);
        temp_plot_x = all_sharpness_accuracy_plot{b,m}(2,:);
        plot(temp_plot_x,temp_plot);
        xlabel('background sharpness');
        ylabel('dust seperation accuracy');
        title( methods_name(m));
    end
    
end

%% rescale to background_ignore score
for b=1:1:bg_num
    for m=1:1:method_num
        [score, new_plot] = background_ignore_score(all_sharpness_accuracy_plot{b,m}); 
        
        all_rescaled_sharpness_accuracy_plot{b,m} = new_plot;
        all_background_ignore_score{b,m} = score;
    end
end

%% rescale 된 background sharpness - seperation accuracy plot하기

for b=1:1:bg_num
    figure(b);
    sgtitle(strcat('rescaled FM-SA plot (bg set ',num2str(b),')'));
    methods_name = ["sobel","prewitt","median","gaussian"];
    
    for m=1:1:method_num
        
        subplot(2,2,m);
        
        temp_plot = all_rescaled_sharpness_accuracy_plot{b,m}(1,:);
        temp_plot_x = all_rescaled_sharpness_accuracy_plot{b,m}(2,:);
        plot(temp_plot_x,temp_plot);
        xlabel('background sharpness');
        ylabel('dust seperation accuracy');
        title( methods_name(m));
    end
    
end


%% background ignore score plot하기

temp_plot = zeros([bg_num method_num]);
temp_plot_x = zeros([1 method_num]);
temp_plot_mean = zeros([1 method_num]);
leg =[""];
for b = 1:1:bg_num
    for m=1:1:method_num
        temp_plot(b,m) = all_background_ignore_score{b,m};
    end
    
    leg(b) = strcat("bg image ",num2str(b));
end



for m=1:1:method_num
    temp_plot_mean(m) = mean(temp_plot(:,m));
end


figure(1);
sgtitle("");
subplot(1,1,1);

plot([1:method_num],temp_plot);
xlabel('method');
ylabel('background ignore score');
legend(leg);
title('background ignore score plots');
names = ["sobel" "prewitt" "median" "gaussian"];
set(gca,'xtick',[1:method_num],'xticklabel',names);

figure(2);
sgtitle("");
subplot(1,1,1);

bar([1:method_num],temp_plot_mean);
xlabel('method');
ylabel('background ignore score');
title('background ignore score');
names = ["sobel" "prewitt" "median" "gaussian"];
set(gca,'xtick',[1:method_num],'xticklabel',names);


%% 테스트 코드들

for b=1:1:8
    figure(b);
    plot(all_threshold_accuracy_plots{1,b,1});
end

%% 나머지

function binary = get_dustmask_binary(maskPath, maskName, maskNum)
    dust_mask = imread(strcat(maskPath,maskName,"_",num2str(maskNum),'.png'));
    binary = (dust_mask(:,:)>0);
end

function images = get_all_dusted_arimage(picNum, focusNum, maskNum)
images = {};

original_full = '촬영사진들_dusted\';
save_full = '촬영사진들 결과 데이터\';

for p=1:1:picNum
    for f=1:1:focusNum
        for M=1:1:maskNum
        filename = strcat('사진',num2str(p),'_흐림',num2str(f),'_M',num2str(M),'.png');
        filename_full = strcat(original_full,filename);
        image = imread(filename_full);
        images{p,f,M} = image;
        end
    end
end

end

function images_bg = get_all_bgimage(picNum, focusNum)
images_bg = {};

original_full = '촬영사진들\';

for p=1:1:picNum
    for f=1:1:focusNum
        filename = strcat('사진',num2str(p),'_흐림',num2str(f),'.jpg');
        filename_full = strcat(original_full,filename);
        image = imread(filename_full);
        image = imnlmfilt(image,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
        image = rgb2gray(image);
        images_bg{p,f} = image;
    end
end

end




