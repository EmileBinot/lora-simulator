function [out] = LoRa_Deinterleaving(in,CR,SF)

% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

%% Deinterleaving
out=zeros(SF,CR+4);
for i= 0:(SF)-1
    for j=0:(CR+4)-1
        idi=CR+4-1-j;
        idj=mod(SF-1-i+(CR+4)-1-j,SF);
        out(i+1,j+1)=in(idi+1,idj+1);
    end
end

end
