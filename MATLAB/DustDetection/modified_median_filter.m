function [new_image, med_sizes] = modified_median_filter(image)
new_image = zeros(size(image));
med_sizes = zeros(size(image));

image_y = size(image,1);
image_x = size(image,2);

for i=1:1:image_y
    for j=1:1:image_x
        med_size = 3;
        
        
        while (true)
            med_edge = (med_size-1)/2;
            ys = [i-med_edge, i+med_edge];
            xs = [j-med_edge, j+med_edge];
            
            ys = min(max(ys,1),image_y);
            xs = min(max(xs,1),image_x);
            
            temp_stack = image(ys(1):ys(2) , xs(1):xs(2));
            temp_stack = reshape(temp_stack,1,numel(temp_stack));
            
            min_ = min(temp_stack);
            max_ = max(temp_stack);
            med_ = median(temp_stack);
            
            A1 = double(med_) - double(min_);
            A2 = double(med_) - double(max_);
            
            if (A1>0) && (A2<0)
                break;
            else
                med_size = med_size + 2;
            end
        end
        
        new_image(i,j) = round(med_);
        med_sizes(i,j) = med_size;
    end
end

new_image = uint8(new_image);
end