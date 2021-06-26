function [score, new_plot] = background_ignore_score(background_ignore_plot)
    new_plot = zeros(size(background_ignore_plot));
    
    new_plot(1,:) = flip(rescale(background_ignore_plot(1,:)));
    new_plot(2,:) = flip(rescale(background_ignore_plot(2,:)));
    
    plot_size = size(background_ignore_plot,2);
    
    score_sum = 0;
    for i=1:1:plot_size-1
        xi = new_plot(2,i);
        xi_1 = new_plot(2,i+1);
        
        yi = new_plot(1,i);
        yi_1 = new_plot(1,i+1);
        
        score_sum = score_sum + (xi_1 - xi)*(yi_1+yi)/2 ;
    end
    
    score = score_sum;
end