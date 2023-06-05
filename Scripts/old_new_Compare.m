
% 19-may-2021
% Jacob Arnold


% Compare New non-QC SIT with Cody's



% Mine
load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/sector10SIT2.mat;
S10SIT = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/ICEThickness_Webb/MAT_files_Webb/SabrinaSITqc.mat
WebbSIT = SIT; clear SIT

sect = find(WebbSIT.lon>=min(S10SIT.lon) & WebbSIT.lon<=max(S10SIT.lon) & WebbSIT.lat>=min(S10SIT.lat) & WebbSIT.lat<=max(S10SIT.lat));
WebbSIT.H=WebbSIT.H(sect,:);WebbSIT.lon=WebbSIT.lon(sect,:);WebbSIT.lat=WebbSIT.lat(sect,:);

% View some examples of each to see what grid we're working with
m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]) %sector10
set(gcf, 'Position', [600, 500, 700, 450])
m_scatter(S10SIT.lon, S10SIT.lat, 23, S10SIT.H(:,79), 'filled');
colormap(jet);
colorbar
caxis([0,600])


m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]) %sector10
set(gcf, 'Position', [600, 500, 700, 450])
m_scatter(WebbSIT.lon, WebbSIT.lat, 65, WebbSIT.H(:,find(WebbSIT.dn==(S10SIT.dn(79)))), 'filled');
colormap(jet);
colorbar
caxis([0,600])




figure
set(gcf, 'Position', [600, 500, 1100, 400]);
plot(SIT1.dn, nanmean(SIT1.H)); hold on
plot(WebbSIT.dn, nanmean(WebbSIT.H))
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT1.dn),max(SIT1.dn)])
legend('New', 'Webb');
grid on; grid minor
print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/NEWvsWebbFull.png','-dpng', '-r400')


