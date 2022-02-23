clear;
clc;
%close all;

%% Constants Definitions

CR=3;     % Coding rate : {1,4}
SF=12;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
load("noise","whiteNoise");
binary_data = randi([0 1],20,CR+4);

%% LoRa Emitter

%[txSig,dataIn]=LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise,0); 

preambleUpMod = LoRa_Modulation_Old(B,SF,zeros(Pr_len+2,1),1,Fs);
preambleDownMod = LoRa_Modulation_Old(B,SF,ones(3,1),-1,Fs);
preamble= [preambleUpMod ; preambleDownMod(1:M*2.25)];

%% Channel
rxSig=[zeros(2500,1); txSig];% Neutral
