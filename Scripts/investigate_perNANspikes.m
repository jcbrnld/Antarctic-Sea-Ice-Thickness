% Jacob Arnold

% 18-Jan-2022

% Address spikes in %nan in early years 

% 1. load in sector SIT data
% 2. find indices between start and critical date (around 2001-2002 ->
%    check with percent nan plots) with non-permanent nan.
% 3. spatially plot to see where those grid points fall


% start with a good example sector: 
% sector 12


sector = '12';

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);


%%
Cdate = find(SIT.dn==datenum(2001,01,01));

loc = find(sum(isnan(SIT.H(:,1:Cdate)),2)./length(SIT.H(1,1:Cdate)) < .99 &...
    sum(isnan(SIT.H(:,1:Cdate)),2)./length(SIT.H(1,1:Cdate)) > 0);

loc1 = find(sum(isnan(SIT.H(:,1:Cdate)),2)./length(SIT.H(1,1:Cdate)) >= .99);

sdot = sectordotsize(str2num(sector));
[londom, latdom] = sectordomain(str2num(sector));

m_basemap('a', londom, latdom)
sectorexpand(str2num(sector));
m_scatter(SIT.lon, SIT.lat, sdot, [0.7,0.7,0.7],'filled');
m_scatter(SIT.lon(loc), SIT.lat(loc), sdot, [0.9,0.5,0.6],'filled');










