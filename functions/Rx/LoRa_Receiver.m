function [dataOut,chirpFull,demodSig] = LoRa_Receiver(CR,SF,B,Pr_len,rxSig,whiteNoise,bypHamm)
%LoRa_Receiver Wrapping the LoRa Rx device
%
%   [dataOut,chirpFull,demodSig] = LoRa_Receiver(CR,SF,B,Pr_len,rxSig,whiteNoise)
%
%   Rx chain : Demodulation -> Deinterleaver -> Dewhitening -> Hamming -> Formatting
%
% INPUTS :
%
%   CR : Coding Rate (1:4)
%   SF : Spreading Factor (7:12)
%   B : Bandwidth of received signal
%   Pr_len : Preamble length (min. = 2) (not used)
%   rxSig : Received IQ signal
%   whiteNoise : White noise (to increase speed, the noise is already generated)
%
% OUTPUTS :
%
%   chirpFull : Can be used for debug
%   demodSig : Can be used for debug/plot
%   dataOut : Formatted received payload to be compared with dataIn at Tx end
%   of the channel
%
% See also LoRa_Decode_Hamming, LoRa_Dewhitening, LoRa_Deinterleaving,
% LoRa_Symbols_To_Bits, LoRa_Modulation


Fs=B;
M=2^SF;
%% Demodulating

% chirpFull = LoRa_Modulation(SF,zeros(1,length(rxSig)/(2^SF)),-1);
chirp = LoRa_Modulation(SF,0,-1); % Creating the demodulation chirp
% chirpFull=zeros(length(rxSig)/(M),1);
% 
% for i = 1:length(rxSig)/(M)
%     chirpFull(M*(i-1)+1:M*(i),1)=chirp;
% end
%chirpFull=repmat(chirp,length(rxSig)/(M),1);
chirpFull=repmat(chirp,round(length(rxSig)/M),1);
demodSig=rxSig.*chirpFull;


r=1;
fftdemodSigMat=zeros(M,length(rxSig)/M);
for i = 1:M:length(rxSig)
    fftdemodSigMat(:,r) = fft(demodSig(i:i+M-1,:));
    r=r+1;
%     %plots
%     subplot(2,1,1);
%     plot(f,abs(fftdemodSig ));
%     subplot(2,1,2); 
%     spectrogram(demodSig(i:i+2^SF-1,:),20,15,128,B);
%     %title([num2str(round(f(idx)/1e3,1)),' kHz / symbol : ', num2str(round(f(idx)*128/125e3,0))])
%     pause(1)
end

f = (0:M-1)*Fs/M;
[~,idx] = max(fftdemodSigMat,[],1);
symbols=round(f(idx).*(M)/B,0)';

%symbolsBin=LoRa_Symbols_To_Bits(symbols',SF);
symbolsBin=LoRa_Symbols_To_Bits(symbols,SF);
%% Deinterleaving 

cell2=ones(1,size(symbolsBin,1)/(CR+4)).*(CR+4); % Preparing [SF SF .. SF] vector for mat2cell()
deinterleaverIn = mat2cell(symbolsBin,cell2,SF); % [CR+4,SF*x] divided x times to [CR+4,SF] blocks

% Processing every block one by one
deinterleaverOut=[];
for i = 1 :length(deinterleaverIn)
   deinterleaverOut=[deinterleaverOut ; LoRa_Deinterleaving(deinterleaverIn{i},CR,SF)];
end

deinterleaverOutVect = reshape(deinterleaverOut',1,[]); % [SF*x,CR+4] matrix to [1,(CR+4)*SF*x] vector

%% De-whitening

dewhiteningOut = LoRa_Whitening(deinterleaverOutVect,whiteNoise)';

%% Hamming Decoding

hammingDecIn = reshape(dewhiteningOut,CR+4,[]);
hammingDecOut=zeros(4,length(hammingDecIn));
for i = 1: length(hammingDecIn)
    hammingDecOut(:,i) = LoRa_Decode_Hamming(hammingDecIn(:,i)',CR,bypHamm);
end

dataOut = hammingDecOut(:);
end

