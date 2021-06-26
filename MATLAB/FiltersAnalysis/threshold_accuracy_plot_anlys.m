function [min_th, max_th, representative_accuracy] = threshold_accuracy_plot_anlys(plot)

representative_accuracy = 0;
max_th = 1;
min_th = 1;

% find max score and max threshold
for t = 1:1:256
    if(plot(t) > representative_accuracy)
       representative_accuracy = plot(t);
       max_th = t;
    end
end

% find min threshold at 95%of maximum score
max_score_95 = uint8(double(representative_accuracy) * 0.95);

for t=max_th:-1:1
    if(plot(t) < max_score_95)
        min_th = t+1;
        break;
    end
end

end