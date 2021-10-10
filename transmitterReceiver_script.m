clear;
CR=4;
SF=7;

data = 'H';

%% Message to binary vector

binary = reshape(dec2bin(data, 8).'-'0',1,[]);
hamming_in = reshape(binary,4,[]);

i=0;
while mod(8*length(hamming_in),7)
    padding=[0 0;0 0;0 0;0 0];
    hamming_in=[hamming_in padding];
end


%% Hamming
for i = 1: (length(hamming_in))
    hamming_out(:,i) = LoRa_Encode_Hamming(hamming_in(:,i)',CR);
end

hamming_out = hamming_out(:); % shaping

%% Whitening

whitening_out = LoRa_Whitening(hamming_out');

%% Interleaving

% shaping
cell=ones(1,(size(whitening_out,2)/8)/SF).*SF;
interleaver_in = reshape(whitening_out,CR+4,[])';
interleaver_in = mat2cell(interleaver_in,cell,[8]);%too specific, TO BE FIXED (ADDING PADDING AT THE BEGINNING)
interleaver_out=[];

for i = 1 :length(interleaver_in)
    interleaver_out=[interleaver_out;LoRa_Interleaving(interleaver_in{i})];
end

%% Bits to symbols (BYPASSED)
%% Modulation (BYPASSED)
%% Demodulation (BYPASSED)
%% Symbols to bits (BYPASSED)
deinterleaver_in=interleaver_out;

%% De-interleaving

cell2=ones(1,(size(deinterleaver_in,2)*size(deinterleaver_in,1))/8/SF).*8;

deinterleaver_in = mat2cell(deinterleaver_in',[SF],cell2);%too specific, TO BE FIXED (ADDING PADDING AT THE BEGINNING)
deinterleaver_out=[];

for i = 1 : length(deinterleaver_in)
    deinterleaver_out=[deinterleaver_out ; LoRa_Deinterleaving(deinterleaver_in{i}')];
end

deinterleaver_out = reshape(deinterleaver_out',1,[]);

%% De-whitening

dewhitening_out = LoRa_Whitening(deinterleaver_out)';

%% Hamming Decoding, no corrective action yet implemented

hamming_decode_in = reshape(dewhitening_out,8,[]);

for i = 1: (length(dewhitening_out)/8)
    hamming_decode_out(:,i) = LoRa_Decode_Hamming(hamming_decode_in(:,i)',CR);
end

%% Formatting to get received message

received_data_binary = reshape(hamming_decode_out,8,[]);

for i = 1: (size(received_data_binary,2))
    received_data_vector(:,i) = char(bin2dec(num2str(received_data_binary(:,i)')));
end

