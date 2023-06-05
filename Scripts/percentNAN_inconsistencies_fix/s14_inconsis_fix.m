% Jacob Arnold

% 24-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 14

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector14.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1998,09,14
%  --> 1999,05,24
%  --> 2000,12,25
%  July and Dec every year have a little line of nans in the south - find
%  these and average week before and after to fill



% 2. vanishing icebergs
% c--> get nans from 2002-04-08 - apply from start to 2002-03-11
% c--> get nans from 2002-02-25 - apply from 2001-12-31 to 2002-05-06


dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% s14: 1.


d1(1) = find(SIT.dn==datenum(1998,09,14));
d1(2) = find(SIT.dn==datenum(1999,05,24));
d1(3) = find(SIT.dn==datenum(2000,12,25));

for ii = 1:3
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+1))./2;
    clear nani
   
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






%% s14: 2. 




d2 = find(SIT.dn==datenum(2002,04,08)); e2 = find(SIT.dn==datenum(2002,03,11));
d3 = find(SIT.dn==datenum(2002,02,25)); e31 = find(SIT.dn==datenum(2001,12,31)); e32 = find(SIT.dn==datenum(2002,05,06));

nan2 = find(isnan(SIT.H(:,d2)));
nan3 = find(isnan(SIT.H(:,d3)));
berg3 = find(dummybergs(:,d3)==1);

dummyH(nan2,1:e2) = nan;

dummyH(nan3,e31:e32) = nan;
dummybergs(berg3,e31:e32) = 1;



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

%% another type 1 case

d4 = find(SIT.dn==datenum(1999,07,05));
nan4 = find(isnan(SIT.H(:,d4)));

dummyH(nan4,d4) = (dummyH(nan4,d4-2) + dummyH(nan4,d4+1))./2;
dummyH(nan4,d4-1) = (dummyH(nan4,d4-2) + dummyH(nan4,d4+1))./2;


newt = find(isnan(dummyH(:,d4)));

[londom, latdom] = sectordomain(14);
dots = sectordotsize(14);
m_basemap('a', londom, latdom)
sectorexpand(14);
m_scatter(SIT.lon(nan4), SIT.lat(nan4), dots, 'filled');
m_scatter(SIT.lon(newt), SIT.lat(newt), dots, 'filled');

%% july and september southern nan line

% Test case
dt = find(SIT.dn==datenum(2010,07,12));
nant = find(isnan(SIT.H(:,dt)));
trimt = find(SIT.lat(nant)>-78.3 & SIT.lon(nant)<184 & SIT.lon(nant)>180);

[londom, latdom] = sectordomain(14);
dots = sectordotsize(14);
m_basemap('a', londom, latdom)
sectorexpand(14);
m_scatter(SIT.lon(nant), SIT.lat(nant), dots, 'filled');
m_scatter(SIT.lon(nant(trimt)), SIT.lat(nant(trimt)), dots, 'filled');

% good

%% july and sep southern nan lines


jsind = find(SIT.dv(:,2)==7 | SIT.dv(:,2)==9);

for ii = 1:length(jsind)
    nani = find(isnan(SIT.H(:,jsind(ii))));
    trimi = find(SIT.lat(nani)>-78.3 & SIT.lon(nani)<184 & SIT.lon(nani)>180);
    nani = nani(trimi);

    % look for first previous day that is in june/aug
    for ll = 1:5
        if SIT.dv(jsind(ii)-ll,2) == 6 | SIT.dv(jsind(ii)-ll,2) == 8
            sd = ll; % first (start) date is this many before jsind(ii) index
            break
        end
    end
    
    % look for first following day that is in aug/oct
    for jj = 1:5
        if SIT.dv(jsind(ii)+jj,2) == 8 | SIT.dv(jsind(ii)+jj,2) == 10
            ed = jj; % second (end) date is this many after jsind(ii) index
            break
        end
    end
    
    dummyH(nani,jsind(ii)) = (dummyH(nani,jsind(ii)-sd) + dummyH(nani,jsind(ii)+ed))./2;
    
    %clear nani trimi
    
    if ii == 80 % Example
        nane = nani;
        trime = trimi;
    end

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
title('Sector 14 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector14pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector14.mat', 'SIT', '-v7.3');






































