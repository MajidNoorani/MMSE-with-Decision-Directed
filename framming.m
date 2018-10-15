function [f]=framming(Audiofile,fs)


Audiofile=Audiofile;
l=length(Audiofile);  %number of the samples of the whole audio
N=25*fs/1000;  %length of frames in terms of samples
M=10*fs/1000;   %distance between frames in terms of samples
frameNo=fix(l/M)-3;    %quantity of frames
f = zeros(frameNo,N);
for k=1:frameNo
    for s=((M*(k-1))+1):(N+(M*(k-1)))
        f(k,(s-((k-1)*M)))=Audiofile(s);%f: a matrix which in each row there is a frame
    end
end

