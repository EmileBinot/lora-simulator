clear;clc;close all;
load('1511_simul_data');

snrVect=(-35:3);
SFVect=(7:12);

prod=0;
for kSF = SFVect
    prod = prod + 1;
    plot = semilogy(snrVect,berEst(:,:,kSF),'o-','LineWidth', 1.5);
    plot(1).SeriesIndex = prod;
    plot(1).ColorMode = 'auto';
    hold on
end
ylim([10^(-6) 10^0]);
xlim([-35 -5]);
legendStrings = "SF = " + string(SFVect) ;
legend(legendStrings);
title("BER Curves from LoRa simulation , AWGN channel (CR = 4, no CRC, no Gray coding)");

xlabel('SNR (dB)')
ylabel('BER')
grid
hold on

%% ADDING calculated BER curves

% prod=0;
% for kSF = SFVect
%     disp([kSF]);
%     prod = prod + 1;
%     Pb =0.5*qfunc(1.28*sqrt(db2mag(snrVect)/kSF*2^kSF)-1.28*sqrt(kSF)+0.4);% (24)
%     plot = semilogy(snrVect,Pb,'.-.','LineWidth', 1);
%     plot(1).SeriesIndex = prod;
%     plot(1).ColorMode = 'auto';
%     hold on
% end
% 
% ylim([10^(-6) 10^0]);
% xlim([-35 -5]);
% legendStrings = "SF = " + string(SFVect) ;
% legend(legendStrings);
% title("BER Curves from LoRa simulation , AWGN channel (CR = 4, no CRC, no Gray coding)");
% 
% 
% xlabel('SNR (dB)')
% ylabel('BER')
% hold off;