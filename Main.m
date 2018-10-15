close all
clear all

mkdir Voices
mkdir Voices speech1 
mkdir Voices speech2

in = zeros(4,1);
segSNR1 = cell(3,1);
segSNR2 = cell(3,1);
for speech = 1:2
    for noise_type = 1:3
        if speech == 1
            [statement,fs] = audioread('speech1.wav');
            speech_name = 'speech1';
        elseif speech == 2
            [statement,fs] = audioread('speech2.wav');
            speech_name = 'speech2';
        end
        if noise_type == 1
            [noise,fs] = audioread('White_short.wav');
            noise_name = 'white';
        elseif noise_type == 2
            [noise,fs] = audioread('Babble_short.wav');
            noise_name = 'babble';
        elseif noise_type == 3
            [noise,fs] = audioread('Volvo_short.wav');
            noise_name = 'volvo';
        end
          statement = statement *1/10;
          noise = noise*1/10;
    



        statement_size=size(statement);
        noise=noise(1:statement_size(1,1));

        %% signal making with different SNRs :-5 0 5 10

        [snr,ratio]=SNR(statement,noise);
        if snr~=0
            noise0=noise*sqrt(ratio);
        end

        %[snr1,ratio1]=SNR(statement,noise_min5);
        audio = cell(4,1);
        audio{1,1} = statement + noise0 *sqrt(sqrt(10));
        audio{2,1} = statement + noise0;  % noisy audio with snr = 0
        audio{3,1} = statement + noise0 * 1/sqrt(sqrt(10));
        audio{4,1} = statement + noise0 * 1/sqrt(10);



        %% framming
        % [frames] = framming(statement,fs);
        frames = cell(4,1);
        [frames{1,1}] = framming(audio{1,1},fs);
        [frames{2,1}] = framming(audio{2,1},fs);
        [frames{3,1}] = framming(audio{3,1},fs);
        [frames{4,1}] = framming(audio{4,1},fs);

        %% Hanning
        for i = 1: size(frames)
            [frames{i}]= Hanning(frames{i},size(frames{i},1));
        end


        %% FFT

        for i= 1:size(frames,1)
        [frames_FFT{i,1},frq] = FFT_of_Frames(frames{i,1},fs);
        %frames_FFT{i,1} = frames_FFT{i,1}(:,1:201);
        end


        %% noise esimation

        [noise_estim,label] = Direct_estim(frames_FFT);


        %% posterior SNR
        [lambda] = lambda_func(noise_estim,label);
        [gama] = postSNR_func(frames_FFT, lambda);


        %% enhancement

        Zai = cell(size(frames_FFT));
        X = cell(size(frames_FFT));

        for i = 1:size(frames_FFT,1)
            for k = 1:size(frames_FFT{i,1},2)    
            Zai{i}(1,k) = 0.95 +(1-0.95)*max(gama{i}(1,k)-1,0);
            end
        end

        for i=1:1:size(frames_FFT,1)
            for k = 1:size(frames_FFT{i,1},2)
                v = (Zai{i}(1,k)/(1+Zai{i}(1,k))) * gama{i}(1,k);
                X{i}(1,k) = (sqrt(pi)/2) * (sqrt(v)/gama{i}(1,k)) * exp(-v/2)*((1+v)* besseli(0, v/2) + v*besseli(1,v/2))*frames_FFT{i}(1,k);
            end
        end

        vv = cell(4,1);
        for i = 1:size(frames_FFT,1)
            for frame = 2:size(frames_FFT{i},1) 
                for k = 1:size(frames_FFT{i},2) 
                    Zai{i}(frame,k) = 0.999* (X{i}(frame-1,k)^2/lambda{i}(frame-1,k))+(0.001)*max(gama{i}(frame,k)-1,0);
                    v = (Zai{i}(frame,k)/(1+Zai{i}(frame,k))) * gama{i}(frame,k);
                    vv{i}(frame,k) = v;
                    X{i}(frame,k) = (sqrt(pi)/2) * (sqrt(v)/gama{i}(frame,k)) * exp(-v/2)*((1+v)* besseli(0, v/2) + v*besseli(1,v/2))*frames_FFT{i}(frame,k);
                    if (isnan(X{i}(frame,k)) || isinf(X{i}(frame,k)))
                        X{i}(frame,k)=(Zai{i}(frame,k)/(1+Zai{i}(frame,k)))*frames_FFT{i}(frame,k);
                        in(i,1) = in(i,1)+1;
                    end


                end
            end
        end



        [signal] = Reconstruction(X,frames);


        filename = 'min5db.wav';
        audiowrite(filename,signal{4},16000);
        address=strcat('Voices\',speech_name,'\');

        


        figure
        
        subplot(5,2,2)
        plot(statement)
        title(strcat('clean-',speech_name))
        subplot(5,2,1)
        plot(noise)
        title(noise_name)
        

        for i = 1: size(audio,1)
            
            subplot(5,2,2*i+1)
            plot(audio{i})
            if i == 1
                name1 = '-5db Noisy';
                audiowrite(strcat(address,'minus5db_noisy_',noise_name,'.wav'),audio{i}*5,16000);
            elseif i == 2
                name1 = '0db Noisy';
                audiowrite(strcat(address,'0db_noisy_',noise_name,'.wav'),audio{i}*5,16000);
            elseif i == 3
                name1 = '5db Noisy';
                audiowrite(strcat(address,'5db_noisy_',noise_name,'.wav'),audio{i}*5,16000);
            else 
                name1 = '10db Noisy';
                audiowrite(strcat(address,'10db_noisy_',noise_name,'.wav'),audio{i}*5,16000);
            end
             title(name1)


            subplot(5,2,2*i+2)
            plot(1:size(signal{i},2),signal{i})
            if i == 1
                name2 = '-5db Enhanced';
                audiowrite(strcat(address,'minus5db_enhanced_',noise_name,'.wav'),signal{i}*5,16000);
            elseif i == 2
                name2 = '0db Enhanced';
                audiowrite(strcat(address,'0db_enhanced_',noise_name,'.wav'),signal{i}*5,16000);
            elseif i == 3
                name2 = '5db Enhanced';
                audiowrite(strcat(address,'5db_enhanced_',noise_name,'.wav'),signal{i}*5,16000);
            else 
                name2 = '10db Enhanced';
                audiowrite(strcat(address,'10db_enhanced_',noise_name,'.wav'),signal{i}*5,16000);
            end
            title(name2)
            
            
        
        end
        
        if speech == 1
            
            [segSNR1{noise_type}] = Evaluation(statement(1:max(size(signal{i}))),signal);
            
        else
            [segSNR2{noise_type}] = Evaluation(statement(1:max(size(signal{i}))),signal);
        end

    end
end


