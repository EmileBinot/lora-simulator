function [transmittedIQ,ts] = LoRa_Modulation(B,SF,c,sign)

% Constants :
%B  = 125e3; % Bandwidth of modulated signal
%SF = 7;     % Spreading Factor
M  = 2^SF;  % Number of possible symbols
Fs = B;     % Sampling frequency
Ts = 1/Fs;  % Sampling period
T  = M*Ts;  % because B*T=M
%c  = [0 0 0 50 0 100 0 20 30];   % Symbols vector
ts = (0:Ts:(length(c)*T)-Ts)';      % Time vector


% Equations taken from : hal.archives-ouvertes.fr/hal-02485052/document

%modulated=exp(2i*pi*(B/(2*T).*ts+c/T).*ts).*exp(-2i*pi*B.*ts);

%modulated=rectangularPulse(-T, T, ts).*exp(2i*pi*(B/(2*T).*ts+c/T).*ts).*exp(-2i*pi*B.*ts);
%modulated2=rectangularPulse(T, 2*T, ts).*exp(2i*pi*(B/(2*T).*ts+64/T).*ts).*exp(-2i*pi*B.*ts);
%modulated=modulated + modulated2;

transmittedIQ=0;
for k = 1:length(c)
    
    transmittedIQ=transmittedIQ + rectangularPulse(0+((k-1)*T), T+((k-1)*T), ts).*exp(2i*pi*sign*(B/(2*T).*ts+c(k)/T).*ts).*exp(-2i*pi*B.*ts);
    
     %rectangular function dynamic view : 
        %modulated=rectangularPulse(0+((k-1)*T), T+((k-1)*T), ts);
%         plot(real(transmittedIQ));
%         pause(1);
end

transmittedIQ(1,1)=1;

end

