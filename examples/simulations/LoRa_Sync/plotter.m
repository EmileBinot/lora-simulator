clear; close all; clc;

% Load the data file you want to plot
load("loraSync_data");

figure;
% snrVect=-35:5:5;
% SFVect=(7:12);

% Plot every SF 
semilogy(snrVect,error(:,:,7),'-o'); hold on;
semilogy(snrVect,error(:,:,8),'-o'); hold on;
semilogy(snrVect,error(:,:,9),'-o'); hold on;
% plot(snrVect,error(:,:,10),'-o'); hold on;
% plot(snrVect,error(:,:,11),'-o'); hold on;
% plot(snrVect,error(:,:,12),'-o'); hold on;
set(findall(gca, 'Type', 'Line'),'LineWidth',1,'MarkerSize',5);
xlim([-30 -10]);
% ylim([10^(-5) 1]);
grid

xlabel('SNR (dB)')
ylabel("Erreur absolue moyenne (échantillons)")
legendStrings = "SF = " + string(SFVect) ;
legend(legendStrings);