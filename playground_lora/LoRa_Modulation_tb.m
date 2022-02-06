clear;
close all;
CR=3;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]

symbols=[50,30,90];
load("symbols","modSymbK","demodChirp");

txSig = LoRa_Modulation_fast(SF,symbols,1,modSymbK,demodChirp);
rxSig=txSig;

chirp = LoRa_Modulation_fast(SF,zeros(1,length(rxSig)/2^SF),-1,modSymbK,demodChirp);

demodSig = rxSig.*chirp;

%% Plotting modulated signal
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(txSig)*Ts)-Ts)';
figure;
subplot(3,1,1);
spectrogram(txSig,20,15,128,B,'yaxis');    % no idea how it's working
title('txSig');
subplot(3,1,2);
spectrogram(chirp,20,15,128,B,'yaxis');    % no idea how it's working
title('demod chirp')  
subplot(3,1,3);
spectrogram(demodSig,20,15,128,B,'yaxis');    % no idea how it's working
title('txSig * demod chirp')  

%% TESTBENCH

% clear;
% close all;
% 
% load("symbols");
% B=125e3;
% SF=10;
% CR=3;
% numSymPerFrame=10000;
% binary_data = randi([0 1],numSymPerFrame,SF);
% symbols = bi2de(binary_data)';
% 
% profile on
% txSigFast = LoRa_Modulation_fast(SF,symbols,1,modSymbK);
% 
% txSigNormal = LoRa_Modulation(B,SF,symbols,1);
% 
% txSigNormal2 = LoRa_Modulation_faster(SF,symbols,1);
% 
% profile viewer
% errornumber = sum(txSigFast~=txSigNormal)/1280;
