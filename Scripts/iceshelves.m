% Jacob Arnold

% 07-Jan-22

% Find permanent ice in the SIC record (grid points that are nan in >90% of
% the bremen 3.125 km native data)



sector = '18';

%load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);


%%

% now find which grid points are nan more than .9 of the time in SIC. 
% First grab subset of data that are the native 3.125 (AMSRe and AMSR2)
subinds = [6891:10330, 10574:14044];
subsic = SIC.sic(:,subinds);

badginds = find(sum(isnan(subsic),2)/length(subinds)>=.90);

[londom, latdom] = sectordomain(str2num(sector));

%%

m_basemap('a', [londom,5], [latdom,2]);
sectorexpand(str2num(sector));
dotsize = sectordotsize(str2num(sector));
dot1 = m_scatter(SIC.lon, SIC.lat, dotsize,'filled', 'markerfacecolor', [0.3,0.6,0.8]);
dot2 = m_scatter(SIC.lon(badginds), SIC.lat(badginds), dotsize, 'm', 'filled');
legend([dot1,dot2], 'Sector Grid', 'NaN >90% in SIC')
xlabel({['Sector ',sector,': grid points that are NaN at least 90% of the time'], 'in AMSRe and AMSR2 data'});
%print(['ICE/ICETHICKNESS/Figures/Diagnostic/Ice_Shelves/sector',sector,'.png'],'-dpng','-r500');


%% Save SIC with permIceInds in the structure

SIC.permIceInds = badginds; 

save(['ICE/Concentration/ant-sectors/sector',sector,'.mat'],'SIC','-v7.3');




