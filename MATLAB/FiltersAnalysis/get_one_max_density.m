
function max_density = get_one_max_density(image)

target_hor = 1280;
target_ver = 720;

grid_length = 40;

verseg = target_ver/grid_length;
horseg = target_hor/grid_length;

dust = DustDetection_v3_1;

A_ = image;
s = size(A_);
s = s/2;
A = A_((s(1) - target_ver/2):(s(1)+target_ver/2-1),(s(2) - target_hor/2):(s(2)+target_hor/2-1), :);

%A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_denoised = A;
%%A = imresize(A,[720,1280]);

medi_size = 5;
[A_merged, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);


diff = 6;
A_merged_th = dust.thresholding(A_merged,diff);
figure(1);
imshow(A_denoised);

dead_dist = 0.1;
radius = -1;
[final_pos, final_pos_struct, all_pos, radius]= dust.mean_shift(A_merged_th,verseg,horseg,radius,dead_dist);

[maximum_density] = dust.get_maximum_dustDensity_withMeanShift(final_pos_struct, radius, A_merged_th,true);
max_density = maximum_density;

circle_available = true;
frame_sec = 0.1;
%dust.visualize_mean_shift(A_merged_th,all_pos,radius,frame_sec,circle_available)
end
