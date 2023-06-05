% Jacob Arnold

% 18-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 10

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector10.mat;


% Log of fixes
% 1. early in the timeseries there are ~5 times when the coastal nan
%    barrier expands - looks like ice charts sectioned off a larger area along
%    the coast as ice shelf. 
%    --> intpolate from day before and after at those grid points
% Dates:
%    1 --> 03-Nov-1997
%    2 --> 01-Dec-1997
%    3 --> 25-May-1998
%    4 --> 13-Jul-1998
%    5 --> 20-Jul-1998 % these are back to back so will have to do to days
%        after 13 and 2 days before 20
%    6 --> 17-Apr-2000
%    7 --> 10-Jul-2000

% 2. in the middle years there are many small icebergs transiting the
%    basin. Periodically the ice analysts forgot to trace their bergs on
%    random days
%    --> should be able to use location the day before or after to fill in
%    missing berg days. 
dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% s10: 1. 


d1(1) = find(SIT.dn==datenum(1997,11,03));
d1(2) = find(SIT.dn==datenum(1997,12,01));
d1(3) = find(SIT.dn==datenum(1998,05,25));
d1(4) = find(SIT.dn==datenum(1998,07,13));
d1(5) = find(SIT.dn==datenum(1998,07,20));
d1(6) = find(SIT.dn==datenum(2000,04,17));
d1(7) = find(SIT.dn==datenum(2000,07,10));

for ii = 1:length(d1)
    
    nan1 = find(isnan(SIT.H(:,d1(ii))));
    
    if ii == 4 
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+2))./2;
    elseif ii == 5
        new1 = (dummyH(nan1,d1(ii)-2)+dummyH(nan1,d1(ii)+1))./2;
    else
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+1))./2;
    end
    
    dummyH(nan1,d1(ii)) = new1;
    clear nan1 new1

end


% check result

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

% LOOKS GREAT!! Good job!


%% s10: 2.
% s = simple (can just use nan from week before)
% c = complex (have to single out nans for a specific berg or there are multiple days)
% Dates to correct:
% s--> 10-Feb-2003 - use day before
% s--> 21-Feb-2005 - use day before
% c--> 31-Oct-2005 to 28-Nov-2005 - use day after [blob near totten]
% c--> 10-Jul-2006 - use day after [long and narrow berg near south center]
% s--> 01-Aug-2006 - use day after [both blob and long narrow]
% c--> 03-Nov-2006 to 14-Dec-2006 - use day after [just blob to the west]
% s--> 26-Nov-2007 - use day after
% s--> 21-Jan-2008 - use day before
% s--> 03-apr-2010 - use day after
% s--> 16-Apr-2012 - use day after [blob in middle]
% s--> 14-May-2012 - use day before
% c--> 09-Jul-2012 to 23-Jul-2012 - use day before and ONLY for missing bergs [blob in center and sliver on right]
% c--> 06-Aug-2012 - use day after and ONLY for small berg in the East
% c--> 07-Feb-2019 to 08-Feb-2019 - use day after and ONLY for small berg in the East


% Index of the simple ones 
d2(1) = find(SIT.dn==datenum(2003, 02, 10));
d2(2) = find(SIT.dn==datenum(2005, 02, 21));
d2(3) = find(SIT.dn==datenum(2006, 08, 01));
d2(4) = find(SIT.dn==datenum(2007, 11, 26));
d2(5) = find(SIT.dn==datenum(2008, 01, 21));
d2(6) = find(SIT.dn==datenum(2010, 04, 03));
d2(7) = find(SIT.dn==datenum(2012, 04, 16));
d2(8) = find(SIT.dn==datenum(2012, 05, 14));

b4oraf = [1 1 2 2 1 2 2 1]; % 1 means use day before, 2 means use day after

for ii = 1:8
    
    if b4oraf(ii) == 1
        nani = find(isnan(SIT.H(:,d2(ii)-1)));
        bergi = find(dummybergs(:,d2(ii)-1)==1);
    elseif b4oraf(ii) == 2
        nani = find(isnan(SIT.H(:,d2(ii)+1)));
        bergi = find(dummybergs(:,d2(ii)+1)==1);
    end
    
    dummyH(nani, d2(ii)) = nan;
    dummybergs(bergi, d2(ii)) = 1;
    
    clear nani bergi
