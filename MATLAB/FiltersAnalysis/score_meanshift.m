function [score, hist, process] = score_meanshift(image, points_num, section_length, dead_dist)

%get histogram of image
hist = imhist(image);
hist = hist';

% initialize point position
dist = (256+1) / (points_num + 1);
point_pos = [];
for i=1:1:points_num
   if i== 1
       point_pos(i) = dist-1;
   else
       point_pos(i) = point_pos(i-1) + dist;
   end
end

% get ready for all points
mean_shift_log = [];
process = {};

points = {};
for i=1:1:points_num
   a = [];
   a.centriod = point_pos(i);
   a.points=[];
   a.prev_centroid = point_pos(i);
   a.is_alive = true;
   points(i) = a;
   mean_shift_log = [mean_shift_log [a.centroid; a.is_alive]];
end
process(1) = mean_shift_log;

% do mean shift
section_length_half = (section_length - 1)/2.0;

iter = 2;
while true
    is_all_dead = true;
    mean_shift_log = [];
    
    for i=1:1:points_num
        temp_p = points(i);
        % get each centroid's calculating section considering saturation in
        % 1 ~ 256
        section = [temp_p.centroid - section_length_half temp_p.centroid + section_length_half];
        for ii = 1:1:2
           if section(ii) < 1 
              section(ii) = 1;
           elseif section(ii) >256
              section(ii) = 256;
           end
        end
        section = round(section);
        
        % calc new centroid
        temp_p.points = hist(section(1):1:section(2));
        temp_p.centroid = mean(temp_p.points);
        
        % check is dead
        if abs(temp_p.prev_centroid - temp_p.centroid)<dead_dist
           temp_p.is_alive = false;
        end       
        
        %save current log
        mean_shift_log = [mean_shift_log [temp_p.centroid ; temp_p.is_alive]];
        
        
        is_all_dead = ~(temp_p.is_alive);
    end
    
    %save current iteration log
    process(iter) = mean_shift_log;
    iter = iter + 1;
    
    % if all point is dead, break
    if is_all_dead == true
       break;
    end
    
end



end