function [out] = LoRa_Interleaving(in,CR,SF)
%LoRa_Interleaving LoRa style interleaving block
%
%   [out] = LoRa_Interleaving(in,CR,SF)
%
% INPUTS :
%
%   in : SF x (4+CR) matrix
%   CR : Coding Rate (1:4)
%   SF : Spreading Factor (7:12)
%
% OUTPUT :
%
%   out : CR+4 x SF matrix
%
% For more information on the algorithm used, see <a href="matlab: 
% web('doi.org/10.1016/j.comcom.2020.02.034')">Towards an SDR implementation of LoRa</a>
% See also LoRa_DeInterleaving

%% Interleaving
out=zeros(CR+4,SF);
for i= 0:(CR+4)-1
    for j=0:(SF)-1
        idi=SF-1-mod(j-i,SF);
        idj=CR+4-1-i;
        out(i+1,j+1)=in(idi+1,idj+1);
    end
end

end

