function [Han]= Hanning(frames,frameNo)
N=25*16000/1000;
n=0:N-1;
w(n+1)=0.5-(0.5*cos(2*pi*n/(N-1)));   %hanning window
Han=zeros(frameNo,N);
for k=1:frameNo
    for i=1:N
        Han(k,i)=frames(k,i)*w(i);   %multiplication of hanning window in frames
    end
end
