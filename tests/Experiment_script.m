clear;
clc;
close all;
%% TODO :
% TODO : ADD preamble
% TODO : MORE SPEED, deep testing to see where to optimize
% TODO : take ideas from QAM_test.m and use it in experiment_script.m (while loop to get BER on a massive number of bits)
% TODO : AWGN channel
% TODO : Rayleigh channel

%timer
tic 
%% Constants Definitions

CR=3;     % Coding rate : {1,4}
SF=12;     % Coding rate  : {7,12}
B=500e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
load("symbols","modSymbK","demodChirp");
load("noise","whiteNoise");
binary_data=zeros(5,1);
binary_data(:,2:8) = de2bi([2,50,40,90,120]);
binary_data = binary_data(:);

%% LoRa Emitter

[txSig,dataIn]=LoRa_Emitter_fast(CR,SF,Pr_len,binary_data,modSymbK,demodChirp,whiteNoise); 

%% Channel

%rxSig=txSig;% Neutral
rxSig=awgn(txSig,-29,'measured');
% TODO : Rayleigh channel

%% LoRa Receiver
[chirp,demodSig,dataOut]=LoRa_Receiver_fast(CR,SF,B,Pr_len,rxSig,modSymbK,demodChirp,whiteNoise);
%timer end
toc
% 
% Plotting modulated signal
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(txSig)*Ts)-Ts)';

figure;
subplot(3,1,1);
spectrogram(txSig,20,15,128,B,'yaxis');    % no idea how it's working
title('txSig')  
subplot(3,1,2);
spectrogram(rxSig,20,15,128,B,'yaxis');    % no idea how it's working
title('demod chirp')  
subplot(3,1,3);
spectrogram(demodSig,20,15,128,B,'yaxis');    % no idea how it's working
title('txSig * demod chirp')  

figure;
plot(ts,real(rxSig),ts,real(txSig));

[~,ber] = biterr(dataIn,dataOut);
disp(['BER : ' num2str(ber)])
