% Jacob Arnold

% 14-October-2021

% Create scatterplots of KM ICESat SIT data vs my SOD SIT data on ICESat
% tracks. 



sector = '01'
% load data
load(['ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/For_Comparison/sector',...
    sector,'_onTrack_RedunAve.mat']); 

% Averages
for ii = 1:12
    avH(ii) = nanmean(TSOD.H{ii});
    avkmSIT(ii) = nanmean(TSOD.kmSIT{ii});
    
end

figure;plot(avH,'c')
hold on
plot(avkmSIT, 'm')

%% Separate By season


spr = [1,4,9,11]; % ONxx
summ = [2,5,7,10,12]; % FMxx % MA07 fits in well with summer
wint = [3,6,8]; % MJxx

Lwint = [1,3,4,6,8,9,11]; % ONxx and MJxx

% Make seasonal averges
Havspr=[];SITavspr=[];
Havsumm=[];SITavsumm=[];
HavLwint=[];SITavLwint=[];

% spr
for ii = 1:length(spr)
    Havspr(ii) = nanmean(TSOD.H{spr(ii)});
    SITavspr(ii) = nanmean(TSOD.kmSIT{spr(ii)});
end

% summ
for ii = 1:length(summ)
    Havsumm(ii) = nanmean(TSOD.H{summ(ii)});
    SITavsumm(ii) = nanmean(TSOD.kmSIT{summ(ii)});
end

% wint
for ii = 1:length(Lwint)
    HavLwint(ii) = nanmean(TSOD.H{Lwint(ii)});
    SITavLwint(ii) = nanmean(TSOD.kmSIT{Lwint(ii)});
end


figure;
plot(TSOD.mid_dn(Lwint), HavLwint,'-*', 'color', [0.2,0.6,0.5], 'linewidth', 1.2);
hold on
plot(TSOD.mid_dn(Lwint),SITavLwint, '-*','color',[0.5,0.9,0.7], 'linewidth', 1.2)
plot(TSOD.mid_dn(summ), Havsumm, '-*','color', [0.6,0.1,0], 'linewidth', 1.2);
plot(TSOD.mid_dn(summ), SITavsumm, '-*','color', [0.9, 0.4, 0], 'linewidth', 1.2);
set(gcf, 'position', [500,600,1200,500])
datetick('x', 'dd-mmm-yyyy')
xticks(TSOD.mid_dn);
xticklabels(TSOD.Cruises)
ylim([0,3])
grid on; 
xlim([min(TSOD.mid_dn)-50, max(TSOD.mid_dn)+50]);
legend('SOD Winter', 'ICESat Winter', 'SOD Summer', 'ICESat Summer')
title(['Sector ',sector,' SOD SIT and ICESat SIT on Winter and Summer Campaigns']);
ylabel('Sea Ice Thickness [m]');

%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Wint_summ_av_MAsumm.png'], '-dpng', '-r500');




%% Scatterplot of all points (more useful for sectors smaller than 00)

% winter
figure
scatter(TSOD.H{1}, TSOD.kmSIT{1})











