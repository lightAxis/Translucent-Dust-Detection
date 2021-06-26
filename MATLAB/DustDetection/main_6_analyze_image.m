%% 국룰
clc;
clear all;

%% 파라미터 설정

target_hor = 1280;
target_ver = 720;

grid_length = 40;

verseg = target_ver/grid_length;
horseg = target_hor/grid_length;

%% 메인

dust = DustDetection_v3_2;
A = imread("실제창문사진들\실제창문_더러움1_a.jpg");
A = imresize(A,[720,1280]);

%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;
%figure(1);
%imshow(A_denoised);
figure(1)
imshow(A_denoised);

medi_size = 5;
[A_merged, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);

diff = 6;
A_merged_th = dust.thresholding(A_merged,diff);

figure(2)
imshow(A_merged_th)

%figure(2);
%imshow(A_merged_th);

dead_dist = 0.1;
radius = -1;
[final_pos, final_pos_struct, all_pos, radius]= dust.mean_shift(A_merged_th,verseg,horseg,radius,dead_dist);

[maximum_density, maximum_density_dots] = dust.get_maximum_dustDensity_withMeanShift(final_pos_struct, radius, A_merged_th,false);
disp(maximum_density);

circle_disp_struct  = generate_circle_struct(maximum_density_dots,[0 255 0]);
A_merged_th_color = uint8( A_merged_th(:,:,[1 1 1]) * 255 );
A_merged_th_color = draw_circles(A_merged_th_color, circle_disp_struct);
figure(3);
imshow(A_merged_th_color);

imwrite(A_merged_th_color,"temp.png");


function drawn_image = draw_circles(image, circle_structs)

th = 0:pi/1000:2*pi;
drawn_image = image;
image_size = size(image);

for i = 1:1:size(circle_structs,2)
    circle = circle_structs{i};
    
    hunit = round(circle.r * cos(th) + circle.h);
    vunit = round(circle.r * sin(th) + circle.v);
    
    for i2=1:1:size(hunit,2)
        
        if (vunit(i2)< 1) || (vunit(i2)> image_size(1))
            continue;
        elseif (hunit(i2)< 1) || (hunit(i2)> image_size(2))
            continue;
        end
        
        drawn_image(vunit(i2),hunit(i2),:) = circle.color_rgb;
    end
end
end

function drawn_image = draw_text(image, v, h, text)
drawn_image = insertText(image,[v h],text,'FontSize',18);
end

function struct = generate_circle_struct(circle_matrix, color_rgb)
struct = {};
for i=1:1:size(circle_matrix,1)
    temp_struct = [];
    temp_struct.v = circle_matrix(i,1);
    temp_struct.h = circle_matrix(i,2);
    temp_struct.r = circle_matrix(i,4);
    temp_struct.color_rgb = color_rgb;
    struct{end+1} = temp_struct;
end

end