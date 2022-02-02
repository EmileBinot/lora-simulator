clear;
close all;
% rng('default');

Tx_ant=16;
Rx_ant=1;
num_path=3;
% [H,AoD,AoA,alpha,bestPath] = scattering_channel(Tx_ant,Rx_ant,num_path);

% Reflections
nReflections=num_path;
% ReflectingObj=[round(rand(1,nReflections)*10,1) ;round((rand(1,nReflections)-0.5)*10,1)];
ReflectingObj=[5 5 3; 5 -5 0];
Alice=[10 ; 0]; % [x ; y]
Bob=[0;0];
x=0:0.1:10;
xp=repmat(x,3,1);

a1=(ReflectingObj(2,:)-0)./(ReflectingObj(1,:)-0);
TxPath=a1.'*x;
a2=(Alice(2,:)-ReflectingObj(2,:))./(Alice(1,:)-ReflectingObj(1,:));
b2=a2*10;
RxPath=a2.'*x-b2.';

figure(1);
plot(ReflectingObj(1,:),ReflectingObj(2,:),'x','MarkerSize',10,'LineWidth',2); hold on;
plot(Bob(1,:),Bob(2,:),'bo',Alice(1,:),Alice(2,:),'go','MarkerSize',10,'LineWidth',2); hold on;
plot(x,TxPath); hold on;
plot(x,RxPath);
xlim([-1 11]);
ylim([-10 10]);

AoD=[atan(ReflectingObj(2,:)./ReflectingObj(1,:))+pi/2]; % atan(X) returns values in the interval [-?/2, ?/2]
AoA=[atan((10-ReflectingObj(1,:))./ReflectingObj(2,:))+pi/2];
AoD_deg=rad2deg(AoD);
AoA_deg=rad2deg(AoA);

Tx_ant_vect=0:1:Tx_ant-1;
Rx_ant_vect=0:1:Rx_ant-1;

H=zeros(Rx_ant,Tx_ant);  % One user channel

alpha=[1 1 1];
[~, bestPath]= max(alpha);

for i = 1:num_path
    e_t=ones(num_path,1);
    e_r=ones(num_path,1);
    
    e_t=(1/(sqrt(Tx_ant)))*exp(-1i*pi*cos(AoD(i))*Tx_ant_vect.');
    e_r=(1/(sqrt(Rx_ant)))*exp(-1i*pi*cos(AoA(i))*Rx_ant_vect.');
    
    H=H+alpha(i)*e_r*e_t.';
end

NumPayload=500;
SNRdB=35;

r=0;

for angle=0:pi/180:pi
    r=r+1;
    
    bitsIn = randi([0 1],NumPayload,1)';
    s = map_QPSK(1,bitsIn) ;
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
    
    steering_vector=exp(-1i*pi*cos(angle)*[1:Tx_ant]);
    Wdbs=steering_vector'/Tx_ant; 
    x_beam=Wdbs*s;
    y_beam=H*x_beam+noise;
    
    Pwr_beam_good(r)=(norm(y_beam)^2)/NumPayload;
end



figure(2);
plot(0:1:180,Pwr_beam_good);
xlabel('Received Power');
ylabel('Steering angle');
title("Received Power vs Steering angle");

