clear; close all;
% CR=3;
% bypass=0;
% 
% m=[0 1 0 0]
% [c] = LoRa_Encode_Hamming(m,CR,bypass);
% 
% err= [0 0 1 0 0 0 0]
% rc= xor(c,err)
% 
% [m_hat] = LoRa_Decode_Hamming(rc,CR,bypass)

% 
% m=gf([0 1 0 0]) 
% % G=[0 0 0 1 0 1 1 1;0 0 1 0 1 1 0 1;0 1 0 0 1 1 1 0;1 0 0 0 1 0 1 1];
% 
% 
% % emitter
% Id=eye(4);
% Q=gf([0 1 1 1;1 1 0 1; 1 1 1 0;1 0 1 1]);
% G=gf([Id Q]);
% c=m*G
% 
% err=gf([1 0 0 0 0 0 0 0]);
% rc=c+err
% 
% % receiver
% H=gf([Q.' Id]);
% S=rc*H.'

%precompute syndrome decoding table
CR=3;
n=4+CR;
k=4;
Q=[1 1 1;1 1 0; 1 0 1;0 1 1];
G=[eye(k) Q];

H=[Q.' eye(n-k)];

% generate lookup table

E=[zeros(1,n-k+4); eye(n-k+4)];
S=zeros(size(E,1),n-k);
for i=1:size(E,1)
    S(i,:)=E(i,:)*H.';
end

% test
m=[0 1 0 0];
c=m*G

err=[0 0 0 0 0 0 1];

rc=xor(c,err)
synd=mod(rc*H.',2);
for i=1:size(S,1)
    if S(i,:)==synd
        l=i;
        c_hat=xor(rc,E(l,:))
    end
end
