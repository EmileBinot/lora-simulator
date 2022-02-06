clear;clc;close all;


snrVect=(-35:5);
SFVect=(7:12);
CRVect=(1:4);
SF=12;
prod=0;

% Updates existing plots in R2019b or later
figure;
for kSF = SFVect
    load('resultsBER_CR1');
    semilogy(snrVect,berEst(:,:,kSF),'o-','LineWidth', 1,'Color',[0 0.4470 0.7410]);
    hold on;
    load('resultsBER_CR2');
    semilogy(snrVect,berEst(:,:,kSF),'o-','LineWidth', 1,'Color',[0.8500 0.3250 0.0980]);
    hold on;
    load('resultsBER_CR3')
    semilogy(snrVect,berEst(:,:,kSF),'o-','LineWidth', 1,'Color',[0.9290 0.6940 0.1250]);
    hold on;
    load('resultsBER_CR4');
    semilogy(snrVect,berEst(:,:,kSF),'o-','LineWidth', 1,'Color',[0.4940 0.1840 0.5560]);
    hold on
end
%ht = text(-30, 10^(-2), {'{\color{red} o } Red', '{\color{blue} o } Blue', '{\color{black} o } Black'}, 'EdgeColor', 'k');


ylim([10^(-7) 10^0]);
xlim([-35 -5]);
legendStrings = "CR = " + string(CRVect) ;
legend(legendStrings);
title("BER Curves from LoRa simulation, SF 12 to 7, every CR, AWGN channel (no CRC, no Gray coding)");

xlabel('SNR (dB)')
ylabel('BER')
grid
hold off
