% Jacob Arnold

% 29-Sep-2021

% Load in the EnviSat SIT data
% Load in the CryoSat SIT data
% Evaluate overlap months
% Combine into continuous dataset


% Run 1, 4 to view linear trend differences between the datasets where open
% water is not incorporated (no zero-for-open-water correction).
% Run 1, 3 to view the average trends during overlap time without
% zero-for-open-water correction.
% Run 1,2,3,4 to view all where non-permanent nans have been filled with
% zeros (open water within the max ice extent).



%% 1. 
load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/EnviSat_SIT.mat;

load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_CryoSat_2/CryoSat2_SIT.mat;

tdn = [esSIT.dn(1:end-17); csSIT.dn];
tH = [esSIT.SIT(:,1:end-17), csSIT.SIT];
es_csSIT.H = tH;
es_csSIT.dn = tdn;
es_csSIT.lon = csSIT.lon; 
es_csSIT.lat = csSIT.lat;
es_csSIT.dv = datevec(es_csSIT.dn);

%% 2. SKIP THIS TO view trends where THERE IS ICE. This step fills in all the open water zeros

% Fill appropriate zeros! (open water but not land)
figure;plot(es_csSIT.dn,sum(isnan(es_csSIT.H))./length(es_csSIT.H(:,1))); set(gcf, 'position', [500,600,1000,300]);
datetick('x', 'mm-yyyy'); xtickangle(25);
title('% of EnviSat-CryoSat SIT dataset NaN Originally'); 
% first find indices that are always NaN
test = nanmean(es_csSIT.H, 2);
sum(isnan(test))
test2 = find(isnan(test));
m_basemap('p', [0,360], [-90,-40]);
m_scatter(es_csSIT.lon(test2), es_csSIT.lat(test2), 2, 'filled');
% BEAutiful! All those points need to be nan, all other nan locations need
% to be 0.
notNan = find(~isnan(test));
m_basemap('p', [0,360], [-90,-40]);
m_scatter(es_csSIT.lon(notNan), es_csSIT.lat(notNan), 2, 'filled');

tempH = es_csSIT.H;
tempH2 = esSIT.SIT;
tempH3 = csSIT.SIT;

subsetH = tempH(notNan,:);
subsetH2 = tempH2(notNan,:);
subsetH3 = tempH3(notNan,:);

subsetH(isnan(subsetH)) = 0;
subsetH2(isnan(subsetH2)) = 0;
subsetH3(isnan(subsetH3)) = 0;

tempH(notNan,:) = subsetH;
tempH2(notNan,:) = subsetH2;
tempH3(notNan,:) = subsetH3;

es_csSIT.H = tempH;
esSIT.SIT = tempH2;
csSIT.SIT = tempH3;

figure;plot(es_csSIT.dn,sum(isnan(tempH))./length(es_csSIT.H(:,1))); set(gcf, 'position', [500,600,1000,300]);
datetick('x', 'mm-yyyy'); xtickangle(25);
title('% of EnviSat-CryoSat SIT dataset NaN After Correction'); 


%% 3. 
%overlap = find(esSIT.dn == csSIT.dn(1));

% The last 17 of esSIT overlap with the first 17 of csSIT



figure;
set(gcf, 'position', [500,600,1000,400]);
plot(csSIT.dn(1:17),nanmean(esSIT.SIT(:,end-16:end)), 'color', [1, 0.7, 1], 'linewidth', 1.1);
hold on
plot(csSIT.dn(1:17),nanmean(csSIT.SIT(:,1:17)), 'color', [0.7, 1, 1], 'linewidth', 1.1);

datetick('x', 'mm-yyyy');
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);

grid on
ax = gca;
ax.GridColor = [1,1,1];
legend('\color{white} EnviSat SIT', '\color{white} CryoSat SIT','location', 'northwest');
title('SIT from CryoSat and EnviSat During Overlap Months')
ylabel('SIT [m]');
set(gcf, 'InvertHardcopy', 'off')
%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/OverlapSIT_water=nan.png', '-dpng', '-r500');
%------------------------------------------------------------------------------------------------------------
figure;
set(gcf, 'position', [500,600,1000,400]);
plot(csSIT.dn(1:17),sum(esSIT.SIT(:,end-16:end)==0), 'color', [1, 0.7, .7], 'linewidth', 1.1);
hold on
plot(csSIT.dn(1:17),sum(csSIT.SIT(:,1:17)==0), 'color', [0.7, 1, .7], 'linewidth', 1.1);
datetick('x', 'mm-yyyy');
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);

