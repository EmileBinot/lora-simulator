close all; clear; clc; rng(1);

SNRdB = 20;
SIRdB = -20;

N=20;

NumPilots=10;
NumPayload=1000;

theta_deg=0;
x_desired=exp(-1i*pi*sin(theta_deg*pi/180)*[0:N-1].');

pilots=randsrc(1,NumPilots,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);
s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);

%Signal Generation
y_desired=x_desired*[pilots,s];

r=(randn(1,length([pilots,s]))+1i*randn(1,length([pilots,s])))/sqrt(2);

Noise=10^(-SNRdB/20)*(randn(size(y_desired))+1i*randn(size(y_desired)))/sqrt(2);
H=rand(N,1)+rand(N,1)*1i;

y=H.*y_desired+Noise;

Y=y(:,1:NumPilots);
H_hat=Y/pilots;

w_hat=conj(H_hat)./(H_hat.*conj(H_hat)); 
s_hat_MRC=sum(conj(H_hat).*y,1)./sum(H_hat.*conj(H_hat),1);

w_hat_CSI=conj(H)./(H.*conj(H)); 
s_hat_MRC_CSI =  sum(conj(H).*y,1)./sum(H.*conj(H),1); 
s=y;

plot(s,'r.');grid; hold on ;
plot(s_hat_MRC,'.b'); grid; hold on ;
plot(s_hat_MRC_CSI,'.G'); grid; hold on ;
title(['Reconstructed QAMs with ',num2str(N), 'Rx antennas, at SIR =',num2str(SIRdB),'dB and SNR=',num2str(SNRdB),'dB'])

figure;
stem(H_hat,'b.');hold on;
stem(H,'r.');



%Plot the spatial response
phi_deg=[-90:.1:90];
for k=1:length(phi_deg)
    x_test=exp(-1i*pi*sin(phi_deg(k)*pi/180)*[0:N-1].');
    MRC_perfect(k)=abs(x_desired'*x_test)/N;
    MRC_resp(k)=abs(w_hat'*x_test)/N;
    MRC_resp_CSI(k)=abs(w_hat_CSI'*x_test)/N;
end

figure;
plot(phi_deg,20*log10(MRC_resp));hold on; grid;
plot(phi_deg,20*log10(MRC_resp_CSI));hold on; grid;
plot(phi_deg,20*log10(MRC_perfect));hold on; grid;
ylim([-60 12]); xticks(-90:25:90);
title(['Spatial Res. with',num2str(N),' Rx antennas. Desired at ', num2str(theta_deg),'deg']);
xlabel('DOA(deg)'); ylabel('Response (dB)');
legend('MRC (perfect channel)','Empirical BF');