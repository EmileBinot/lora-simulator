clear; close all;
Num_users=1;
TX_ant_w=4;
TX_ant_h=4;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=3;
N_ant_TX=TX_ant_h*TX_ant_w;

[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

% Initialisation
NumPayload=50;
SNRdB=35;
H=squeeze(H).';
tries = 5000;

for r = 1:tries
    [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
        =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

    s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/1/sqrt(2);
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
    H=squeeze(H).';

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

    % Save received power : https://www.gaussianwaves.com/2013/12/computation-of-power-of-a-signal-in-matlab-simulation-and-verification/
    Pwr_beam_good(r)=(norm(good_y_beam)^2)/NumPayload;
    Pwr_beam_bad(r)=(norm(bad_y_beam)^2)/NumPayload;
   
end

binrng = 0:0.01:2;                               % Choose Bin Centres
figure;
plot(binrng, ecdfunc(Pwr_beam_good,binrng),binrng,ecdfunc(Pwr_beam_bad,binrng));
grid;
legend('Beamsteering to the best path','No Beamsteering','Location', 'southeast');
title(['Empirical Cumulative Distribution (Received Power) '  int2str(tries)  ' tries']);
xlabel('Received Power') 
ylabel('Probability NOT to exceed threshold') 

disp(['Pwr beam good, mean = ' num2str(mean(Pwr_beam_good))])
disp(['Pwr beam bad, mean = ' num2str(mean(Pwr_beam_bad))])