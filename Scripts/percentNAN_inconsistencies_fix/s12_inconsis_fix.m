% Jacob Arnold

% 18-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 12

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector12.mat;

% Iceberg B9B of the Ninnis glacier tongue was stuck in about the same
% place until 2010. 
% Need to find the indices for B9B when it first starts to appear in the
% record and project those backward to the start. 


% Log of fixes 
% 1. Iceberg B9b is only traced periodically. 
%    --> find indices of this berg in 12 Dec 2005 and back project these to
%    the star of the dataset. B9b has been grounded here since the late
%    '80s so it should appear from the beginning of our record. 

% 2. Large blob appears at about 138-142 E 
%    --> temporally interpolate H at those grid points using data from the
%    week before and after. 

% 3. B9b dissappears on a couple of other random dates:
%    03-Nov-2006 : 14-Dec-2006  --> for this one can use rm1 
%    03-Apr-2010  --> use location of B9b on day before (22-Mar-2010)
%              --> another large missing berg - the one B9b broke off

% 4. Two instances of vanishing icebergs: 
% --> 27-May-2013 - this is the only change so just use nan from day before
% --> 11-Feb-2021 - ditto



%% 12: 1. 
d1 = find(SIT.dn == datenum(2005, 12, 12));
nans1 = find(isnan(SIT.H(:,d1)));

[londom, latdom] = sectordomain(12);
dots = sectordotsize(12);

m_basemap('a', londom, latdom)
sectorexpand(12);
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled');
m_scatter(SIT.lon(nans1(49:435)), SIT.lat(nans1(49:435)), dots, [0.9, 0.4, 0.6], 'filled');

% find and grab just the points needed:
rm1 = nans1(49:440);
trim = find(SIT.lat(rm1) > -67.645);

% check
m_basemap('a', londom, latdom)
sectorexpand(12);
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled');
m_scatter(SIT.lon(rm1(trim)), SIT.lat(rm1(trim)), dots, [0.9, 0.4, 0.6], 'filled');
rm1 = rm1(trim);
% apply these to everything before d1

dummyH = SIT.H;
dummyH(rm1,1:d1-1) = nan;

dummybergs = SIT.icebergs;
dummybergs(rm1,1:d1-1) = 1;

figure
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon));
plot_dim(800,200)
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon));
legend('Before', 'After')
ylim([0,0.2])


% remove unnecessary leftover iceberg fields from SIT structure
SIT = rmfield(SIT, 'icebergs_inds');
SIT = rmfield(SIT, 'rawicebergs');

%% 12: 2. 

% find indices of large blob at 05-apr-1999
d2 = find(SIT.dn == datenum(1999,04,05));
nan2 = find(isnan(SIT.H(:,d2)));

% remove points that are part of the AMSR permamnent nan correction
counter = 1;
for ii = 1:length(nan2)
    loc = find(SIT.iceShelfCorr == nan2(ii));
    if isempty(loc)
        continue
    else
        trim2(counter) = ii;
        counter = counter+1;
    end
    clear loc
end
nan2(trim2) = [];
trim3 = find(SIT.lon(nan2) > 135 & SIT.lon(nan2) < 145);



m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(nan2(trim3)), SIT.lat(nan2(trim3)), dots, [0.9,0.4,0.6], 'filled')
%m_scatter(SIT.lon(SIT.iceShelfCorr), SIT.lat(SIT.iceShelfCorr), dots, [0.9, 0.6,0.4], 'filled')

rm2 = nan2(trim3); % THESE ARE THE INDICES TO INTERPOLATE 

newval = (SIT.H(rm2,d2-1) + SIT.H(rm2,d2+1))./2; % average of day before and day after

m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(rm2), SIT.lat(rm2), dots, SIT.H(rm2,d2+1), 'filled')
% Looks good! 

% APPLY CORRECTION
dummyH(rm2,d2) = newval;


% Check progress in %nan space

figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon));
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5);
legend('Before', 'After')
ylim([0,0.2])
datetick('x')
grid on





%% 12: 3. 
% B9b dissappears on a couple of other random dates:
% 03-Nov-2006 : 14-Dec-2006  --> for this one can use rm1 
% 03-Apr-2010  --> use location of B9b on day before (22-Mar-2010)
%              --> another large missing berg - the one B9b broke off
t1 = find(SIT.dn==datenum(2006,11,03));
t2 = find(SIT.dn==datenum(2006, 12, 14));
d3 = t1:t2;

m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(rm1), SIT.lat(rm1), dots, [0.9,0.4,0.6], 'filled')

% Looks good SO HERE IS THE CORRECTION
dummyH(rm1, d3) = nan;


% Okay next
d4 = find(SIT.dn == datenum(2010,04,03));

ud = find(SIT.dn == datenum(2010, 03, 22));

nan3 = find(isnan(SIT.H(:,ud)));

m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(nan3), SIT.lat(nan3), dots, [0.9,0.4,0.6], 'filled')


% remove points that are part of the AMSR permamnent nan correction
counter = 1;
for ii = 1:length(nan3)
    loc = find(SIT.iceShelfCorr == nan3(ii));
    if isempty(loc)
        continue
    else
        trim3(counter) = ii;
        counter = counter+1;
    end
    clear loc
end
nan3(trim3) = [];

trim4 = find(SIT.lat(nan3) > -67.27);


m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(nan3(trim4)), SIT.lat(nan3(trim4)), dots, [0.9,0.4,0.6], 'filled')

% looks good so use trim nan3

rm3 = nan3(trim4);


% Now add these nan to the structure at d4
dummyH(rm3,d4) = nan;



% Check progress in %nan space

figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon));
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5);
legend('Before', 'After')
ylim([0,0.2])
datetick('x')
grid on


%% 12: 4

% Two instances of vanishing icebergs: 
% --> 27-May-2013 - this is the only change so just use nan from day before
% --> 11-Feb-2021 - ditto

d5 = find(SIT.dn == datenum(2013, 05, 27));
d6 = find(SIT.dn == datenum(2021, 02, 11));

nan5 = find(isnan(SIT.H(:,d5-1))); % day before for first offense 
berg5 = find(dummybergs(:,d5-1)==1);

m_basemap('a', londom, latdom)
sectorexpand(12)
m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled')
m_scatter(SIT.lon(nan5), SIT.lat(nan5), dots, [0.9,0.4,0.6], 'filled')

% nan5 is good 

nan6 = find(isnan(SIT.H(:,d6-1)));
trim6 = find(SIT.lat(nan6) > -66.4 & SIT.lon(nan6) > 140);
nan6 = nan6(trim6);
% nan6 looks good
% SO apply correction:

dummyH(nan5,d5) = nan;
dummyH(nan6, d6) = nan;

dummybergs(berg5,d5) = 1;
dummybergs(nan6,d6) = 1;


%% IT ALL LOOKS PRETTY GOOD

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
title('Sector 12 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector12pernan.png', '-dpng', '-r500');

%% Finally save

SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector12.mat', 'SIT', '-v7.3');













