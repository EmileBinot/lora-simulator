clear;
close all;

N=20;
Eb_N0_dB=10;
theta_deg=0;
x_desired=exp(-1i*pi*sin(theta_deg*pi/180)*[0:N-1].')/sqrt(N);

%% Tx

NumPayload=1000;
NumPilots=10;

pilots=randsrc(1,NumPilots,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);
s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);

%Signal Generation
txSig=x_desired*[pilots,s];

%% Channel

sigLen=length(txSig);

n = 1/sqrt(2)*[randn(N,sigLen) + 1i*randn(N,sigLen)]; % white gaussian noise, 0dB variance
h = 1/sqrt(2)*[randn(N,sigLen) + 1i*randn(N,sigLen)]; % Rayleigh channel

%%sD = kron(ones(N,1),txSig);
sD = txSig;
rxSig = h.*sD + 10^(-Eb_N0_dB/20)*n;


%% Rx

% equalization maximal ratio combining 

txSigHat =  sum(conj(h).*rxSig,1)./sum(h.*conj(h),1); 
figure;
plot(rxSig,'r.'); grid; hold on ;
plot(txSigHat,'b.'); grid; hold on ;
