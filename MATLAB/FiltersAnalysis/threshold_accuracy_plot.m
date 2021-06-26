function [scores] = threshold_accuracy_plot(detection, mask_binary)
scores = zeros([1 256]);

for t = 0:1:255
   detection_binary = (detection(:,:) >= t);
   scores(t+1) = score_xor(detection_binary, mask_binary);
end

end