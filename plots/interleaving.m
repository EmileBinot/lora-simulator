clear;clc;close all;
SF=7;
CR=2;
N=SF-1;
M=CR+4;
% Creating a NxM matrix (CR+4 x SF matrix)
matrix=[reshape(repmat(0:N,1,M),[],M)];
out=LoRa_Interleaving(matrix,CR,SF);

figure;
s=imagesc(matrix);colormap(jet(SF))
%s.LineWidth = 2;
axis off

figure;
s=imagesc(out);colormap(jet(SF))
%s.LineWidth = 2;
axis off

