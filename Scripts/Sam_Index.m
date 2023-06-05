% Jacob Arnold
% 22-Oct-2021
% Load in SAM data and view

% SAM index from https://legacy.bas.ac.uk/met/gjma/sam.html
% The same as outlined in Marshall, G. J., 2003: Trends in the Southern Annular Mode from observations and reanalyses. J. Clim., 16, 4134-4143, doi:10.1175/1520-0442%282003%29016<4134%3ATITSAM>2.0.CO%3B2
% But updated 

SAM = textread('ICE/SAM/Data/newsam.1957.2007.txt','', 'headerlines', 2);


years = SAM(:,1);
SAM(:,1) = [];
SAM = SAM.';
SAM(10:12,65) = nan;

samvec = SAM(:);
samvec(length(samvec)-2:length(samvec)) = [];


st = 1; en = 12
for ii = 1:length(years)-1
    SAMdv(st:en,1) = years(ii);
    SAMdv(st:en,2) = [1:12];
    st = st+12; en = en+12;
    
end
SAMdv(length(SAMdv)+1:length(SAMdv)+9,1) = 2021;
SAMdv(length(SAMdv)-8:length(SAMdv),2) = [1:9];
SAMdv(:,3) = 15;

SAMdn = datenum(SAMdv);

%% Plot


figure;
set(gcf, 'position', [300,300,1200,500]);
plot(SAMdn,samvec)
datetick('x', 'mm-yyyy');
grid on
yline(0,'--')
xtickangle(15)


%% Very nice, now load SIT data and compare

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat

%%
avH = nanmean(SIT.H);

% Create new sam matching SIT temporal domain

ind1 = find(SAMdn > SIT.dn(1));
ind1 = ind1(1)-1;
ind2 = find(SAMdn < SIT.dn(end));
ind2 = ind2(end)+1;

shortSAM = samvec(ind1:ind2);
shortdn = SAMdn(ind1:ind2);


%%

figure
set(gcf, 'position', [300,300,1200,500]);
plot(shortdn, shortSAM)
datetick('x', 'mm-yyyy')
yyaxis right
plot(SIT.dn, avH)
grid on


%% 

% 12 month moving average 
avShortSAM = movmean(shortSAM, 12);

figure;
set(gcf, 'position', [300,300,1200,500]);
plot(SIT.dn, avH, 'linewidth', 1)
datetick('x', 'mm-yyyy');
xtickangle(15)
yyaxis right
plot(shortdn, avShortSAM, 'linewidth', 1)

% Try as subplot
figure
set(gcf, 'position', [300,300,1500,700]);
subplot(2,1,1)
plot(SIT.dn, avH, 'linewidth', 1)
datetick('x', 'mm-yyyy');
xtickangle(15)
grid on

subplot(2,1,2)
plot(shortdn, avShortSAM, 'linewidth', 1, 'color',[0.2,0.8,0.5])
datetick('x', 'mm-yyyy');
yline(0, '--r');
xtickangle(15)
grid on

%% Now compare winter and summer SIT with SAM

shortdv = datevec(shortdn);

wintind = find(SIT.dv(:,2) == 6 | SIT.dv(:,2) == 7 | SIT.dv(:,2) == 8);
%sumind = find(SIT.dv(:,2) == 12 | SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);
sumind = find(SIT.dv(:,2) == 1 | SIT.dv(:,2) == 2);

wintind2 = find(shortdv(:,2) == 6 | shortdv(:,2) == 7 | shortdv(:,2)== 8);
sumind2 = find(shortdv(:,2) == 1 | shortdv(:,2) == 2);

figure
set(gcf, 'position', [300,300,1200,600]);
subplot(2,1,1)
plot(SIT.dn(wintind), avH(wintind), 'linewidth',1);
hold on
plot(SIT.dn(sumind), avH(sumind), 'linewidth',1);
plot(SIT.dn, avH, 'color', [0.7,0.7,0.7]);
datetick('x', 'mm-yyyy');
xtickangle(15)
grid on
legend('Winter SIT', 'Summer SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');


subplot(2,1,2)
plot(shortdn, avShortSAM,  'linewidth', 1, 'color',[0.2,0.8,0.5])
datetick('x', 'mm-yyyy');
yline(0, '--r');
xtickangle(15)
grid on
title('Southern Annular Mode Index')
ylabel('SAM')



%% Try with winter and summer dots rather than lines

% 1yr rolling SIT mean
% number of SIT years
(SIT.dn(end)-SIT.dn(1))/365.25;
% 23.2963 years
length(SIT.dn)/23.2963;
% 37.9459 weeks/year 

% Using 38 still preserves far too much seasonal variability
% 52 point moving average shows large scale variability well. 
SITroll = movmean(avH,52);



figure
set(gcf, 'position', [300,300,1200,700]);
subplot(2,1,1)
scatter(SIT.dn(wintind), avH(wintind), 'filled');
hold on
scatter(SIT.dn(sumind), avH(sumind), 'filled');
plot(SIT.dn, avH, 'color', [0.6,0.6,0.6], 'linewidth', 1);
plot(SIT.dn, SITroll, '--m')
datetick('x', 'mm-yyyy');
xtickangle(15)
grid on; box on;
legend('Winter SIT', 'Summer SIT', 'ALL SIT', '1 Year Moving Mean SIT')
title('Winter [Jun, Jul, Aug] and Summer [Dec, Jan, Feb] SIT');
ylabel('Sea Ice Thickness [m]');


subplot(2,1,2)
plot(shortdn, shortSAM,  'linewidth', 1, 'color',[0.6,0.6,0.6], 'linewidth', .2)
hold on
plot(shortdn, avShortSAM,  'linewidth', 1, 'color',[0.2,0.8,0.5], 'linewidth', 1.5)
datetick('x', 'mm-yyyy');
yline(0, '--r');
xtickangle(15)
grid on
title('Southern Annular Mode Index')
ylabel('SAM')
ylim([-3,4]);
legend('Monthly Index', '12 Month Moving Mean')

%print('ICE/SAM/Figures/SIT_SAM_Compare1.png', '-dpng', '-r800'); 


% subplot(3,1,3)
% plot(shortdn, shortSAM,  'linewidth', 1, 'color',[0.2,0.8,0.9])
% datetick('x', 'mm-yyyy');
% yline(0, '--r');
% xtickangle(15)
% grid on
% title('Southern Annular Mode Index')
% ylabel('SAM')































