% Jacob Arnold

% 19-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 13

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector13.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1999-05-03
%  --> 2002-01-28
%  --> 2011-10-17 to 2012-06-25 - grab nans from first and average from day
%      before first to day after last
%  --> 1999-11-29 - thought it was a berg at first but there is no record
%      of one this large at this place and time. 

% 2. vanishing icebergs
% s--> 2004-01-12 use week before
% s--> 2004-01-26 use two weeks before
% r--> 2004-02-23 to 2004-05-03 use week after
% s--> 2006-01-23 use week before
% c--> 2006-06-26 use week after


dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% S13: 1.



d1 = find(SIT.dn==datenum(1999,05,03));
nan1 = find(isnan(SIT.H(:,d1)));
fill1 = (SIT.H(nan1,d1-1)+SIT.H(nan1,d1+1))./2;

dummyH(nan1,d1) = fill1;

d2 = find(SIT.dn==datenum(2002,01,28));
nan2 = find(isnan(SIT.H(:,d2)));
fill2 = (SIT.H(nan2,d2-1)+SIT.H(nan2,d2+1))./2;

dummyH(nan2,d2) = fill2;

d3 = find(SIT.dn==datenum(2011,10,17));
d4 = find(SIT.dn==datenum(2012,06,25));
nan3 = find(isnan(SIT.H(:,d3)));
fill3 = (SIT.H(nan3,d3-1)+SIT.H(nan3,d4+1))./2;

cr = 0;
for ii = 1:19
    dummyH(nan3,d3+cr) = fill3;
    cr = cr+1;
end

d5 = find(SIT.dn==datenum(1999,11,29));
nan5 = find(isnan(SIT.H(:,d5)));
fill5 = (SIT.H(nan5,d5-1)+SIT.H(nan5,d5+1))./2;

dummyH(nan5,d5) = fill5;

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


%% s13: 2. 

% 2. vanishing icebergs
% s--> 2004-01-12 use week before
% s--> 2004-01-26 use two weeks before
% r--> 2004-02-23 to 2004-05-03 use week after
% s--> 2006-01-23 use week before
% c--> 2006-06-26 use week after


% take care of simple ones first
d6(1) = find(SIT.dn==datenum(2004,01,12));
d6(2) = find(SIT.dn==datenum(2004,01,26));
d6(3) = find(SIT.dn==datenum(2006,01,23));

for ii = 1:length(d6)
    if ii==2
        nani = find(isnan(SIT.H(:,d6(ii)-2)));
        bergi = find(dummybergs(:,d6(ii)-2)==1);
    else 
        nani = find(isnan(SIT.H(:,d6(ii)-1)));
        bergi = find(dummybergs(:,d6(ii)-1)==1);
    end
    
    dummyH(nani,d6(ii)) = nan;
    dummybergs(bergi,d6(ii)) = 1;
    clear nani
end



% now the range
d7 = find(SIT.dn==datenum(2004,02,23));
d8 = find(SIT.dn==datenum(2004,05,03));

nan7 = find(isnan(SIT.H(:,d8+1)));
berg7 = find(dummybergs(:,d8+1)==1);

dummyH(nan7,d7:d8) = nan;
dummybergs(berg7) = 1;



% now the complex one
d9 = find(SIT.dn==datenum(2006,06,26));
nan9 = find(isnan(SIT.H(:,d9+1)));
trim1 = find(SIT.lat(nan9)>-68 & SIT.lon(nan9)>152.5);

[londom, latdom] = sectordomain(13);
dots = sectordotsize(13);
m_basemap('a', londom, latdom);
sectorexpand(13)
m_scatter(SIT.lon(nan9(trim1)), SIT.lat(nan9(trim1)), dots, [0.9,0.4,0.6], 'filled'); 

nan9 = nan9(trim1);

dummyH(nan9,d9) = nan;
dummybergs(nan9,d9) = 1;





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
title('Sector 13 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector13pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector13.mat', 'SIT', '-v7.3');
























