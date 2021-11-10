function [symbols] = LoRa_Bits_To_Symbols(inMatrix)
%LoRa_Bits_To_Symbols Summary of this function goes here
%   Detailed explanation goes here

symbols = [];

for i = 1 :size(inMatrix,1)
    %symbols = [ symbols ; binaryVectorToDecimal(inMatrix(i,:)) ];
    %b2d being way faster than binaryVectorToDecimal
    symbols = [ symbols ; b2d(inMatrix(i,:)) ];
end

end

