%% set parameters
imagse_size = [1280 1920];
noise_density = 0.001;

saving_path = "generatedNoise.bmp";

%% generate image

image = ones([1280 1920])*255;
image = imnoise(image,'salt & pepper',noise_density);

imshow(image);
imwrite(image,saving_path);
%%
for i = 1:1:1280
   for j = 1:1:1920
      if(image(i, j) == 1)
          image(i, j) = 0;
      else
          image(i, j) = 1;
      end
   end
end

%%
figure(2)
imshow(image)
imwrite(image,"generatedNoise_reversed.bmp");