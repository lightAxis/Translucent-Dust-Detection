%% 국룰
clc;
clear all;

%% 파라미터들

image_size = [720 1280];
path_full = '인조배경\';
mask_path_full = 'DustGenerator\';

dust_mask_num = 1;

%% 메인
[bg_y1, bg_y2, bg_x1, bg_x2] = genTestBackground(image_size);

imwrite(bg_y1, strcat(path_full,'bg_y1.png'),'Mode','Lossless');
imwrite(bg_y2, strcat(path_full,'bg_y2.png'),'Mode','Lossless');
imwrite(bg_x1, strcat(path_full,'bg_x1.png'),'Mode','Lossless');
imwrite(bg_x2, strcat(path_full,'bg_x2.png'),'Mode','Lossless');

mask = imread(strcat(mask_path_full,'DustMask_',num2str(dust_mask_num),'.png'));

imwrite(blendBackgroundWithDustMask(bg_y1,mask,255),strcat(path_full,'bg_y1_dusted.png'),'Mode','lossless');
imwrite(blendBackgroundWithDustMask(bg_y2,mask,255),strcat(path_full,'bg_y2_dusted.png'),'Mode','lossless');
imwrite(blendBackgroundWithDustMask(bg_x1,mask,255),strcat(path_full,'bg_x1_dusted.png'),'Mode','lossless');
imwrite(blendBackgroundWithDustMask(bg_x2,mask,255),strcat(path_full,'bg_x2_dusted.png'),'Mode','lossless');


