function [labels,mean] = Labeling(frames, E_mean,mean_init)
labels = zeros(size(frames,1),size(frames{1,1},1));

for i = 1:size(frames,1)
    for j = 6: size(frames{1,1},1)
        E_frame = sum(frames{i,1}(j,:).^2);
        if E_frame > 20*E_mean(i)
            labels(i,j) = 1;
        else
            labels(i,j) = 0;
            count = 0;
            for k = 1:j-1
                if labels(i,k) == 0
                    count = count +1;
                end
            end
            mean_init(i,:) = (mean_init(i,:)*count + frames{i,1}(j,:))/(count+1);
            E_mean(i) = sum(mean_init(i,:).^2);
        end
    end
end
mean = mean_init;