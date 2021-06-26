function [bg_y1, bg_y2, bg_x1, bg_x2] = genTestBackground(size)

y_len = size(1);
x_len = size(2);

bg_y1 = uint8(zeros([y_len x_len]));
bg_y2 = bg_y1;
bg_x1 = bg_y2;
bg_x2 = bg_x1;


for y=1:1:y_len
    for x=1:1:x_len
        bg_x1(y,x) = uint8(round(((y/y_len)*255.0)));
        bg_x2(y,x) = uint8(round(((1-(y/y_len))*255.0)));
        
        bg_y1(y,x) = uint8(round(((x/x_len)*255.0)));
        bg_y2(y,x) = uint8(round(((1-(x/x_len))*255.0)));
    end
end


end