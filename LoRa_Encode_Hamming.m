function [out] = LoRa_Encode_Hamming(in,CR)

switch CR
   case 1
        disp(['CR ='  num2str(CR) ' not supported']);
   case 2
        %G= [0 0 0 1 0 1 1 1;0 0 1 0 1 1 0 1;0 1 0 0 1 1 1 0; 1 0 0 0 1 0 1 1];
        %out =  logical(in*G);
        disp(['CR ='  num2str(CR) ' not supported']);
   case 3
        %G= [0 0 0 1 0 1 1 1;0 0 1 0 1 1 0 1;0 1 0 0 1 1 1 0; 1 0 0 0 1 0 1 1];
        %out =  logical(in*G);
        disp(['CR ='  num2str(CR) ' not supported']);
   case 4 %Code hamming(8,4)
        % Hamming(8,4)
        % Matrixes taken from : en.wikipedia.org/wiki/Hamming_code
        
        H=[0 1 1 1 1 0 0 0;1 0 1 1 0 1 0 0;1 1 0 1 0 0 1 0;1 1 1 0 0 0 0 1];
        G=[1 0 0 0 0 1 1 1;0 1 0 0 1 0 1 1;0 0 1 0 1 1 0 1;0 0 0 1 1 1 1 0];
        out =  mod(in * G,2);
        out(:,8)=sum(xor(out,out));
        %TODO !
        %encoded = [d0 d1 d2 d3 p0 p1 p2 p3], p3 being parity bit
   otherwise
      disp(['WRONG CR']);
end

end