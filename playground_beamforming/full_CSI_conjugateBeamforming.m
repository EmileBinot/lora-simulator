close all; clear; clc; rng(1);

SNRdB = 20;

N=20;

NumPilots=100;
NumPayload=1000;

theta_deg=30;
x_desired=exp(-1i*pi*sin(theta_deg*pi/180)*[0:N-1].');

pilots=randsrc(1,NumPilots,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);
s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);

%Signal Generation
y_desired=x_desired*[pilots,s];

r=(randn(1,length([pilots,s]))+1i*randn(1,length([pilots,s])))/sqrt(2);

Noise=10^(-SNRdB/20)*(randn(size(y_desired))+1i*randn(size(y_desired)))/sqrt(2);
H=(rand(N,1)+rand(N,1)*1i).';
W=H';

txSigTR=(H.').*y_desired.*W;
txSig=(H.').*y_desired;

rxSigTR=txSigTR+Noise;
rxSig=txSig+Noise;

plot(rxSigTR,'r.');grid; hold on ;
plot(rxSig,'.b'); grid; hold on ;

title(['Reconstructed QAMs with ',num2str(N), 'Rx antennas, at SNR=',num2str(SNRdB),'dB'])