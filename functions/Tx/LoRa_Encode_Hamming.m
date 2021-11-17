function [out] = LoRa_Encode_Hamming(in,CR)

% switch CR
%    case 1 % Hamming(6,4), out = [d3 d2 d1 d0 p0]
%         out(:,5)=xor(xor(xor(in(1),in(2)),in(3)),in(4));% po (parity)
%    case 2 % Hamming(6,4), out = [d3 d2 d1 d0 p1 p0]  
%         out(:,6)=xor(xor(in(1),in(2)),in(3));% po
%         out(:,5)=xor(xor(in(2),in(3)),in(4));% p1
%    case 3 % Hamming(7,4), out = [d3 d2 d1 d0 p2 p1 p0]  
%         out(:,7)=xor(xor(in(1),in(2)),in(4)); % p0
%         out(:,6)=xor(xor(in(1),in(3)),in(4)); % p1
%         out(:,5)=xor(xor(in(2),in(3)),in(4)); % p2
%    case 4 % Hamming(8,4), out = [d3 d2 d1 d0 p3 p2 p1 p0]    
%         out(:,8)=xor(xor(in(1),in(2)),in(4)); % p0
%         out(:,7)=xor(xor(in(1),in(3)),in(4)); % p1
%         out(:,6)=xor(xor(in(2),in(3)),in(4)); % p2
%         out(:,5)=xor(xor(xor(xor(xor(xor(in(1),in(2)),in(3)),in(4)),out(:,6)),out(:,7)),out(:,8));%p3
%         %there must to be another way to calculate out(:,8) since parity
%         %bits are derived from data bits...
%    otherwise
%        disp(['WRONG CR']);
% end
% out(:,1:4)=in;% data

%% BYPASS
out(:,1:4)=in;% data
out(:,5:(4+CR))=zeros(1,CR);% data
end