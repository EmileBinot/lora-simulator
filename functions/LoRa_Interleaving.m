function [interleaved_block] = LoRa_Interleaving(in_matrix)

% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

%% INTERLEAVING for SF=7, CR=4 (blocks of 7 lines *(4+CR) columns)
interleaved_block = rot90(in_matrix,2);
interleaved_block= [interleaved_block(:,1) circshift(interleaved_block(:,2),1)...
                    circshift(interleaved_block(:,3),2) circshift(interleaved_block(:,4),3)...
                    circshift(interleaved_block(:,5),4) circshift(interleaved_block(:,6),5)...
                    circshift(interleaved_block(:,7),6) interleaved_block(:,8)]';

end

