clear;
clc;
CR=3;
SF=7;
B=150e3;
disp([]);
disp(["CR = " + CR + " / SF = " + SF]);
load("symbols","modSymbK","demodChirp");
data = 'hello world';

%% Message to binary vector

binary = reshape(dec2bin(data, 8).'-'0',1,[]); % String to binary vector
hamming_in = reshape(binary,4,[]); % Groups of 4 data bits 

% Adding padding to respect block sizes for interleaver
while mod(length(hamming_in),SF)
    hamming_in=[hamming_in [0;0;0;0]];
end 

transmitted_data_vector = hamming_in(:); % for later

%% Hamming encoding

% Processing every groups of 4 bits one by one
for i = 1: (length(hamming_in))
    hamming_out(:,i) = LoRa_Encode_Hamming(hamming_in(:,i)',CR);
end

hamming_out = hamming_out(:); % [CR+4,SF*x] matrix to [(CR+4)*SF*x,1] vector

%% Whitening

whitened_out = LoRa_Whitening(hamming_out');

%% Interleaving

whitened_out_block = reshape(whitened_out,CR+4,[])'; % vector to SF*x_blocks,CR+4 matrix

cell=ones(1,size(whitened_out_block,1)/SF).*SF; % Preparing [SF SF .. SF] vector for mat2cell()
interleaver_in = mat2cell(whitened_out_block,cell,CR+4); % [SF*x_blocks,CR+4] divided x times to [SF,CR+4] blocks

% Processing every block one by one
interleaver_out=[]; % Preallocation
for i = 1 :length(interleaver_in)
   interleaver_out=[interleaver_out ; LoRa_Interleaving(interleaver_in{i},CR,SF)];
end

%% Bits to symbols
symbols = LoRa_Bits_To_Symbols(interleaver_out);

%% Modulation
txSig = LoRa_Modulation_fast(SF,symbols,1,modSymbK,demodChirp);

rxSig=txSig;

%% Demodulation

chirp = LoRa_Modulation_fast(SF,zeros(1,length(rxSig)/2^SF),-1,modSymbK,demodChirp);
demodSig = rxSig.*chirp;
fftdemodSig = fft(demodSig);

Fs=B;
f = (0:length(fftdemodSig)-1)*Fs/length(fftdemodSig);
symbols_demod=[];

for i = 1:2^SF:length(rxSig)
    fftdemodSig = fft(demodSig(i:i+2^SF-1,:));
    [~,idx]=max(fftdemodSig);
    f = (0:length(fftdemodSig)-1)*Fs/length(fftdemodSig);
    symbols_demod(end+1)=round(f(idx)*(2^SF)/125e3,0);
end

symbols_bits=LoRa_Symbols_To_Bits(symbols',SF);
%% Deinterleaving 

cell2=ones(1,size(symbols_bits,1)/(CR+4)).*(CR+4); % Preparing [SF SF .. SF] vector for mat2cell()
deinterleaver_in = mat2cell(symbols_bits,cell2,SF); % [CR+4,SF*x] divided x times to [CR+4,SF] blocks

% Processing every block one by one
deinterleaver_out=zeros(size(whitened_out_block,1),CR+4); % Preallocation
for i = 1 :length(deinterleaver_in)
   deinterleaver_out(SF*(i-1)+1:i*SF,:)=LoRa_Deinterleaving(deinterleaver_in{i},CR,SF);
end

deinterleaver_out_vect = reshape(deinterleaver_out',1,[]); % [SF*x,CR+4] matrix to [1,(CR+4)*SF*x] vector

disp(["Interleaver in == Deinterleaver out: " + isequal(deinterleaver_out_vect,whitened_out)]);

%% De-whitening

dewhitening_out = LoRa_Whitening(deinterleaver_out_vect)';

disp(["Whitening in == Dewhitening out:     " + isequal(hamming_out,dewhitening_out)]);

%% Hamming Decoding

hamming_decode_in = reshape(dewhitening_out,CR+4,[]);

for i = 1: length(hamming_decode_in)
    hamming_decode_out(:,i) = LoRa_Decode_Hamming(hamming_decode_in(:,i)',CR);
end

disp(["Hamm. encode in == Hamm. decode out: " + isequal(hamming_in,hamming_decode_out)]);

%% Formatting to get received message

% received_data_binary = reshape(hamming_decode_out,8,[]);
% 
% for i = 1: (size(received_data_binary,2))
%     received_data_vector(:,i) = char(bin2dec(num2str(received_data_binary(:,i)')));
% end

received_data_vector = hamming_decode_out(:);

disp(["data transmitted == data received:   " + isequal(transmitted_data_vector,received_data_vector)]);

%disp(["received : " + received_data_vector])

