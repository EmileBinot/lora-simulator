clear;
clc;
% CR=4;
% SF=7;
% 
% data = 'H';
% 
% %% Message to binary vector
% 
% binary = reshape(dec2bin(data, 8).'-'0',1,[]);
% hamming_in = reshape(binary,4,[]);
% 
% i=0;
% while mod(8*length(hamming_in),7)
%     padding=[0 0;0 0;0 0;0 0];
%     hamming_in=[hamming_in padding];
% end
% 
% 
% %% Hamming
% for i = 1: (length(hamming_in))
%     hamming_out(:,i) = LoRa_Encode_Hamming(hamming_in(:,i)',CR);
% end
% 
% hamming_out = hamming_out(:); % shaping
% 
% %% Whitening
% 
% whitening_out = LoRa_Whitening(hamming_out');
% 
% %% Interleaving
% 
% % shaping
% cell=ones(1,(size(whitening_out,2)/8)/SF).*SF;
% interleaver_in = reshape(whitening_out,CR+4,[])';
% interleaver_in = mat2cell(interleaver_in,cell,[8]);%too specific, TO BE FIXED (ADDING PADDING AT THE BEGINNING)
% interleaver_out=[];
% 
% for i = 1 :length(interleaver_in)
%     interleaver_out=[interleaver_out;LoRa_Interleaving(interleaver_in{i})];
% end
% 
% %% Bits to symbols
% M  = 2^SF;
% 
% symbols = LoRa_Bits_To_Symbols(interleaver_out,SF);
% 
% %% Modulation
% 
% B=125e3;
% n=4;%header length+2
% 
% preamble_up_mod = LoRa_Modulation(B,7,zeros(n+2),1);
% preamble_down_mod = LoRa_Modulation(B,7,ones(4),-1);
% payload_mod = LoRa_Modulation(B,7,symbols,1);
% 
% %signalIQ= [ preamble_up_mod ; preamble_down_mod(1:floor((length(preamble_down_mod)/4)*2.25)) ; payload_mod];
% signalIQ= [ preamble_up_mod ; preamble_down_mod(1:floor((length(preamble_down_mod)))) ; payload_mod];
% 
% Fs = B;     % Sampling frequency
% Ts = 1/Fs;  % Sampling period
% ts = (0:Ts:(length(signalIQ)*Ts)-Ts)';
% 
% %  figure(1)
% %  plot(ts,real(signalIQ),ts,imag(signalIQ));
% 
% figure;
% spectrogram(signalIQ,20,15,128,B,'yaxis');    % no idea how it's working
% 
% %% De-Modulation
% 
% Demod_chirp = LoRa_Modulation(B,7,zeros(27),-1);
% 
% save('./LoRa-chain-simulation/signals_mod.mat')

load('./LoRa-chain-simulation/signals_mod.mat');

signal_demod=signalIQ.*Demod_chirp(1:length(signalIQ),:);

unchirped_signal_fft_full = fft(signal_demod);

f = (0:length(unchirped_signal_fft_full)-1)*Fs/length(unchirped_signal_fft_full);

div = floor(length(signalIQ)/128);

% figure;
% subplot(2,1,1);
% spectrogram(signal_demod,20,15,128,B);
% subplot(2,1,2); 
% plot(f,abs(unchirped_signal_fft_full));
% figure;

u = symunit;
symbols_demod=[];

for i = 1:div-1
    signal_demod_fft_part = fft(signal_demod(i*128:i*128+128,:));
    f = (0:length(signal_demod_fft_part)-1)*Fs/length(signal_demod_fft_part);
    [~,idx]=max(signal_demod_fft_part);
    symbols_demod(i)=round(f(idx)*128/125e3,0);
    
%     %plots
%     subplot(2,1,1);
%     plot(f,abs(signal_demod_fft_part ));
%     subplot(2,1,2); 
%     spectrogram(signal_demod(i*128:i*128+128,:),20,15,128,B);
%     title([num2str(round(f(idx)/1e3,1)),' kHz / symbol : ', num2str(round(f(idx)*128/125e3,0))])
%     pause(0.1)
end

symbols_demod=symbols_demod(:,10:end)';



