function [out] = LoRa_Decode_Hamming(in,CR)

% NO CORRECTIVE ACTION IMPLEMENTED YET !!!

switch CR
   case 1
       disp(['CR ='  num2str(CR) ' not supported']);
   case 2
       in=in(:,1:6);
       disp(['CR ='  num2str(CR) ' not supported']);
   case 3
       
       %in=in(:,1:7);
       %[H,~,~,~] = hammgen(3);
       %S =  logical(in*H');
   case 4
       out=in(:,1:4);
   otherwise
      disp(['WRONG CR']);
end

end
