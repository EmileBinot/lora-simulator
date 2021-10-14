function [deinterleaved_block] = LoRa_Deinterleaving(interleaved_block)

% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

%% DETINTERLEAVING for SF=7, CR=4 (blocks of (4+CR) lines * 7 columns)

temp=interleaved_block';
temp= [temp(:,1) circshift(temp(:,2),-1)...
                    circshift(temp(:,3),-2) circshift(temp(:,4),-3)...
                    circshift(temp(:,5),-4) circshift(temp(:,6),-5)...
                    circshift(temp(:,7),-6) temp(:,8)];
deinterleaved_block = rot90(temp,-2);

end
