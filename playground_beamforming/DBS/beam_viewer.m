clear;
% close all;

TX_ant_w=4;             % Number of antennas in width
TX_ant_h=4;             % Number of antennas in height
N_ant_TX=TX_ant_w*TX_ant_h;

angle_az_deg = 0;     % Azimuth angle to point (theta)
angle_el_deg = 0;     % Elevation angle to point (phi)

% Calculating steering vectors (see Antoine Roze's thesis)
steering_vector_h=exp(-1i*pi*sin(angle_el_deg*pi/180)*[1:TX_ant_h]);
steering_vector_w=exp(-1i*pi*sin(angle_az_deg*pi/180)*cos(angle_el_deg*pi/180)*[1:TX_ant_w]);

% get radiation value from -pi/2 to pi/2 in azimuth and elevation
angle_deg=[-90:1:90]; 
for k=1:length(angle_deg)
    x_test_h=exp(1i*pi*sin(angle_deg(k)*pi/180)*[0:TX_ant_h-1].');
    ArrayFactor_h(1,k)=abs(steering_vector_h*x_test_h);
    x_test_w=exp(1i*pi*sin(angle_deg(k)*pi/180)*[0:TX_ant_w-1].');
    ArrayFactor_w(1,k)=abs(steering_vector_w*x_test_w);
end

% Calculate result array factor
ArrayFactor=kron(ArrayFactor_w,ArrayFactor_h.');

% s=mesh(phi_deg,phi_deg,BF);                   % 3D
% s.FaceColor = 'flat';
% OR
s=imagesc(angle_deg,angle_deg,ArrayFactor);     % 2D heatmap
% set ( gca, 'ydir', 'reverse' )
xlim([-90 90]); xlabel('azimuth (largeur)');
ylim([-90 90]); ylabel('elevation (hauteur)');
title(['Radiation pattern , azimuth: ' num2str(angle_az_deg) '° / elevation: ' num2str(angle_el_deg) '°']);