function [noise,label] = Direct_estim(frames_FFT)
% 
% N = cell(size(frames_FFT));
% %N = zeros(size(frames_FFT,1),size(frames_FFT{1,1},2));
% for i = 1:size(frames_FFT,1)
%     N{i}(1,:) = sum(frames_FFT{i,1}(1:5,:))/5;
% end
% 
% for i = 1:size(frames_FFT,1)
%     for j = 1:size(frames_FFT{1,1},2)
%         for frame = 2:size(frames_FFT{1,1},1)
%             if frames_FFT{i,1}(frame,j) < N{i}(frame-1,j)
%                 N{i}(frame,j) = (0.006)*frames_FFT{i}(frame,j) + ((1-0.006)*(N{i}(frame-1,j)));
%             else
%                 N{i}(frame,j) = (0.022)*frames_FFT{i}(frame,j) + ((1-0.022)*(N{i}(frame-1,j)));
%             end
%         end
%     end
% end
% noise = N;

label = cell(size(frames_FFT));
N = cell(size(frames_FFT));
%N = zeros(size(frames_FFT,1),size(frames_FFT{1,1},2));
for i = 1:size(frames_FFT,1)
    for frame = 1:40
        N{i}(frame,:) = sum(frames_FFT{i}(1:40,:))/40;
        
    end
    label{i}(1:40) = 0;
end


for i = 1:size(frames_FFT,1)
    
        for frame = 41:size(frames_FFT{1},1)
            %XS{i}(frame) = sum(frames_FFT{i}(frame,:).^2);
            %XN{i}(frame) = sum(N{i}(frame-1,:).^2);
            if sum(frames_FFT{i}(frame,:).^2) < 2*sum(N{i}(frame-1,:).^2)
                for k = 1:size(frames_FFT{1,1},2)
                    label{i}(frame) = 0;
                    N{i}(frame,k) = (0.01)*frames_FFT{i}(frame,k) + ((1-0.01)*(N{i}(frame-1,k)));
                end
            else
                label{i}(frame) = 1;
                N{i}(frame,:) = N{i}(frame-1,:);
            end
        
        end
end
noise = N;


