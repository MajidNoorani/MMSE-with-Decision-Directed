function [Lambda]=variance(input)

noise_mean = cell(size(input));
for i= 1:size(input,1)  %signal
    sum = 0;
    for j = 1:5
        sum = sum + input{i,1}(j,:);
    end
    noise_mean{i,1} = sum / 5;
end

Lambda = cell(size(input));
for i = 1:size(input,1)
    var = zeros(1,size(input{1,1},2));
    for j=1:5
    var = var +(input{i,1}(j,:)-noise_mean{i,1}).^2;
    end
    Lambda{i,1} = var/5;
end
