clear;

SF=7;
CR=4;
in_matrix = [0 1 1 1 0 0 1 0 ; 1 1 1 0 1 0 0 0 ; 1 2 3 4 5 6 7 8 ; 0 0 0 0 0 0 0 0 ;0 0 1 0 1 1 1 0 ;1 1 0 1 0 0 0 1 ;1 1 1 1 1 1 1 1];
% algorithm : www.researchgate.net/publication/339255011_Towards_an_SDR_implementation_of_LoRa_Reverse-engineering_demodulation_strategies_and_assessment_over_Rayleigh_channel

%% INTERLEAVING for SF=7, CR=4 (blocks of 7 lines *(4+CR) columns)
interleaved_block = rot90(in_matrix,2);
interleaved_block= [interleaved_block(:,1) circshift(interleaved_block(:,2),1)...
                    circshift(interleaved_block(:,3),2) circshift(interleaved_block(:,4),3)...
                    circshift(interleaved_block(:,5),4) circshift(interleaved_block(:,6),5)...
                    circshift(interleaved_block(:,7),6) interleaved_block(:,8)]';
               
%% DETINERLEAVING for SF=7, CR=4 (blocks of 7 lines * (4+CR) columns)

temp=interleaved_block';
temp= [temp(:,1) circshift(temp(:,2),-1)...
                    circshift(temp(:,3),-2) circshift(temp(:,4),-3)...
                    circshift(temp(:,5),-4) circshift(temp(:,6),-5)...
                    circshift(temp(:,7),-6) temp(:,8)];
deinterleaved_block = rot90(temp,-2);

if(deinterleaved_block == in_matrix)
    disp("deinterleaved_block == in_matrix")
end