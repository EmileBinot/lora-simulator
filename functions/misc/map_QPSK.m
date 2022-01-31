function [symbolsOut] = map_QPSK(grayCoding,bitsIn)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% INITIALISATION
% Get number of bits available at bitsIn input
numBits = length(bitsIn); 
% Calculate the number of symbols to generate
bitsPerSymbol = 2; 
numSymbols = floor(numBits/bitsPerSymbol);
% Calculate the number of bits actually used due to floor operation
bitStream=bitsIn(1:numSymbols*bitsPerSymbol);

% CONVERSION of the BITSTREAM into a STREAM of M-ARY SYMBOLS  
%reshape bitStream
bitStream=reshape(bitStream,bitsPerSymbol,numSymbols);
%list of bit weights to consider (first bit is LSB, last bit is MSB)
bitWeights=2.^[0:bitsPerSymbol-1];
%Int stream calculation
intStream=bitWeights(1,:)*bitStream;

% CONVERSION of the M-ARY SYMBOLS to COMPLEX SYMBOLS
if (grayCoding == true) %Use Gray coding 
 constPoints=[+1.0-1.0i,-1.0-1.0i,+1.0+1.0i,-1.0+1.0i]; %constellation points with Gray mapping
 complexStream=constPoints(intStream+1); %mapping operation

else %Use Natural coding 
 constPoints=[+1.0-1.0i,-1.0-1.0i,+1.0+1.0i,-1.0+1.0i]; %constellationpoints with Natural mapping
 complexStream=constPoints(intStream+1); %mapping operation

end

% POWER NORMALIZATION
Pavg=2;
symbolsOut = complexStream/sqrt(Pavg);

end

