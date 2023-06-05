% Jacob Arnold

% 17-Dec-2021

% Check out the amount/area of icebergs in coastal sectors with respect to
% time. 


load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector10_shpSIG.mat;
gSIT = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector10.mat;

%%

% Glacial ice is only found in SA (SA==98)
% Work on these conditionals -> check SITworkingscript 
berglog = ((gSIT.sa == 98) & (gSIT.sb == 99)) | ((gSIT.sa == 98) & (isnan(gSIT.sb))) | ((gSIT.sa == 98) & (gSIT.sb == -9));

bergs = (sum(((gSIT.sa == 98) & (gSIT.sb == 99)) | ((gSIT.sa == 98) & (isnan(gSIT.sb))) | ((gSIT.sa == 98) & (gSIT.sb == -9)))/...
    length(gSIT.lon))*100;


xtickmaker = unique(SIT.dv(:,1));
xtickmaker(:,2:3) = 1;
xtickmaker = datenum(xtickmaker);
figure;
plot_dim(1200,400)
plot(SIT.dn, (sum(isnan(SIT.H))/length(SIT.lon))*100, 'linewidth', 1.2)
hold on
plot(gSIT.dn, bergs, 'linewidth', 1.2)
xticks(xtickmaker)
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(23)
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
grid on
print('ICE/ICETHICKNESS/Figures/Icebergs/Sector10/timeseries.png','-dpng', '-r400');



%% 

[londom, latdom] = sectordomain(10);

m_basemap('a', londom, latdom)
m_scatter(SIT.lon, SIT.lat, 12, SIT.H(:,742), 'filled')
xlabel('Sector 10: 2012-01-09 SIT')
print('ICE/ICETHICKNESS/Figures/Icebergs/Sector10/SIT2012-01-09.png','-dpng', '-r400');

m_basemap('a', londom, latdom)
m_scatter(gSIT.lon, gSIT.lat, 12, berglog(:,230),'filled');
cbh = colorbar;
caxis([0,1])
colormap(parula(2))
cbh.Ticks = [0,1];
xlabel('Sector 10: 2012-01-09 Icebergs')
print('ICE/ICETHICKNESS/Figures/Icebergs/Sector10/bergs2012-01-09.png','-dpng', '-r400'); 




