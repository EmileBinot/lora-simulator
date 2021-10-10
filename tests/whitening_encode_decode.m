clear;
CR = 3;
symbols =[1 0 0 0 1 0 0 0];


%% GENERATING NOISE SEQUENCE
%noise source : 9 bits LFSR intialized to 0

%using this function : https://linear-feedback-shift-register.readthedocs.io/en/latest/matlab.html

s=[1 1 1 1 1 1 1 1 1];
t=[9 5];
[white_sequence,c] =LFSRv2(s,t);


%% EMITTER

N = min([length(symbols) length(white_sequence)]); % cut-off to length of transmit symbols
whitened = bitxor(symbols(1:N),white_sequence(1:N)); % encode white


%% RECEIVER

N = min([length(whitened) length(white_sequence)]); % cut-off to length of transmit symbols
dewhitened = bitxor(whitened(1:N),white_sequence(1:N)); % decode white