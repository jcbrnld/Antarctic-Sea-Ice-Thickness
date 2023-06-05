% Jacob Arnold

% 06-Jan-22

% Remove repeat gridpoints from sectors 08, 13, 15 for raw gridded e00 data


sector = '15';

load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat']);
SITe00 = SIT; clear SIT
load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']);
SITsig = SIT; clear SIT
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
SITo = SIT; clear SIT

%%

if length(SITe00.lon) == length(SITo.lon)
    error('No need for correction here')
end

disp(['Number of gridpoints to remove in sector',sector,' is ',num2str(length(SITo.rm_gpoint{1,1}(:,2)))])
rminds = SITo.rm_gpoint{1,1}(:,2);
SITe00.H(rminds,:) = [];
SITe00.sa(rminds,:) = [];
SITe00.sb(rminds,:) = [];
SITe00.sc(rminds,:) = [];
SITe00.sd(rminds,:) = [];
SITe00.ca(rminds,:) = [];
SITe00.cb(rminds,:) = [];
SITe00.cc(rminds,:) = [];
SITe00.cd(rminds,:) = [];
SITe00.ct(rminds,:) = [];
SITe00.lon(rminds) = [];
SITe00.lat(rminds) = [];

    
if length(SITe00.lon) == length(SITo.lon)
    disp('Success! Repeat gpoints have been removed')
    
    SIT = SITe00;
    save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat'], 'SIT','-v7.3');
    
else
    warning(['Check sector ',sector,' incorrect num grid points removed']) 
end
    




