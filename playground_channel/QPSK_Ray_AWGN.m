clc;
clear all;
tic;
% Calculate BER in AWGN and Rayleigh flat-fading channel
% Finish: 2017.07.06
% Last test: 2017.07.06
% Spend time: 180 second

Ls=2048; % number of transmitted bits
SNR_dB_start=0; % SNR range
SNR_dB_end=20; % SNR range
count_m=6000; % number of Monte Carlo method is performed
path=3; % number of path
P=[0.9 0.09 0.009].'; % power of every path
N_situation=2; % number of channel type, 1:AWGN, 2:Rayleigh flat-fading

%% simulation start
for situation=1:N_situation
for SNR_dB=SNR_dB_start:SNR_dB_end
    index=1; % index of BER
    for m_cont=1:count_m % index of Monte Carlo method
        
        symbol_r=2*(rand([Ls,1])>0.5)-1;
        symbol_i=2*(rand([Ls,1])>0.5)-1;
        QPSK_sym=symbol_r+1i*symbol_i; % generate QPSK symbols
        
        Es=1; % power of every transmitted symbol
        N0=Es/10^(SNR_dB/10); % give SNR_dB and calculate noise power spectral density
        
        if situation==1
            %% AWGN channel
            noise=sqrt(N0/2)*(randn(Ls,1)+1i*randn(Ls,1)); % noise
            received=QPSK_sym+noise; % received signal
            
            equalized_t=received;
            
        else
            %% Rayleigh flat-fading channel
            h=sqrt(P/2).*( randn(path,1)+1i*randn(path,1) ); 
            % a sampled version of the impulse response function generated as Rayleigh fading process
            faded=conv(h,QPSK_sym); % QPSK signal pass through a Rayleigh slat-fading channel
            noise=sqrt(N0/2)*(randn(length(faded),1)+1i*randn(length(faded),1)); % noise
        
            received=faded+noise; % received signal
            received=received(1:Ls); % remove last Ls:end bits
            equalized_f=fft(received)./fft(h,Ls); % Use ZF equalizer to compensate channel effect in fre-domain
            equalized_t=ifft(equalized_f); % transform signal back from fre-domain to time-domain
        end
        %% calculate BER
        detect_r=sign(real(equalized_t)); % detect received bit in real    
        detect_i=sign(imag(equalized_t)); % detect received bit in complex
        ber_r=sum(symbol_r~=detect_r)/Ls; % calculate BER
        ber_i=sum(symbol_i~=detect_i)/Ls;
        ber(index)=(ber_r +ber_i)/2; % overall BER in ones Monte Carlo method
        
        index=index+1; % record overall BER in every Monte Carlo method
    end
    bersum(SNR_dB+1)=0;
    for i=1:count_m
        bersum(SNR_dB+1)=bersum(SNR_dB+1)+ber(i); % sum overall BER of every Monte Carlo method in one SNR_dB
    end
    finalber(situation,SNR_dB+1)=0;
    finalber(situation,SNR_dB+1)=bersum(SNR_dB+1)/count_m; % calculate fianl BER in every SNR_dB
end
end
%% plot result
figure(1)
SNR=SNR_dB_start:1:SNR_dB_end;
semilogy(SNR,finalber(1,:),'r-o','MarkerSize',5,'MarkerFaceColor','r','LineWidth',2)
hold on;
semilogy(SNR,finalber(2,:),'b-o','MarkerSize',5,'MarkerFaceColor','b','LineWidth',2)
grid on;
legend('through AWGN channel',['through ' num2str(path) '-path Rayleigh flat-fading channel'])
xlabel('SNR(dB)')
ylabel('BER')
title('QPSK signal pass through different channels')
        
toc