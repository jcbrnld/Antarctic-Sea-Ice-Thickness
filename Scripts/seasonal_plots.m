% Jacob Arnold

% 27-Jan-2022

% Seasonal analysis of SIT data in all sectors. 


% Seasons according to Pope et al
% Autumn: March, April, May
% Winter: June, July, August
% Spring: September, October, November
% Summer: December, January, February 



% Test first then do 18 sector loop 

sector = '10';

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

[londom, latdom] = sectordomain(str2num(sector));
dots = sectordotsize(str2num(sector));

%% still testing

% seasonal indices - record length

autuI = find(SIT.dv(:,2) == 3 | SIT.dv(:,2) == 4 | SIT.dv(:,2) == 5);
wintI = find(SIT.dv(:,2) == 6 | SIT.dv(:,2) == 7 | SIT.dv(:,2) == 8);
spriI = find(SIT.dv(:,2) == 9 | SIT.dv(:,2) == 10 | SIT.dv(:,2) == 11);
summI = find(SIT.dv(:,2) == 12 | SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);

autumn = nanmean(SIT.H(:,autuI),2);
winter = nanmean(SIT.H(:,wintI),2);
spring = nanmean(SIT.H(:,spriI),2);
summer = nanmean(SIT.H(:,summI),2);

%%

m_basemap('a', londom, latdom)
sectorexpand(str2num(sector));
m_scatter(SIT.lon, SIT.lat, dots, spring, 'filled')
colormap(colormapinterp(mycolormap('mint'),8));
cbh = colorbar;
caxis([0,2.4]);
cbh.Ticks = [0,0.3:0.3:2.4];
cbh.Label.String = ('Sea Ice Thickness [m]');
cbh.FontSize = 13;
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'Bold';
cbh.TickLength = 0.0499;






% seasonal indices - yearly
















