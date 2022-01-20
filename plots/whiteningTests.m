clear;
close all;
clc;

CR=4;     % Coding rate : {1,4}
SF=8;
B=500e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
bypassHamming=0;
numSymPerFrame = 100;   % Number of LoRa symbols per frame
binary_data = [ones(numSymPerFrame,CR+4)];

%% NOT RANDOMIZED BY WHITE NOISE
NotWhiteNoise=ones(1,511);
[txSig,dataIn,interleaverOut]=LoRa_Emitter_fast(CR,SF,Pr_len,binary_data,NotWhiteNoise,bypassHamming);
datasent=interleaverOut(:);
figure;
subplot(2,1,1)
histogram(binary_data.');
title("suite de 1 s en entrée")
subplot(2,1,2)
histogram(datasent.');
title("sent data (pas de whitening)")

%% RANDOMIZED BY WHITE NOISE

load("noise","whiteNoise");
[txSigWhite,dataIn,interleaverOut]=LoRa_Emitter_fast(CR,SF,Pr_len,binary_data,whiteNoise,bypassHamming);
datasent=interleaverOut(:);
figure;
subplot(2,1,1)
histogram(binary_data.');
title("suite de 1 s en entrée")
subplot(2,1,2)
histogram(datasent.');
title("sent data (avec whitening)")

%% SPECTRUM DENSITY

figure;
pspectrum(txSig,B)
figure;
pspectrum(txSigWhite,B)

% figure;
% subplot(2,1,1)
% periodogram(txSig,[],0:B/256:B-B/256,B)
% subplot(2,1,2)
% periodogram(txSigWhite,[],0:B/256:B-B/256,B)
% 
figure;
subplot(2,1,1)
spectrogram(txSig,20,15,128,B,'yaxis');title('txSig') 
subplot(2,1,2)
spectrogram(txSigWhite,20,15,128,B,'yaxis');title('txSigWhite') 