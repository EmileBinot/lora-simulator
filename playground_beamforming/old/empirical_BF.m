close all; clear; clc; rng(1);

SNRdB = 15;
SIRdB = -20;

N=4;

NumPilots=100;
NumPayload=1000;

theta_deg=0;
x_desired=exp(-1i*pi*sin(theta_deg*pi/180)*[0:N-1].');

Interf_angle=-50;
x_Interf=exp(-1i*pi*sin(Interf_angle*pi/180)*[0:N-1].');

pilots=randsrc(1,NumPilots,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);
s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);

%Signal Generation
a_desired=exp(1i*2*pi*rand);
y_desired=a_desired*x_desired*[pilots,s];

r=(randn(1,length([pilots,s]))+1i*randn(1,length([pilots,s])))/sqrt(2);
y_interf=exp(1i*2*pi*rand)*x_Interf*10^(-SIRdB/20)*r;

Noise=10^(-SNRdB/20)*(randn(size(y_desired))+1i*randn(size(y_desired)))/sqrt(2);

y=y_desired+y_interf+Noise;

Y=y(:,1:NumPilots).';
p=pilots.';

w_hat=inv(Y'*Y)*Y'*p;

% Y'*Y = empirical total covariance
% Y'*p = estimate of channel
% We do that because spacial covariance matrix is hard to get.
% w_hat is the least square estimate of w

%Reconstrut QAMs

s_hat_MRC=(a_desired*x_desired)'/N*y(:,NumPilots+1:end);

plot(s_hat_MRC,'.'); grid; hold on ;
title(['Reconstructed QAMs with ',num2str(N), 'Rx antennas, at SIR =',num2str(SIRdB),'dB and SNR=',num2str(SNRdB),'dB'])

s_hat_ebf=w_hat.'*y(:,NumPilots+1:end);
plot(s_hat_ebf,'r.');

%EVM Calculation
EVM_ebf_dB=10*log10(mean(abs(s_hat_ebf-s).^2));

legend('MRC Perfect channel',['Empirical BF, EVM',num2str(EVM_ebf_dB),'dB']);

% Plot the spatial response
phi_deg=[-90:.1:90];
for k=1:length(phi_deg)
    x_test=exp(-1i*pi*sin(phi_deg(k)*pi/180)*[0:N-1].');
    MRC_resp(k)=abs(x_desired'*x_test)/N;
    Emp_BF_response(k)=abs(w_hat.'*x_test);
end

figure;
plot(phi_deg,20*log10(MRC_resp));hold on; grid;
plot(phi_deg,20*log10(Emp_BF_response),'r');
ylim([-60 12]); xticks(-90:25:90);
title(['Spatial Res. with',num2str(N),' Rx antennas. Desired at ', num2str(theta_deg),'deg and Interf at ',num2str(Interf_angle),'deg']);
xlabel('DOA(deg)'); ylabel('Response (dB)');
legend('MRC (perfect channel)','Empirical BF');