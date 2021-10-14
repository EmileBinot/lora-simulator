clear;
clc;
CR=4;
SF=7;

data = 'H';

%% Message to binary vector

binary = reshape(dec2bin(data, 8).'-'0',1,[]);
hamming_in = reshape(binary,4,[]);

i=0;
while mod(8*length(hamming_in),7)
    padding=[0 0;0 0;0 0;0 0];
    hamming_in=[hamming_in padding];
end

%% Hamming encoding