end

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



% now the complex ones 
% 31-Oct-2005 to 28-Nov-2005
d2u = find(SIT.dn==datenum(2005,11,28))+1;
d3 = find(SIT.dn==datenum(2005, 10,31));

nan2 = find(isnan(SIT.H(:,d2u)));

[londom, latdom] = sectordomain(10);
dots = sectordotsize(10);
m_basemap('a', londom, latdom);
sectorexpand(10);
m_scatter(SIT.lon, SIT.lat, dots, [.7,.7,.7], 'filled');
m_scatter(SIT.lon(nan2), SIT.lat(nan2), dots, [.9, .4, .6], 'filled');

% Turns out this one is actually simple

dummyH(nan2,d3:d2u-1) = nan;

berg2 = find(dummybergs(:,d2u)==1);
dummybergs(berg2,d3:d2u-1) = 1;


% next
% c--> 10-Jul-2006 - use day after
%this one is also simple
d4 = find(SIT.dn==datenum(2006,07,10));
nan3 = find(isnan(SIT.H(:,d4+1)));
berg3 = find(dummybergs(:,d4+1)==1);

dummyH(nan3,d4) = nan;
dummybergs(berg3,d4) = 1;


% next 
% 03-Nov-2006 to 14-Dec-2006 - use day after [just blob to the west]
% this one also turns out to be simple
d5 = find(SIT.dn==datenum(2006,11,03));
d6 = find(SIT.dn==datenum(2006,12,14));

nan4 = find(isnan(SIT.H(:,d6+1)));
berg4 = find(dummybergs(:,d6+1)==1);

dummyH(nan4,d5:d6) = nan;
dummybergs(berg4,d5:d6) = 1;

% Next
% 09-Jul-2012 to 23-Jul-2012 - use day before and ONLY for missing bergs [blob in center and sliver on right]

d7 = find(SIT.dn==datenum(2012, 07, 09));
d8 = find(SIT.dn==datenum(2012, 07,23));

nan5 = find(isnan(SIT.H(:,d7-1)));
trim5 = find(SIT.lat(nan5)>-65.9 & SIT.lon(nan5)<118 & SIT.lon(nan5)>113.7); % bingo
nan5 = nan5(trim5);

m_basemap('a', londom, latdom);
sectorexpand(10);
m_scatter(SIT.lon, SIT.lat, dots, [.7,.7,.7], 'filled');
m_scatter(SIT.lon(nan5), SIT.lat(nan5), dots, [.9, .4, .6], 'filled');

dummyH(nan5,d7:d8) = nan;
dummybergs(nan5, d7:d8) = 1;

% Next
% c--> 06-Aug-2012 - use day after and ONLY for small berg in the East
d9 = find(SIT.dn==datenum(2012, 08, 06));

nan6 = find(isnan(SIT.H(:,d9+1)));
trim6 = find(SIT.lat(nan6)>-66.5 & SIT.lon(nan6)<120 & SIT.lon(nan6)>119); % bingo
nan6 = nan6(trim6);

m_basemap('a', londom, latdom);
sectorexpand(10);
m_scatter(SIT.lon, SIT.lat, dots, [.7,.7,.7], 'filled');
m_scatter(SIT.lon(nan6(trim6)), SIT.lat(nan6(trim6)), dots, [.9, .4, .6], 'filled');


dummyH(nan6,d9) = nan;
dummybergs(nan6,d9) = 1;


% Next THE LAST ONE!
% c--> 07-Feb-2019 to 08-Feb-2019 - use day after and ONLY for small berg in the East
% Actually simple because other berg does not move
d10 = find(SIT.dn==datenum(2019,02,07));

nan7 = find(isnan(SIT.H(:,d10+2)));
berg7 = find(dummybergs(:,d10+2)==1);

dummyH(nan7,d10:d10+1) = nan;
dummybergs(berg7,d10:d10+1) = 1;


% Check final


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
title('Sector 10 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector10pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector10.mat', 'SIT', '-v7.3');























