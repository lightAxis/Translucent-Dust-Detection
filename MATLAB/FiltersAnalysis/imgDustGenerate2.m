function [dust_mask] = imgDustGenerate2(image_sizes,x_split,y_split,dust_thickness,radius,blur_size)

% 이미지 사이즈
x_len = image_sizes(2);
y_len = image_sizes(1);

% 원의 중심점들 위치 계산
all_centers = {};

dots_len = y_split * x_split;
y_seg = randi(y_len, 1, dots_len);
x_seg = randi(x_len, 1, dots_len);

% 랜덤 반지름, 랜덤 블러 커널 사이즈 저장
for i=1:1:dots_len
    a=[];
    a.center = [y_seg(i) x_seg(i)];
    a.radius = randi([radius(1) radius(2)],1);
    a.blur_size = randi([(blur_size(1)-1)/2 (blur_size(2)-1)/2],1);
    a.blur_size = 2*a.blur_size + 1;
    a.im = [];
    all_centers{i} = a;
end

% all_centers에다가 만들어진 임시 원 이미지 저장
for i=1:1:dots_len
    p = all_centers{i};
    
    im_size = p.radius*2 + (p.blur_size-1) + 1;
    im_center = p.radius + (p.blur_size-1)/2 + 1;
    
    % 임시 이미지 초기화
    im = uint8(zeros([im_size im_size]));
    % 원 그리고 채우기
    dust_base_gray = randi(dust_thickness,1);
    for yy=1:1:im_size
        for xx=1:1:im_size
            dist = sqrt((xx-im_center)*(xx-im_center) + (yy-im_center)*(yy-im_center));
            if(dist <= p.radius)
                im(yy,xx) = dust_base_gray;
            end
        end
    end
    
    % 가우스필터 적용해서 이미지
    im = imgaussfilt(im,'FilterSize',p.blur_size);
    p.im = im;
    % 해당 이미지 저장
    all_centers{i} = p;
end

% 만든 이미지들 짜집기. 투명도 적용.
dust_mask = uint8(zeros([y_len x_len]));

for i = 1:1:dots_len
    
    p = all_centers{i};
    c = p.center;
    im = p.im;
    im_half = (size(im,1)-1)/2;
    
    cut_leftup = max(1 -( c - im_half),0);
    cut_rightdown = max((c + im_half) - [y_len x_len],0);
    
    image_cord_y = [c(1) - im_half + cut_leftup(1) , c(1) + im_half - cut_rightdown(1)];
    image_cord_x = [c(2) - im_half + cut_leftup(2) , c(2) + im_half - cut_rightdown(2)];
    
    im_cut = im((1+cut_leftup(1)):1:(size(im,1)-cut_rightdown(1)) , (1+cut_leftup(2)):1:(size(im,2)-cut_rightdown(2)));
    
    for yy=image_cord_y(1):1:image_cord_y(2)
        for xx=image_cord_x(1):1:image_cord_x(2)
            base_gray = double(dust_mask(yy,xx));
            mask_gray = double(im_cut(yy - image_cord_y(1) + 1 , xx - image_cord_x(1) + 1));
            blend_gray = base_gray + mask_gray;
            dust_mask(yy,xx) = uint8(blend_gray);
        end
    end
    
end



end