clear; close all; clc;

% Load the data file you want to plot
load("BerSnrCr1");
figure;

% Plot every SF 
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
CRvect=[CR];

load("BerSnrCr4");
% Plot every SF 
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
CRvect=[CRvect CR];
% set(findall(gca, 'Type', 'Line'),'LineWidth',1,'MarkerSize',5);
% xlim([-30 -5]);
% ylim([10^(-5) 1]);
grid

xlabel('SNR (dB)')
ylabel('Bit Error Rate')
legendStrings = "CR = " + string(CRvect) ;
legend(legendStrings);