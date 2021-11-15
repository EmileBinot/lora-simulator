function [txSig] = LoRa_Modulation_fast(SF,symbols,sign,modSymbK,demodChirp)
%LORA_MODULATION Summary of this function goes here
%   Detailed explanation goes here

% Constants :

M  = 2^SF;  % Number of possible symbols

switch SF
    case 7
        start=1;
    case 8
        start=2^7;
    case 9
        start=2^7+2^8;
    case 10
        start=2^7+2^8+2^9;
    case 11
        start=2^7+2^8+2^9+2^10;
    case 12
        start=2^7+2^8+2^9+2^10+2^11;
end

txSig=zeros(length(symbols)*M,1);
if sign == 1
    for k = 1:length(symbols)
        symbK= modSymbK(1:M,start+symbols(k));
        txSig(M*(k-1)+1:M*k,:)=symbK; %SLOW
    end
    
elseif sign == -1
    for k = 1:length(symbols)
        symbK= demodChirp(1:M,SF-6);
        txSig(M*(k-1)+1:M*k,:)=symbK; %SLOW
    end
end
txSig=txSig(:);
txSig(1,1)=1;
end

