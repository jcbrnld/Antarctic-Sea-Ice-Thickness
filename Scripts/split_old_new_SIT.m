% Jacob Arnold

% 24-sep-2021

% Separate old (ad hoc 1973-1997) SIT from new (data based 1997-2021) SIT




for ii = 1:18
    if ii<10
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors_L/sector0',num2str(ii),'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors_L/sector',num2str(ii),'.mat']);
    end
    %SIT = allSIT; clear allSIT
    
    SIT.old.dn = allSIT.olddn;
    SIT.old.dv = allSIT.olddv; 

    SIT.dn = allSIT.newdn; SIT.dv = allSIT.newdv; 
    
    longSIT = allSIT.H;
    SIT.H = longSIT(:,length(SIT.old.dn)+1:end);
    SIT.old.H = longSIT(:,1:length(SIT.old.dn));
    
    longCAhires = allSIT.CAhires; clear SIT.CAhires
    SIT.CAhires = longCAhires(:,length(SIT.old.dn)+1:end);
    SIT.old.CAhires = longCAhires(:,1:length(SIT.old.dn));
    
    longCBhires = allSIT.CBhires; clear SIT.CBhires
    SIT.CBhires = longCBhires(:,length(SIT.old.dn)+1:end);
    SIT.old.CBhires = longCBhires(:,1:length(SIT.old.dn));
    
    longCChires = allSIT.CChires; clear SIT.CChires
    SIT.CChires = longCChires(:,length(SIT.old.dn)+1:end);
    SIT.old.CChires = longCChires(:,1:length(SIT.old.dn));
    
    longCDhires = allSIT.CDhires; clear SIT.CDhires
    SIT.CDhires = longCDhires(:,length(SIT.old.dn)+1:end);
    SIT.old.CDhires = longCDhires(:,1:length(SIT.old.dn));
    
    % the rest
    SIT.lon = allSIT.lon;
    SIT.lat = allSIT.lat;
    SIT.error = allSIT.error;
    
    
    if ii<10
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector0',num2str(ii),'.mat'], 'SIT', '-v7.3');
    else
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',num2str(ii),'.mat'], 'SIT','-v7.3');
    end
    
    clearvars
end


