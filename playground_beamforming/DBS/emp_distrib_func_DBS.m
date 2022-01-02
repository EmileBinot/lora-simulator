clear; close all;
% -------------------------------------------------------------------------
Num_users=1;
TX_ant_w=4;
TX_ant_h=1;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=1;
N_ant_TX=TX_ant_w*TX_ant_h;

for r = 1:1000
    [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
        =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths);

    % Tx
    NumPayload=50;
    SNRdB=35;

    s=randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i])/1/sqrt(2);
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
    H=squeeze(H).';

    % No precoding 
    x=(ones(TX_ant_w,1)/N_ant_TX)*s;
    y=H*x+noise; 

    % bad DBS precoding
    [~, worst_path]= min(alpha(:));
    bad_steering_vector=exp(-1i*pi*sin(AoD_az(worst_path))*[1:TX_ant_w]);
    bad_Wdbs=bad_steering_vector'/N_ant_TX; 
    bad_x_beam=bad_Wdbs*s;
    bad_y_beam=H*bad_x_beam+noise;  
    
    % good DBS precoding
    %steering_vector=exp(-1i*pi*sin(AoD_az(LoS))*[1:TX_ant_w]);
    steering_vector=a_TX_los.';%a_TX_los marche mieux que beam_bad!!!! pb de normalisation ?
    Wdbs=steering_vector'/N_ant_TX; 
    x_beam=Wdbs*s;
    y_beam=H*x_beam+noise;  

    % Received pwr

    Pwr(r)=(norm(y)^2)/NumPayload;
    Pwr_beam(r)=(norm(y_beam)^2)/NumPayload;
    Pwr_beam_bad(r)=(norm(bad_y_beam)^2)/NumPayload;
end

%figure;
%plot(Pwr,'r'); hold on;
%plot(Pwr_beam,'g');
%legend(['Pwr, mean = ' num2str(mean(Pwr))],['Pwr beam, mean = ' num2str(mean(Pwr_beam))])
disp(['Pwr, mean = ' num2str(mean(Pwr))])
disp(['Pwr beam, mean = ' num2str(mean(Pwr_beam))])
disp(['Pwr beam bad, mean = ' num2str(mean(Pwr_beam_bad))])
% -------------------------------------------------------------------------
% Plots
% -------------------------------------------------------------------------
% figure;
% plot(s,'b.'); hold on;
% plot(y,'r.'); hold on;
% plot(y_beam,'g.');
% 
% figure;
% plot(abs(alpha));