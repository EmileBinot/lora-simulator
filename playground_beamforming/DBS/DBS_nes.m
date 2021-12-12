clear; close all;

Num_users=1;
TX_ant_w=4;
TX_ant_h=4;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=1;
N_Txantennas=TX_ant_w*TX_ant_h;
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
s=(randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2)).';
noise=(10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2)).';

%Creating steering vectors then kron product them
steering_vector_el=(exp(-1i*pi*sin(AoD_el(LoS))*[0:TX_ant_h-1])/sqrt(TX_ant_h)).';
%steering_vector_el=1;
%steering_vector_az=exp(-1i*pi*sin(AoD_az(LoS))*cos(AoD_el(LoS))*[0:TX_ant_w-1].')/sqrt(TX_ant_w);
steering_vector_az=(exp(-1i*pi*sin(AoD_az(LoS))*[0:TX_ant_w-1])/sqrt(TX_ant_w)).';
steering_vector = kron(steering_vector_el,steering_vector_az);

Hprod=permute(H,[3 2 1]);

% DBS precoding
Wdbs=steering_vector'; 
x=s*Wdbs; 
y_beam=x*Hprod+noise; % with beamsteering pointing to LOS path

% No precoding
x2=s*ones(1,N_Txantennas).*1/sqrt(N_Txantennas);
y=x2*Hprod+noise; % without beamsteering

%
figure();
plot(abs(alpha))

% PLOT RECEIVED SYMBOLS

figure;

plot(y,'g.'); hold on;
plot(y_beam,'b.');hold on;
p= plot(s,'+'); 
set(p,'Color','red','MarkerSize',10,'MarkerEdgeColor','red','LineWidth',2);
%legend('Symbols at Rx','Symbols at Rx w/ beamforming','Symbols at Tx');
title('Rice channel, DBS precoder (Digital Beam Steering)');

% PLOT BEAMPATTERN

lambda = 1;         % Incoming Signal Wavelength in (m).
d      = lambda/2;  % Interelement Distance in (m).
angle = -90:0.1:90;
L = length(angle);
C1 = zeros(1,L);
C2 = zeros(1,L);

for k=1:L
    u = (d/lambda)*sin(angle(k)*pi/180);
    v_az = exp(-1i*2*pi*u*(0:TX_ant_w-1).')/sqrt(TX_ant_w); % Azimuth Scanning Steering Vector.
    C1(k) = steering_vector_az'*v_az;
    v_el = exp(-1i*2*pi*u*(0:TX_ant_h-1).')/sqrt(TX_ant_h); % Azimuth Scanning Steering Vector.
    C2(k) = steering_vector_el'*v_el;
end

figure('NumberTitle', 'off','Name','Figure 11.9');
% This plots the instantaneous power for every element (M waveforms).
plot(angle,10*log10(abs(C1).^2)); hold on
plot(angle,10*log10(abs(C2).^2));hold on
xline(rad2deg(AoD_az(LoS)),'-.'); hold on
xline(rad2deg(AoD_el(LoS)),'-.'); 
legend('azimuth','elevation');
ylim([-70 5]);
xlim([-90 90]);
grid on;
title(['Beampattern, AOD az : ' num2str(rad2deg(AoD_az(LoS))) '°, AOD el : ' num2str(rad2deg(AoD_el(LoS))) '°']);
xlabel('Angles (-90:90)');
ylabel('Output Power (dB)');
