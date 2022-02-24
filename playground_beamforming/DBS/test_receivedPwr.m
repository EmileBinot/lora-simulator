clear;
close all;

Tx_ant=4;
Rx_ant=1;
num_path=5;
[H,AoD,AoA,alpha,bestPath] = angular_channel(Tx_ant,Rx_ant,num_path);

NumPayload=500;
SNRdB=35;

r=0;
for angle=0:pi/180:pi
    r=r+1;
    
    bitsIn = randi([0 1],NumPayload,1)';
    s = map_QPSK(1,bitsIn) ;
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
    
    % steering_vector=exp(-1i*pi*sin(AoD_el(LoS))*[1:TX_ant_h]);
    steering_vector=exp(-1i*pi*cos(angle)*[1:Tx_ant]);
    Wdbs=steering_vector'/Tx_ant; 
    x_beam=Wdbs*s;
    y_beam=H*x_beam+noise;
    
    Pwr_beam_good(r)=(norm(y_beam)^2)/NumPayload;
end
    
plot(0:1:180,Pwr_beam_good);
xlabel('Received Power');
ylabel('Steering angle');
title("Received Power vs Steering angle");