function [out] = LoRa_Decode_Hamming(in,CR,bypass)
%LoRa_Decode_Hamming Hamming decoding block
%
%   [out] = LoRa_Decode_Hamming(in,CR)
%
% INPUTS :
%
%   in : 1 x (CR+4) codeword
%   CR : Coding Rate (1:4)
%   bypass : bypass = 1 : hamming block is bypassed, 0 hamming block is
%   working
%
% OUTPUT :
%
%   out : 1 x 4 decoded message
%
% See also LoRa_Encode_Hamming
if(bypass==0)
    corrected=in;
    switch CR
       case 1
           syndrome(:,1)=xor(xor(xor(xor(in(1),in(2)),in(3)),in(4)),in(5));
           if syndrome
               %disp('[HAMMING]: error occured');
           end
       case 2
           syndrome(:,1)=xor(xor(xor(in(1),in(2)),in(3)),in(6));
           syndrome(:,2)=xor(xor(xor(in(2),in(3)),in(4)),in(5));
           % correcting the error (only 1 correctable error)
           %disp(['[HAMMING]: syndrome   = ', num2str(syndrome)]);

           if (syndrome == [0 1])   %don't know what to do
                %correction_vector=[0 0 0 1 0 0];
                %corrected=xor(in,correction_vector);
                %disp('[HAMMING]: error on d3 or p0 corrupted');
           elseif (syndrome == [1 0])
               %correction_vector=[1 0 0 0 0 0];
               %corrected=xor(in,correction_vector);
               %disp('[HAMMING]: error on d0 or p1 corrupted');
           else
               %disp('[HAMMING]: error not detectable');
           end
           %disp(['[HAMMING]: corrected   = ', num2str(corrected)]);
       case 3
            n=4+CR;
            k=4;
            Q=[0 1 1;1 1 0;1 1 1;1 0 1];
            H=[Q.' eye(n-k)];
            syndrome=mod(in*H.',2);
            % generate lookup table
            E=[zeros(1,n-k+4); eye(n-k+4)];
            S=E*H.';
            for i=1:size(S,1)
                if S(i,:)==syndrome
                    l=i;
                    corrected=xor(in,E(l,:));
                end
            end
       case 4
            n=4+CR;
            k=4;
            Q=[0 1 1 1;1 1 0 1;1 1 1 0;1 0 1 1];
            H=[Q.' eye(n-k)];
            syndrome=mod(in*H.',2);
            if syndrome==[0 0 0 0]
%                 disp(["no errors"]);
            else
                parity=xor(xor(xor(xor(xor(xor(xor(in(1),in(2)),in(3)),in(4)),in(5)),in(6)),in(7)),in(8));
                if parity==1
%                      disp(["1 erreur corrigeable -> envoi de rc(:,1:7) vers decodeur 7,3"]);
                    corrected=LoRa_Decode_Hamming(in(:,1:7),3,0);
                else
%                      disp(["2 erreurs !"]);
                end
            end
       otherwise
          disp('[HAMMING]: WRONG CR');
    end
    out=corrected(:,1:4);
elseif(bypass==1)
    out=in(:,1:4);
end

end
