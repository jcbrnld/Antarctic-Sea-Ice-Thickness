% Jacob Arnold

% 25-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 07

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector07.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 


% august nan line along amery ice shelf
% sep and oct nan patch by amery
% southern nan border --> not month specific 
% perhaps large berg calved in sep 2019? 
%  --> berg d28 calved then - project nans from area in front of ice shelf
%  back from this time to start of record
% ______> take nans from 2002,08,07 and project from start to 2019-09-19





% 2. vanishing icebergs
% s--> none!

dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% s07: 1. reproject iceshelf nans before sep 2019 (calving of D28)



d1 = find(SIT.dn==datenum(2002,10,07));
d2 = find(SIT.dn==datenum(2019,09,19));

nan1 = find(isnan(SIT.H(:,d1)));

% reproject
dummyH(nan1,1:d2) = nan;

% check it out

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


%% Smoothe over that last sep-oct hump then remake movie

d3 = find(SIT.dn==datenum(2020,07,30));
d4 = find(SIT.dn==datenum(2020,11,05));

dr = d3:d4;

for ii = 1:length(dr)
    nani = find(isnan(dummyH(:,dr(ii))));
    
    dummyH(nani,dr(ii)) = (dummyH(nani,d3-1) + dummyH(nani,d4+1))./2;
    
    clear nani
    
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

%% one last little fix

d5 = find(SIT.dn==datenum(2021,05,20));

nan5 = find(isnan(dummyH(:,d5-1)));

dummyH(nan5, d5) = nan;




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
title('Sector 07 Corrections [first stage]');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector07pernan_1.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector07.mat', 'SIT', '-v7.3');













%% AAAND 07 part 2
% after having done the above (rather significant) corrections and remade
% the video

%load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector07_2.mat;



% Type 1 corrections 
% --> 1998,09,07
% --> 1998,04,19
% --> 1999,06,21
% --> 1999,09,20
% --> 1999,11,22
% --> 2002,07,15
% --> 2004,12,27 btb1
% --> 2005,01,10 btb1
% --> 2008,09,15



% Type 2 corrections
% --> take nans from 1997,12,01 and apply forward to 2019-09-19 [DO THIS FIRST]
% --> do same with nans from 2015,02,26 but project from start to 2013,07,08
% 2019-09-26 needs nans from week previous


dummyH = SIT.H;
dummybergs = SIT.icebergs;


%% that big type 2


d1 = find(SIT.dn==datenum(1997,12,01));
d2 = find(SIT.dn==datenum(2019,09,19));

nan1 = find(isnan(SIT.H(:,d1)));

% project to all
dummyH(nan1,1:d2) = nan;


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

%% that second big type 2

d3 = find(SIT.dn==datenum(2015,02,26));
d4 = find(SIT.dn==datenum(2013,07,08));

nan3 = find(isnan(dummyH(:,d3)));
trim3 = find(SIT.lon(nan3)>80);

[londom, latdom] = sectordomain(07);
dots = sectordotsize(07);
m_basemap('a', londom, latdom)
sectorexpand(7);
m_scatter(SIT.lon(nan3(trim3)), SIT.lat(nan3(trim3)), dots, 'fill');
% Looks good!

nan3 = nan3(trim3);

% Project to all
dummyH(nan3,1:d4) = nan;


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

% last type to: 
d5 = find(SIT.dn==datenum(2019,09,26));

nan5 = find(isnan(dummyH(:,d5-1)));

dummyH(nan5,d5) = nan;





%%  type 1 corrections



d6(1) = find(SIT.dn==datenum(1998,09,07));
d6(2) = find(SIT.dn==datenum(1999,04,19));
d6(3) = find(SIT.dn==datenum(1999,06,21));
d6(4) = find(SIT.dn==datenum(1999,09,20));
d6(5) = find(SIT.dn==datenum(1999,11,22));
d6(6) = find(SIT.dn==datenum(2002,07,15));
d6(7) = find(SIT.dn==datenum(2004,12,27));% btb1
d6(8) = find(SIT.dn==datenum(2005,01,10));% btb1
d6(9) = find(SIT.dn==datenum(2008,09,15));

for ii = 1:length(d6)
    
    nani = find(isnan(dummyH(:,d6(ii))));
    
    if ii == 7
        dummyH(nani,d6(ii)) = (dummyH(nani,d6(ii)-1) + dummyH(nani,d6(ii)+2))./2;
    elseif ii == 8
        dummyH(nani,d6(ii)) = (dummyH(nani,d6(ii)-2) + dummyH(nani,d6(ii)+1))./2;
    else
        dummyH(nani,d6(ii)) = (dummyH(nani,d6(ii)-1) + dummyH(nani,d6(ii)+1))./2;
    end
    
    clear nani
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
title('After third correction');
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
title('Sector 07 Corrections [second stage]');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector07pernan_2.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector07.mat', 'SIT', '-v7.3');






































