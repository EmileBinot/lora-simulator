M = 64;                 % Modulation order
k = log2(M);            % Bits per symbol
EbNoVec = (5:15)';      % Eb/No values (dB)
numSymPerFrame = 100;   % Number of QAM symbols per frame

berEst = zeros(size(EbNoVec));

for n = 1:length(EbNoVec)
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 200 && numBits < 1e7
        % Generate binary data and convert to symbols
        binary_data = randi([0 1],numSymPerFrame,k);
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
    
    % Estimate the BER
    berEst(n) = numErrs/numBits;
end

berTheory = berawgn(EbNoVec,'qam',M);

semilogy(EbNoVec,berEst,'*')
hold on
semilogy(EbNoVec,berTheory)
grid
legend('Estimated BER','Theoretical BER')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')