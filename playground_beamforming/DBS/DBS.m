clear; close all;
Num_users=1;
TX_ant_w=20;
TX_ant_h=1;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=50;

[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

% OUTPUT :
% 
% H : Channel matrix
% alpha : Attenuation matrix for each user (row -> user, column -> paths)
% AoD_el : Elevation Angle of Departure
% AoD_az : Azimuth Angle of Departure -> from the BS
% AoA_el : Elevation Angle of Arrival
% AoA_ar : Azimith Angle of Arrival -> on the UE
% LoS : Index of the LoS traject in the alpha

NumPayload=50;
SNRdB=30;

s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(20);
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);

steering_vector=exp(-1i*pi*sin(AoD_az(LoS))*[0:TX_ant_w-1].')/sqrt(TX_ant_w);

Wdbs=steering_vector';

Hprod=permute(H,[3 2 1]);


y=alpha*s+noise;
figure;
plot(y,'b.'); hold on;
plot(s,'r.');

%% PLOT BEAMPATTERN

% lambda = 1;         % Incoming Signal Wavelength in (m).
% d      = lambda/2;  % Interelement Distance in (m).
% angle = -90:0.1:90;
% L = length(angle);
% C1 = zeros(1,L);
% 
% for k=1:L
%     u = (d/lambda)*sin(angle(k)*pi/180);
%     v = exp(-1i*2*pi*u*(0:TX_ant_w-1).')/sqrt(TX_ant_w); % Azimuth Scanning Steering Vector.
%     C1(k) = steering_vector'*v;
% end
% 
% figure('NumberTitle', 'off','Name','Figure 11.9');
% % This plots the instantaneous power for every element (M waveforms).
% plot(angle,10*log10(abs(C1).^2));
% ylim([-70 5]);
% xlim([-90 90]);
% grid on;
% title(['Beampattern Using Definition ' num2str(rad2deg(AoD_az(LoS)))]);
% xlabel('Angles (-90:90)');
% ylabel('Output Power (dB)');
