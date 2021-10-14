function [symbols] = LoRa_Bits_To_Symbols(inMatrix,SF)

M  = 2^SF;

symbols = [];

for i = 1 :size(inMatrix,1)
    symbols = [ symbols ; binaryVectorToDecimal(inMatrix(i,:)) ];
end

end

