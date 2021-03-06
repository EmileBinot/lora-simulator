function [out] = LoRa_Encode_Hamming(in,CR,bypass)
%LoRa_Encode_Hamming Hamming encoding block
%
%   [out] = LoRa_Encode_Hamming(in,CR)
%
% INPUTS :
%
%   in : 1 x 4 message
%   CR : Coding Rate (1:4)
%
% OUTPUT :
%
%   out : 1 x (4+CR) codeword
%
% See also LoRa_Decode_Hamming
if(bypass==0)
    switch CR
       case 1 % Hamming(6,4), out = [d3 d2 d1 d0 p0]
            out(:,5)=xor(xor(xor(in(1),in(2)),in(3)),in(4));% po (parity)
       case 2 % Hamming(6,4), out = [d3 d2 d1 d0 p1 p0]  
            out(:,6)=xor(xor(in(1),in(2)),in(3));% po
            out(:,5)=xor(xor(in(2),in(3)),in(4));% p1
       case 3 % Hamming(7,4), out = [d3 d2 d1 d0 p2 p1 p0]  
            k=4;
            Q=[0 1 1 1;1 1 0 1;1 1 1 0;1 0 1 1];
            G=[eye(k) Q];
            out=mod(in*G,2);
            out=out(:,1:7);
       case 4 % Hamming(8,4), out = [d3 d2 d1 d0 p3 p2 p1 p0]    
            k=4;
            Q=[0 1 1 1;1 1 0 1;1 1 1 0;1 0 1 1];
            G=[eye(k) Q];
            out=mod(in*G,2);
       otherwise
           disp(['WRONG CR']);
    end
    out(:,1:4)=in;% data

%% BYPASS
elseif (bypass==1)
    out(:,1:4)=in;% data
    out(:,5:(4+CR))=zeros(1,CR);% data
end
end