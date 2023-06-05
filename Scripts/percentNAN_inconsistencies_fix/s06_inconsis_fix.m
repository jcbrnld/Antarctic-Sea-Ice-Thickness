% Jacob Arnold

% 26-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 06

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector06.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
% --> 1998,01,05
% --> 1999,01,11
% --> 1999,04,05
% --> 


% 2. vanishing icebergs
% --> 2006,08,01 use day before
% --> 

dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% type 1


d1(1) = find(SIT.dn==datenum(1998,01,05));
d1(2) = find(SIT.dn==datenum(1999,01,11));
d1(3) = find(SIT.dn==datenum(1999,04,05));

for ii = 1:length(d1)
    
    nani = find(isnan(dummyH(:,d1(ii))));
    
    dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+1))./2;
    
    clear nani
    
end


% type 2

d2 = find(SIT.dn==datenum(2006,08,01));

nan2 = find(isnan(dummyH(:,d2-1)));
berg2 = find(dummybergs(:,d2-1)==1);

dummyH(nan2,d2) = nan;
dummybergs(berg2,d2) = 1;





%% Check final


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
ylabel('% NaN')
title('Sector 06 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector06pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector06.mat', 'SIT', '-v7.3');







