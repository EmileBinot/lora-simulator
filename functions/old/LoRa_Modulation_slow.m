function [tsSig,ts] = LoRa_Modulation_slow(B,SF,symbols,sign)
%LORA_MODULATION Summary of this function goes here
%   Detailed explanation goes here

% Constants :
M  = 2^SF;  % Number of possible symbols
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
T  = M*Ts;  % because B*T=M
ts = (0:Ts:T-Ts)';      % Time vector
tsSig=[];%SLOW
%rxSig=zeros(length(symbols)*M,1); % Preallocation
%ka=1:2^SF;
for k = 1:length(symbols)
    
    symbK= exp(2i*pi*sign*(B/(2*T).*ts+symbols(k)/T).*ts).*exp(-2i*pi*B.*ts); 
    %symbK= exp(1i*pi*(ts.^2)/M).*exp(2i*pi*(symbols(k)/M)*ts); 
    %symbK= exp(1i*sign*pi*(ka.^2)/M).*exp(2i*pi*(symbols(k)/M)*ka);
    tsSig=[tsSig ; symbK]; %SLOW
    %rxSig((k-1)*M+1:(k-1)*M+M,:) = symbK;
    
end
%doing the last one
%symbK= exp(2i*pi*sign*(B/(2*T).*ts+symbols(k+1)/T).*ts).*exp(-2i*pi*B.*ts); 
%rxSig(end-M+1:end,:) = symbK;

tsSig(1,1)=1;
end

