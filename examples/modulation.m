clear;
close all;
CR=3;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]

symbols=[50];

txSig = LoRa_Modulation(SF,symbols,1);
rxSig=txSig;

chirp = LoRa_Modulation(SF,symbols,-1);

demodSig = rxSig.*chirp;

%% Plotting modulated signal
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(txSig)*Ts)-Ts)';
figure;
plot(ts,real(txSig));

figure;
subplot(3,1,1);
spectrogram(txSig,20,15,-B/2:1e3:B/2,B,'yaxis');    % no idea how it's working
title('txSig');
subplot(3,1,2);
spectrogram(txSig,20,15,128,B,'yaxis');
title('demod chirp')  
subplot(3,1,3);
spectrogram(demodSig,20,15,128,B,'yaxis');
title('txSig * demod chirp')  