%Power Array factor is calculated and plotted
%Code can be extended for larger arrays
clc
clear



TX_ant_w=16;             % Number of antennas in width
TX_ant_h=16;             % Number of antennas in height
N_ant_TX=TX_ant_w*TX_ant_h;

angle_az_deg = 90;     % Azimuth angle to point (theta)
angle_el_deg = 90;     % Elevation angle to point (phi)

% Calculating steering vectors (see Antoine Roze's thesis)
steering_vector_h=exp(-1i*pi*sin(angle_el_deg*pi/180)*[1:TX_ant_h]);
steering_vector_w=exp(-1i*pi*sin(angle_az_deg*pi/180)*cos(angle_el_deg*pi/180)*[1:TX_ant_w]);

steering_matrix=kron(steering_vector_w,steering_vector_h.');
%constants
c=3e8;
f=1.8e9;
lambda=c/f;
dx=lambda/2; %distance between elements (X)
dy=lambda/2;%distance between elements (Y)
AB=[1 1 1 1;
    1 1 1 1;
    1 1 1 1;
    1 1 1 1]; % Array amplitudes
AB_phase=[0 0 0 0;
          0 0 0 0;
          0 0 0 0;
          0 0 0 0]*pi/180; %Array phases
AB_coe=AB.*(cos(AB_phase)+j*sin(AB_phase));
AB_coe=steering_matrix;
total_power= ( sum(sum(AB.^2)) ); 
%AF calculation
theta0=[-pi/2:pi/50:pi/2];
phi0=[-pi/2:pi/50:pi/2];
[phi,theta]=meshgrid(phi0,theta0);
sinU=sin(theta).*cos(phi);
sinV=sin(theta).*sin(phi);
AF_Field=0;
for n=1:4
    for m=1:4
        AF_Field = AB_coe(n,m)*exp(j*2*pi*(n-1)/lambda*dx*(sinU)).*exp(j*2*pi*(m-1)/lambda*dy*(sinV)) + AF_Field; 
    end
end
AF_power=AF_Field.^2;
AF_power_normalized=AF_power/total_power;
%Plotting
%mesh(phi0*180/pi,theta0*180/pi,20*log10(abs(AF)))
axis([0 360 0 180 -10 6])
imagesc(phi0*180/pi,theta0*180/pi,(abs(AF_power_normalized))), colorbar
xlabel('\phi')
ylabel('\theta')
shading interp