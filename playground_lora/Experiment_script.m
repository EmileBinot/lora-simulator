clear;
clc;
%close all;
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
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
% load("symbols","modSymbK","demodChirp");
load("noise","whiteNoise");
% binary_data=zeros(5,1);
% binary_data(:,2:8) = de2bi([2,50,40,90,120]);
% binary_data = binary_data(:);
binary_data = randi([0 1],20,CR+4);

%% LoRa Emitter

[txSig,dataIn]=LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise,0); 

%% Channel

%rxSig=txSig;% Neutral

rxSig=[zeros(2500,1); txSig];% Neutral
%% LoRa Receiver
[dataOut,chirp,demodSig,lags,c]=LoRa_Receiver_Sync(CR,SF,B,Pr_len,rxSig,whiteNoise,0);

figure(1);
subplot(2,1,1);
spectrogram(rxSig,16,15,64,'yaxis');
[~,~,~,pxx,fc,tc] = spectrogram(rxSig,16,15,64,'yaxis','MinThreshold',0);
h= plot(tc(pxx>0)*6.25,fc(pxx>0)/6,'.');
ax = ancestor(h, 'axes');
ax.XAxis.Exponent = 0;
ax.XAxis.TickLabelFormat = '%.0f';
xlabel('Frequency (Normalized)');
xlabel('Samples');
title('Trame reçue')  

subplot(2,1,2);
h=stem(lags,c); %hold on;
ax = ancestor(h, 'axes');
ax.XAxis.Exponent = 0;
ax.XAxis.TickLabelFormat = '%.0f';
title('Corrélation entre preambule et trame')  
