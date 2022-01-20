clear;
close all;
clc;

load("everySF_data_copy");
figure;
snrVect=-35:0.5:5;
SFVect=(7:12);
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
semilogy(snrVect,berEst(:,:,8),'-o'); hold on;
semilogy(snrVect,berEst(:,:,9),'-o'); hold on;
semilogy(snrVect,berEst(:,:,10),'-o'); hold on;
semilogy(snrVect,berEst(:,:,11),'-o'); hold on;
semilogy(snrVect,berEst(:,:,12),'-o');hold on;
set(findall(gca, 'Type', 'Line'),'LineWidth',1,'MarkerSize',5);
xlim([-30 -5]);
ylim([10^(-5) 1]);
%hold on
%semilogy(EbNoVec,berTheory)
grid
%legend('Estimated BER','Theoretical BER')
xlabel('SNR (dB)')
ylabel('Bit Error Rate')
title('')