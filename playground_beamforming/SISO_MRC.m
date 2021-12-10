clear; close all;
Num_users=1;
TX_ant_w=1;
TX_ant_h=1;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=5000;

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
SNRdB=20;
s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/sqrt(2);
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);

y=H*s+noise;

a=conj(H);
x_hat=a*y;

figure;
plot(s,'b.'); hold on;
plot(y,'r.'); hold on;
plot(x_hat,'g.'); hold off

figure;
plot(abs(alpha)); hold off