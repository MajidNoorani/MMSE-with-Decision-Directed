function [gama] = postSNR_func(frames_FFT, landa)

gama = cell(size(frames_FFT));
for i = 1: size(frames_FFT,1)
    for frame = 1:size(frames_FFT{1,1},1)
        for k= 1:size(frames_FFT{1,1},2)
            gama{i}(frame,k) = (frames_FFT{i}(frame,k)^2)/landa{i}(frame,k);
%             if gama{i}(frame,k) > 1300
%                 gama{i}(frame,k) = 1100;
%             end
        end
    end
end

