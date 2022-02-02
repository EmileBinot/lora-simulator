% clear; close all;
Num_users=1;
TX_ant_w=1;
TX_ant_h=4;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=3;
N_ant_TX=TX_ant_h*TX_ant_w;

[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

% Initialization
NumPayload=500;
SNRdB=25;
H=squeeze(H).';
tries = 30;
grayCoding=1;
angle_el_deg=50;  % no more than abs(90) [-pi/2 pi/2]
angle_az_deg=50;	% no more than abs(90)
angle_el_deg_worst=25;  % no more than abs(90)
angle_az_deg_worst=0;	% no more than abs(90)

for r = 1:tries
    [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
        =generate_channels_fixedAngles(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths,angle_el_deg,angle_az_deg,angle_el_deg_worst,angle_az_deg_worst);
    
    bitsIn = randi([0 1],NumPayload,1)';
    s = map_QPSK(grayCoding,bitsIn) ;
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
    H=squeeze(H).';
% transpose(exp(1j*pi*(ind_TX_w*sin(AoD_az(u,k))*sin(AoD_el(u,k))+ind_TX_h*cos(AoD_el(u,k))) ));
    % bad DBS precoding (=no beamsteering), pointing always in one
    % direction
    [~, worst_path]= min(alpha(:));
    bad_steering_vector_h=exp(-1i*pi*sin(0)*[1:TX_ant_h]);
    bad_steering_vector_w=exp(-1i*pi*sin(0)*cos(0)*[1:TX_ant_w]);
    bad_steering_vector=kron(bad_steering_vector_w,bad_steering_vector_h);
    bad_Wdbs=bad_steering_vector'/N_ant_TX; 
    bad_x_beam=bad_Wdbs*s;
    bad_y_beam=H*bad_x_beam+noise;  
    
    % good DBS precoding, pointing to the best path (LoS)
    good_steering_vector_h=exp(-1i*pi*sin(AoD_el(LoS))*[1:TX_ant_h]);
    good_steering_vector_w=exp(-1i*pi*sin(AoD_az(LoS))*cos(AoD_el(LoS))*[1:TX_ant_w]);
    good_steering_vector=kron(good_steering_vector_w,good_steering_vector_h);
    good_Wdbs=good_steering_vector'/N_ant_TX; 
    good_x_beam=good_Wdbs*s;
    good_y_beam=H*good_x_beam+noise;
    
    % BIS
    good_steering_vector_h=exp(1i*pi*sin(AoD_el(LoS))*[1:TX_ant_h]*sin(AoD_el(LoS)));
    good_steering_vector_w=exp(1i*pi*cos(AoD_el(LoS))*[1:TX_ant_w]);
    good_steering_vector=kron(good_steering_vector_w,good_steering_vector_h);
    good_Wdbs=good_steering_vector'/N_ant_TX; 
    good_x_beam=good_Wdbs*s;
    good_y_beam=H*good_x_beam+noise;
    
%     prod=exp(1j*pi*([1:TX_ant_w]*sin(AoD_az(LoS))*sin(AoD_el(LoS))+[1:TX_ant_h]*cos(AoD_el(LoS))) );
    
    bitsOut_bad = demap_QPSK(grayCoding,bad_y_beam);
    bitsOut_good = demap_QPSK(grayCoding,good_y_beam);
    

    
    [~,ratio_bad(r)] = biterr(bitsIn,bitsOut_bad);
    [~,ratio_good(r)] = biterr(bitsIn,bitsOut_good);
end
figure(1);

plot(bad_y_beam,'.'); hold on;
plot(good_y_beam,'.');hold on;
plot(awgn(s,SNRdB,'measured'),'.'); 
legend('bad path','good path','QPSK');
hold off;

mean(ratio_bad)
mean(ratio_good)

figure(2);
plot(ratio_bad); hold on;
plot(ratio_good);
hold off;


steering_vector_h=good_steering_vector_h;
steering_vector_w=good_steering_vector_w;
% get radiation value from -pi/2 to pi/2 in azimuth and elevation
angle_deg=[-90:1:90]; 
for k=1:length(angle_deg)
    x_test_h=exp(1i*pi*sin(angle_deg(k)*pi/180)*[0:TX_ant_h-1].');
    ArrayFactor_h(1,k)=abs(prod*x_test_h);
    x_test_w=exp(1i*pi*sin(angle_deg(k)*pi/180)*[0:TX_ant_w-1].');
    ArrayFactor_w(1,k)=abs(steering_vector_w*x_test_w);
end

% Calculate result array factor
ArrayFactor=kron(ArrayFactor_w,ArrayFactor_h.');

figure(3);
% s=mesh(phi_deg,phi_deg,BF);                   % 3D
% s.FaceColor = 'flat';
% OR
s=imagesc(angle_deg,angle_deg,ArrayFactor);     % 2D heatmap
% set ( gca, 'ydir', 'reverse' )
xlim([-90 90]); xlabel('azimuth (largeur)');
ylim([-90 90]); ylabel('elevation (hauteur)');
title(['Radiation pattern , azimuth: ' num2str(angle_az_deg) '° / elevation: ' num2str(angle_el_deg) '°']);

