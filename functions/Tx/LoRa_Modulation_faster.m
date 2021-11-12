function [txSig] = LoRa_Modulation_faster(SF,symbols,sign)
%LORA_MODULATION Summary of this function goes here
%   Detailed explanation goes here

% Constants :
M  = 2^SF;  % Number of possible symbols
ka=1:2^SF;

txSig=zeros(length(symbols)*M,1); % Preallocation
for k = 1:length(symbols)
    symbK= exp(1i*sign*pi*(ka.^2)/M).*exp(2i*pi*(symbols(k)/M)*ka);
    %rxSig=[rxSig , symbK]; %SLOW
    txSig((k-1)*M+1:(k-1)*M+M,:) = symbK;
    
end
txSig(1,1)=1;
end

