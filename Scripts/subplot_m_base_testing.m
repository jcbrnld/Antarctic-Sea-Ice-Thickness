% Jacob Arnold

% 18-Jan-2022

% Make movies of nan grid points in each sector 

% Include timeseries with moving line in movie? 
% To do that, either need to subplot m_basemap or find a way to plot
% timeseries over existing axes. 



% Test % THIS WORKS BUT BELOW IS BETTER
m_basemap('a', londom, latdom)
plot_dim(800,800)
m_scatter(SIT.lon, SIT.lat, sdot, SIT.H(:,735), 'filled')


axes('Position', [0.17,0.1,0.7,0.13]) % timeseries axes
plot(SIT.dn, nanmean(SIT.H), 'linewidth', 1.4,'color', [0.9,0.5,0.6])
xline(SIT.dn(735), 'linewidth', 1.2, 'color', [0.3, 0.9, 0.6])
datetick('x', 'mm-yyyy')
xtickangle(25)
grid on




%% basemap subplot 

dticker = unique(SIT.dv(:,1));
dticker(end+1) = 2022;
dticker(:,2:3) = 1;
dticker = datenum(dticker);

figure;
s1 = subplot(4,1,1:3);
set(s1, 'Position', [0.1,0.3,0.81,0.6])
plot_dim(800,800);
m_basemap_subplot('a', londom, latdom);
m_scatter(SIT.lon, SIT.lat, sdot, SIT.H(:,735), 'filled');
%colormap(jet(8))
cmocean('ice', 8);
caxis([0,2.4]);
cbh = colorbar;
cbh.Ticks = [0:0.3:2.4];
cbh.Label.String = ('Sea Ice Thickness [m]');
cbh.FontSize = 13;
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'Bold';
cbh.TickLength = 0.045;
xlabel(['Sector ',sector], 'Position', [0,-0.046], 'fontsize', 15, 'fontweight', 'bold');

s2 = subplot(4,1,4);
%set(s2, 'Position', [0.17,0.28,0.71,0.13])
set(s2, 'Position', [0.12,0.2,0.77,0.13])
plot(SIT.dn, nanmean(SIT.H), 'linewidth', 1.4,'color', [0.9,0.5,0.6])
xline(SIT.dn(735), 'linewidth', 1.2, 'color', [0.3, 0.9, 0.6]);
xticks(dticker);
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30)
ylim([0,2.4])
ylabel('H [m]')
grid on

%print('~/Desktop/testsubplot1.png', '-dpng', '-r300');









