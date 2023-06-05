% Jacob Arnold

% 26-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 05

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector05.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
% --> 1998,03,23
% --> 1998,05,18
% --> 1998,10,12
% --> 


% 2. vanishing icebergs
% --> 2005,01,10 use week before
% --> 2004,11,15 to 2004,12,13 use week after
% --> 2015,11,26 use week before


dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% type 1

d1(1) = find(SIT.dn==datenum(1998,03,23));
d1(2) = find(SIT.dn==datenum(1998,05,18));
d1(3) = find(SIT.dn==datenum(1998,10,12));

for ii = 1:length(d1)
    
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+1))./2;
   
    clear nani
end


%% Type 2

d2 = find(SIT.dn==datenum(2005,01,10));
nan2 = find(isnan(dummyH(:,d2-1)));
berg2 = find(dummybergs(:,d2-1)==1);

dummyH(nan2,d2) = nan;
dummybergs(berg2,d2) = 1;

d3 = find(SIT.dn==datenum(2004,11,15));
d4 = find(SIT.dn==datenum(2004,12,13));
nan3 = find(isnan(dummyH(:,d4+1)));
berg3 = find(dummybergs(:,d4+1)==1);

dummyH(nan3,d3:d4) = nan;
dummybergs(berg3,d3:d4) = 1;


d5 = find(SIT.dn==datenum(2015,11,26));
nan5 = find(isnan(dummyH(:,d5-1)));
berg5 = find(dummybergs(:,d5-1)==1);

dummyH(nan5,d5) = nan;
dummybergs(berg5,d5) = 1;


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
title('Sector 05 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector05pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector05.mat', 'SIT', '-v7.3');




























