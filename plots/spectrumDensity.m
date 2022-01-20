clear all;clc;

CR=4;     % Coding rate : {1,4}
SF=8;
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
bypassHamming=0;
numSymPerFrame = 20;   % Number of LoRa symbols per frame
%binary_data = [ones(ceil(numSymPerFrame/2),CR+4);zeros(ceil(numSymPerFrame/2),CR+4)];
binary_data= randn(numSymPerFrame,SF);
[symbols] = LoRa_Bits_To_Symbols(binary_data);
[txSig,~] = LoRa_Modulation_slow(B,SF,symbols,1);

Fs=4*B;
Ts=1/Fs;
ts = (0:Ts:(length(txSig)*Ts)-Ts)';
plot(ts,imag(txSig),ts,real(txSig));

x =txSig;

obw(x);

% N = length(x);
% xdft = fft(x);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
% plot(freq,10*log10(psdx))
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')