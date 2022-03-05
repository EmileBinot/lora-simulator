clear; close all; clc;

% Load the data file you want to plot
load("loraSync_data");

% figure;
% % snrVect=-35:5:5;
% % SFVect=(7:12);
% 
% % Plot every SF 
% plot(snrVect,error(:,:,7),'-o'); hold on;
% plot(snrVect,error(:,:,8),'-o'); hold on;
% plot(snrVect,error(:,:,9),'-o'); hold on;
% % plot(snrVect,error(:,:,10),'-o'); hold on;
% % plot(snrVect,error(:,:,11),'-o'); hold on;
% % plot(snrVect,error(:,:,12),'-o'); hold on;
% set(findall(gca, 'Type', 'Line'),'LineWidth',1,'MarkerSize',5);
% xlim([-30 -10]);
% % ylim([10^(-5) 1]);
% grid
% 
% xlabel('SNR (dB)')
% ylabel("Erreur absolue moyenne (échantillons)")
% legendStrings = "SF = " + string(SFVect) ;
% legend(legendStrings);

figure;
nrSamples = 3;
cMap = lines(nrSamples);
% https://fr.mathworks.com/matlabcentral/fileexchange/29534-stdshade
for x = 1 : nrSamples
    aline(x) = stdshade(err(:,:,SFVect(x)),0.1,cMap(x,:),snrVect,1);
    hold on;
end
axis square 
xlabel('SNR (dB)')
ylabel("Erreur absolue moyenne (en échantillons)")
legendStrings = "SF = " + string(SFVect) ;
legend(aline,legendStrings); axis square 
