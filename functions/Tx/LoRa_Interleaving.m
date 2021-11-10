function [out] = LoRa_Interleaving(in,CR,SF)

% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

%% Interleaving
out=zeros(CR+4,SF);
for i= 0:(CR+4)-1
    for j=0:(SF)-1
        idi=SF-1-mod(j-i,SF);
        idj=CR+4-1-i;
        out(i+1,j+1)=in(idi+1,idj+1);
    end
end

end

