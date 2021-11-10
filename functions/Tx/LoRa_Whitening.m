function [out] = LoRa_Whitening(in)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%noise source : 9 bits LFSR intialized to 0

%using this function : https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html

s=[1 1 1 1 1 1 1 1 1];
t=[9 5];
[whiteNoise,c] =LFSRv2(s,t);

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

