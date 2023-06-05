% Jacob Arnold

% 18-Feb-2022

% Okay so there are two date issues that I have been fixing after
% calculating SIT but which I think should be fixed in the raw gridded data
% instead. 
% These are: 
% 1. extra date (extra data) in some sectors but not others 
        % - third dn == 729704 if that sector has it
        % - If I remember correctly there were a couple of "pie slices" of
        %   data that week but not others - not hemisphric coverage.
% 2. One date is repeated - remove the second one. 
        % - should be indices 306 and 307 (dn 732700) 
        % - 306 should be 2006-01-09 rather than 2006-01-23
        %       - simply change the date and save.
        
        
  % 1 is in E00 and 2 is in SIG
 zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};
        
for ss = 1:24
    if ss < 10
        sector = ['0', num2str(ss)];
    elseif ss <= 18 & ss >= 10
        sector = num2str(ss);
    else
        sector = zones{ss-18};
    end
    
    disp(['Beginning sector ',sector,'...']);
    
    % start with issue 1: E00 data
    if ss <= 18
        load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup_18_feb_22/sector',sector,'_shpE00.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup_18_feb_22/sector',sector,'_SIC_25km_shpE00.mat']);
    end
    
    if SIT.dn(3) == 729704
        disp(['Sector ',sector,'has type 1 issue!'])
        SIT.dn(3) = [];
        SIT.dv(3,:) = [];
        SIT.H(:,3) = [];
        SIT.sa(:,3) = [];
        SIT.sb(:,3) = [];
        SIT.sc(:,3) = [];
        SIT.sd(:,3) = [];
        SIT.ca(:,3) = [];
        SIT.cb(:,3) = [];
        SIT.cc(:,3) = [];
        SIT.cd(:,3) = [];
        SIT.ct(:,3) = [];
        
        if ss <= 18
            save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat'], 'SIT', '-v7.3');
        else
            save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_SIC_25km_shpE00.mat'], 'SIT', '-v7.3');
        end
    else
        disp(['Sector ',sector,'does not have type 1 issue'])
    end
    l1 = length(SIT.dn);
    clear SIT
    
    % Now issue 2
    
    if ss <= 18
        load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup_18_feb_22/sector',sector,'_shpSIG.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup_18_feb_22/sector',sector,'_SIC_25km_shpSIG.mat']);
    end
    
    if min(diff(SIT.dn))==0
        % look for that date
        dind = find(diff(SIT.dn)==0);
        if SIT.dn(dind) == 732700 & SIT.dn(dind+1) == 732700;
            disp(['Sector ',sector,' type 2 error... Extra date is where it should be'])
            
            SIT.dv(dind,3) = 9; % correct from jan 23 to jan 9 
            SIT.dn(dind) = datenum(SIT.dv(dind,:));
            if ss <= 18
                save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat'], 'SIT', '-v7.3');
            else
                save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_SIC_25km_shpSIG.mat'], 'SIT', '-v7.3');
            end
        end
            
    end
    disp(['Sector ',sector,' date count is now ',num2str(l1+length(SIT.dn))])
    
    clearvars -except zones
end
    


