grid on
ax = gca;
ax.GridColor = [1,1,1];
legend('\color{white} EnviSat SIT', '\color{white} CryoSat SIT','location', 'northwest');
title('CryoSat and EnviSat SIT Overlap # of zeros')
ylabel('Number of zeros');
set(gcf, 'InvertHardcopy', 'off')
%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/OverlapNumzeros.png', '-dpng', '-r500');

% Pretty similar


%% 4. Plot full timeseries of averages



Amean = nanmean(es_csSIT.H);
ESmean = nanmean(esSIT.SIT(:,1:end-17));
CSmean = nanmean(csSIT.SIT);

figure;
set(gcf, 'position', [500,600,1000,350]);
plot(es_csSIT.dn, nanmean(es_csSIT.H), 'color', [1,1,0.6])
hold on
datetick('x', 'mm-yyyy');
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);
grid on
title('Merged EnviSat and CryoSat SIT and Trends')
ylabel('Sea Ice Thickness [m]');
ax = gca;
ax.GridColor = [1,1,1];
 % Get coefficients of a line fit through the data. coefficients(1) = slope
 % and coefficients(2) = intercept
coefficients = polyfit(es_csSIT.dn, Amean.', 1);
YFit = coefficients(1)*es_csSIT.dn+coefficients(2);

plot(es_csSIT.dn, YFit, '--', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.

totalSlope = YFit(end)-YFit(1);
monthSlope = totalSlope/length(es_csSIT.dn);
yearSlope = monthSlope*12;
decadeSlope = yearSlope*10;

legend('\color{white} Hemispheric Mean SIT', ['\color{white} Slope = ',num2str(decadeSlope),'/decade']); 
set(gcf, 'InvertHardcopy', 'off')
%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/joined_avSIT_water=nan.png', '-dpng', '-r500');


%---------------------------------------------------------------
% Make figure with best fit lines for EnviSat and CryoSat separately
figure;
set(gcf, 'position', [500,600,1000,350]);
plot(esSIT.dn(1:end-17), ESmean, 'color', [1,0.7,1])
hold on
plot(csSIT.dn, CSmean, 'color', [0.7,1,1])
datetick('x', 'mm-yyyy');
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);
grid on
title('EnviSat and CryoSat SIT and Trends')
ylabel('Sea Ice Thickness [m]');
ax = gca;
ax.GridColor = [1,1,1];
 % Get coefficients of a line fit through the data. coefficients(1) = slope
 % and coefficients(2) = intercept
coefficients1 = polyfit(esSIT.dn(1:end-17), ESmean.', 1);
coefficients2 = polyfit(csSIT.dn, CSmean.', 1);

YFit1 = coefficients1(1)*esSIT.dn(1:end-17)+coefficients1(2);
YFit2 = coefficients2(1)*csSIT.dn+coefficients2(2);

plot(esSIT.dn(1:end-17), YFit1, '--', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.
plot(csSIT.dn, YFit2, '--', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.


totalSlope1 = YFit1(end)-YFit1(1);
totalSlope2 = YFit2(end)-YFit2(1);
monthSlope1 = totalSlope1/length(esSIT.dn(1:end-17));
monthSlope2 = totalSlope2/length(csSIT.dn);
yearSlope1 = monthSlope1*12;
yearSlope2 = monthSlope2*12;
decadeSlope1 = yearSlope1*10;
decadeSlope2 = yearSlope2*10;

legend('\color{white} EnviSat SIT', '\color{white} CryoSat SIT',...
    ['\color{white} Slope = ',num2str(decadeSlope1),'/decade'],...
    ['\color{white} Slope = ',num2str(decadeSlope2),'/decade']); 
set(gcf, 'InvertHardcopy', 'off')
%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/separate_avSIT_water=nan.png', '-dpng', '-r500');



%% Scatter overlap
corrVals = corrcoef(nanmean(esSIT.SIT(:,end-16:end)), nanmean(csSIT.SIT(:,1:17)), 'rows', 'complete');
figure;scatter(nanmean(esSIT.SIT(:,end-16:end)), nanmean(csSIT.SIT(:,1:17)), 60,'filled')
hold on
ylim([0,2.1]);xlim([0,2.1]);
grid on ;grid minor
title(['EnviSat CryoSat Hemispheric Averages for Overlapping Months'])
text(0.08, 1.85, ['r = ', num2str(corrVals(2,1))], 'fontsize', 16);
xlabel('EnviSat SIT [m]');
ylabel('CryoSat SIT [m]')
box on
tempx = [0:0.1:3];
coef = polyfit(nanmean(esSIT.SIT(:,end-16:end)), nanmean(csSIT.SIT(:,1:17)), 1);
YFit = coef(1)*tempx+coef(2);
fit = plot(tempx, YFit, '--m', 'linewidth', 1.1);
legend([fit], ['Slope = ',num2str(coef(1))], 'location', 'northwest','fontsize', 14);

%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/overlap_correlation.png', '-dpng', '-r500');



%% Find yearly SIT peaks and plot



yrs = unique(es_csSIT.dv(:,1));



yrMax = nan(size(yrs));
yrMin = yrMax;
meanSIT = nanmean(es_csSIT.H);

for ii = 1:length(yrs)
    yrLoc = find(es_csSIT.dv(:,1) == yrs(ii));
    maxVal = max(meanSIT(yrLoc));
    minVal = min(meanSIT(yrLoc));
    
    maxLoc(ii) = yrLoc(find(meanSIT(yrLoc)==maxVal));
    minLoc(ii) = yrLoc(find(meanSIT(yrLoc)==minVal));
    
    yrMax(ii) = maxVal;
    yrMin(ii) = minVal;
end
    
% remove first year (only summer)
yrMax(1) = [];
%yrMin(1) = [];
maxLoc(1) = [];


maxDn = es_csSIT.dn(maxLoc);
minDn = es_csSIT.dn(minLoc);

%% Plot max and all

figure;
set(gcf, 'position', [500,600,1000,400]);
plot(es_csSIT.dn, nanmean(es_csSIT.H),  'color', [1,1,0.6], 'linewidth', 1);
hold on
plot(maxDn, yrMax, 'color', [1,0.7,1], 'linewidth', 1)
plot(minDn, yrMin, 'color', [0.7,0.9, 1], 'linewidth', 1);
datetick('x', 'mm-yyyy')
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);
grid on
title('EnviSat and CryoSat SIT and Trends')
ylabel('Sea Ice Thickness [m]');
ax = gca;
ax.GridColor = [1,1,1];

 % Get coefficients of a line fit through the data. coefficients(1) = slope
 % and coefficients(2) = intercept
coefficients1 = polyfit(es_csSIT.dn, nanmean(es_csSIT.H).', 1);
coefficients2 = polyfit(maxDn.', yrMax.', 1);
coefficients3 = polyfit(minDn.', yrMin.', 1);

YFit1 = coefficients1(1)*es_csSIT.dn+coefficients1(2);
YFit2 = coefficients2(1)*maxDn+coefficients2(2);
YFit3 = coefficients3(1)*minDn+coefficients3(2);


plot(es_csSIT.dn, YFit1, '--', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.
plot(maxDn, YFit2, '-.', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.
plot(minDn, YFit3, ':', 'color', [1,1,1],'LineWidth', 1); % Plot fitted line.


totalSlope1 = YFit1(end)-YFit1(1);
totalSlope2 = YFit2(end)-YFit2(1);
totalSlope3 = YFit3(end)-YFit3(1);

monthSlope1 = totalSlope1/length(es_csSIT.dn);
%monthSlope2 = totalSlope2/length(maxDn);
yearSlope1 = monthSlope1*12;
yearSlope2 = totalSlope2/length(maxDn);
yearSlope3 = totalSlope3/length(minDn);
decadeSlope1 = yearSlope1*10;
decadeSlope2 = yearSlope2*10;
decadeSlope3 = yearSlope3*10;

legend('\color{white} EnviSat SIT', '\color{white} Yearly Max','\color{white} Yearly Min',...
    ['\color{white} Slope = ',num2str(decadeSlope1),'/decade'],...
    ['\color{white} Slope = ',num2str(decadeSlope2),'/decade'],...
    ['\color{white} Slope = ',num2str(decadeSlope3),'/decade'],'location', 'northwest', 'orientation', 'horizontal'); 
set(gcf, 'InvertHardcopy', 'off')


%print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/yr_max_min.png', '-dpng', '-r500');


% Just maxes
figure;
set(gcf, 'position', [500,600,1000,400]);

plot(maxDn, yrMax, 'color', [1,0.7,1], 'linewidth', 1)
datetick('x', 'mm-yyyy')
xtickangle(25)
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);
grid on
title('EnviSat and CryoSat SIT and Trends')
ylabel('Sea Ice Thickness [m]');
ax = gca;
ax.GridColor = [1,1,1];
% print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/yr_max.png', '-dpng', '-r500');






















