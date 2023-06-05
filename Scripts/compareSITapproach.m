% Jacob Arnold

% twos day (02/22/2022)

% Compare output from different SIT approaches


sector = '14';

 %old (creates ratios from averages)
 load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/b4_ratioCorrection/sector',sector,'.mat']);
 oSIT = SIT; clear SIT;

% new (uses moving monthly averages to fill 99s and some others)
%load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/RatioCorrection_loopedAv/sector',sector,'.mat']);
%nSIT = SIT;

% new (record length monthly means used to fill 99s and some others)
%load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/recLenAv/sector',sector,'_reclenav.mat']);
%rlSIT = SIT; clear SIT

% Hybrid approach ("moving" montly averages to fill SOD and record length monthly to fill SIC partials)
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/raw_hybrid/sector',sector,'_hybrid.mat']);
hySIT = SIT; clear SIT


%%
SIT1 = rlSIT; % (define which ones to compare)
SIT2 = rlSIT;
SIT3 = hySIT; 
% trends
p1 = polyfit(SIT1.dn, nanmean(SIT1.H)',1);
p2 = polyfit(SIT2.dn, nanmean(SIT2.H)',1);
p3 = polyfit(SIT3.dn, nanmean(SIT3.H)',1);
y1 = polyval(p1, SIT1.dn);
y2 = polyval(p2, SIT2.dn);
y3 = polyval(p3, SIT3.dn);


% Get slope 52.18 weeks in a year ~522 weeks in 10 years
slope1 = y1(622)-y1(101);
slopeper1 = (slope1/y1(101))*100;
slope2 = y2(622)-y2(101);
slopeper2 = (slope2/y2(101))*100;
slope3 = y3(622)-y3(101);
slopeper3 = (slope3/y3(101))*100;

ticker = dnticker(1997,2022);
figure;
plot_dim(1000,300);
%plot(SIT1.dn, nanmean(SIT1.H), 'linewidth', 1.1, 'color', [0.4,0.7,0.9]);
%hold on
plot(SIT2.dn, nanmean(SIT2.H), 'linewidth', 1.1, 'color', [0.05, 0.6, 0.1]);hold on
plot(SIT3.dn, nanmean(SIT3.H), 'linewidth', 1.1, 'color', [0.99,0.1,0.99]);
%trend1 = plot(SIT1.dn, y1, '--', 'color', [0.4,0.7,0.9], 'linewidth', 1.5);
trend2 = plot(SIT2.dn, y2, '--', 'color', [0.05, 0.6, 0.1], 'linewidth', 1.5);
trend3 = plot(SIT3.dn, y3, '--', 'color', [0.99,0.1,0.99], 'linewidth', 1.5);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks')
xlim([min(SIT1.dn)-50, max(SIT1.dn)+50]);

%legend('Moving average to create ratios', 'Rec. Len. average to fill missing data', 'Hybrid approach',...
 %   [num2str(slopeper1),' % dec^-^1'], [num2str(slopeper2),' % dec^-^1'], [num2str(slopeper3),' % dec^-^1'], 'orientation', 'horizontal')
legend('Record length average', 'Hybrid approach',...
    [num2str(slopeper2),' % dec^-^1'], [num2str(slopeper3),' % dec^-^1'], 'orientation', 'horizontal', 'location', 'north')


xtickangle(27)
grid on
title(['Sector ',sector,' Mean Sea Ice Thickness']);
ylabel('SIT [m]');


print(['ICE/ICETHICKNESS/Figures/Diagnostic/Compare_methods/sector',sector,'reclenavVShybrid2.png'], '-dpng', '-r400');


%% Spatial comparison (temporal average)

diff1 = nanmean(nSIT.H,2) - nanmean(rlSIT.H,2);


[londom, latdom] = sectordomain(str2num(sector));
dots = sectordotsize(str2num(sector));

m_basemap('a', londom, latdom)
sectorexpand(str2num(sector));
m_scatter(oSIT.lon, oSIT.lat, dots, diff1, 's','filled')

colorbar
cmocean('balance')
caxis([-0.2,0.2])























