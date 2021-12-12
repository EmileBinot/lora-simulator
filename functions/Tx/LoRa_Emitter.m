function [txSig,dataIn] = LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise)
%LoRa_Emitter Wrapping the LoRa Tx device
%
%   [txSig,dataIn] = LoRa_Emitter(CR,SF,Pr_len,binary_data,whiteNoise)
%
%   Tx chain : Hamming -> Whitening -> Interleaver -> Bits to Symbols -> Modulation
%
% INPUTS :
%
%   CR : Coding Rate (1:4)
%   SF : Spreading Factor (7:12)
%   Pr_len : Preamble length (min. = 2)
%   binary_data : Binary vector payload to send
%   whiteNoise : White noise (to increase speed, the noise is already generated)
%
% OUTPUTS :
%
%   txSig : IQ Signal to be sent
%   dataIn : Formatted payload to be compared with dataOut at the other end
%   of the channel
%
% See also LoRa_Encode_Hamming, LoRa_Whitening, LoRa_Interleaving,
% LoRa_Bits_To_Symbols, LoRa_Modulation

%% Message to binary vector

hammingIn = reshape(logical(binary_data),4,[]); % Groups of 4 data bits 

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

preambleUpMod = LoRa_Modulation(SF,zeros(Pr_len+2,1),1);
preambleDownMod = LoRa_Modulation(SF,ones(3,1),-1);
payloadMod = LoRa_Modulation(SF,payload,1);

txSig= [preambleUpMod ; preambleDownMod(1:(2^SF)*2.25) ; payloadMod];

end

