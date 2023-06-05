% Jacob Arnold

% 25-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 04

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector04.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
% --> 1998,01,12
% --> 1998,08,10 to 1998,09,14
% --> 


% 2. vanishing icebergs
% --> project nans in 2012,01,09 to entire record


dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% let's start with 2


d1 = find(SIT.dn==datenum(2012,01,09));

nan1 = find(isnan(SIT.H(:,d1)));

% Apply to all
dummyH(nan1,:) = nan;


% view
ticker = unique(SIT.dv(:,1));
ticker(end+1) = 2022;
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon), 'linewidth', 1, 'color', [0.4,0.7,0.9]);
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5, 'color', [0.9, 0.3,0.4]);
legend('Before', 'After')
xticks(ticker);
ylim([0,max(sum(isnan(SIT.H))./length(SIT.lon))+.10])
datetick('x', 'mm-yyyy', 'keepticks')
grid on
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
title('After first correction');
xtickangle(30);

%% now for 1


d2 = find(SIT.dn==datenum(1998,01,12));

nan2 = find(isnan(SIT.H(:,d2)));

dummyH(nan2,d2) = (dummyH(nan2,d2-1) + dummyH(nan2,d2+1))./2;


d3 = find(SIT.dn==datenum(1998,08,10));
d4 = find(SIT.dn==datenum(1998,09,14));

dr = d3:d4;

for ii = 1:length(dr)
    nani = find(isnan(dummyH(:,dr(ii))));
    
    dummyH(nani,dr(ii)) = (dummyH(nani,d3-1) + dummyH(nani,d4+1))./2;
   
    clear nani
end





%% Check final


figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon), 'linewidth', 1, 'color', [0.4,0.7,0.9]);
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5, 'color', [0.9, 0.3,0.4]);
legend('Before', 'After')
xticks(ticker);
ylim([0,max(sum(isnan(SIT.H))./length(SIT.lon))+.10])
datetick('x', 'mm-yyyy', 'keepticks')
grid on
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
ylabel('% NaN')
title('Sector 04 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector04pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector04.mat', 'SIT', '-v7.3');







































