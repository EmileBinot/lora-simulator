clear; close all;
Num_users=1;
TX_ant_w=1;
TX_ant_h=4;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=3;
N_ant_TX=TX_ant_h*TX_ant_w;
[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels_fixedAngles(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

% Tx
NumPayload=50;
SNRdB=35;

s=1/sqrt(2)*randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i]);
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
n=ones(N_ant_TX,1)*s/N_ant_TX;
H=squeeze(H).';

figure;
r=0;
for phi = 0:pi/128:pi
    r=r+1;
    % Tx DBS precoding
    steering_vector=1/(sqrt(N_ant_TX))*exp(-1i*pi*sin(phi)*[1:TX_ant_h]);
    Wdbs=steering_vector'; 
    x_beam=Wdbs*s;

    % Rx
    y_beam=H*x_beam+noise; 
    Pwr(r)=(norm(y_beam)^2)/NumPayload; % measurate received pwr
end
phi = 0:pi/128:pi;
plot(phi/pi,Pwr)
polarplot(phi,Pwr)
[~,idx]=max(Pwr);
angle(idx)
title(max(Pwr))