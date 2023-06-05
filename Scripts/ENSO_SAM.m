% Jacob Arnold
% 28-Oct-2021

% Compare both ENSO and SAM with SIT dataset




data = textread('ICE/ENSO/Data/NOAA_ENSO.txt');

years = data(:,1);
data(:,1) = [];
data(72,9:12) = nan;
data = data.';

ENSO = data(:);

st = 1; en = 12;
for ii = 1:length(years)-1
    ENSOdv(st:en,1) = years(ii);
    ENSOdv(st:en,2) = [1:12];
    st = st+12; en = en+12;
    
end
ENSOdv(length(ENSOdv)+1:length(ENSOdv)+8,1) = 2021;
ENSOdv(length(ENSOdv)-7:length(ENSOdv),2) = [1:8];
ENSOdv(:,3) = 15;

ENSO(length(ENSO)-3:length(ENSO)) = [];

ENSOdn = datenum(ENSOdv);



%%% Load in SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat
% PROBLEM with two same SIT dns 
% For now average the values of the two
% Days 305 and 306

SIT.dn(306) = [];
SIT.dv(306,:) = [];
repdays = [SIT.H(:,305), SIT.H(:,306)];
avcol = nanmean(repdays, 2);
SIT.H(:,305) = avcol;
SIT.H(:,306) = [];

avH = nanmean(SIT.H);

% Create new ENSO matching SIT temporal domain

ind1 = find(ENSOdn > SIT.dn(1));
ind1 = ind1(1)-1;
ind2 = find(ENSOdn < SIT.dn(end));
ind2 = ind2(end)+1;

shortENSO = ENSO(ind1:ind2);
shortdn = ENSOdn(ind1:ind2);


%%% Plot year moving average ENSO vs SIT


ENSOav = movmean(shortENSO,12);
SITav = movmean(avH, 52);

%% load in SAM
SAM = textread('ICE/SAM/Data/newsam.1957.2007.txt','', 'headerlines', 2);


years2 = SAM(:,1);
SAM(:,1) = [];
SAM = SAM.';
SAM(10:12,65) = nan;

samvec = SAM(:);
samvec(length(samvec)-2:length(samvec)) = [];


st = 1; en = 12
for ii = 1:length(years2)-1
    SAMdv(st:en,1) = years2(ii);
    SAMdv(st:en,2) = [1:12];
    st = st+12; en = en+12;
    
end
SAMdv(length(SAMdv)+1:length(SAMdv)+9,1) = 2021;
SAMdv(length(SAMdv)-8:length(SAMdv),2) = [1:9];
SAMdv(:,3) = 15;

SAMdn = datenum(SAMdv);
% ~~~
% Create new sam matching SIT temporal domain
ind1 = find(SAMdn > SIT.dn(1));
ind1 = ind1(1)-1;
ind2 = find(SAMdn < SIT.dn(end));
ind2 = ind2(end)+1;

shortSAM = samvec(ind1:ind2);
shortdn2 = SAMdn(ind1:ind2);


% 12 month moving average 
avShortSAM = movmean(shortSAM, 12);





%% Subplot with winter and summer markings

shortdv = datevec(shortdn);

wintind = find(SIT.dv(:,2) == 6 | SIT.dv(:,2) == 7 | SIT.dv(:,2) == 8);
%sumind = find(SIT.dv(:,2) == 12 | SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);
sumind = find(SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);

meanSIT = nanmean(SIT.H, 'all');
meanW = nanmean(SIT.H(:,wintind), 'all');
meanS = nanmean(SIT.H(:,sumind), 'all');
%%
clear sampdv sampdn
sampdv(:,1) = [1997:2022];
sampdv(:,2:3) = 1;
sampdn = datenum(sampdv);


figure
set(gcf, 'position', [300,300,1200,700]);
subplot(3,1,1:2)
scatter(SIT.dn(wintind), avH(wintind), 'filled');
hold on
scatter(SIT.dn(sumind), avH(sumind), 'filled');
plot(SIT.dn, avH, 'color', [0.6,0.6,0.6], 'linewidth', 1);
plot(SIT.dn, SITav, '--m', 'linewidth', 1.3)
%yline(meanSIT, '--', 'color', [0.2, 0.2, 0.1]);
%yline(meanW, '--');
%yline(meanS, '--');
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(15)
grid on; box on;
legend('Winter SIT', 'Summer SIT', 'ALL SIT', '1 Year Moving Mean SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');
ylim([0.2, 1.85]);
xlim([729650, 738238]);


