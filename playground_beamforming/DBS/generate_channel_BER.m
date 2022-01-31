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

% Initialization
NumPayload=500;
SNRdB=35;
H=squeeze(H).';
tries = 5000;
grayCoding=1;

for r = 1:tries
    [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
        =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);
    
    bitsIn = randi([0 1],NumPayload,1)';
    s = map_QPSK(grayCoding,bitsIn) ;
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
   
    
    bitsOut_bad = demap_QPSK(grayCoding,bad_y_beam);
    bitsOut_good = demap_QPSK(grayCoding,good_y_beam);
    
    [~,ratio_bad(r)] = biterr(bitsIn,bitsOut_bad);
    [~,ratio_good(r)] = biterr(bitsIn,bitsOut_good);
end

mean(ratio_bad)
mean(ratio_good)

plot(ratio_bad); hold on;
plot(ratio_good)