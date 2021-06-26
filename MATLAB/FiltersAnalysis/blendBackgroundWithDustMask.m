function blended_image = blendBackgroundWithDustMask(image_gray,dust_mask,blend_gray)
y_size = size(image_gray,1);
x_size = size(image_gray,2);

blended_image = uint8(zeros([y_size x_size]));

for y = 1:1:y_size
   for x=1:1:x_size
       base_gray = double(image_gray(y,x));
       mask_gray = double(dust_mask(y,x));
       blended_image(y,x) = uint8(base_gray*(1-mask_gray/255.0) + blend_gray * (mask_gray/255.0));
   end
end


end