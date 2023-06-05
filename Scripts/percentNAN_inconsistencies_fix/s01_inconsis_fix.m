% Jacob Arnold

% 19-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 01

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector01.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1998-11-09
%  --> 1999-01-11
%  --> 1999-04-26


% 2. vanishing icebergs
% cr--> 2004-12-13 to 2005-02-07 blob above larsen ice shelf - use week before
% cr--> 2005-04-18 to 2005-05-16 ''''
%  s--> 2005-05-16 use week before (blob in the south)
% cr--> 2005-06-13 to 2005-06-27 above larsen - use week after
%  s--> 2005-07-25 use week before
% sr--> 2005-09-19 to 2005-10-03   use week after
%  s--> 2005-10-31 use week before
% sr--> 2005-12-12 to 2006-01-23 use week before
% cr--> 2006-03-06 to 2006-03-20 use week before
%  s--> 2006-07-20 use week before
%  s--> 2006-09-04 use week after
%  s--> 2007-02-08 use week after
%  c--> 2007-04-20 small berg in the south - use week before
%  s--> 2008-06-23 use week before
%  s--> 2015-08-06 use week before 



dummyH = SIT.H;
dummybergs = SIT.icebergs;



%% s01: 1.


d1(1) = find(SIT.dn==datenum(1998,11,09));
d1(2) = find(SIT.dn==datenum(1999,01,11));
d1(3) = find(SIT.dn==datenum(1999,04,26));

for ii = 1:length(d1)
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    newval = (SIT.H(nani,d1(ii)-1)+SIT.H(nani,d1(ii)+1))./2;
    
    dummyH(nani,d1(ii)) = newval;
    
    clear nani newval
end



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

%% s01: 2. 
% 2. vanishing icebergs
% cr--> 2004-12-13 to 2005-02-07 blob above larsen ice shelf - use week before
% cr--> 2005-04-18 to 2005-05-16 ''''
%                      d s--> 2005-05-16 use week before (blob in the south)
% cr--> 2005-06-13 to 2005-06-27 above larsen - use week after
%                      d s--> 2005-07-25 use week before
%                      d sr--> 2005-09-19 to 2005-10-03   use week after
%                      d s--> 2005-10-31 use week before
% sr--> 2005-12-12 to 2006-01-23 use week before
% cr--> 2006-03-06 to 2006-03-20 use week before
%                      d s--> 2006-07-10 use week before
%                      d s--> 2006-09-04 use week after
%                      d s--> 2007-02-08 use week after
%  c--> 2007-04-20 small berg in the south - use week before
%                      d s--> 2008-06-23 use week before
%                      d s--> 2015-08-06 use week before 


% start with simple
d2(1) = find(SIT.dn==datenum(2005,05,16));
d2(2) = find(SIT.dn==datenum(2005,07,25));
d2(3) = find(SIT.dn==datenum(2005,10,31));
d2(4) = find(SIT.dn==datenum(2005,09,19));%use 2 weeks after
d2(5) = find(SIT.dn==datenum(2005,10,03));
d2(6) = find(SIT.dn==datenum(2006,07,10));
d2(7) = find(SIT.dn==datenum(2006,09,04));
d2(8) = find(SIT.dn==datenum(2007,02,08));
d2(9) = find(SIT.dn==datenum(2008,06,23));
d2(10) = find(SIT.dn==datenum(2015,08,06));

b4oraf = [1 1 1 3 2 1 2 2 1 1];

for ii = 1:length(d2)
    if b4oraf(ii) == 1
        nani = find(isnan(SIT.H(:,d2(ii)-1)));
        bergi = find(dummybergs(:,d2(ii)-1)==1);
    elseif b4oraf(ii) == 2
        nani = find(isnan(SIT.H(:,d2(ii)+1)));
        bergi = find(dummybergs(:,d2(ii)+1)==1);
    elseif b4oraf(ii)==3
        nani = find(isnan(SIT.H(:,d2(ii)+2)));
        bergi = find(dummybergs(:,d2(ii)+2)==1);
    end
    
    dummyH(nani,d2(ii)) = nan;
    dummybergs(bergi,d2(ii)) = 1;
    
    clear nani bergi
end


