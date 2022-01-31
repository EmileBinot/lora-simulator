    clear; close all;
for angle=-pi/2:pi/4:pi/2

    Num_users=1;
    TX_ant_w=4;
    TX_ant_h=4;
    RX_ant_w=1;
    RX_ant_h=1;
    Num_paths=3;
    N_ant_TX=TX_ant_h*TX_ant_w;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % INPUT: [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    %    =generate_channels(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths)
    %
    % Num_users : Number of users in the beamforming system
    % TX_ant_w : Number of antennas in the width side of the TX antenna array
    % TX_ant_h : Number of antennas in the height side of the TX antenna array
    % RX_ant_w : Number of antennas in the width side of the RX antenna array
    % RX_ant_h : Number of antennas in the height side of the RX antenna array
    % Num_path = Number of paths followed
    %
    % OUTPUT :
    % 
    % H : Channel matrix
    % alpha : Attenuation matrix for each user (row -> user, column -> paths)
    % AoD_el : Elevation Angle of Departure
    % AoD_az : Azimuth Angle of Departure -> from the BS
    % AoA_el : Elevation Angle of Arrival
    % AoA_ar : Azimuth Angle of Arrival -> on the UE
    % LoS : Index of the LoS traject in the alpha

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    H=zeros(Num_users,RX_ant_w*RX_ant_h,TX_ant_w*TX_ant_h);  % One user channel
    a_TX=zeros(TX_ant_w*TX_ant_h,Num_users); % TX steering vector
    a_TX_los=zeros(TX_ant_w*TX_ant_h,Num_users);
    a_RX_los=zeros(RX_ant_w*RX_ant_h,Num_users);
    a_RX=zeros(RX_ant_w*RX_ant_h,Num_users); % RX steering vector
    ind_TX_w=reshape(repmat([0:1:TX_ant_w-1],TX_ant_h,1),1,TX_ant_w*TX_ant_h);
    ind_TX_h=repmat([0:1:TX_ant_h-1],1,TX_ant_w);
    ind_RX_w=reshape(repmat([0:1:RX_ant_w-1],RX_ant_h,1),1,RX_ant_w*RX_ant_h);
    ind_RX_h=repmat([0:1:RX_ant_h-1],1,RX_ant_w);
    % Constructing the channels
    for u=1:1:Num_users
    %     AoD_el(u,:)=pi*rand(1,Num_paths)-pi/2;
    %     AoD_az(u,:)=2*pi*rand(1,Num_paths);
    %     AoA_el(u,:)=pi*rand(1,Num_paths)-pi/2;
    %     AoA_az(u,:)=2*pi*rand(1,Num_paths);
        AoD_el(u,:)=[angle 0 0];
        AoD_az(u,:)=[angle 0 0];
        AoA_el(u,:)=[angle 0 0];
        AoA_az(u,:)=[angle 0 0];

        %Compute a CN(0,1) law, normalized by the number of paths
        alpha(u,:)=sqrt(1/Num_paths)*sqrt(1/2)*([12 0 0]+1j*[0 0 0]);

        %Find the index of the LOS path
        [~, LoS(u)]= max(alpha(u,:));

        Temp_Channel=zeros(RX_ant_w*RX_ant_h,TX_ant_w*TX_ant_h);
        for l=1:1:Num_paths
            a_TX(:,u)=transpose(sqrt(1/(TX_ant_w*TX_ant_h))*exp(1j*pi*(ind_TX_w*sin(AoD_az(u,l))*sin(AoD_el(u,l))+ind_TX_h*cos(AoD_el(u,l))) ));
            a_RX(:,u)=transpose(sqrt(1/(RX_ant_w*RX_ant_h))*exp(1j*pi*(ind_RX_w*sin(AoA_az(u,l))*sin(AoA_el(u,l))+ind_RX_h*cos(AoA_el(u,l))) ));
            Temp_Channel=Temp_Channel+sqrt((TX_ant_w*TX_ant_h)*(RX_ant_w*RX_ant_h))*alpha(u,l)*a_RX(:,u)*a_TX(:,u)';
        end
        a_TX_los(:,u)= transpose(sqrt(1/(TX_ant_w*TX_ant_h))*exp(1j*pi*(ind_TX_w*sin(AoD_az(u,LoS(u)))*sin(AoD_el(u,LoS(u)))+ind_TX_h*cos(AoD_el(u,LoS(u)))) ));
        a_RX_los(:,u)= transpose(sqrt(1/(RX_ant_w*RX_ant_h))*exp(1j*pi*(ind_RX_w*sin(AoA_az(u,LoS(u)))*sin(AoA_el(u,LoS(u)))+ind_RX_h*cos(AoA_el(u,LoS(u)))) ));

        H(u,:,:)=Temp_Channel;
    end

    % Initialization
    grayCoding=1;
    NumPayload=500;
    SNRdB=35;
    H=squeeze(H).';

    bitsIn = randi([0 1],NumPayload,1)';
    s = map_QPSK(grayCoding,bitsIn) ;
    noise=10^(-SNRdB/20)*(randn(size(s))+1i*randn(size(s)))/sqrt(2);

    % H=ones(1,16);

    % DBS

    steering_vector_h=exp(-1i*pi*sin(angle)*[1:TX_ant_h]);
    steering_vector_w=exp(-1i*pi*sin(angle)*cos(angle)*[1:TX_ant_w]);
    steering_vector=kron(steering_vector_w,steering_vector_h);
    Wdbs=steering_vector'/N_ant_TX; 
    x_beam=Wdbs*s;
    y_beam=H*x_beam+noise;

    % using a_TX_los
    Wdbs_atx=a_TX_los/N_ant_TX; 
    x_beam=Wdbs_atx*s;
    y_beam_los=H*x_beam+noise;

    phi_deg=[-90:.1:90];
    for k=1:length(phi_deg)
        x_test=exp(-1i*pi*sin(phi_deg(k)*pi/180)*[0:N_ant_TX-1].');
        BF_response(k)=abs(Wdbs.'*x_test);
        BF_response_ATX(k)=abs(Wdbs_atx.'*x_test);
    end

    figure;
    plot(phi_deg,20*log10(BF_response));hold on; grid;
    plot(phi_deg,20*log10(BF_response_ATX),'r');
    ylim([-60 12]); xticks(-90:25:90);
    legend('Wdbs','Wdbs atx');
    title(['angle: ' num2str(angle)]);
    % 
    % figure;
    % subplot(2,1,1)
    % plot(real(steering_vector)); hold on;
    % plot(imag(steering_vector));
    % title('steering vector');
    % subplot(2,1,2)
    % plot(real(a_TX_los)); hold on;
    % plot(imag(a_TX_los));
    % title('a TX los');
    % sgtitle(['angle: ' num2str(angle)]) 
end