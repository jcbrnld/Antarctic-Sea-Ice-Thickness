% Jacob Arnold

% 06-Jan-22

% Make some example plots of old and new SIT


sector = '10';
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
SITn = SIT; clear SIT
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors_b4CTnanfill/sector',sector,'.mat']);



%%

[londom, latdom] = sectordomain(str2num(sector));

num1 = 100
m_basemap('a', londom, latdom)
m_scatter(SIT.lon, SIT.lat, 8, SIT.H(:,num1-1), 'filled');
xlabel(['Old Sector ',sector,': ',datestr(SIT.dn(num1))]);
%colormap(jet);
caxis([0,2]);
print(['ICE/ICETHICKNESS/Figures/Diagnostic/NewSIT/sector',sector,'OLD_',datestr(SIT.dn(num1)),'.png'], '-dpng', '-r400');

m_basemap('a', londom, latdom)
m_scatter(SITn.lon, SITn.lat, 8, SITn.H(:,num1), 'filled');
xlabel(['New Sector ',sector,': ',datestr(SITn.dn(num1))]);
%colormap(jet);
caxis([0,2]);
print(['ICE/ICETHICKNESS/Figures/Diagnostic/NewSIT/sector',sector,'NEW_',datestr(SIT.dn(num1)),'.png'], '-dpng', '-r400');


%%

m1 = nanmean(SIT.H);
m2 = nanmean(SITn.H);

figure;
plot(m1-m2(1:length(m1)))


%%

ticker = unique(SITn.dv(:,1));ticker(length(ticker)+1) = 2022;
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure;
plot_dim(1000,300);
plot(SIT.dn, nanmean(SIT.H), 'linewidth',1.3);
hold on
plot(SITn.dn, nanmean(SITn.H), 'linewidth',1.3);
title(['Sector ',sector,' old vs new SIT']);
legend('Old SIT', 'New SIT');

xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(25)
xlim([min(SITn.dn)-50, max(SITn.dn)+50]);
grid on

print(['ICE/ICETHICKNESS/Figures/Diagnostic/NewSIT/sector',sector,'_oldvsnew.png'],'-dpng','-r400');


%%

npernan = (sum(isnan(SITn.H))/length(SITn.lon))*100;
opernan = (sum(isnan(SIT.H))/length(SIT.lon))*100;

figure;
plot_dim(1000,300);
plot(SIT.dn, opernan, 'linewidth',1.2);
hold on
plot(SITn.dn, npernan, 'linewidth',1.2);
title(['Sector ',sector,' old vs new SIT']);
legend('Old SIT % nan', 'New SIT % nan');
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(25)
xlim([min(SITn.dn)-50, max(SITn.dn)+50]);
grid on
ylim([0,100]);
%print(['ICE/ICETHICKNESS/Figures/Diagnostic/NewSIT/sector',sector,'_oldvsnew_perNAN.png'],'-dpng','-r400');
















