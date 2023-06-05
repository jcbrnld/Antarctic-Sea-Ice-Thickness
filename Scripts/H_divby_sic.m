% Jacob Arnold

% 02-Feb-2022

% Check actual thickness of the ice not of the grid cell area by dividing
% SIT by SIC (CT hires)

sector = '01'
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

%%

IH = SIT.H./(SIT.ct_hires./100);

ticker = (1997:2022)';
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure
plot_dim(900,300);

plot(SIT.dn, nanmean(SIT.H),'color',[0.4,0.9,0.6] , 'linewidth', 1.2)
hold on
plot(SIT.dn, nanmean(IH),'color',[0.3,0.65,0.9] , 'linewidth', 1.2)
xticks(ticker);

datetick('x', 'mm-yyyy','keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(25);
grid on;
title(['Sector ',sector,' SIT of grid cell vs SIT of ice']);
ylabel('SIT [m]')
legend('SIT of cells', 'SIT of ice within cells')
% check % nan
ylim([0,2.4])
yticks(0:0.3:2.4);



%% Check out IH minus SIT.H 1. timeseries; 2. averaged across all time (spatial)

Hdif = IH-SIT.H;

% 1.
figure;
plot_dim(900,300);
plot(SIT.dn, nanmean(Hdif));
xticks(ticker);
datetick('x', 'mm-yyyy','keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(25);
grid on;

%% Try that separated by season


autuI = find(SIT.dv(:,2) == 3 | SIT.dv(:,2) == 4 | SIT.dv(:,2) == 5);
wintI = find(SIT.dv(:,2) == 6 | SIT.dv(:,2) == 7 | SIT.dv(:,2) == 8);
spriI = find(SIT.dv(:,2) == 9 | SIT.dv(:,2) == 10 | SIT.dv(:,2) == 11);
summI = find(SIT.dv(:,2) == 12 | SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);

% autumn = nanmean(SIT.H(:,autuI),2);
% winter = nanmean(SIT.H(:,wintI),2);
% spring = nanmean(SIT.H(:,spriI),2);
% summer = nanmean(SIT.H(:,summI),2);

autumn = nanmean(SIT.H(:,autuI),1);
winter = nanmean(SIT.H(:,wintI),1);
spring = nanmean(SIT.H(:,spriI),1);
summer = nanmean(SIT.H(:,summI),1);

autCT = nanmean(SIT.ct_hires(:,autuI),1);
wintCT = nanmean(SIT.ct_hires(:,wintI),1);
sprCT = nanmean(SIT.ct_hires(:,spriI),1);
sumCT = nanmean(SIT.ct_hires(:,summI),1);


autIH = autumn./(autCT./100);
wintIH = winter./(wintCT./100);
sprIH = spring./(sprCT./100);
sumIH = summer./(sumCT./100);

autdif = autIH-autumn;
wintdif = wintIH-winter;
sprdif = sprIH-spring;
sumdif = sumIH-summer;


figure;
plot_dim(900,300);
scatter(SIT.dn(autuI), autdif, 'filled');
hold on
scatter(SIT.dn(wintI), wintdif, 'filled');
scatter(SIT.dn(spriI), sprdif, 'filled');
scatter(SIT.dn(summI), sumdif, 'filled');
legend('Autumn', 'Winter', 'Spring', 'Summer')


















%%
% Compare ct_hires with SIC 
% Should match pretty closely as ct_hires is just weekly averaged SIC

%load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

% They match beautifully!!
%%
newc = find(SIC.dn>=SIT.dn(1));
sic = SIC.sic(:,newc(1):end);
dn = SIC.dn(newc(1):end);

figure;
plot_dim(900,300)
plot(SIT.dn, nanmean(SIT.ct_hires));
hold on
plot(dn, nanmean(sic));
xticks(ticker);
datetick('x', 'mm-yyyy','keepticks');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
xtickangle(25);
grid on;

