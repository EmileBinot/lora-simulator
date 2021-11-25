function [dataOut,chirpFull,demodSig] = LoRa_Receiver_Sync(CR,SF,B,Pr_len,rxSig,whiteNoise)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Fs=B;
M=2^SF;

%% Syncing

preambleUpMod = LoRa_Modulation(SF,zeros(Pr_len+2,1),1);
preambleDownMod = LoRa_Modulation(SF,ones(3,1),-1); % Length = M
preamble= [preambleUpMod ; preambleDownMod(1:M*2.25)];

% cross-correlation of rxSig and preamble
[c,lags] = xcorr(rxSig,preamble);
[~,idx]=max(c);
stem(lags,c);
delayInt=lags(idx);
disp(["[LoRa_Receiver_Sync]Delay = " delayInt]);
rxSigFixed=rxSig(delayInt+length(preamble)+1:end);

% Passing fixed signal to syncronized receiver
[dataOut,chirpFull,demodSig]=LoRa_Receiver(CR,SF,B,Pr_len,rxSigFixed,whiteNoise);

end

