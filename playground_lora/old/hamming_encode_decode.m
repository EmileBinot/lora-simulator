clear;
CR = 4;
in =[1 0 0 1];

%% EMITTER

switch CR
   case 1
        %disp(['CR ='  num2str(CR) ' not supported']);
   case 2
       
        %G= [0 0 0 1 0 1 1 1;0 0 1 0 1 1 0 1;0 1 0 0 1 1 1 0; 1 0 0 0 1 0 1 1];
        %out =  logical(in*G);
   case 3
        % Hamming(7,4)
        [H,G,~,~] = hammgen(3);
        out =  mod(in * G,2);
        %encoded = [p0 p1 p2 d0 d1 d2 d3]
   case 4
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

%% CHANNEL

%received = xor(encoded,[0 0 0 1 0 0 0]); %adding error
%encoded = received;

%% RECEIVER
switch CR
   case 1
       disp(['CR ='  num2str(CR) ' not supported']);
   case 2
       in=in(:,1:6);
       disp(['CR ='  num2str(CR) ' not supported']);
   case 3
       S =  mod(H * out',2);
   case 4
       S =  mod(H * out',2);
   otherwise
      disp(['WRONG CR']);
end

