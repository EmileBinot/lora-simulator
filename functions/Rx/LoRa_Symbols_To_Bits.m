function [out] = LoRa_Symbols_To_Bits(symbols,SF)
%LoRa_Bits_To_Symbols Converts symbols to bits
% INPUTS :
%
%   symbols : L x 1 symbols (double) vector
%   SF : Spreading Factor (7:12)
%
% OUTPUT :
%
%   symbols : L x SF output (binary) matrix
%
% See also d2b,LoRa_Bits_To_Symbols

out = [];
for i = 1 :size(symbols,1)
    %out = [ out ; de2bi(symbols(i,:),SF,'left-msb') ];
    out = [ out ; d2b(symbols(i,:),SF) ];   % using d2b instead of de2bi for speed
end

end

