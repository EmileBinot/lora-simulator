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
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
% load("symbols","modSymbK","demodChirp");
load("noise","whiteNoise");
binary_data=zeros(5,1);
binary_data(:,2:8) = de2bi([2,50,40,90,120]);
binary_data = binary_data(:);

%% LoRa Emitter

[txSig,dataIn]=LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise,0); 

%% Channel

%rxSig=txSig;% Neutral

rxSig=[zeros(0,1); txSig];% Neutral
rxSig=awgn(rxSig,20,'measured');

%% LoRa Receiver
[dataOut,chirp,demodSig]=LoRa_Receiver_Sync(CR,SF,B,Pr_len,rxSig,whiteNoise,0);
%timer end
toc
% 
% Plotting modulated signal
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(txSig)*Ts)-Ts)';

% figure;
% subplot(3,1,1);
% spectrogram(txSig,20,15,128,B,'yaxis');    % no idea how it's working
% title('txSig')  
% subplot(3,1,2);
% spectrogram(chirp,20,15,128,B,'yaxis');    % no idea how it's working
% title('demod chirp')  
% subplot(3,1,3);
% spectrogram(demodSig,20,15,128,B,'yaxis');    % no idea how it's working
% title('txSig * demod chirp')  

figure;
spectrogram(txSig,20,15,128,B,'yaxis');

[~,ber] = biterr(dataIn,dataOut);
disp(['BER : ' num2str(ber)])
