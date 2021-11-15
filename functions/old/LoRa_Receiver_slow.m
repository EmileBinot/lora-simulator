function [chirp,demodSig,dataOut] = LoRa_Receiver_slow(CR,SF,B,Pr_len,rxSig)
%LoRa_Receiver Summary of this function goes here
%   Detailed explanation goes here

Fs=B;

%% Demodulating

chirp = LoRa_Modulation(B,SF,zeros(1,length(rxSig)/(2^SF)),-1); % Creating the demodulation chirp

demodSig=rxSig.*chirp;

fftdemodSig = fft(demodSig);

f = (0:length(fftdemodSig)-1)*Fs/length(fftdemodSig);

symbols=[];
for i = 1:2^SF:length(rxSig)
    fftdemodSig = fft(demodSig(i:i+2^SF-1,:));
    [~,idx]=max(fftdemodSig);
    f = (0:length(fftdemodSig)-1)*Fs/length(fftdemodSig);
    symbols(end+1)=round(f(idx)*(2^SF)/B,0);
end


symbolsBin=LoRa_Symbols_To_Bits(symbols',SF);

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

dewhiteningOut = LoRa_Whitening(deinterleaverOutVect)';

%% Hamming Decoding

hammingDecIn = reshape(dewhiteningOut,CR+4,[]);

for i = 1: length(hammingDecIn)
    hammingDecOut(:,i) = LoRa_Decode_Hamming(hammingDecIn(:,i)',CR);
end

dataOut = hammingDecOut(:);

end

