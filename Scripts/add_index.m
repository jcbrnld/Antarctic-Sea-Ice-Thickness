% Jacob Arnold

% 03-Mar-2022

% open all SIT and properties files and add "index" from SIC files  
% then resave


for ss = 1:18
    if ss < 10 
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    disp(['Starting sector ',sector,'...'])
    % concentration
    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    index = SIC.index; clear SIC;
    
    % SIT
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    SIT.index = index; 
    SIT.comment{length(SIT.comment)+1,1} = 'Index is indices of original 2d 3.125km global grid (grid_3125.mat) corresponding to this sectors lat and lon vectors';
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    
    % properties
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    seaice.index = index;
    seaice.readme{length(seaice.readme)+1,1} = 'Index is indices of original 2d 3.125km global grid (grid_3125.mat) corresponding to this sectors lat and lon vectors';
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice');
    
    disp(['Sector ',sector,' updated with index'])
    
    clearvars
    
end










