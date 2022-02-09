clear;
% close all;
CR=3;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]

symbols=[0];

% txSig = LoRa_Modulation(SF,symbols,1);
% rxSig=txSig;
% 
% chirp = LoRa_Modulation(SF,symbols,-1);
% 
% demodSig = rxSig.*chirp;
Fs = B;     % Sampling frequency

txSig=LoRa_Modulation_Old(B,SF,symbols,1,Fs);
chirp=LoRa_Modulation_Old(B,SF,zeros(1,length(symbols)),-1,Fs);
demodSig = txSig.*chirp;

Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(txSig)*Ts)-Ts)';

f = -Fs/2:Fs/length(txSig):Fs/2-Fs/length(txSig);

Y = fftshift(fft(txSig));
% figure;
plot(f,abs(Y));
% figure;
% plot(ts,real(txSig),ts,imag(txSig));

% figure;
% subplot(3,1,1);
% spectrogram(txSig,20,15,-B/2:1e3:B/2,Fs,'yaxis');    % no idea how it's working
% title('txSig');
% subplot(3,1,2);
% spectrogram(txSig,20,15,-B/2:1e3:B/2,B,'yaxis');
% title('demod chirp')  
% subplot(3,1,3);
% spectrogram(demodSig,20,15,128,B,'yaxis');
% title('txSig * demod chirp')  