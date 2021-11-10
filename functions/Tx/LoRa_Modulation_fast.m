function [rxSig,ts] = LoRa_Modulation_fast(B,SF,symbols,sign)
%LORA_MODULATION Summary of this function goes here
%   Detailed explanation goes here

% Constants :
M  = 2^SF;  % Number of possible symbols
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
T  = M*Ts;  % because B*T=M
ts = (0:Ts:T-Ts)';      % Time vector
rxSig=[];%SLOW
%rxSig=zeros(length(symbols)*M,1); % Preallocation

for k = 1:length(symbols)
    symbK= 
    rxSig=[rxSig ; symbK]; %SLOW
    %rxSig((k-1)*M+1:(k-1)*M+M,:) = symbK;
end
rxSig(1,1)=0;


end

