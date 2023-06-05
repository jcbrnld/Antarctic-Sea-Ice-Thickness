% Jacob Arnold
% 13-Jan-22

% Load in raw gridded data and remove 2021-03-18 to the end in preparation to test the process_new_SIT.m script

% All except sector 10; 


for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    elseif ii == 10
        disp('Skipping sector 10')
        continue
    elseif ii > 10
        sector = num2str(ii);
    end
    
    disp(['Start sector ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']);
    
    datetorm = datenum(2021,3,18);
    dateone = find(SIT.dn==datetorm);
    
    SIT.dn(dateone:end) = [];
    SIT.dv(dateone:end,:) = [];
    SIT.H(:,dateone:end) = [];
    SIT.sa(:,dateone:end) = [];
    SIT.sb(:,dateone:end) = [];
    SIT.sc(:,dateone:end) = [];
    SIT.sd(:,dateone:end) = [];
    SIT.ca(:,dateone:end) = [];
    SIT.cb(:,dateone:end) = [];
    SIT.cc(:,dateone:end) = [];
    SIT.cd(:,dateone:end) = [];
    SIT.ct(:,dateone:end) = [];
    
    disp(['Sector ',sector,': last date is ',datestr(SIT.dn(end))])
    
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat'], 'SIT', '-v7.3');

end


