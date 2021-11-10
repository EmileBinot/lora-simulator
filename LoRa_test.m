CR=4;     % Coding rate : {1,4}
SF=7;     % Coding rate  : {7,12}
B=125e3;  % Bandwidth : [125 kHz,250 kHz,500 kHz]
Pr_len=4; % Preamble length
k=SF;

EbNoVec = (0:10)';      % Eb/No values (dB)
numSymPerFrame = 100;   % Number of QAM symbols per frame
M=2^SF;
berEst = zeros(size(EbNoVec));

for n = 1:length(EbNoVec)
    tic
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    disp([snrdB]);
    pause(0.5);
    while numErrs < 200 && numBits < 1e7
        % Generate binary data and convert to symbols
        binary_data = randi([0 1],numSymPerFrame,CR+4);
        %dataSym = bi2de(dataIn);
        
        % QAM modulate using 'Gray' symbol mapping
        %txSig = qammod(dataSym,M);
        [txSig,dataIn]=LoRa_Emitter(CR,SF,B,Pr_len,binary_data); 
        
        % Pass through AWGN channel
        rxSig = awgn(txSig,snrdB,'measured');
        
        % Demodulate the noisy signal
        [dataOut]=LoRa_Receiver(CR,SF,B,Pr_len,rxSig);
        % Convert received symbols to bits
        %dataOut = de2bi(rxSym,k);
        
        % Calculate the number of bit errors
        nErrors = biterr(dataIn,dataOut);
        
        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + numSymPerFrame*k;
        
    end
    toc
    % Estimate the BER
    berEst(n) = numErrs/numBits;
end
save('resultsBER')

berTheory = berawgn(EbNoVec,'fsk',32,'noncoherent');

semilogy(EbNoVec,berEst,'*')
hold on
semilogy(EbNoVec,berTheory)
grid
legend('Estimated BER','Theoretical BER')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')