clear;
% close all;
clc;

CR=4;     % Coding rate : {1,4}
SF=8;
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
bypassHamming=0;
bypassInterleaver=0;
numSymPerFrame = 500/2;   % Number of LoRa symbols per frame
% numBits=;
% binary_data = [ones(numSymPerFrame,CR+4)];
binary_data = [zeros(numSymPerFrame/2,CR+4) ; ones(numSymPerFrame/2,CR+4)];
% binary_data = [zeros(numSymPerFrame/4,CR+4) ; ones(numSymPerFrame/4,CR+4) ; zeros(numSymPerFrame/4,CR+4) ; ones(numSymPerFrame/4,CR+4)];

%% NOT RANDOMIZED BY WHITE NOISE
NotWhiteNoise=ones(1,511);
[txSig,dataIn,interleaverOut,symbOut]=LoRa_Emitter_modif_inter(CR,SF,Pr_len,binary_data,NotWhiteNoise,bypassHamming,bypassInterleaver);
datasent=interleaverOut(:);
% figure;
% subplot(2,1,1)
% histogram(binary_data.');
% title("suite de 1 s en entrée")
% subplot(2,1,2)
% histogram(datasent.');
% title("sent data (pas de whitening)")

%% RANDOMIZED BY WHITE NOISE

load("noise","whiteNoise");
[txSigWhite,dataIn,interleaverOutWhite,symbOutWhite]=LoRa_Emitter_modif_inter(CR,SF,Pr_len,binary_data,whiteNoise,bypassHamming,bypassInterleaver);
datasentWhite=interleaverOutWhite(:);
% figure;
% subplot(2,1,1)
% histogram(binary_data.');
% title("suite de 1 s en entrée")
% subplot(2,1,2)
% histogram(datasentWhite.');
% title("sent data (avec whitening)")

%% SPECTRUM DENSITY

% figure;
% pspectrum(txSig,B)
% figure;
% pspectrum(txSigWhite,B)

figure(4);
subplot(2,1,1)
periodogram(txSig,[],-B/2:B/256:B/2,B)
title(['non-whitened ' num2str(numSymPerFrame) ' symbols sequence']);
subplot(2,1,2)
periodogram(txSigWhite,[],-B/2:B/256:B/2,B)
title(['whitened ' num2str(numSymPerFrame) ' symbols sequence']);

% figure;
% heatmap(interleaverOutWhite,'GridVisible','off');
% figure;
% heatmap(interleaverOut,'GridVisible','off');

% figure(1);
% s=imagesc(interleaverOutWhite);colormap(gray(SF));
% axis off
% figure(2);
% s=imagesc(interleaverOut);colormap(gray(SF));
% axis off

figure(3);
subplot(2,1,1)
plot(symbOut)
title('non-whitened sequence');
xlabel('sample');ylabel('symbol value');
subplot(2,1,2)
plot(symbOutWhite)
title('whitened sequence');
xlabel('sample');ylabel('symbol value');

figure(5);
subplot(2,1,1)
spectrogram(txSig,20,15,128,B,'yaxis');title('txSig') 
subplot(2,1,2)
spectrogram(txSigWhite,20,15,128,B,'yaxis');title('txSigWhite') 