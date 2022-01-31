function [bitsOut] = demap_QPSK(grayCoding,symbolsIn)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Get number of symbols available at the input
numSymbols = length(symbolsIn); 

% Calculate the number of bits
bitsPerSymbol = 2; 
numBits = numSymbols*bitsPerSymbol; 

% Initialize bitstream in matrix form
bitStream=zeros(bitsPerSymbol,numSymbols);

% THRESHOLD DETECTOR

% Use Natural or Gray coding for demodulation
if (grayCoding == true) %If Gray coding is used

    bitStream(1,find(real(symbolsIn)<0))=1;
	bitStream(2,find(imag(symbolsIn)>0))=1; 
else %If Natural coding is used

    bitStream(1,find((real(symbolsIn)>0)&(imag(symbolsIn)<0)))=1;
    bitStream(1,find((real(symbolsIn)<0)&(imag(symbolsIn)>0)))=1;
	bitStream(2,find(imag(symbolsIn)>0))=1;  

end

bitsOut=(bitStream(:)>0).'; %vectorization of the bitstream

end