subplot(3,1,3)
plot(shortdn, ENSOav, 'color',[0.2,0.9,0.6], 'linewidth', 1.5) % Year-averaged ENSO
hold on
%plot(shortdn, shortENSO, 'color',[0.8,0.8,0.8], 'linewidth', 1) % Original (monthly) ENSO
plot(shortdn2, avShortSAM, 'color',[0.2,0.55,0.9], 'linewidth', 1.5); % Year-averaged SAM
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
yline(0, '--r');
xtickangle(15)
grid on
title('ENSO and SAM Indices Year Moving Average')
ylabel('ENSO, SAM')
ylim([-2,3]);
legend('ENSO', 'SAM')
xlim([729650, 738238]);


%print('ICE/ENSO/Figures/ENSO_SAM_SIT.png', '-dpng', '-r700');





%% Just year moving averages

figure
set(gcf, 'position', [300,300,1200,500]);
subplot(2,1,1)
plot(SIT.dn, SITav, 'm', 'linewidth', 1.5)
yline(meanSIT, '--', 'color', [0.4,.4,.4], 'linewidth', .7);
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(15)
grid on; box on;
legend('Year Moving Average SIT', 'Mean SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');
ylim([0.6, 1.3]);
xlim([729650, 738238]);



subplot(2,1,2)
plot(shortdn, ENSOav,  'linewidth', 1, 'color',[0.2,0.9,0.6], 'linewidth', 1.5) % Year-averaged ENSO
hold on
plot(shortdn2, avShortSAM, 'color',[0.2,0.55,0.9], 'linewidth', 1.5); % Year-averaged SAM
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
yline(0, '--r', 'linewidth', .6);
xtickangle(15)
grid on
title('ENSO and SAM Indices')
ylabel('ENSO')
legend('ENSO', 'SAM');
ylim([-2,3]);
xlim([729650, 738238]);



%print('ICE/ENSO/Figures/ENSO_SAM_SIT_YrAv.png', '-dpng', '-r700');



%% Load in SIC and Compare


load('ICE/Concentration/ant-sectors/sector00.mat');

SICdn = sector00.dn;

low = SIT.dn(1);
high = SIT.dn(end);
lowind = find(SICdn>=low);
lowind = lowind(1);
highind = find(SICdn<=high);
highind = highind(end);

shortSIC = sector00.sic(:,lowind:highind);
sicdn = SICdn(lowind:highind);

clear sector00

savSIC = nanmean(shortSIC); % Spatial average
yavSIC = movmean(savSIC, 365); % Year moving average

%% Plot with SIC


figure
set(gcf, 'position', [300,300,1200,500]);
subplot(2,1,1)
%plot(SIT.dn, SITav, 'm', 'linewidth', 1.5)
plot(sicdn, yavSIC, 'color', [0.8, 0.5, 0.7], 'linewidth', 1.5);
%yline(meanSIT, '--', 'color', [0.4,.4,.4], 'linewidth', .7);
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(15)
grid on; box on;

title('SIC');
ylabel('Sea Ice Concentration [%]');
%ylim([0.6, 1.3]);
xlim([729650, 738238]);



subplot(2,1,2)
plot(shortdn, ENSOav,  'linewidth', 1, 'color',[0.2,0.9,0.6], 'linewidth', 1.5) % Year-averaged ENSO
hold on
plot(shortdn2, avShortSAM, 'color',[0.2,0.55,0.9], 'linewidth', 1.5); % Year-averaged SAM
xticks(sampdn);
datetick('x', 'mm-yyyy', 'keepticks');
yline(0, '--r', 'linewidth', .6);
xtickangle(15)
grid on
title('ENSO and SAM Indices')
ylabel('ENSO')
legend('ENSO', 'SAM');
ylim([-2,3]);
xlim([729650, 738238]);














