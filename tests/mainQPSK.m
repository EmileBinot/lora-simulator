%% Initialization

grayCoding=1;
SNR=10;
transmittedBitsNbr=5000;
bitsIn = randi([0 1],transmittedBitsNbr,1)';

%% Transmission

% QPSK mapping
[txSig] = map_QPSK(grayCoding,bitsIn) ;

% AWGN channel
rxSig = awgn(txSig,SNR,'measured');

% QPSK decoding
[bitsOut] = demap_QPSK(grayCoding,rxSig);

%% Plotting results

figure();
plot(rxSig,'r.'); hold on;
plot(txSig,'b.'); hold off ;

[number,ratio] = biterr(bitsIn,bitsOut);

title(['QPSK , ' num2str(transmittedBitsNbr) ' bits, SNR =' num2str(SNR) ', BER = ' num2str(ratio)])