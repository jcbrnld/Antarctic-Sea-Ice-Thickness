% 08-July-2021

% Jacob Arnold

% Investigate days with large portions of the sector nan


% Consult ICE/ICETHICKNESS/Data/MAT_files/gaps_log.txt for dates

sector = '14';


load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'SIG.mat']);
%load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);



d = 11;
m = 2;
y = 2021;
disp(['date is ',num2str(d), '-',num2str(m),'-', num2str(y)])

idx = find((SIT.dv(:,3) == d) & (SIT.dv(:,2) == m) & (SIT.dv(:,1) == y));



splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53.5 68.5]; splot{6,2}=[-68 -65.2];
splot{7,1}=[67 86]; splot{7,2}=[-70.5 -65]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99.5 113.5]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[121 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[133.5 150.5]; splot{12,2}=[-69 -64.5];
splot{13,1}=[149 173]; splot{13,2}=[-72 -65]; splot{14,1}=[160 207]; splot{14,2}=[-79 -69];
splot{15,1}=[202 235.5]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-70 -59];


% looks like a big polygon that we didn't capture
m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.sa(:,idx), 'filled');
title(['sector_',sector, 'SA raw gridded'])
colormap('jet(12)');
caxis([0,300]);
colorbar

m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.ca_hires(:,idx), 'filled');
colormap('jet(12)');
caxis([0,300]);
colorbar 



m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.sb(:,idx), 'filled');
colormap('jet(12)');
caxis([0,300]);
colorbar 

m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.cb(:,idx), 'filled');
colormap('jet(12)');
caxis([0,300]);
colorbar 



m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.sc(:,idx), 'filled');
colormap('jet(12)');
caxis([0,300]);
colorbar 

m_basemap('m', splot{str2num(sector), 1}, splot{str2num(sector), 2}); 
set(gcf, 'position', [500,600,1000,800]);
m_scatter(SIT.lon, SIT.lat, 10, SIT.cc(:,idx), 'filled');
colormap('jet(12)');
caxis([0,300]);
colorbar 




%%

% load shapfiles using SITworkingscript__TEST.m
% Make sure it converts them to lat+lon creating shapefile lat and lons
% Sector 1 polys of interest: idx18:766, idx34:748 and 836
% Sector 14 polys of interest: idx75:273 idx55:219  idx128:12   One ice type


idx = 18; % date index of observed missing data
p=[1]; m_basemap('p', [0 360], [-75 -40])
%m_basemap('m', [280,360], [-85,-50]);
set(gcf, 'position', [500,600,1000,800]);
for ii = 1:length(p)
    m_plot(lon{idx,p(ii)},lat{idx,p(ii)}, 'linewidth', 1.3);hold on
end
%m_scatter(SIT.lon, SIT.lat, 0.3,  [0.7,0.7,0.7],'filled','MarkerFaceAlpha', .9);
%print('ICE/ICETHICKNESS/Figures/investigating_nans/sector_01/Polygon_idx18.png', '-dpng', '-r100');














