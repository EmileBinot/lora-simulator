function [out] = LoRa_Dewhitening(in,whiteNoise)
%LoRa_Dewhitening LoRa style de-whitening block
%
%   [out] = LoRa_Dewhitening(in,whiteNoise)
%
% INPUTS :
%
%   in : input whitened binary vector
%   whiteNoise : already calculated white noise binary vector
%
% OUTPUT :
%
%   out : de-whitened bits vector
%
% noise source : 9 bits LFSR intialized to 0
%
% For more information, see <a href="matlab: 
% web('https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html')">LFSR function used</a>
% See also LoRa_Whitening

N=ceil(length(in)/length(whiteNoise));
if N>1
    for i=1:N
        whiteNoise=[whiteNoise, whiteNoise];
    end
end

N = min([length(in) length(whiteNoise)]); % cut-off to length of transmit symbols
out = bitxor(in(1:N),whiteNoise(1:N)); % encode white

end

