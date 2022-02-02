clear;
close all;

Tx_ant=4;
Rx_ant=1;
num_path=3;
[H,AoD,AoA,alpha,bestPath] = angular_channel(Tx_ant,Rx_ant,num_path);

NumPayload=500;
SNRdB=35;
bitsIn = randi([0 1],NumPayload,1)';
s = map_QPSK(1,bitsIn) ;
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);

% good DBS precoding, pointing to the best path (LoS)
angle=pi/2;
% steering_vector=exp(-1i*pi*sin(AoD_el(LoS))*[1:TX_ant_h]);
steering_vector=exp(-1i*pi*cos(AoD(bestPath))*[1:Tx_ant]);
Wdbs=steering_vector'/Tx_ant; 
x_beam=Wdbs*s;
y_beam=H*x_beam+noise;

bitsOut = demap_QPSK(1,y_beam);
[~,ratio] = biterr(bitsIn,bitsOut);
disp(ratio);
figure(1);
plot(s,'.');hold on;
plot(y_beam,'.');hold off;

figure(2);
colorVec = [repmat(linspace(1,0.5,10)',1,1) zeros(10,1) zeros(10,1)];
plot(0,0,'ob',10,0,'og',8,-5,'or','MarkerSize',10,'LineWidth',2); hold on;
% y=1:1:10;
x=0:0.01:10;
% Paths=zeros(num_path,length(x));
for i = 1:num_path
    if i == bestPath
        Ls='-';
        plot(x,zeros(length(x)),'Color','black','LineStyle',Ls); hold on;
%         Paths(i,:)=zeros(1,length(x));
    else
        Ls='--';

        x_D(i) = 20*cos(pi/2-AoD(i));
        y_D(i) = 20*sin(pi/2-AoD(i));
        a1=y_D(i)/x_D(i);
        Txpath=a1*x;

        x_A(i) = 20*cos(pi/2-AoA(i));
        y_A(i) = 20*sin(pi/2-AoA(i));
        a2=y_A(i)/x_A(i);
        b=a2*10;
        Refpath=-a2*x+b;

        intersec=b/(a1+a2);

        plot(x(x<intersec),Txpath(x<intersec),'Color','black','LineStyle',Ls); hold on;
        plot(x(x>intersec),Refpath(x>intersec),'Color','black','LineStyle',Ls); hold on;
        
%         Paths(i,1:length(Txpath(x<floor(intersec))))=Txpath(x<floor(intersec));
%         Paths(i,length(Txpath(x<floor(intersec)))+2:end)=Refpath(x>ceil(intersec));
%         Txpath=Refpath;
    end
end
xlim([-1 11]);
ylim([-10 10]);
