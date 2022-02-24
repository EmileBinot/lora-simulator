clear; close all; clc;

% Load the data file you want to plot
load("everySF_try1");

figure;
snrVect=-35:0.5:5;
SFVect=(7:12).';
B=125e3;
EbNoVect = snrVect-10*log10(B./2.^SFVect)-10*log10(SFVect)+10*log10(B);
% Plot every SF 
semilogy(EbNoVect(1,:),berEst(:,:,7),'-'); hold on;
semilogy(EbNoVect(2,:),berEst(:,:,8),'-'); hold on;
semilogy(EbNoVect(3,:),berEst(:,:,9),'-'); hold on;
semilogy(EbNoVect(4,:),berEst(:,:,10),'-'); hold on;
semilogy(EbNoVect(5,:),berEst(:,:,11),'-'); hold on;
semilogy(EbNoVect(6,:),berEst(:,:,12),'-');hold on;


set(findall(gca, 'Type', 'Line'),'LineWidth',1,'MarkerSize',5);
xlim([-10 10]);
ylim([10^(-4) 1]);
grid

xlabel('Eb/N0 (dB)')
ylabel('Bit Error Rate')
legendStrings = "SF = " + string(SFVect) ;
legend(legendStrings);