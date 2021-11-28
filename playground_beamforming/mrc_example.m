% Maximal Ratio Combining Example
% luminouslogic.com

% Goal: prove that by weighting multiple copies of a signal by each's SNR, the result is 
% a single signal whose SNR is the SUM of the individual copies
% Initialize workspace
clear all;
close all;
% Simulation parameters
snr_db_copies = [20 15 12];  % The SNR in dB of each of the copies
num_iter      = 10000;            % # of combines to perform
% Create BPSK signals
tx_symbols = round(rand(num_iter,1))*2 - 1;
% Define how much to scale the mu=0 s=1 noise to get desired SNRs
% Now, I know that SNR_dB = 10*log10( signal_var / noise_var)
% And by experimentation, I see that if noise created by randn is scaled by K, 
% the resulting variance of that noise is K^2.  So,
% SNR_dB = 10*log10( signal_var / K^2)
% SNR_dB / 10 = log10( signal_var / K^2)
% 10^(SNR_dB / 10) = signal_var / K^2
% 10^(-SNR_dB/10) = K^2 / signal_var
% K^2 = signal_var * 10^(-SNR_dB/10)
% so use K = sqrt(signal_var * 10^(-SNR_dB/10)) to scale noise for desired SNR
% Create channel noise
K     = sqrt( var(tx_symbols) * 10.^(-snr_db_copies/10));
noise = randn(num_iter, length(K)) .* K(ones(1, num_iter),:);
% Create received copies of noisy signals
rx_symbols = tx_symbols(:,ones(1,length(snr_db_copies))) + noise;
% Estimate SNR on each channel to verify coded up correctly
S = var(tx_symbols);
for i=1:length(snr_db_copies)
	N = var(rx_symbols(:,i) - tx_symbols);
	fprintf(1,'SNR on channel %d is supposed to be %2.0f dB.  Actually is %2.2f dB\n',i,snr_db_copies(i),10*log10(S/N))
end
% Create Maximal Ratio Combining (MRC) weights
mrc_weights    = 10.^(snr_db_copies/10); % Weight by SNR (but not in dB!)
% Perform MRC
mrc_rx_symbols = rx_symbols * mrc_weights.' / sum(mrc_weights); 
% Did it work?  Well, isn't that something!
N = var(mrc_rx_symbols - tx_symbols);
fprintf(1,'SNR after MRC    is supposed to be %2.1f dB.  Actually is %2.2f dB\n',10*log10(sum(mrc_weights)), 10*log10(S/N))