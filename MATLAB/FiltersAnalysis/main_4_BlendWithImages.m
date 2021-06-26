%% ����
clc;
clear all;

%% ���� ����

mask_full = "DustGenerator\";
original_full = "�Կ�������\";
save_full = "�Կ�������_dusted\";

mask_num = 8;
pictype = 2;
focus = 8;

base_alpha = 255;

%% ����


for i = 1:1:pictype
    for j=0:1:focus
        for k=1:1:mask_num
        dust_mask = imread(strcat(mask_full,'DustMask_',num2str(k),'.png'));
        % �̹��� �ε�
        filename = strcat('����',num2str(i),'_�帲',num2str(j));
        filename_full = strcat(original_full,filename,'.jpg');
        image = imread(filename_full);
        
        % none local maximum ���� ���. ��ķ�� �̻��ϰ� ����      
        image = imnlmfilt(image,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
        
        % �̹����� ���� dustmask ����
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
