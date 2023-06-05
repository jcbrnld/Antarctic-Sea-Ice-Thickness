% Jacob Arnold
% 01-Feb-2021
% Check random spikes in SIV 


sector = '18';

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup01feb22/sector',sector,'.mat']);


[londom, latdom] = sectordomain(str2num(sector));
dots = sectordotsize(str2num(sector));
%% view H

m_basemap('a', londom, latdom);
sectorexpand(str2num(sector));
m_scatter(SIT.lon, SIT.lat, dots, SIT.H(:,150), 'filled');
cbh = colorbar;
%colormap(jet(8));
colormap(colormapinterp(mycolormap('mint'),8));
caxis([0,2.4]);
cbh.Ticks = 0:0.3:2.4;


%% SIV timeseries


ticker = (1997:2022).';
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure;
plot_dim(1200,300);
plot(SIT.dn, SIT.SIV, 'color', [0.3,0.6,0.8]);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
grid on
title(['Sector ',sector,' Sea Ice Volume']);
ylabel('SIV [km^3]');
xtickangle(25);
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);

% didn't look bad
% lowdif = find(diff(SIT.dn)==1);
% for ii = 1:length(lowdif)
%     xline(SIT.dn(lowdif(ii)), 'm');
% end



%% 
% Remove from H Just before interpolation

% Sector 01: 143, 179
% Sector 02: 21, 28, 143, 179
% Sector 03: []
% Sector 04: []
% Sector 05: []
% Sector 06: []
% Sector 07: 359
% Sector 08: []
% Sector 09: []
% Sector 10: 528, 545
% Sector 11: []
% Sector 12: []
% Sector 13: []
% Sector 14: 149
% Sector 15: []
% Sector 16: []
% Sector 17: []
% Sector 18: []


%% sector 01


