function [txSig,dataIn] = LoRa_Emitter_fast(CR,SF,Pr_len,binary_data,modSymbK,demodChirp,whiteNoise)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Message to binary vector

hammingIn = reshape(binary_data,4,[]); % Groups of 4 data bits 

% Adding padding to respect block sizes for interleaver
while mod(length(hammingIn),SF)
    hammingIn=[hammingIn [0;0;0;0]];
end 
dataIn = hammingIn(:); % save for later

%% Hamming encoding

% Processing every groups of 4 bits one by one
for i = 1: (length(hammingIn))
    hammingOut(:,i) = LoRa_Encode_Hamming(hammingIn(:,i)',CR);
end

hammingOut = hammingOut(:); % [CR+4,SF*x] matrix to [(CR+4)*SF*x,1] vector

%% Whitening

whiteOut = LoRa_Whitening(hammingOut',whiteNoise);

%% Interleaving

whiteOutBlock = reshape(whiteOut,CR+4,[])'; % vector to SF*x_blocks,CR+4 matrix

cell=ones(1,size(whiteOutBlock,1)/SF).*SF; % Preparing [SF SF .. SF] vector for mat2cell()
interleaverIn = mat2cell(whiteOutBlock,cell,CR+4); % [SF*x_blocks,CR+4] divided x times to [SF,CR+4] blocks

interleaverOut=[];
for i = 1 :length(interleaverIn)
   interleaverOut=[interleaverOut ; LoRa_Interleaving(interleaverIn{i},CR,SF)];
end

%% Bits to symbols

payload = LoRa_Bits_To_Symbols(interleaverOut);


%% Symbols modulation

%With preamble

% preamble_up_mod = LoRa_Modulation(B,SF,zeros(Pr_len+2,1),1);
% preamble_down_mod = LoRa_Modulation(B,SF,ones(4,1),-1);
% payload_mod = LoRa_Modulation(B,SF,symbols,1);
% 
% txSig= [ preamble_up_mod ; preamble_down_mod(1:floor((length(preamble_down_mod)))) ; payload_mod];

%Without preamble
%payloadMod = LoRa_Modulation_fast(SF,payload,1,modSymbK,demodChirp);
payloadMod = LoRa_Modulation_faster(SF,payload,1);

txSig= payloadMod;


end

