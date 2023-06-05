% Jacob Arnold

% 23-Oct-2021

% View NOAA_ENSO dataset and compare with SIT
% Data from: https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php


data = textread('ICE/ENSO/Data/NOAA_ENSO.txt');

years = data(:,1);
data(:,1) = [];
data(72,9:12) = nan;
data = data.';

ENSO = data(:);

st = 1; en = 12
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

figure;
set(gcf, 'position', [300,300,1200,500]);
plot(ENSOdn,ENSO)
datetick('x', 'mm-yyyy');
grid on
yline(0,'--')
xtickangle(15)
title('NOAA ENSO Index')


%%
% Load in SIT

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


figure
set(gcf, 'position', [300,300,1200,500]);
plot(shortdn, shortENSO)
datetick('x', 'mm-yyyy')
yline(0, '--', 'color', [0.2,.2,.2], 'linewidth', 1);
yyaxis right
plot(SIT.dn, avH)
grid on
title('ENSO Index (blue), SIT (orange)');


%% Plot year moving average ENSO vs SIT


ENSOav = movmean(shortENSO,12);
SITav = movmean(avH, 52);


figure
set(gcf, 'position', [300,300,1200,500]);
plot(shortdn, ENSOav)
set(gca, 'YDir','reverse')
datetick('x', 'mm-yyyy')
yline(0, '--', 'color', [0.2,.2,.2], 'linewidth', 1);
yyaxis right
plot(SIT.dn, SITav)
grid on
title('ENSO Index (blue), SIT (orange)');

%% Subplot with winter and summer markings

shortdv = datevec(shortdn);

wintind = find(SIT.dv(:,2) == 6 | SIT.dv(:,2) == 7 | SIT.dv(:,2) == 8);
%sumind = find(SIT.dv(:,2) == 12 | SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);
sumind = find(SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);

meanSIT = nanmean(SIT.H, 'all');
meanW = nanmean(SIT.H(:,wintind), 'all');
meanS = nanmean(SIT.H(:,sumind), 'all');


figure
set(gcf, 'position', [300,300,1200,700]);
subplot(3,1,1:2)
scatter(SIT.dn(wintind), avH(wintind), 'filled');
hold on
scatter(SIT.dn(sumind), avH(sumind), 'filled');
plot(SIT.dn, avH, 'color', [0.6,0.6,0.6], 'linewidth', 1);
plot(SIT.dn, SITav, '--m', 'linewidth', 1.1)
%yline(meanSIT, '--', 'color', [0.2, 0.2, 0.1]);
%yline(meanW, '--');
%yline(meanS, '--');
datetick('x', 'mm-yyyy');
xtickangle(15)
grid on; box on;
legend('Winter SIT', 'Summer SIT', 'ALL SIT', '1 Year Moving Mean SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');
ylim([0.2, 1.85]);


subplot(3,1,3)
plot(shortdn, shortENSO,  'linewidth', 1, 'color',[0.6,0.6,0.6], 'linewidth', .2)
hold on
plot(shortdn, ENSOav,  'linewidth', 1, 'color',[0.2,0.8,0.5], 'linewidth', 1.5)
datetick('x', 'mm-yyyy');
yline(0, '--r');
xtickangle(15)
grid on
title('NOAA ENSO Index')
ylabel('ENSO')
ylim([-2,3]);
legend('Monthly Index', '12 Month Moving Mean')

%% Compare just the year averages


figure
set(gcf, 'position', [300,300,1200,500]);
subplot(2,1,1)
plot(SIT.dn, SITav, 'm', 'linewidth', 1.5)
yline(meanSIT, '--r')
datetick('x', 'mm-yyyy');
xtickangle(15)
grid on; box on;
legend('Year Moving Average SIT', 'Mean SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');
ylim([0.6, 1.3]);


subplot(2,1,2)
plot(shortdn, ENSOav,  'linewidth', 1, 'color',[0.2,0.8,0.5], 'linewidth', 1.5)
datetick('x', 'mm-yyyy');
yline(0, '--r');
xtickangle(15)
grid on
title('NOAA ENSO Index')
ylabel('ENSO')
ylim([-2,3]);











%% Interpolate SIT in time to match ENSO index


I_SIT = interp1(SIT.dn, avH, shortdn);
I_SIT2 = interp1(SIT.dn, SITav, shortdn);

figure
plot(shortdn, I_SIT, '-*')
hold on
plot(SIT.dn, avH, '-o');
datetick('x', 'mm-yyyy');
legend('Temporally Interp SIT', 'Orignial SIT');
xtickangle(20);

% Now they are the same length, correlate. 

corMat = corrcoef(I_SIT(2:280), shortENSO(2:280)) % r = -0.0581
corMat2 = corrcoef(I_SIT2(2:280), ENSOav(2:280))  % r = -0.1833 
% Year averaged shows a larger correlation between La Nina and SIT

figure
scatter(I_SIT2(2:280), ENSOav(2:280))















% --------------------------------------------------------------------------------------------------------------



%% Still Darwin 2

% Need to shortin ENSO2 and compare with ENSO and SIT




%% View another nino index
% https://climatedataguide.ucar.edu/climate-data/nino-sst-indices-nino-12-3-34-4-oni-and-tni
% Trenberth, Kevin & National Center for Atmospheric Research Staff (Eds). Last modified 21 Jan 2020. "The Climate Data Guide: Nino SST Indices (Nino 1+2, 3, 3.4, 4; ONI and TNI)." Retrieved from https://climatedataguide.ucar.edu/climate-data/nino-sst-indices-nino-12-3-34-4-oni-and-tni.

% Load in data, shorten to SIT temporal domain, 
% Compare with ENSO and ENSO2, Compare with SIT













