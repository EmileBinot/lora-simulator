clear;
clc;
SF=10;
CR=4;

% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

for i= 0:10:SF*10-10
    for j= 1:(CR+4)
        %disp(num2str(i+j))
        in_matrix(i/10+1,j)=i+j-1;
    end
end

%% INTERLEAVING

% for i= 0:(CR+4)-1
%     for j=0:(SF)-1
%         idi=SF-1-mod(j-i,SF);
%         idj=CR+4-1-i;
%         out(i+1,j+1)=in_matrix(idi+1,idj+1);
%     end
% end

interleaved= LoRa_Interleaving(in_matrix,CR,SF);
deinterleaved= LoRa_Deinterleaving(interleaved,CR,SF);

%% DEINTERLEAVING

% for i= 0:(SF)-1
%     for j=0:(CR+4)-1
%         idi=CR+4-1-j;
%         idj=mod(SF-1-i+(CR+4)-1-j,SF);
%         recovered(i+1,j+1)=out(idi+1,idj+1);
%     end
% end


