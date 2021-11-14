clear;
clc;
close all;

%% SPEED TEST #1

% sum=0;
% Nit=50;
% Ndata=100;
% 
% CR=3;     % Coding rate : {1,4}
% SF=12;    % Coding rate  : {7,12}
% B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
% Pr_len=4; % Preamble length
% binary_data = randi([0 1],Ndata,8);
% binary_data = binary_data(:);
% for k = 1:Nit
% 	tic % timer start
%     % LoRa Emitter
%     [txSig,dataIn]=LoRa_Emitter(CR,SF,B,Pr_len,binary_data); 
%     rxSig=txSig;% Neutral
%     % LoRa Receiver
%     [chirp,demodSig,dataOut]=LoRa_Receiver(CR,SF,B,Pr_len,rxSig);
% 	sum=sum+toc;% timer end
% end
% mean=sum/Nit;
% disp(["Mean exec. time = "+mean])
% [~,ber] = biterr(dataIn,dataOut);
% disp(['BER : ' num2str(ber)])

%% SPEED TEST #2

sum=0;
Nit=200;
Ndata=100;

CR=4;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
binary_data = randi([0 1],Ndata,8);
binary_data = binary_data(:);

profile on
load("symbols","modSymbK","demodChirp");
load("noise","whiteNoise");

for k = 1:Nit
	tic % timer start
    % LoRa Emitter
    [txSig,dataIn]=LoRa_Emitter_fast(CR,SF,Pr_len,binary_data,modSymbK,demodChirp,whiteNoise); 
    rxSig=txSig;% Neutral channel
    % LoRa Receiver
    [chirp,demodSig,dataOut]=LoRa_Receiver_fast(CR,SF,B,Pr_len,rxSig,modSymbK,demodChirp,whiteNoise);
	sum=sum+toc;% timer end
end
profile viewer
mean=sum/Nit;
disp(["Mean exec. time = "+mean])
[~,ber] = biterr(dataIn,dataOut);
disp(['BER : ' num2str(ber)])

%0.0214,Ndata=100,Nit=200
%0.0114,Ndata=100,Nit=200 after going to d2b instead of de2bi


