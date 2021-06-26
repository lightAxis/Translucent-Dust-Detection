A = imread('ÃÔ¿µ»çÁøµé\»çÁø1_Èå¸²8.jpg');

A_denoised = imnlmfilt(A,'DegreeOfSmoothing',10,'ComparisonWindowSize',7);
A_gray = rgb2gray(A_denoised);

[dust_mask] = imgDustGenerate(size(A),127,71,[230 250],[0 2],[1 9]);

A_dusted = blendBackgroundWithDustMask(A_gray, dust_mask);


figure(1)
imshow(A);

figure(2)
imshow(A_denoised);

figure(3)
imshow(A_gray);

figure(4)
imshow(dust_mask);

figure(5)
imshow(A_dusted);


