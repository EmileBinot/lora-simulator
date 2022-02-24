function [H,AoD,AoA,alpha,bestPath] = angular_channel(Tx_ant,Rx_ant,num_path)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Tx_ant_vect=0:1:Tx_ant-1;
Rx_ant_vect=0:1:Rx_ant-1;

H=zeros(Rx_ant,Tx_ant);  % One user channel

% AoD=[pi/2 pi/4 pi/3];
% AoA=[pi/2 pi/3 pi/4];

AoD=pi*rand(1,Num_paths);
AoA=pi*rand(1,Num_paths);

alpha=[1 0.5 0.1];
[~, bestPath]= max(alpha);

for i = 1:num_path
    e_t=ones(num_path,1);
    e_r=ones(num_path,1);
    
    e_t=(1/(sqrt(Tx_ant)))*exp(-1i*pi*cos(AoD(i))*Tx_ant_vect.');
    e_r=(1/(sqrt(Rx_ant)))*exp(-1i*pi*cos(AoA(i))*Rx_ant_vect.');
    
    H=H+alpha(i)*e_r*e_t.';
end
end

