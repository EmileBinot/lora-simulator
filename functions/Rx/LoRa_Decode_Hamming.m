function [out] = LoRa_Decode_Hamming(in,CR)
%LoRa_Decode_Hamming Hamming decoding block
%
%   [out] = LoRa_Decode_Hamming(in,CR)
%
% INPUTS :
%
%   in : 1 x (CR+4) codeword
%   CR : Coding Rate (1:4)
%
% OUTPUT :
%
%   out : 1 x 4 decoded message
%
% See also LoRa_Encode_Hamming

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
       % calculating syndrome
       syndrome(:,3)=xor(xor(xor(in(1),in(2)),in(4)),in(7));
       syndrome(:,2)=xor(xor(xor(in(1),in(3)),in(4)),in(6));
       syndrome(:,1)=xor(xor(xor(in(2),in(3)),in(4)),in(5));
       
       % correcting the error (only 1 correctable error)
       if (b2d(syndrome)~= 0)
            correction_vector=zeros(1,7);
            correction_vector(1,8-(b2d(syndrome)))=1;
            correction_vector([4 1 2 7 3 6 5])=correction_vector([1 2 3 4 5 6 7]);
            corrected=xor(in,correction_vector);
            %disp(['[HAMMING]: corrected   = ', num2str(corrected)]);
       end
   case 4
       % calculating syndrome
       syndrome(:,4)=xor(xor(xor(xor(xor(xor(xor(in(1),in(2)),in(3)),in(4)),in(5)),in(6)),in(7)),in(8));
       syndrome(:,3)=xor(xor(xor(in(1),in(2)),in(4)),in(8));
       syndrome(:,2)=xor(xor(xor(in(1),in(3)),in(4)),in(7));
       syndrome(:,1)=xor(xor(xor(in(2),in(3)),in(4)),in(6));
       
       % correcting/detecting errors (up to 2 detectable errors)
       if ((b2d(syndrome(:,1:3))~=0) && b2d(syndrome(:,4)==1))
            correction_vector=zeros(1,8);
            correction_vector(1,8-(b2d(syndrome(:,1:3))))=1;
            correction_vector([4 1 2 8 3 7 6 5])=correction_vector([1 2 3 4 5 6 7 8]);
            corrected=xor(in,correction_vector);
            %disp('[HAMMING]: correction as in H(7,4)');
       elseif((b2d(syndrome(:,1:3))==0) && b2d(syndrome(:,4)==1))
           corrected=xor(in,[0 0 0 0 1 0 0 0]);
           %disp('[HAMMING]: parity bit corrupted');
       elseif((b2d(syndrome(:,1:3))~=0) && b2d(syndrome(:,4)==0))
           %disp('[HAMMING]: double error');
           corrected=in; % WHICH DECISION TO TAKE ?
       end
       %disp(['[HAMMING]: corrected   = ', num2str(corrected)]);
   otherwise
      disp('[HAMMING]: WRONG CR');
end
out=corrected(:,1:4);

% %% BYPASS
% out=in(:,1:4);
end
