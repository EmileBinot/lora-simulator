% LoRa_Emmiter.m : 
% Input = Modulation parameters (B,SF,CR), Binary vector to transmit
% Output = modulated_signal.dat 

clear;
clc;

%% Constants Definitions

CR=4;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length

data = 'hello world';

%% Message to binary vector

binary_data = reshape(dec2bin(data, 8).'-'0',1,[]); % String to binary vector
hamming_in = reshape(binary_data,4,[]); % Groups of 4 data bits 

% Adding padding to respect block sizes for interleaver
while mod(length(hamming_in),SF)
    hamming_in=[hamming_in [0;0;0;0]];
end 
transmitted_data_vector = hamming_in(:); % save for later

%% Hamming encoding

% Processing every groups of 4 bits one by one
for i = 1: (length(hamming_in))
    hamming_out(:,i) = LoRa_Encode_Hamming(hamming_in(:,i)',CR);
end

hamming_out = hamming_out(:); % [CR+4,SF*x] matrix to [(CR+4)*SF*x,1] vector

%% Whitening

whitened_out = LoRa_Whitening(hamming_out');

%% Interleaving

whitened_out_block = reshape(whitened_out,CR+4,[])'; % vector to SF*x_blocks,CR+4 matrix

cell=ones(1,size(whitened_out_block,1)/SF).*SF; % Preparing [SF SF .. SF] vector for mat2cell()
interleaver_in = mat2cell(whitened_out_block,cell,CR+4); % [SF*x_blocks,CR+4] divided x times to [SF,CR+4] blocks

% Processing every block one by one
%interleaver_out=zeros(CR+4,size(whitened_out_block,1)); % Preallocation
interleaver_out=[];
for i = 1 :length(interleaver_in)
   %interleaver_out(:,SF*(i-1)+1:i*SF)=LoRa_Interleaving(interleaver_in{i},CR,SF);
   interleaver_out=[interleaver_out ; LoRa_Interleaving(interleaver_in{i},CR,SF)];
end

%% Bits to symbols

symbols = LoRa_Bits_To_Symbols(interleaver_out);

%% Symbols modulation

preamble_up_mod = LoRa_Modulation(B,7,zeros(Pr_len+2),1);
preamble_down_mod = LoRa_Modulation(B,7,ones(4),-1);
payload_mod = LoRa_Modulation(B,7,symbols,1);

signalIQ= [ preamble_up_mod ; preamble_down_mod(1:floor((length(preamble_down_mod)))) ; payload_mod];

Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
ts = (0:Ts:(length(signalIQ)*Ts)-Ts)';

%% Saving signal data + transmitted_binary_vector

save('LoRa_Emmiter_transmitted','signalIQ','transmitted_data_vector','CR','SF','B','Pr_len');

%% Optional Plots

figure;
spectrogram(signalIQ,20,15,128,B,'yaxis');    % no idea how it's working
