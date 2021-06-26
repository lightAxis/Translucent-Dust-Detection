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