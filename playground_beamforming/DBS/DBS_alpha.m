clear; close all;
% -------------------------------------------------------------------------
Num_users=1;
TX_ant_w=4;
TX_ant_h=1;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=4;
N_ant_TX=TX_ant_w*TX_ant_h;
[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);
% OUTPUT :
% H : Channel matrix
% alpha : Attenuation matrix for each user (row -> user, column -> paths)
% AoD_el : Elevation Angle of Departure
% AoD_az : Azimuth Angle of Departure -> from the BS
% AoA_el : Elevation Angle of Arrival
% AoA_ar : Azimuth Angle of Arrival -> on the UE
% LoS : Index of the LoS traject in the alpha

% -------------------------------------------------------------------------
% General setup
% -------------------------------------------------------------------------
NumPayload=50;
SNRdB=35;
s=1/sqrt(2)*randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i]);
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
n=ones(TX_ant_w,1)*s/N_ant_TX;
H=squeeze(H).';

% -------------------------------------------------------------------------
% No precoding
% -------------------------------------------------------------------------
x=ones(TX_ant_w,1)*s/N_ant_TX;
y=H*x+noise;

% -------------------------------------------------------------------------
% DBS precoding
% -------------------------------------------------------------------------
steering_vector=exp(-1i*pi*sin(0.5)*[0:TX_ant_w-1])/N_ant_TX;
Wdbs=steering_vector'; 
x_beam=Wdbs*s;
y_beam=H*x_beam+noise;

% -------------------------------------------------------------------------
% Plots
% -------------------------------------------------------------------------
figure;
plot(s,'b.'); hold on;
plot(y,'r.'); hold on;
plot(y_beam,'g.');