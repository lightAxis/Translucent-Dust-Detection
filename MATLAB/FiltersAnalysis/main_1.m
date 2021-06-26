%% 국룰
clc;
clear all;

%% 파라미터들

medianfilterThresh = 10;
pictype = 2;
focus = 8;

original_full = '촬영사진들\';
save_full = '촬영사진들 결과 데이터\';
%%
filename = "";
filenames = [];
sharpnesses = [];
scores = [];

all_images = {};

asdf = 1;

for i = 1:1:pictype
    for j=0:1:focus
        
        filename = strcat('사진',num2str(i),'_흐림',num2str(j),'.jpg');
        filename_full = strcat(original_full,filename);
        image = imread(filename_full);
        % none local maximum 필터 사용. 웹캠이 이상하게 나옴
        image = imnlmfilt(image,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
        filenames = [filenames ; filename];
        
        [sharpness graph] = imgSharpness(image,true,false);
        sharpnesses = [sharpnesses ; sharpness];
        
        [sobel_, prewitt_, canny_, median_,gauss_, image] = edgeDetection(image,medianfilterThresh,false);
        all_images{asdf} = sobel_;
        asdf = asdf+1;
        
        score_ = [score(sobel_), score(prewitt_), score(canny_), score(median_), score(gauss_)];
        scores = [scores ; score_];
    
        
        imwrite(image,strcat(save_full,filename,"_gray_",num2str(sharpness),".png"));
        imwrite(sobel_,strcat(save_full,filename,"_sobel_",num2str(scores(1)),".png"));
        imwrite(prewitt_,strcat(save_full,filename,"_prewitt_",num2str(scores(2)),".png"));
        imwrite(canny_,strcat(save_full,filename,"_canny_",num2str(scores(3)),".png"));
        imwrite(median_,strcat(save_full,filename,"_median_",num2str(scores(4)),".png"));
        imwrite(median_,strcat(save_full,filename,"_gauss_",num2str(scores(5)),".png"));
        
        figure(99)
        set(gcf, 'Position',  [300, 200, 1280, 720])
        set(gca, 'Visible', 'off');
        colorbar('off');
        imagesc(graph);
        saveas(gcf,strcat(save_full,filename,"_fft.jpg"));
    end
end

filenames = cellstr(filenames);
sharpnesses = num2cell(sharpnesses);
scores = num2cell(scores);
body = [filenames sharpnesses scores];

index = {'filename','FM score','sobel','prewitt','canny','median','gauss'};
full_excel = [index ; body];

xlswrite(strcat(save_full,"result.xls"),full_excel);

%% 이미지 보기

for i=1:1:9
   detection = all_images{i}; 
   detection = detection(2:end-1,2:end-1);
   figure(i)
   imhist(detection);
end




%% 함수들 짱박아놓기

function a = score(image)
size_y = size(image,1);
size_x = size(image,2);

a = 0;
for y=1:1:size_y
    for x=1:1:size_x
        a = a + double(image(y,x))/255.0;
    end
end

a = (size_x * size_y - a)/(size_x * size_y);

end