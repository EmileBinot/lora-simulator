clear;
close all;

Tx_ant=4;
Rx_ant=1;

Tx_ant_vect=0:1:Tx_ant-1;
Rx_ant_vect=0:1:Rx_ant-1;

num_path=1;
H=zeros(Rx_ant,Tx_ant);  % One user channel

AoD=[pi/2 pi/4];
AoA=[pi/2 pi/4];

a=[1 0.1];

for i = 1:num_path
    e_t=ones(num_path,1);
    e_r=ones(num_path,1);
    
    e_t=(1/(sqrt(Tx_ant)))*exp(-1i*pi*cos(AoD(i))*Tx_ant_vect.');
    e_r=(1/(sqrt(Rx_ant)))*exp(-1i*pi*cos(AoA(i))*Rx_ant_vect.');
    
    H=H+a(i)*e_r*e_t.';
end



% angle_deg=[0:1:180]; 
% for k=1:length(angle_deg)
%     x_test=exp(1i*pi*cos(angle_deg(k)*pi/180)*Tx_ant_vect);
%     ArrayFactor(k)=abs(x_test*e_t);
% end
% 
% plot(ArrayFactor);