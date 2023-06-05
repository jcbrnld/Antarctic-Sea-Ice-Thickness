
% Jacob Arnold

% 25-oct-2021

% Compare ENSO indices


% First NOAA ENSO Index




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


%% Next Darwin SLP Anomalies Index 

data2 = load('ICE/ENSO/Data/darwin.anom_.txt');
years2 = data2(:,1);
data2(:,1)=[];
data2(155,:) = [];
data2 = data2.';
years2(end) = [];

ENSO2 = data2(:);


st = 1; en = 12
for ii = 1:length(years2)
    ENSO2dv(st:en,1) = years2(ii);
    ENSO2dv(st:en,2) = [1:12];
    st = st+12; en = en+12;
    
end

ENSO2dv(:,3) = 15;

ENSO2dn = datenum(ENSO2dv);


figure;
set(gcf, 'position', [300,300,1200,500]);
plot(ENSO2dn,ENSO2)
hold on
plot(ENSOdn, ENSO)
datetick('x', 'mm-yyyy');
grid on
yline(0,'--')
xtickangle(15)
title('NOAA ENSO Index')


% Create new ENSO2 matching SIT temporal domain

ind1 = find(ENSO2dn > SIT.dn(1));
ind1 = ind1(1)-1;
ind2 = find(ENSO2dn < SIT.dn(end));
ind2 = ind2(end);

shortENSO2 = ENSO2(ind1:ind2);
shortdn2 = ENSO2dn(ind1:ind2);

%% Compare ENSO and Darwin over SIT period

figure;
plot(shortdn, shortENSO);
hold on
plot(shortdn2, shortENSO2);

% Try movmean of Darwin
shortENSO2_2 = movmean(shortENSO2,3);


figure;
plot(shortdn, shortENSO);
hold on
plot(shortdn2, shortENSO2_2);
grid on
datetick('x', 'mm-yyyy');
xtickangle(20)
title('NOAA ENSO and Darwin SLP Anomaly')
legend('ENSO', 'Darwin')











