
% Jacob Arnold

% 19-Nov-2021

% Investigate sector boundaries - is there overlap? 



load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector01.mat
SIT12 = SIT; clear SIT
load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector02.mat
SIT13 = SIT; clear SIT

[c1, ilon12, ilon13] = intersect(SIT12.lon, SIT13.lon);
[c2, ilat12, ilat13] = intersect(SIT12.lat, SIT13.lat);

inin12 = intersect(ilon12,ilat12);
inin13 = intersect(ilon13, ilat13);

disp(['Number of overlapping grid points: ',num2str(length(inin12))])

%%

%m_basemap('a', [130,182],[-72,-63]) 
m_basemap('a', [290,318],[-75,-67]) 
plot_dim(1200,800)
m_scatter(SIT12.lon, SIT12.lat, 20, 'filled', 'c');
m_scatter(SIT13.lon, SIT13.lat, 30,'m')



%%

print('ICE/ICETHICKNESS/Figures/Diagnostic/Sector_bounds/sector01_02.png', '-dpng', '-r400');


%%
% load and investigate sector 00 for overlap


load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat
SIT00 = SIT; clear SIT
lonlat = [SIT00.lon, SIT00.lat];

myun = unique(lonlat, 'rows', 'stable');


disp(['Number of overlapping grid points: ',num2str(length(SIT00.lon)-length(myun))])









