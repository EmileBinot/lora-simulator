function [txSig] = LoRa_Modulation(SF,symbols,sign)
%LoRa_Modulation LoRa Modulator
%
%   [txSig] = LoRa_Modulation(SF,symbols,sign)
%
% INPUTS :
%
%   SF : Spreading Factor (7:12)
%   symbols : vector of symbols to modulate
%   sign : (-1,+1), used to choose between down-chirps and up-chirps.
%
% OUTPUT :
%
%   txSig : IQ modulated signal
%
% For more information, see <a href="matlab: 
% web('doi.org/10.1016/j.comcom.2020.02.034')">Towards an SDR implementation of LoRa</a>
prod=1;
% Constants :
M  = prod*2^SF;  % Number of possible symbols
ka=1:(2^SF)*prod;

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
