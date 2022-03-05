clear; close all; clc;

% Load the data file you want to plot

figure;
load("BerSnrCr1");
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
CRvect=[CR];

load("BerSnrCr4");
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
CRvect=[CRvect CR];

load("BerSnrCr3");
semilogy(snrVect,berEst(:,:,7),'-o'); hold on;
CRvect=[CRvect CR];

grid

xlabel('SNR (dB)')
ylabel('Bit Error Rate')
legendStrings = "CR = " + string(CRvect) ;
legend(legendStrings);