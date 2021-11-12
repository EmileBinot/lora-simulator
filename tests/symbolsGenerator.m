clear;

itSF=0;
itB=0;
modSymbK=[];

for SF=[7:10]
    disp([SF])
    itSF=itSF+1;
    for symbK=[1:2^SF]
        r=LoRa_Modulation_faster(SF,symbK,1);
        [i1,j1] = ndgrid(1:size(modSymbK,1),1:size(modSymbK,2));
        [i2,j2] = ndgrid(1:size(r,1),(1:size(r,2))+size(modSymbK,2));

        modSymbK = accumarray([i1(:),j1(:);i2(:),j2(:)],[modSymbK(:);r(:)]);
    end
end

demodChirp=[];
for SF = [7:10]
    disp([SF])
    itSF=itSF+1;
    r=LoRa_Modulation_faster(SF,0,-1);
    [i1,j1] = ndgrid(1:size(demodChirp,1),1:size(demodChirp,2));
    [i2,j2] = ndgrid(1:size(r,1),(1:size(r,2))+size(demodChirp,2));

    demodChirp = accumarray([i1(:),j1(:);i2(:),j2(:)],[demodChirp(:);r(:)]);
end

save("symbols","modSymbK","demodChirp");
