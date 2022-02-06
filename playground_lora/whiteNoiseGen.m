clear;
clc;
close all;

s=[1 1 1 1 1 1 1 1 1];
t=[9 5];
[whiteNoise,c] =LFSRv2(s,t);

save("noise","whiteNoise");