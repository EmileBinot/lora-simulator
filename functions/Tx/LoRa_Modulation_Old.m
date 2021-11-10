function [rxSig,ts] = LoRa_Modulation_Old(B,SF,symbols,sign)

% Equations taken from : hal.archives-ouvertes.fr/hal-02485052/document

% Constants :
M  = 2^SF;  % Number of possible symbols
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
T  = M*Ts;  % because B*T=M
ts = (0:Ts:(length(symbols)*T)-Ts)';      % Time vector

rxSig=0;


for k = 1:length(symbols)
    % up to 0.71 seconds / symbol, multiplying by rect is taking a lot of  time:
    symbK= rectangularPulse(0+((k-1)*T), T+((k-1)*T), ts).*exp(2i*pi*sign*(B/(2*T).*ts+symbols(k)/T).*ts).*exp(-2i*pi*B.*ts); 
    rxSig = rxSig + symbK; % taking negligible time
end

rxSig(1,1)=1;

end

