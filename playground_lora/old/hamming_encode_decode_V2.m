clear;
CR = 1;
in =[1 0 1 0];

%% EMITTER

switch CR
   case 1 % Hamming(6,4), out = [d3 d2 d1 d0 p0]
        out(:,1:4)=in;% data
        out(:,5)=xor(xor(xor(in(1),in(2)),in(3)),in(4));% po (parity)
   case 2 % Hamming(6,4), out = [d3 d2 d1 d0 p1 p0]  
        out(:,1:4)=in;% data
        out(:,6)=xor(xor(in(1),in(2)),in(3));% po
        out(:,5)=xor(xor(in(2),in(3)),in(4));% p1
   case 3 % Hamming(7,4), out = [d3 d2 d1 d0 p2 p1 p0]  
        out(:,1:4)=in;% data
        out(:,7)=xor(xor(in(1),in(2)),in(4)); % p0
        out(:,6)=xor(xor(in(1),in(3)),in(4)); % p1
        out(:,5)=xor(xor(in(2),in(3)),in(4)); % p2
   case 4 % Hamming(8,4), out = [d3 d2 d1 d0 p3 p2 p1 p0]    
        out(:,1:4)=in;% data
        out(:,8)=xor(xor(in(1),in(2)),in(4)); % p0
        out(:,7)=xor(xor(in(1),in(3)),in(4)); % p1
        out(:,6)=xor(xor(in(2),in(3)),in(4)); % p2
        out(:,5)=xor(xor(xor(xor(xor(xor(in(1),in(2)),in(3)),in(4)),out(:,6)),out(:,7)),out(:,8));%p3
        %there must to be another way to calculate out(:,8) since parity
        %bits are derived from data bits...
   otherwise
       disp(['WRONG CR']);
end

%% CHANNEL
disp(['transmitted = ',num2str(out)]);
out = xor(out,[0 0 0 0 1]); %adding error
disp(['error added = ',num2str(out)]);
corrected = out;
%% RECEIVER
switch CR
   case 1
       syndrome(:,1)=xor(xor(xor(xor(out(1),out(2)),out(3)),out(4)),out(5));
       if syndrome
           disp('error occured');
       end
   case 2
       syndrome(:,1)=xor(xor(xor(out(1),out(2)),out(3)),out(6));
       syndrome(:,2)=xor(xor(xor(out(2),out(3)),out(4)),out(5));
       % correcting the error (only 1 correctable error)
       disp(['syndrome   = ', num2str(syndrome)]);
       
       if (syndrome == [0 1])   %don't know what to do
            %correction_vector=[0 0 0 1 0 0];
            %corrected=xor(out,correction_vector);
            disp('error on d3 or p0 corrupted');
       elseif (syndrome == [1 0])
           %correction_vector=[1 0 0 0 0 0];
           %corrected=xor(out,correction_vector);
           disp('error on d0 or p1 corrupted');
       else
           disp('error not detectable');
       end
       disp(['corrected   = ', num2str(corrected)]);
   case 3
       % calculating syndrome
       syndrome(:,3)=xor(xor(xor(out(1),out(2)),out(4)),out(7));
       syndrome(:,2)=xor(xor(xor(out(1),out(3)),out(4)),out(6));
       syndrome(:,1)=xor(xor(xor(out(2),out(3)),out(4)),out(5));
       
       % correcting the error (only 1 correctable error)
       if (bi2de(syndrome)~= 0)
            correction_vector=zeros(1,7);
            correction_vector(1,8-(bi2de(syndrome)))=1;
            correction_vector([4 1 2 7 3 6 5])=correction_vector([1 2 3 4 5 6 7]);
            corrected=xor(out,correction_vector);
            disp(['corrected   = ', num2str(corrected)]);
       end
   case 4
       % calculating syndrome
       syndrome(:,4)=xor(xor(xor(xor(xor(xor(xor(out(1),out(2)),out(3)),out(4)),out(5)),out(6)),out(7)),out(8));
       syndrome(:,3)=xor(xor(xor(out(1),out(2)),out(4)),out(8));
       syndrome(:,2)=xor(xor(xor(out(1),out(3)),out(4)),out(7));
       syndrome(:,1)=xor(xor(xor(out(2),out(3)),out(4)),out(6));
       
       % correcting/detecting errors (up to 2 detectable errors)
       if ((bi2de(syndrome(:,1:3))~=0) && bi2de(syndrome(:,4)==1))
            correction_vector=zeros(1,8);
            correction_vector(1,8-(bi2de(syndrome(:,1:3))))=1;
            correction_vector([4 1 2 8 3 7 6 5])=correction_vector([1 2 3 4 5 6 7 8]);
            corrected=xor(out,correction_vector);
            disp('correction as in H(7,4)');
       elseif((bi2de(syndrome(:,1:3))==0) && bi2de(syndrome(:,4)==1))
           corrected=xor(out,[0 0 0 0 1 0 0 0]);
           disp('parity bit corrupted');
       elseif((bi2de(syndrome(:,1:3))~=0) && bi2de(syndrome(:,4)==0))
           disp('double error');
           corrected=out; % WHICH DECISION TO TAKE ?
       end
       disp(['corrected   = ', num2str(corrected)]);
   otherwise
      disp('WRONG CR');
end