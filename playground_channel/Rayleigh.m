clear;
close all;
Ls=1000;
SNR_dB=40;
P=1;
multipath=4;

signal_r=2*(rand([Ls,1])>0.5)-1;
signal_i=2*(rand([Ls,1])>0.5)-1;
QPSK=signal_r+1i*signal_i;
Es=((QPSK)' *(QPSK) ) / Ls;
N0=Es/10^(SNR_dB/10);
h=sqrt(P/2)*(randn(1,multipath)+1i*randn(1,multipath));
fading=conv(QPSK , h);
noise=sqrt(N0/4)*( randn(length(fading),1)+1i*randn(length(fading),1) );
received = fading+noise;

plot(QPSK,'.'); hold on
plot(received,'.');