function [out] = LoRa_Symbols_To_Bits(symbols,SF)
%LORA_SYMBOLS_TO_BITS Summary of this function goes here
%   Detailed explanation goes here

out = [];

for i = 1 :size(symbols,1)
    out = [ out ; de2bi(symbols(i,:),SF,'left-msb') ];
end

end

