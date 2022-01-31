function [H,a_TX,a_RX, a_TX_los, a_RX_los, alpha, AoD_el,AoD_az,AoA_el,AoA_az,LoS]...
    =generate_channels_fixedAngles(Num_users,TX_ant_w,TX_ant_h,RX_ant_w,RX_ant_h,Num_paths,angle_el,angle_az)

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
%     angle_el=pi/4;
%     angle_az=0;
    AoD_el(u,:)=[angle_el 0 0]; % attenuations
    AoD_az(u,:)=[angle_az 0 0];
    AoA_el(u,:)=[angle_el 0 0];
    AoA_az(u,:)=[angle_az 0 0];
    
    
    %Compute a CN(0,1) law, normalized by the number of paths
    alpha(u,:)=sqrt(1/Num_paths)*sqrt(1/2)*([1 0.1 0.1]+1j*[1 0.1 0.1]);
    %Find the index of the LOS path
    [~, LoS(u)]= max(alpha(u,:))

    Temp_Channel=zeros(RX_ant_w*RX_ant_h,TX_ant_w*TX_ant_h);
    for k=1:1:Num_paths
        a_TX(:,u)=transpose(sqrt(1/(TX_ant_w*TX_ant_h))*exp(1j*pi*(ind_TX_w*sin(AoD_az(u,k))*sin(AoD_el(u,k))+ind_TX_h*cos(AoD_el(u,k))) ));
        a_RX(:,u)=transpose(sqrt(1/(RX_ant_w*RX_ant_h))*exp(1j*pi*(ind_RX_w*sin(AoA_az(u,k))*sin(AoA_el(u,k))+ind_RX_h*cos(AoA_el(u,k))) ));
        Temp_Channel=Temp_Channel+sqrt((TX_ant_w*TX_ant_h)*(RX_ant_w*RX_ant_h))*alpha(u,k)*a_RX(:,u)*a_TX(:,u)';
    end
    a_TX_los(:,u)= transpose(sqrt(1/(TX_ant_w*TX_ant_h))*exp(1j*pi*(ind_TX_w*sin(AoD_az(u,LoS(u)))*sin(AoD_el(u,LoS(u)))+ind_TX_h*cos(AoD_el(u,LoS(u)))) ));
    a_RX_los(:,u)= transpose(sqrt(1/(RX_ant_w*RX_ant_h))*exp(1j*pi*(ind_RX_w*sin(AoA_az(u,LoS(u)))*sin(AoA_el(u,LoS(u)))+ind_RX_h*cos(AoA_el(u,LoS(u)))) ));

    H(u,:,:)=Temp_Channel;
end

end