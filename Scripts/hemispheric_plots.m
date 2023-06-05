% Jacob Arnold

% 12-nov-2021

% Plot some hemispheric SIT



load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat




%%
daynum = 875;

m_basemap('p', [0,360], [-90,-45]);
set(gcf, 'position', [200,250,1100,900]);
m_scatter(SO_SIT.lon(SO_SIT.offshore_ind), SO_SIT.lat(SO_SIT.offshore_ind),...
   12, SO_SIT.H(SO_SIT.offshore_ind, daynum), 'filled')
m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind), ...
    .8, SO_SIT.H(SO_SIT.shelf_ind, daynum), 'filled');
cmocean('ice', 10)
caxis([0,2])
cbh = colorbar;
cbh.Ticks = [0:0.2:2];
cbh.FontSize = 13;
cbh.Label.String = ('Sea Ice Thickness [cm]');
cbh.Label.FontSize = 16;

text(-0.07, 0, [datestr(SO_SIT.dn(daynum))], 'FontSize', 14);


print(['ICE/ICETHICKNESS/Figures/Southern_Ocean/Example_plots/recording',num2str(daynum), '.png'], '-dpng', '-r600');



%% Means

tmH = nanmean(SO_SIT.H, 2);
smH = nanmean(SO_SIT.H);

m_basemap('p', [0,360], [-90,-45]);
set(gcf, 'position', [200,250,1100,900]);
m_scatter(SO_SIT.lon(SO_SIT.offshore_ind), SO_SIT.lat(SO_SIT.offshore_ind),...
   12, tmH(SO_SIT.offshore_ind), 'filled')
m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind), ...
    .8, tmH(SO_SIT.shelf_ind), 'filled');
cmocean('ice', 10)
caxis([0,2])
cbh = colorbar;
cbh.Ticks = [0:0.2:2];
cbh.FontSize = 13;
cbh.Label.String = ('Sea Ice Thickness [cm]');
cbh.Label.FontSize = 16;
text(-0.12, 0, '1997-2021 Average', 'FontSize', 14);


print(['ICE/ICETHICKNESS/Figures/Southern_Ocean/97-21Average.png'], '-dpng', '-r600');


%%
clear sampdv sampdn
sampdv(:,1) = [1997:2022];
sampdv(:,2:3) = 1;
sampdn = datenum(sampdv);



figure;
set(gcf, 'position', [200,200,1200,400])
plot(SO_SIT.dn, smH, 'linewidth',1.2, 'color', [0.7, 0.3, 0.2])
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(25)
grid on
xlim([729650, 738238]);
title('Southern Ocean Mean Sea Ice Thickness');
ylabel('Sea Ice Thickness [m]')


print(['ICE/ICETHICKNESS/Figures/Southern_Ocean/area_averaged.png'], '-dpng', '-r600');


%% Offshore and shelf averages

offmH = nanmean(SO_SIT.H(SO_SIT.offshore_ind, :));
shemH = nanmean(SO_SIT.H(SO_SIT.shelf_ind, :));

figure;
set(gcf, 'position', [200,200,1200,400])
plot(SO_SIT.dn, offmH, 'linewidth',1.2, 'color', [0.7, 0.3, 0.2])
hold on
plot(SO_SIT.dn, shemH, 'linewidth',1.2, 'color', [0.2, 0.6, 0.4])
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(25)
grid on
xlim([729650, 738238]);
title('Southern Ocean Mean Sea Ice Thickness');
ylabel('Sea Ice Thickness [m]')
legend('Shelf SIT', 'Offshore SIT');











