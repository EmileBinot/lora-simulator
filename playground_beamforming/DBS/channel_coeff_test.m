clear;
% correlated Rayleigh MIMO channel coefficient
% Inputs:
% NT : number of transmitters
% NR : number of receivers
% N : length of channel matrix
% Rtx : correlation vector/matrix of Tx
% e.g.) [1 0.5], [1 0.5;0.5 1]
% Rrx : correlation vector/matrix of Rx
% type : correlation type: ’complex’ or ’field’
% Outputs:
% hh : NR x NT x N correlated channel
% uncorrelated Rayleigh fading channel, CN(1,0)

NT=4;
NR=1;
N=4;
Rtx=[1 0.5];
Rrx=[1 0.5];
type='field';
hh=channel_coeff(NT,NR,N,Rtx,Rrx,type);

