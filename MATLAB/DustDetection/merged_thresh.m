function merged_th = merged_thresh(image_path)
dust = DustDetection_v2;
A = imread(image_path);
A = imresize(A,[720,1280]);

A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);

medi_size = 5;
[A_merged, A_medi, A_gray] = dust.seperate_dust(A_denoised,medi_size);

diff = 30;
A_merged_th = dust.thresholding(A_merged,diff);

merged_th = A_merged_th;
end