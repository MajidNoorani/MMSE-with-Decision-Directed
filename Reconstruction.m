function [final_signal] = Reconstruction(X,frames)

Xt = cell(size(X));
Xt0 = cell(size(X));
N=25*16000/1000;  %length of frames in terms of samples
M=10*16000/1000;   %shift of frames in terms of samples

FFT1 = cell(size(frames));
for i = 1:size(frames,1)
    for frame = 1:size(frames{i},1)
        Tf=frames{i}.'; %transpose f to be able to compute FFT of the matrix- FFT computes vectors in colomns
        FFT1{i}=fft(Tf,400);
        FFT2{i} = FFT1{i}.';
    end
end

for i = 1:size(frames,1)
    theta=angle(FFT2{i}); 
    X{i}=(X{i}.*cos(theta))+(X{i}.*sqrt(-1).*sin(theta));
end
for i =1: size(X,1)
    for frame = 1: size(X{1,1},1)
        Xt{i}(frame,:) = ifft(X{i}(frame,:),400,'symmetric');
    end 
end

% for i = 1: size(Xt0)
%     for frame = 1: size(Xt0{i},1)
%         Xt{i}(frame,:) = Xt0{i}(frame,:);
%     end
% end

%% overlap add

for i = 1: size(Xt,1)
    [Xt{i}]= Hanning(Xt{i},size(Xt{i},1));    
end



final_signal = cell(size(Xt));
for i = 1: size(Xt,1)
    signal = zeros(1,size(Xt{i},1)* (M) +(N-M));
    for frame = 1: size(Xt{i},1)
        signal(((frame-1)*M)+1:((frame-1)*M)+N) = Xt{i}(frame,:) + signal(((frame-1)*M)+1:((frame-1)*M)+N);
    end
    final_signal{i}(1,:) = signal(1,:);
    final_signal{i}(1,1:4000) = final_signal{i}(1,1:4000)/10^8;
end
    


