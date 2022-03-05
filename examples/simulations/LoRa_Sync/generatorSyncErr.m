clear;
close all;
clc;

CR=4;     % Coding rate : {1,4}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length

numSymPerFrame = 100;   % Number of LoRa symbols per frame

load("noise","whiteNoise");
snrVect=-40:1:-10;
%snrVect=100:5:325;
SFVect=(7:9);
% SFVect=7;
%SFVect=[7 8];
berEstAllSF=[];
bypassHamming=1; % BYPASSING HAMMING

currentPrecision = digits(6);

for kSF = SFVect
    M=2^kSF;
    preambleUpMod = LoRa_Modulation(kSF,zeros(Pr_len+2,1),1);
    preambleDownMod = LoRa_Modulation(kSF,ones(3,1),-1); % Length = M
    preamble= [preambleUpMod ; preambleDownMod(1:M*2.25)];
    
    n=0;
    for nSNR = snrVect
        n=n+1;
        
        % Reset the error and bit counters
        numErrs = 0;
        numBits = 0;
        disp(kSF);
        disp(nSNR);
        
        tic
        err_sum=0;
        
        for frameSent=1:500
            
            % Generate binary data and convert to symbols
            binary_data = randi([0 1],numSymPerFrame,CR+4);
            
            % QAM modulate using 'Gray' symbol mapping
            [txSig,dataIn]=LoRa_Emitter(CR,kSF,Pr_len,binary_data,whiteNoise,bypassHamming); 

            % Pass through AWGN channel
            offset = randi([0 2^kSF-1]) ;
            rxSig = [zeros(offset,1) ; txSig];
            rxSig = awgn(rxSig,nSNR,'measured');
            
            [c,lags] = xcorr(rxSig,preamble);
            [~,idx]=max(c);
            offset_hat=mod(lags(idx),M);
            
%             err=abs(offset-offset_hat)/length(rxSig);
            err(frameSent,n,kSF)=abs(offset-offset_hat);
            % Increment the error and bit counters
%             err_sum=err_sum+err;
%             frameSent = frameSent + 1;
        end
%         err_avg=err_sum/frameSent;
        toc
        % Estimate the BER
%         error(n,:,kSF) = err_avg;
        save('./examples/simulations/LoRa_Sync/loraSync_data','err','snrVect','SFVect');
    end
end

%berTheory = berawgn(EbNoVec,'fsk',128,'coherent');

% semilogy(snrVect,error(:,:,8),'*')
% %hold on
% %semilogy(EbNoVec,berTheory)
% grid
% legend('Estimated BER','Theoretical BER')
% xlabel('SNR (dB)')
% ylabel('Bit Error Rate')