% now for that other sr 
% sr--> 2005-12-12 to 2006-01-23 use week before
d3 = find(SIT.dn==datenum(2005,12,12));
d4 = find(SIT.dn==datenum(2006,01,23));
nan3 = find(isnan(SIT.H(:,d3-1)));
berg3 = find(dummybergs(:,d3-1)==1);

dummyH(nan3,d3:d4) = nan;
dummybergs(berg3,d3:d4) = 1;


%% and now complex 

% 1. cr--> 2004-12-13 to 2005-02-07 blob above larsen ice shelf - use week before
d5 = find(SIT.dn==datenum(2004,12,13));
d6 = find(SIT.dn==datenum(2005,02,07));
nan5 = find(isnan(SIT.H(:,d5-1)));
trim1 = find(SIT.lat(nan5)>-66.8 & SIT.lat(nan5)<-66.3); % bingo

[londom, latdom] = sectordomain(1);
dots = sectordotsize(1);
m_basemap('a', londom, latdom)
sectorexpand(1);
m_scatter(SIT.lon(nan5(trim1)), SIT.lat(nan5(trim1)),dots, 'filled')

nan5 = nan5(trim1);

dummyH(nan5,d5:d6) = nan;
dummybergs(nan5,d5:d6) = 1;


% 2. cr--> 2005-04-18 to 2005-05-16 ''''
d7 = find(SIT.dn==datenum(2005,04,18));
d8 = find(SIT.dn==datenum(2005,05,16));
nan7 = find(isnan(SIT.H(:,d7-1)));
trim2 = find(SIT.lat(nan7)>-66.8 & SIT.lat(nan7)<-66.3); % bingo

[londom, latdom] = sectordomain(1);
dots = sectordotsize(1);
m_basemap('a', londom, latdom)
sectorexpand(1);
m_scatter(SIT.lon(nan7(trim2)), SIT.lat(nan7(trim2)),dots, 'filled')

nan7 = nan7(trim2);

dummyH(nan7,d7:d8) = nan;
dummybergs(nan7,d7:d8) = 1;


% 3. cr--> 2005-06-13 to 2005-06-27 above larsen - use week after
d9 = find(SIT.dn==datenum(2005,06,13));
d10 = find(SIT.dn==datenum(2005,06,27));
nan9 = find(isnan(SIT.H(:,d10+1)));
trim3 = find(SIT.lat(nan9)>-66.8 & SIT.lat(nan9)<-66.3); % bingo

[londom, latdom] = sectordomain(1);
dots = sectordotsize(1);
m_basemap('a', londom, latdom)
sectorexpand(1);
m_scatter(SIT.lon(nan9(trim3)), SIT.lat(nan9(trim3)),dots, 'filled')

nan9 = nan9(trim3);

dummyH(nan9,d9:d10) = nan;
dummybergs(nan9,d9:d10) = 1;


% 4. cr--> 2006-03-06 to 2006-03-20 use week before
d11 = find(SIT.dn==datenum(2006,03,06));
d12 = find(SIT.dn==datenum(2006,03,20));
nan11 = find(isnan(SIT.H(:,d11-1)));
trim4 = find(SIT.lat(nan11)>-67.25 & SIT.lat(nan11)<-66.9); % bingo

[londom, latdom] = sectordomain(1);
dots = sectordotsize(1);
m_basemap('a', londom, latdom)
sectorexpand(1);
m_scatter(SIT.lon(nan11(trim4)), SIT.lat(nan11(trim4)),dots, 'filled')

nan11 = nan11(trim4);

dummyH(nan11,d11:d12) = nan;
dummybergs(nan11,d11:d12) = 1;


% 5. Last one!
%  c--> 2007-04-20 small berg in the south - use week before
d13 = find(SIT.dn==datenum(2007,04,20));
nan13 = find(isnan(SIT.H(:,d13-1)));
trim13 = find(SIT.lat(nan13)<-71 & SIT.lon(nan13)>300);

m_basemap('a', londom, latdom)
sectorexpand(1);
m_scatter(SIT.lon(nan13(trim13)), SIT.lat(nan13(trim13)),dots, 'filled')

nan13 = nan13(trim13);

dummyH(nan13,d13) = nan;
dummybergs(nan13,d13) = 1;




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
title('Sector 01 Corrections');
xtickangle(30);
print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector01pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector01.mat', 'SIT', '-v7.3');















