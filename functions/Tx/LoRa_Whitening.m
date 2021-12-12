function [out] = LoRa_Whitening(in,whiteNoise)
%LoRa_Whitening LoRa style whitening block
%
%   [out] = LoRa_Whitening(in,whiteNoise)
%
% INPUTS :
%
%   in : input binary vector
%   whiteNoise : already calculated white noise binary vector
%
% OUTPUT :
%
%   out : whitened bits vector
%
% noise source : 9 bits LFSR intialized to 0
%
% For more information, see <a href="matlab: 
% web('https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html')">LFSR function used</a>
% See also LoRa_Dewhitening

N=ceil(length(in)/length(whiteNoise));
if N>1
    for i=1:N
        whiteNoise=[whiteNoise, whiteNoise];
    end
end

N = min([length(in) length(whiteNoise)]); % cut-off to length of transmit symbols
out = bitxor(in(1:N),whiteNoise(1:N)); % encode white

% if(length(in)>white_sequence)
%     N = min([length(in) length(white_sequence)]); % cut-off to length of transmit symbols
%     whitened = bitxor(in(1:N),white_sequence(1:N)); % encode white
%     whitened = bitxor(in(N:end),white_sequence(1:length(in)));
% end
% N = min([length(in) length(white_sequence)]); % cut-off to length of transmit symbols
% whitened = bitxor(in(1:N),white_sequence(1:N)); % encode white

end

