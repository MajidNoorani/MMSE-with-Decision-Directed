function [segSNR] = Evaluation(clean_speech,enhanced)

N = 25*16000/1000; %length of the segment in terms of samples
M = fix(size(clean_speech,1)/N); %number of segments
segSNR = zeros(size(enhanced));
for i = 1:size(enhanced,1)
    for m = 0:M-1
        sum1 =0;
        sum2 =0;
        for n = m*N +1 : m*N+N
            sum1 = sum1 +clean_speech(n)^2;
            sum2 = sum2 +(enhanced{i}(n) - clean_speech(n))^2;
        end
        r = 10*log10(sum1/sum2);
        if r>55
            r = 55;
        elseif r < -10
            r = -10;
        end
       
        segSNR(i) = segSNR(i) +r;
    end
    segSNR(i) = segSNR(i)/M;
end


        
    