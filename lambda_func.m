function [lambda] = lambda_func(noise_estim,label)

lambda = cell(size(noise_estim));
for i = 1:size(noise_estim,1)
    for frame = 1:40
        
            lambda{i}(frame,:) = mean(noise_estim{i}(1:40,:).^2);
    end
end



 for i = 1:size(noise_estim,1)
    for frame = 41:size(noise_estim{1,1},1)
        
        
           
            if label{i}(frame) == 0
                lambda{i}(frame,:) =0.999*(lambda{i}(frame-1,:)) + 0.001*( mean(noise_estim{i}(1:frame,:).^2));
            else
                lambda{i}(frame,:) = lambda{i}(frame-1,:);
            end
        
    end
 end











% landa = cell(size(noise_estim));
% for i =1: size(landa,1)
%     landa{i}(1,:) = noise_estim{i}(1,:).^2;
% end
%  for i = 1:size(noise_estim,1)
%     for frame = 2:size(noise_estim{1,1},1)
%         
%         for k = 1:size(noise_estim{1,1},2)
%             s = 0;
%             for j = 1:frame
%                 s = s + (noise_estim{i}(j,k)^2);
%                 
%             end
%             if label{i}(frame) == 0
%                 landa{i}(frame,k) =0.8*(landa{i}(frame-1,k)) + 0.2*( s/frame);
%             else
%                 landa{i}(frame,k) = landa{i}(frame-1,k);
%             end
%         end
%     end
% end
% 
% 
