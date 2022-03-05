clear; close all;

% 
% nErrors_CR3=0;
% nErrors_noCR=0;
% for iter=1:1e3
%     CR=3;
%     m=randi([0 1],1,4);
%     c=LoRa_Encode_Hamming(m,CR,0);
%     err=[0 0 1 0 0 0 0];
%     rc=xor(c,err);
%     m_hat_CR3=LoRa_Decode_Hamming(rc,CR,0);
%     nErrors_CR3 = nErrors_CR3+biterr(m,m_hat_CR3);
%     m_hat_noCR=rc;
%     nErrors_noCR = nErrors_noCR+biterr(m,m_hat_noCR(:,1:4));
% end
% CR=3;
% m=[0 0 1 0];
% c=LoRa_Encode_Hamming(m,CR,0);
% err=[0 0 0 0 0 0 0];
% rc=xor(c,err);
% m_hat=LoRa_Decode_Hamming(rc,CR,0)
% %%%%%%%%%%%%%%% CR = 4 %%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% CR=4;
% m=[0 0 1 0];
% c=LoRa_Encode_Hamming(m,CR,0);
% err=[1 0 0 0 0 0 0 0];
% rc=xor(c,err);
% m_hat=LoRa_Decode_Hamming(rc,CR,0)
