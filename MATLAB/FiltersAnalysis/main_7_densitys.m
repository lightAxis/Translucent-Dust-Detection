%% 국룰
%clc;
clear all;

%% 파라미터 지정

filesFolder = "실사들";

D_numbers = 5;
image_numbers_per_D = 12;

%% 메인

max_densities = zeros([D_numbers image_numbers_per_D]);

for D = 1:1:D_numbers
    for i=1:1:image_numbers_per_D
        D
        i
        
        fileLoadPath = strcat(filesFolder,"\D",num2str(D),"\",num2str(i),".png");
        
        image = imread(fileLoadPath);
        max_density = get_one_max_density(image);
        
        max_densities(D, i) = max_density;
    end
end

max_densities_normalized = [];
StandardDeviation = zeros([1 D_numbers]);

figure(50);
for D = 1:1:D_numbers
    temp = max_densities(D,:);
    temp = temp/mean(temp);
    max_densities_normalized(D,:) = temp;
    StandardDeviation(D) = sqrt(var(temp));
    subplot(2,3,D);
    plot(1:1:image_numbers_per_D, max_densities_normalized(D,:));
    ylim([0 2]);
end
a = []
for i=1:1:size(max_densities,1)
   a = [a mean(max_densities(i,:))];
end