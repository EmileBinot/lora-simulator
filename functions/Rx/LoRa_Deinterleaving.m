function [out] = LoRa_Deinterleaving(in,CR,SF)
%LoRa_Interleaving LoRa style interleaving block
%
%   [out] = LoRa_Deinterleaving(in,CR,SF)
%
% INPUTS :
%
%   in : (4+CR) x SF matrix
%   CR : Coding Rate (1:4)
%   SF : Spreading Factor (7:12)
%
% OUTPUT :
%
%   out : SF x (CR+4) matrix
%
% For more information on the algorithm used, see <a href="matlab: 
% web('doi.org/10.1016/j.comcom.2020.02.034')">Towards an SDR implementation of LoRa</a>
% See also LoRa_Interleaving

%% Deinterleaving
out=zeros(SF,CR+4);
for i= 0:(SF)-1
    for j=0:(CR+4)-1
        idi=CR+4-1-j;
        idj=mod(SF-1-i+(CR+4)-1-j,SF);
        out(i+1,j+1)=in(idi+1,idj+1);
    end
end

end
