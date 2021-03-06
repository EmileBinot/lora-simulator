function [rxSig,ts] = LoRa_Modulation_Old(B,SF,symbols,sign,Fs)

% Equations taken from : hal.archives-ouvertes.fr/hal-02485052/document

% Constants :
M  = 2^SF;  % Number of possible symbols
% Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
T  = (Fs/B)*M*Ts;  
ts = (0:Ts:T-Ts)';      % Time vector
 ts= 0:2^SF;
rxSig=[1];
symbK=0;
for k = 1:length(symbols)
%     % up to 0.71 seconds / symbol, multiplying by rect is taking a lot of  time:
%     prod=exp(-2i*pi*B.*ts);
%     symbK= exp(2i*pi*sign*((B/(2*T)).*ts+symbols(k)/T).*ts).*prod; 
    

     symbK=exp(2*1i*pi*(((ts.^2)/(2*M))+((symbols(k)/M)-(1/2)).*ts));
    if k ==1
        rxSig = symbK; % taking negligible time
    else
        rxSig =[rxSig  symbK];
    end
end

rxSig(1,1)=1;

end

