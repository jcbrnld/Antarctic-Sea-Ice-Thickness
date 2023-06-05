% Jacob Arnold
% 
% 11-aug-2021
% 
% make CT vs Bremen SIC plots

sector = 10;


% THIS MUST BE UPDATED AFTER DATA CONVERSION (See SITworkingscript chapter 2)
load(['ICE/ICEeTHICKNESS/Data/MAT_files/Raw_Gridded/sector',num2str(sector),'_shpE00.mat']);
e00SIT = SIT;clear SIT

load(['ICE/ICEeTHICKNESS/Data/MAT_files/Raw_Gridded/sector',num2str(sector),'_shpSIG.mat']);
shp = SIT;clear SIT

test = load(['ICE/Concentration/ant-sectors/sector',num2str(sector),'.mat']);
test2 = struct2cell(test); SIC = test2{1,1};clear test test2;



SIT.dn = [e00SIT.dn;shp.dn];
SIT.dv = [e00SIT.dv;shp.dv];
SIT.sa = [e00SIT.sa,shp.sa];
SIT.ct = [e00SIT.ct,shp.ct];
SIT.sa = [e00SIT.sa,shp.sa];
SIT.lon = shp.lon; SIT.lat = shp.lat;


%dnind = find(SIC.dn==SIT.dn(1));

figure;
set(gcf, 'position', [500,600,1200,500]);
plot(SIT.dn, nanmean(SIT.ct), 'linewidth', 1.2);
hold on
plot(double(SIC.dn), nanmean(SIC.sic), 'linewidth', 1.2);

