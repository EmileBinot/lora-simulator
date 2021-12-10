close all; clear; clc; rng(1);

figure;
tilt =20;

SNRdB = 15;

N=10;

NumPilots=100;
NumPayload=1000;

theta_deg=0;
x_desired=exp(-1i*pi*sin(theta_deg*pi/180)*[0:N-1].');
x_desired_tilted=exp(-1i*pi*sin((theta_deg+tilt)*pi/180)*[0:N-1].');

s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);

%Signal Generation
y_desired=x_desired*s;

Noise=10^(-SNRdB/20)*(randn(size(y_desired))+1i*randn(size(y_desired)))/sqrt(2);

y=y_desired+Noise;

%Reconstrut QAMs

subplot(1,2,1);
s_hat_MRC=x_desired'/N*y(:,NumPilots+1:end);
plot(s_hat_MRC,'.'); grid; hold on ;
title(['Reconstructed QAMs with ',num2str(N), 'Rx antennas, at SNR=',num2str(SNRdB),'dB'])

s_hat_MRC_tilted=x_desired_tilted'/N*y(:,NumPilots+1:end);
plot(s_hat_MRC_tilted,'r.');

legend('MRC 0°',['MRC ' num2str(tilt+theta_deg)]);

% Plot the spatial response
phi_deg=[-90:.1:90];
for k=1:length(phi_deg)
    x_test=exp(-1i*pi*sin(phi_deg(k)*pi/180)*[0:N-1].');
    MRC_resp(k)=abs(x_desired'*x_test)/N;
    MRC_resp_tilted(k)=abs(x_desired_tilted'*x_test)/N;
end

subplot(1,2,2);
plot(phi_deg,20*log10(MRC_resp));hold on; grid;
plot(phi_deg,20*log10(MRC_resp_tilted),'r');
ylim([-60 12]); xticks(-90:25:90);
title(['Spatial Res. with',num2str(N),' Rx antennas. Desired at ', num2str(theta_deg),'deg']);
xlabel('DOA(deg)'); ylabel('Response (dB)');
legend('MRC 0°',['MRC ' num2str(tilt+theta_deg)]);


hold off;