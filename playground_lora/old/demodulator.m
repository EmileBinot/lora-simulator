% clear;
% clc;
% 
% B=125e3;
% Fs = B;     % Sampling frequency
% Ts = 1/Fs;  % Sampling period
% 
% %% Creating the test frame
% 
% test_frame=[ones(5,1).*64 ; ones(10,1).*32 ; ones(5,1).*16 ; ones(5,1).*17];
% 
% signal = LoRa_Modulation(B,7,test_frame,1);
% 
% figure;
% spectrogram(signal,20,15,128,B,'yaxis');    % no idea how it's working
% title("Received frame");
% 
% %% Demodulation
% 
% Demod_chirp = LoRa_Modulation(B,7,zeros(25),-1);
% 
% %% Unchirping
% 
% figure;
% spectrogram(Demod_chirp,20,15,128,B,'yaxis');
% title("Demodulating chirp");
% save('./LoRa-chain-simulation/tests/signals.mat');



clear;
clc;
close all;

load('./LoRa-chain-simulation/tests/signals.mat')
SF=7;
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(signal)*Ts)-Ts)';

y = awgn(signal,-5,'measured');

%signal=signal+y;

% figure;
% plot(ts,real(signal),ts,imag(signal));
% figure;
% plot(ts,real(y),ts,imag(y));

signal=y;

signal_demod=signal.*Demod_chirp(1:length(signal),:);


figure;
spectrogram(signal_demod,20,15,128,B);
title("Demodulated signal");

%% FFT

unchirped_fft=fft(signal_demod);

f = (0:length(unchirped_fft)-1)*Fs/length(unchirped_fft);

figure;
plot(f,abs(unchirped_fft));


div = 25;

M=2^SF;
u = symunit;
symbols_demod=[];
T  = M*Ts;

for i = 0:div-1
    signal_demod_fft_part = fft(signal_demod(1+i*128:i*128+128,:));
    f = (0:length(signal_demod_fft_part)-1)*Fs/length(signal_demod_fft_part);
    [~,idx]=max(signal_demod_fft_part);
    symbols_demod(i+1)=round(f(idx)*128/125e3,0);
    
%     %plots
%     subplot(2,1,1);
%     plot(f,abs(signal_demod_fft_part ));
%     subplot(2,1,2); 
%     spectrogram(signal_demod(i*128:i*128+128,:),20,15,128,B);
%     title([num2str(round(f(idx)/1e3,1)),' kHz / symbol : ', num2str(round(f(idx)*128/125e3,0))])
%     pause(1)
    
end
