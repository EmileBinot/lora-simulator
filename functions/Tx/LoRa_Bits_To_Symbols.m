function [symbols] = LoRa_Bits_To_Symbols(inMatrix)
%LoRa_Bits_To_Symbols Converts bits to symbols
% INPUTS :
%
%   inMatrix : L x SF input binarymatrix
%
% OUTPUT :
%
%   symbols : L x 1 output symbols (double) vector 
%
% See also b2d,LoRa_Symbols_To_Bits
symbols = [];

for i = 1 :size(inMatrix,1)
    symbols = [ symbols ; b2d(inMatrix(i,:)) ];
end

end

