% Jacob Arnold

% 15-Feb-2022

% Combine offshore and sector00 to create southern_ocean data structure




% offshore
load('ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat');
offs = SIT; clear SIT

load('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat');
shes = SIT; clear SIT;

%%
 siv = sum([nansum((shes.H./1000).*3.125); nansum((offs.H./1000).*25)]);
 
SIT.H = [offs.H; shes.H];
SIT.lon = [offs.lon; shes.lon];
SIT.lat = [offs.lat; shes.lat];
SIT.dn = offs.dn;
SIT.dv = offs.dv;

SIT.SIV = siv;
% Example plot
m_basemap('p', [0,360], [-90,-50]);
m_scatter(SIT.lon, SIT.lat, 5, SIT.H(:,900), 's', 'filled')




save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat', 'SIT', '-v7.3');




