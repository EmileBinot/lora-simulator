clear;
close all;
clc;
pbO = pbNotify('o.w5fpNT5CcknDygQxbxIImMoCAP4Z1HXm');

CR=4;     % Coding rate : {1,4}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length

numSymPerFrame = 100;   % Number of LoRa symbols per frame

load("noise","whiteNoise");
snrVect=(-35:3);
SFVect=(7:12);
berEstAllSF=[];


pbO.notify(strcat(datestr(now,'HH:MM:SS'),' : Starting simulation : SF = (7:10), snrVect=(-35:10)'));

for kSF = SFVect
    
    chr=int2str(kSF);
    pbO.notify(strcat(datestr(now,'HH:MM:SS: '),chr));
    
    n=0;
    for nSNR = snrVect
        n=n+1;
        % Pushbullet notifications
        ch='SF=';
        ch2=', SNR=';
        chr=strcat(ch,int2str(kSF),ch2,int2str(nSNR));
        pbO.notify(strcat(datestr(now,'HH:MM:SS: '),chr));
        
        % Reset the error and bit counters
        numErrs = 0;
        numBits = 0;
        disp(kSF);
        disp(nSNR);
        
        tic
        
        while numErrs < 200 && numBits < 1e7
            % Generate binary data and convert to symbols
            binary_data = randi([0 1],numSymPerFrame,CR+4);
            
            % QAM modulate using 'Gray' symbol mapping
            [txSig,dataIn]=LoRa_Emitter(CR,kSF,Pr_len,binary_data,whiteNoise); 

            % Pass through AWGN channel
            rxSig = awgn(txSig,nSNR,'measured');

            % Demodulate the noisy signal
            [dataOut]=LoRa_Receiver(CR,kSF,B,Pr_len,rxSig,whiteNoise);

            % Calculate the number of bit errors
            nErrors = biterr(dataIn,dataOut);

            % Increment the error and bit counters
            numErrs = numErrs + nErrors;
            numBits = numBits + numSymPerFrame*kSF;

        end
        toc
        % Estimate the BER
        berEst(n,:,kSF) = numErrs/numBits;
        save('resultsBER','berEst');
    end
end

%berTheory = berawgn(EbNoVec,'fsk',128,'coherent');

semilogy(snrVect,berEst(:,:,9),'*')
%hold on
%semilogy(EbNoVec,berTheory)
grid
legend('Estimated BER','Theoretical BER')
xlabel('SNR (dB)')
ylabel('Bit Error Rate')