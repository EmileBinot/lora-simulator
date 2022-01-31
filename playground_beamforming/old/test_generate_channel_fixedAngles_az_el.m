clear; close all;
Num_users=1;
TX_ant_w=4;
TX_ant_h=4;
RX_ant_w=1;
RX_ant_h=1;
Num_paths=3;
N_ant_TX=TX_ant_h*TX_ant_w;

% ANGLES
angle_el=pi/2;
angle_az=pi/4;

[H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels_fixedAngles(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths,angle_el,angle_az);

% Tx
NumPayload=50;
SNRdB=35;

s=1/sqrt(2)*randsrc(1,NumPayload,[1+1i 1-1i -1+1i -1-1i]);
noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);
n=ones(N_ant_TX,1)*s/N_ant_TX;
H=squeeze(H).';


row=0;
col=0;
beam=zeros();
step=pi/100;
for phi = -pi/2:step:pi/2-step % elevation
    row=row+1;
    col=0;
    for theta = 0:step:pi-step % azimuth
        col=col+1;
        % Tx DBS precoding
        steering_vector_h=exp(-1i*pi*sin(phi)*[1:TX_ant_h]);
        steering_vector_w=exp(-1i*pi*sin(theta)*cos(phi)*[1:TX_ant_w]);
        steering_vector=kron(steering_vector_w,steering_vector_h);
        Wdbs=1/(sqrt(N_ant_TX))*steering_vector'; 
        x_beam=Wdbs*s;

        % Rx
        y_beam=H*x_beam+noise; 
        Pwr(row,col)=(norm(y_beam)^2)/NumPayload; % measurate received pwr
    end
end
% [~,idx]=max(Pwr);
% steering_vector_h_max=exp(1i*pi*sin(pi/128*idx(:,12))*[1:TX_ant_h]);
% steering_vector_w_max=exp(1i*pi*sin(pi/128*idx(:,12))*cos(pi/128*idx(:,12))*[1:TX_ant_w]);
% steering_vector_max=kron(steering_vector_w_max,steering_vector_h_max);
% beam=fft(steering_vector_max,[],2);
% beam=reshape(beam,[4,4]);
% surf(real(beam));

figure;
x=0:step:pi-step;
y=0:step:pi-step;
y=fliplr(y);
imagesc(x,y,Pwr);
set(gca, 'YDir','reverse')
xlabel('azimuth');
ylabel('elevation');
colorbar;
% for k=1:length(prod)
%     x_test_w=exp(-1i*pi*sin(prod(k))*[0:TX_ant_w-1].');
%     steering_vector_h=exp(-1i*pi*sin(angle)*cos(angle)*[1:TX_ant_w]);
%     resp_w(:,k)=abs(steering_vector_h*x_test_w);
% end
% plot(prod,resp_h);