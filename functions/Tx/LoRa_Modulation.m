function [txSig] = LoRa_Modulation(SF,symbols,sign)
%LORA_MODULATION Summary of this function goes here
%   Detailed explanation goes here

% Constants :
M  = 2^SF;  % Number of possible symbols
ka=1:2^SF;

%txSig=zeros(length(symbols)*M,1); % Preallocation

fact1=exp(1i*sign*pi*(ka.^2)/M); % Compute it only one time
r=1;
txSig=zeros(M,length(symbols));
for k = 1:length(symbols)
    symbK= fact1.*exp(2i*pi*(symbols(k)/M)*ka);
    txSig(:,r) = symbK;
    r=r+1;
end
txSig=reshape(txSig,[],1);
txSig(1,1)=1;
end
