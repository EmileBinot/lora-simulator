function [out] = LoRa_Dewhitening(in,whiteNoise)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%noise source : 9 bits LFSR intialized to 0

%using this function : https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html

% s=[1 1 1 1 1 1 1 1 1];
% t=[9 5];
% [white_sequence,c] =LFSRv2(s,t);

N=ceil(length(in)/length(whiteNoise));
if N>1
    for i=1:N
        whiteNoise=[whiteNoise, whiteNoise];
    end
end

N = min([length(in) length(whiteNoise)]); % cut-off to length of transmit symbols
out = bitxor(in(1:N),whiteNoise(1:N)); % encode white

end

