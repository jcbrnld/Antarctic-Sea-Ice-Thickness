% Jacob Arnold

% 16-Feb-2022

% Investigate the drops in SIV (and mean SIT) in all regions during October

load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat

%%


figure;plot(seaice.dn, seaice.SIV, 'm','linewidth', 1.2)
ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(seaice.dv(:,2)==10);
for ii = 1:length(novloc)
xline(seaice.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.5]);
end
title('Sea Ice Volume');
ylabel('SIV [km^3]');



%%

figure;plot(seaice.dn, seaice.SIA, 'color',[0.2,0.8,0.6],'linewidth', 1.2)
ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(seaice.dv(:,2)==10);
for ii = 1:length(novloc)
xline(seaice.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.7], 'linewidth', 0.2);
end
title('Sea Ice Area')
ylabel('SIA [km^2]')


%% now load in full file and try to trace back to partials

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat;

%% the SODs


figure;
plot_dim(1400,300);
p1 = plot(SIT.dn, nanmean(SIT.sa), 'color',[0.2,0.8,0.6],'linewidth', 1.2)
hold on
p2 = plot(SIT.dn, nanmean(SIT.sb), 'color', [0.2,0.6,0.85], 'linewidth', 1.2);
p3 = plot(SIT.dn, nanmean(SIT.sc), 'color', [0.7,0.6,0.2], 'linewidth', 1.2);
p4 = plot(SIT.dn, nanmean(SIT.sd), 'color', [0.8,0.1,0.4], 'linewidth', 1.2);

ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(SIT.dv(:,2)==10);
for ii = 1:length(novloc)
xline(SIT.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.2], 'linewidth', 0.8);
end
title('Translated Mean Stages of Development')
ylabel('[cm]')

legend([p1,p2,p3,p4], 'SA', 'SB', 'SC', 'SD');



%% the SICs
% It looks like the dip appears here - analyze further

figure;
plot_dim(1400,300);
p1 = plot(SIT.dn, nanmean(SIT.ca), 'color',[0.2,0.8,0.6],'linewidth', 1.2)
hold on
p2 = plot(SIT.dn, nanmean(SIT.cb), 'color', [0.2,0.6,0.85], 'linewidth', 1.2);
p3 = plot(SIT.dn, nanmean(SIT.cc), 'color', [0.7,0.6,0.2], 'linewidth', 1.2);
p4 = plot(SIT.dn, nanmean(SIT.cd), 'color', [0.8,0.1,0.4], 'linewidth', 1.2);

ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(SIT.dv(:,2)==10);
for ii = 1:length(novloc)
xline(SIT.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.2], 'linewidth', 0.8);
end
title('Translated Mean Partial Concentrations')
ylabel('[%]')

legend([p1,p2,p3,p4], 'CA', 'CB', 'CC', 'CD');



%% Check on non-interpolated data

% No sector00 available
load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector17.mat

%%

figure;
plot_dim(1400,300);
p1 = plot(SIT.dn, nanmean(SIT.ca), 'color',[0.2,0.8,0.6],'linewidth', 1.2)
hold on
p2 = plot(SIT.dn, nanmean(SIT.cb), 'color', [0.2,0.6,0.85], 'linewidth', 1.2);
p3 = plot(SIT.dn, nanmean(SIT.cc), 'color', [0.7,0.6,0.2], 'linewidth', 1.2);
p4 = plot(SIT.dn, nanmean(SIT.cd), 'color', [0.8,0.1,0.4], 'linewidth', 1.2);

ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(seaice.dv(:,2)==10);
for ii = 1:length(novloc)
xline(seaice.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.2], 'linewidth', 0.8);
end
title('Translated Mean Partial Concentrations')
ylabel('[%]')

legend([p1,p2,p3,p4], 'CA', 'CB', 'CC', 'CD');



%%
figure;
plot_dim(1400,300);
p0 = plot(SIT.dn, nanmean(SIT.ct_hires), 'color', [0.7,0.7,0.7], 'linewidth', 2);
hold on
p1 = plot(SIT.dn, nanmean(SIT.ca_hires), 'color',[0.2,0.8,0.6],'linewidth', 1.2)
p2 = plot(SIT.dn, nanmean(SIT.cb_hires), 'color', [0.2,0.6,0.85], 'linewidth', 1.2);
p3 = plot(SIT.dn, nanmean(SIT.cc_hires), 'color', [0.7,0.6,0.2], 'linewidth', 1.2);
p4 = plot(SIT.dn, nanmean(SIT.cd_hires), 'color', [0.8,0.1,0.4], 'linewidth', 1.2);

ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(seaice.dv(:,2)==10);
for ii = 1:length(novloc)
xline(seaice.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.2], 'linewidth', 0.8);
end
title('Translated Mean Partial Concentrations')
ylabel('[%]')

legend([p0,p1,p2,p3,p4],'SIC', 'CA', 'CB', 'CC', 'CD');


%% Compare sic and siv directly

figure
plot_dim(1700,300)
p1 = plot(SIT.dn, SIT.SIV, 'color', [.6, .2, .2], 'linewidth', 2)
hold on
p2 = plot(SIT.dn, nanmean(SIT.ct_hires), 'color', [0.7,0.7,0.7], 'linewidth', 2);
p3 = plot(SIT.dn, nanmean(SIT.ct), 'color', [0.2,0.7,0.7], 'linewidth', 2);

ticker = dnticker(1997,2022,1,1);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');xtickangle(17)
xtickangle(27)
grid on
novloc = find(seaice.dv(:,2)==10);
for ii = 1:length(novloc)
xline(seaice.dn(novloc(ii)),'color', [0.4,0.4,0.6,0.2], 'linewidth', 0.8);
end
title('Sector 17 SIV, SIC, and CT comparison')
legend([p1,p2,p3], 'SIV [km^3]', 'SIC [%]', 'CT [%]');


print('ICE/ICETHICKNESS/Figures/Diagnostic/winterDip/s17_SIVvsSICvsCT.png', '-dpng', '-r700');





