% Jacob Arnold

% 28-Sep-2021

% Remove extra date from SIT data. 
% DN 729704 appears in only a few sectors but not others. 


for ii = 1:18 % all sectors
    disp(['On Sector ', num2str(ii)])

    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    if length(SIT.dn)==885
        loc = find(SIT.dn==729704);
        if loc~=3
            disp(['Wrong loc, breaking']);
            break
        end
        SIT.dn(3) = [];
        SIT.H(:,3) = [];
        SIT.dv(3,:) = [];
        SIT.CAhires(:,3) = [];
        SIT.CBhires(:,3) = [];
        SIT.CChires(:,3) = [];
        SIT.CDhires(:,3) = [];
        
        
        
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
        
    elseif length(SIT.dn)==884
        disp('This one is good')
    else
        disp('Hmm one is not 884 or 885'); % shouldn't happen
        
    end
    
    clearvars
end
    
    