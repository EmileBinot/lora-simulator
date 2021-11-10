% LoRa_Receiver.m : 
% Input = Demodulation parameters (B,SF,CR), Binary vector to transmit
% Output = Demodulated data
clear;
clc;

%% Constants Definitions

load('LoRa_Emmiter_transmitted');
Fs=B;

%% Demodulating

demod_chirp = LoRa_Modulation(B,SF,zeros(length(signalIQ)/128),-1); % Creating the demodulation chirp

signal_demod=signalIQ.*demod_chirp(1:length(signalIQ),:);

unchirped_signal_fft_full = fft(signal_demod);

f = (0:length(unchirped_signal_fft_full)-1)*Fs/length(unchirped_signal_fft_full);

div = floor(length(signalIQ)/128);

% figure;
% subplot(2,1,1);
% spectrogram(signal_demod,20,15,128,B);
% subplot(2,1,2); 
% plot(f,abs(unchirped_signal_fft_full));
% figure;
for i = 1:div-1
    signal_demod_fft_part = fft(signal_demod(i*128:i*128+128,:));
    [~,idx]=max(signal_demod_fft_part);
    f = (0:length(signal_demod_fft_part)-1)*Fs/length(signal_demod_fft_part);
    symbols_demod(i)=round(f(idx)*128/125e3,0);
    %plots
%     subplot(2,1,1);
%     plot(f,abs(signal_demod_fft_part ));
%     subplot(2,1,2); 
%     spectrogram(signal_demod(i*128:i*128+128,:),20,15,128,B);
%     title([num2str(round(f(idx)/1e3,1)),' kHz / symbol : ', num2str(round(f(idx)*128/125e3,0))])
%     pause(0.1)
end

save('temp');
clear;
load('temp');

symbols_demod(:,10:end);

symbols_bits=LoRa_Symbols_To_Bits(symbols_demod(:,10:end),SF)';

%% Deinterleaving 

cell2=ones(1,size(symbols_bits,2)/(CR+4)).*(CR+4); % Preparing [SF SF .. SF] vector for mat2cell()
deinterleaver_in = mat2cell(symbols_bits,SF,cell2); % [CR+4,SF*x] divided x times to [CR+4,SF] blocks

% Processing every block one by one
deinterleaver_out=[];
for i = 1 :length(deinterleaver_in)
   deinterleaver_out=[deinterleaver_out; LoRa_Deinterleaving(deinterleaver_in{i}',CR,SF)];
end

deinterleaver_out_vect = reshape(deinterleaver_out',1,[]); % [SF*x,CR+4] matrix to [1,(CR+4)*SF*x] vector

%% De-whitening

dewhitening_out = LoRa_Whitening(deinterleaver_out_vect)';

%% Hamming Decoding

hamming_decode_in = reshape(dewhitening_out,CR+4,[]);

for i = 1: length(hamming_decode_in)
    hamming_decode_out(:,i) = LoRa_Decode_Hamming(hamming_decode_in(:,i)',CR);
end

%% Formatting to get received message

received_data_binary = reshape(hamming_decode_out,8,[]);

for i = 1: (size(received_data_binary,2))
    received_data_vector(:,i) = char(bin2dec(num2str(received_data_binary(:,i)')));
end

received_data_vector = hamming_decode_out(:);

%disp(["data transmitted == data received:   " + isequal(transmitted_data_vector,received_data_vector)]);

%disp(["received : " + received_data_vector])
