clear;clc;close all;
SF=8;
CR=4;
N=SF-1;
M=CR+4;
% Creating a NxM matrix (CR+4 x SF matrix)
matrix=[reshape(repmat(0:N,1,M),[],M)];
out=LoRa_Interleaving(matrix,CR,SF);

out_str = "d" + compose('%g',out) ;

% label=["d0" "d1" "d2" "d3" "d4" "d5" "d6"];
% clabels=repelem(label,M ,1);
% % clabel = arrayfun(@(x){sprintf('%0.2f',x)}, c_small);
% % 
% % clf
% clf
% hMap = heatmap(out);
% hMap.CellLabelVisible = 'off';
% set(gcf,'Position',[100 100 400 350])

figure;
hmh=heatmap(matrix);
figure;
hmh=heatmap(out);

% figure;
% s=imagesc(matrix);colormap(winter(SF))
% s.LineWidth = 2;
% axis off
% 
% figure;
% s=imagesc(out);colormap(winter(SF))
% s.LineWidth = 2;
% axis off

