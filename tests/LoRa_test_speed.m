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
pbO = pbNotify('o.w5fpNT5CcknDygQxbxIImMoCAP4Z1HXm');
sum=0;
Nit=200;
Ndata=100;

CR=4;     % Coding rate : {1,4}
SF=10;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
binary_data = randi([0 1],Ndata,8);
binary_data = binary_data(:);

profile on
%load("symbols","modSymbK","demodChirp");
load("noise","whiteNoise");

for k = 1:Nit
	tic % timer start
    % LoRa Emitter
    [txSig,dataIn]=LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise); 
    rxSig=txSig;% Neutral channel
    % LoRa Receiver
    [dataOut]=LoRa_Receiver(CR,SF,B,Pr_len,rxSig,whiteNoise);
	sum=sum+toc;% timer end
end

profile viewer
mean=sum/Nit;
disp(["Mean exec. time = "+mean])
[~,ber] = biterr(dataIn,dataOut);
disp(['BER : ' num2str(ber)])

%SF=10,Ndata=100, mean exec time = 0.042
%0.0368
%0.03154 - 0.034
%0.02757 0.397
%
