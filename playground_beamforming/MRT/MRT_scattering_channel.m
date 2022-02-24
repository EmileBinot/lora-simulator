clear;
close all;
% rng('default');

Tx_ant=16;
Rx_ant=1;
nReflections=2;
% [H,AoD,AoA,alpha,bestPath] = scattering_channel(Tx_ant,Rx_ant,num_path);

% Reflections
ReflectingObj=[round(rand(1,nReflections)*10,1) 5;round((rand(1,nReflections)-0.5)*10,1) 0];
% ReflectingObj=[5 5 3; 5 -5 0];
Alice=[10 ; 0]; % [x ; y]
Bob=[0;0];
Eve=[8;-4];
x=0:0.1:10;
xp=repmat(x,3,1);

a1=(ReflectingObj(2,:)-0)./(ReflectingObj(1,:)-0);
TxPath=a1.'*x;
a2=(Alice(2,:)-ReflectingObj(2,:))./(Alice(1,:)-ReflectingObj(1,:));
b2=a2*10;
RxPath=a2.'*x-b2.';

figure(1);
plot(ReflectingObj(1,1:end-1),ReflectingObj(2,1:end-1),'x','MarkerSize',10,'LineWidth',2); hold on;
plot(Bob(1,:),Bob(2,:),'bo',Alice(1,:),Alice(2,:),'go',Eve(1,:),Eve(2,:),'ro','MarkerSize',10,'LineWidth',2); hold on;


% idx=find(TxPath(1:end-1,:)==ReflectingObj(2,1:end-1).');
% plot(x(:,1:idx),TxPath(:,1:idx)); hold on;
% plot(x,RxPath.*(x.'>=ReflectingObj(1,:)).');
% for i=1:size(ReflectingObj)-1
%     idx(i)=find(TxPath(i,:)==ReflectingObj(2,i).');
% end

plot(x,TxPath); hold on;
plot(x,RxPath); hold on;

xlim([-1 11]);
ylim([-10 10]);
xlabel('x');
ylabel('y');
text(Bob(1,:)-0.3,Bob(2,:)-1,'Bob');
text(Alice(1,:)-0.4,Alice(2,:)-1,'Alice');
text(Eve(1,:)-0.3,Eve(2,:)-1,'Eve');


AoD=[pi/2 atan(ReflectingObj(2,:)./ReflectingObj(1,:))+pi/2]; % atan(X) returns values in the interval [-pi/2, pi/2]
AoA=[pi/2 atan((10-ReflectingObj(1,:))./ReflectingObj(2,:))+pi/2];
AoD_deg=rad2deg(AoD);
AoA_deg=rad2deg(AoA);

Tx_ant_vect=0:1:Tx_ant-1;
Rx_ant_vect=0:1:Rx_ant-1;

H=zeros(Rx_ant,Tx_ant);  % One user channel

alpha=[1 0.5 1];
[~, bestPath]= max(alpha);

for i = 1:nReflections+1
    e_t=ones(nReflections,1);
    e_r=ones(nReflections,1);
    
    e_t=(1/(sqrt(Tx_ant)))*exp(-1i*pi*cos(AoD(i))*Tx_ant_vect.');
    e_r=(1/(sqrt(Rx_ant)))*exp(-1i*pi*cos(AoA(i))*Rx_ant_vect.');
    
    H=H+alpha(i)*e_r*e_t.';
end

NumPayload=500;
SNRdB=35;

% DBS
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

% MRT

bitsIn = randi([0 1],NumPayload,1)';
s = map_QPSK(1,bitsIn) ;
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
Wmrt=H'/norm(H);
x_beam_mrt=Wmrt*s;
y_beam_mrt=H*x_beam_mrt+noise;

r=0;
for angle=0:pi/180:pi
    r=r+1;
    
    steering_vector=exp(-1i*pi*cos(angle)*[1:Tx_ant]);
    ArrayFactor_w(1,r)=abs(steering_vector*Wmrt);
end
figure(3);
plot(ArrayFactor_w);

% figure(2);
% plot(0:1:180,Pwr_beam_good);
% ylabel('Received Power');
% xlabel('Steering angle');
% title("Received Power vs Steering angle");