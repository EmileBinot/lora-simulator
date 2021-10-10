clear;
clc;

% LoRa_Tx : full LoRa transmitting chain

CR=8;
SF=7;

%% Message to binary vector
data = 'Hello world !';
data_binary = reshape(dec2bin(data, 8).'-'0',1,[]);

%% Hamming
LoRa_Encode_Hamming(data_binary,CR);