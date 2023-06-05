% Jacob Arnold

% 24-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 15

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector15.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1999,07,05
%  --> 2002,04,08
%  --> 2006,06,15 % one day b4, 2 after
%  --> 2006,06,26 % 2 days b4, 1 after


% 2. vanishing icebergs
% c--> none!

dummyH = SIT.H;
dummybergs = SIT.icebergs;

%%


d1 = find(SIT.dn==datenum(1999,07,05));
nan1 = find(isnan(SIT.H(:,d1)));
dummyH(nan1,d1) = (dummyH(nan1,d1-1) + dummyH(nan1,d1+1))./2;

d2 = find(SIT.dn==datenum(2002,04,08));
nan2 = find(isnan(SIT.H(:,d2)));
dummyH(nan2,d2) = (dummyH(nan2,d2-1) + dummyH(nan2,d2+1))./2;

d3 = find(SIT.dn==datenum(2006,06,15));
nan3 = find(isnan(SIT.H(:,d3)));
dummyH(nan3,d3) = (dummyH(nan3,d3-1) + dummyH(nan3,d3+2))./2;

d4 = find(SIT.dn==datenum(2006,06,26));
nan4 = find(isnan(SIT.H(:,d4)));
dummyH(nan4,d4) = (dummyH(nan4,d4-2) + dummyH(nan4,d4+1))./2;

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
title('Sector 15 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector15pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector15.mat', 'SIT', '-v7.3');




































