% Jacob Arnold

% 21-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 02

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector02.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1997-10-27 (first date --> use values from week after)
%  --> 1998-10-05 to 1998-10-26 % IGNORE THESE FOR NOW - i believe these
%      gpoints will be nand by 2. 
%  --> 1999-10-04 to 1999-10-25
%  --> 2000-10-02 to 200-10-30
%  --> 2001-10-08 to 2001-10-22    
%
%  --> 2003-09-08
%  --> 2003-09-22 % back to back


% 2. vanishing icebergs
% c--> Get berg A23A from 2004-06-14 and back project to start AFTER temporally averaging to fill older blobs
% c--> Get berg ____ from 1997-12-22 and apply from start to 2004-04-19
% 


dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% S02: 1.      


d1 = find(SIT.dn==datenum(2003,09,08));
d2 = find(SIT.dn==datenum(2003,09,22));


nan1 = find(isnan(SIT.H(:,d1)));
nan2 = find(isnan(SIT.H(:,d2)));

trim1 = find(SIT.lat(nan1)>-77 & SIT.lon(nan1)>306 & SIT.lon(nan1)<321);
trim2 = find(SIT.lat(nan2)>-77 & SIT.lon(nan2)>306 & SIT.lon(nan2)<321);
nan1 = nan1(trim1);
nan2 = nan2(trim2);

[londom, latdom] = sectordomain(2);
dots = sectordotsize(2);
m_basemap('a', londom, latdom)
sectorexpand(2);
m_scatter(SIT.lon(nan2), SIT.lat(nan2), dots, 'filled');
m_scatter(SIT.lon(nan2(trim2)), SIT.lat(nan2(trim2)), dots, 'filled');


dummyH(nan1,d1) = (dummyH(nan1,d1-1) + dummyH(nan1,d1+2))./2;
dummybergs(nan1,d1) = 0;

dummyH(nan2,d2) = (dummyH(nan2,d2-2) + dummyH(nan2,d2+1))./2;
dummybergs(nan2,d2) = 0;


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

%% s02 2. 


d3 = find(SIT.dn==datenum(2004,06,14));
nan3 = find(isnan(SIT.H(:,d3)));
trim3 = find(SIT.lat(nan3)>-77 & SIT.lon(nan3)>316 & SIT.lon(nan3)<321); % Got it!

m_basemap('a', londom, latdom)
sectorexpand(2);
m_scatter(SIT.lon(nan3), SIT.lat(nan3), dots, 'filled')
m_scatter(SIT.lon(nan3(trim3)), SIT.lat(nan3(trim3)), dots, 'filled')

nan3 = nan3(trim3);
% these nans are iceberg A23A which has been stuck since 1986

dummyH(nan3,1:d3-1) = nan; 
dummybergs(nan3, 1:d3-1) = 1;




% Second correction
d4 = find(SIT.dn==datenum(1997,12,22));
nan4 = find(isnan(SIT.H(:,d4)));
trim4 = find(SIT.lat(nan4)>-77 & SIT.lon(nan4)>311 & SIT.lon(nan4)<321);

m_basemap('a', londom, latdom)
sectorexpand(2);
m_scatter(SIT.lon(nan4), SIT.lat(nan4), dots, 'filled')
m_scatter(SIT.lon(nan4(trim4)), SIT.lat(nan4(trim4)), dots, 'filled')

nan4 = nan4(trim4);

ed = find(SIT.dn==datenum(2004,04,19));

dummyH(nan4,1:ed) = nan;
dummybergs(nan4,1:ed) = 1;

% View
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
title('After second correction');
xtickangle(30);






%% More type 1

% s--> 2005,04,18 % use week before
% s--> 2010,04,03 % use week after
% s--> 2010,03,22 % use week before
% s--> 2005,09,05 % use week before
% s--> 2005,09,19 % use week after
% r--> 2006,01,23 to 2006-06-26 % use week before
% s--> 2007,02,08 % use week before
% s--> 2007-03-17 % Use week before




d5(1) = find(SIT.dn==datenum(2005,04,18)); % use week before
d5(2) = find(SIT.dn==datenum(2010,04,03)); % use week after
d5(3) = find(SIT.dn==datenum(2010,03,22)); % use week before
d5(4) = find(SIT.dn==datenum(2005,09,05)); % use week before
d5(5) = find(SIT.dn==datenum(2005,09,19)); % use week after
d5(6) = find(SIT.dn==datenum(2007,02,08)); % use week before
d5(7) = find(SIT.dn==datenum(2007,05,17)); % Use week before

wi = [1 2 1 1 2 1 1];

for ii = 1:length(d5)
    if wi(ii) == 1
        nani = find(isnan(SIT.H(:,d5(ii)-1)));
        bergi = find(dummybergs(:,d5(ii)-1)==1);
    elseif wi(ii) == 2
        nani = find(isnan(SIT.H(:,d5(ii)+1)));
        bergi = find(dummybergs(:,d5(ii)+1)==1);
    end
    
    dummyH(nani,d5(ii)) = nan;
    dummybergs(bergi,d5(ii)) = 1;
    
    clear nani bergi
    
end



d6 = find(SIT.dn==datenum(2006,01,23));
d7 = find(SIT.dn==datenum(2006,06,26));

nan6 = find(isnan(SIT.H(:,d6-1)));
trim6 = find(SIT.lat(nan6)>-77 & SIT.lon(nan6)>311 & SIT.lon(nan6)<316.9); 

m_basemap('a', londom, latdom)
sectorexpand(2);
m_scatter(SIT.lon(nan6), SIT.lat(nan6), dots, 'filled')
m_scatter(SIT.lon(nan6(trim6)), SIT.lat(nan6(trim6)), dots, 'filled')

nan6 = nan6(trim6);

dummyH(nan6,d6:d7) = nan;
dummybergs(nan6,d6:d7) = 1;





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
title('Sector 02 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector02pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector02.mat', 'SIT', '-v7.3');


















