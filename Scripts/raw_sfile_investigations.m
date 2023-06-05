% Jacob Arnold

% 18-Feb-2022

% Investigate occurrences of 99s in Cn and Sn from ice charts


load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector00_all.mat;

%%

% 99 amounts in % of grid area
sa99 = (sum(SIT.sa==99)./length(SIT.lon)).*100;
sb99 = (sum(SIT.sb==99)./length(SIT.lon)).*100;
sc99 = (sum(SIT.sc==99)./length(SIT.lon)).*100;
sd99 = (sum(SIT.sd==99)./length(SIT.lon)).*100;
ca99 = (sum(SIT.ca==99)./length(SIT.lon)).*100;
cb99 = (sum(SIT.cb==99)./length(SIT.lon)).*100;
cc99 = (sum(SIT.cc==99)./length(SIT.lon)).*100;
cd99 = (sum(SIT.cd==99)./length(SIT.lon)).*100;
ct99 = (sum(SIT.ct==99)./length(SIT.lon)).*100;

sanan = (sum(isnan(SIT.sa))./length(SIT.lon)).*100;
sbnan = (sum(isnan(SIT.sb))./length(SIT.lon)).*100;
scnan = (sum(isnan(SIT.sc))./length(SIT.lon)).*100;
sdnan = (sum(isnan(SIT.sd))./length(SIT.lon)).*100;
canan = (sum(isnan(SIT.ca))./length(SIT.lon)).*100;
cbnan = (sum(isnan(SIT.cb))./length(SIT.lon)).*100;
ccnan = (sum(isnan(SIT.cc))./length(SIT.lon)).*100;
ctnan = (sum(isnan(SIT.ct))./length(SIT.lon)).*100;

%% plots

ticker = dnticker(1997,2022);
figure;
plot_dim(1200,800);
subplot(2,1,1)
plot(SIT.dn,sa99, 'linewidth', 1.2);
hold on
plot(SIT.dn,sb99, 'linewidth', 1.2)
plot(SIT.dn, sc99, 'linewidth', 1.2)
plot(SIT.dn,sd99, 'linewidth', 1.2);
title('Sector 00 Stage of Development 99s')
ylabel('Amount of grid with 99 [%]')
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on
legend('SA', 'SB', 'SC', 'SD');

subplot(2,1,2)
plot(SIT.dn, ca99, 'linewidth', 1.2)
hold on
plot(SIT.dn, cb99, 'linewidth', 1.2);
plot(SIT.dn, cc99, 'linewidth', 1.2);
plot(SIT.dn, ct99, 'linewidth', 1.2, 'color','m');
title('Sector 00 Partial Concentration 99s')
legend('CA', 'CB', 'CC', 'CT')
ylabel('Amount of grid with 99 [%]')
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on

%print('ICE/ICETHICKNESS/Figures/Shapefiles/raw/sec00_99s.png', '-dpng', '-r500');
%% plots 2

ticker = dnticker(1997,2022);
figure;
plot_dim(1200,800);
subplot(2,1,1)
plot(SIT.dn,sanan, 'linewidth', 1.2);
hold on
plot(SIT.dn,sbnan, 'linewidth', 1.2)
plot(SIT.dn, scnan, 'linewidth', 1.2)
plot(SIT.dn,sdnan, 'linewidth', 1.2);
title('Sector 00 Stage of Development nans')
ylabel('Amount of grid with 99 [%]')
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on
legend('SA', 'SB', 'SC', 'SD');

subplot(2,1,2)
plot(SIT.dn, canan, 'linewidth', 1.2)
hold on
plot(SIT.dn, cbnan, 'linewidth', 1.2);
plot(SIT.dn, ccnan, 'linewidth', 1.2);
plot(SIT.dn, ctnan, 'linewidth', 1.2, 'color','m');
title('Sector 00 Partial Concentration nans')
legend('CA', 'CB', 'CC', 'CT')
ylabel('Amount of grid with 99 [%]')
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on

%print('ICE/ICETHICKNESS/Figures/Shapefiles/raw/sec00_nans.png', '-dpng', '-r500');

%% How about -9s? 





%% check out moving averaged values 

% sector 17

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector17_0.mat

%%

figure;
plot_dim(1200,800)
subplot(2,1,1)
plot(SIT.dn, nanmean(SIT.mavg.SA(1:929)), 'linewidth', 1.2);
hold on
plot(SIT.dn, nanmean(SIT.mavg.SB(1:929)), 'linewidth', 1.2);
plot(SIT.dn, nanmean(SIT.mavg.SC(1:929)), 'linewidth', 1.2);
plot(SIT.dn, nanmean(SIT.mavg.SD(1:929)), 'linewidth', 1.2)
legend('SA', 'SB', 'SC', 'SD');
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on
title('Sector 00 neighboring year moving-average means')

subplot(2,1,2)
plot(SIT.dn, nanmean(SIT.mavg.CA), 'linewidth', 1.2)
hold on
plot(SIT.dn, nanmean(SIT.mavg.CB), 'linewidth', 1.2);
plot(SIT.dn, nanmean(SIT.mavg.CC), 'linewidth', 1.2);
plot(SIT.dn, nanmean(SIT.mavg.CD), 'linewidth', 1.2);
plot(SIT.dn, nanmean(SIT.mavg.CT),'color','m', 'linewidth', 1.2);
legend('CA', 'CB', 'CC', 'CD', 'CT')
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(27);
grid on
title('Sector 00 neighboring year moving-average means')






























