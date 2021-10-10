function [whitened] = LoRa_Whitening(in)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%noise source : 9 bits LFSR intialized to 0

%using this function : https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html

s=[1 1 1 1 1 1 1 1 1];
t=[9 5];
[white_sequence,c] =LFSRv2(s,t);

N = min([length(in) length(white_sequence)]); % cut-off to length of transmit symbols
whitened = bitxor(in(1:N),white_sequence(1:N)); % encode white

end

