% Jacob Arnold

% Check out the raw gridded NIC charts to see if/how reporting of ice types
% changed over time. 

% sector 14
% load('ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpSIG.mat');
% SIG = SIT; clear SIT;
% load('ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpE00.mat');
% E00 = SIT; clear SIT;
% sa = [E00.sa, SIG.sa];
% sb = [E00.sb, SIG.sb];
% sc = [E00.sc, SIG.sc];
% sd = [E00.sd, SIG.sd];
% dn = [E00.dn; SIG.dn];

% Entire shelf
load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector00_all.mat;
sa = SIT.sa; sb = SIT.sb; sc = SIT.sc; sd = SIT.sd;
dn = SIT.dn;

sa(sa<0) = nan; sa(sa==99) = nan; sa(sa==98) = nan; sa(sa==0) = nan; sa(sa==55) = nan;
sb(sb<0) = nan; sb(sb==99) = nan; sb(sb==98) = nan; sb(sb==0) = nan; sb(sb==55) = nan;
sc(sc<0) = nan; sc(sc==99) = nan; sc(sc==98) = nan; sc(sc==0) = nan; sc(sc==55) = nan;
sd(sd<0) = nan; sd(sd==99) = nan; sd(sd==98) = nan; sd(sd==0) = nan; sd(sd==55) = nan;


%% plot the mean timeseries
ticker = dnticker(1997,2022,1,1);

figure;
plot_dim(1000,300);
p1 = plot(dn, nanmean(sa));
hold on
p2 = plot(dn, nanmean(sb));
p3 = plot(dn, nanmean(sc));
p4 = plot(dn, nanmean(sd));
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend([p1,p2,p3,p4],'SA', 'SB', 'SC', 'SD', 'orientation', 'horizontal', 'location', 'southwest');
title('AA shelf mean stage of development values');
xlim([min(dn)-50, max(dn)+50]);
ylim([75,100]);

%print('ICE/ICETHICKNESS/Figures/Shapefiles/Category_use/AAshelf_meanSOD.png', '-dpng', '-r400')


%% Same but median

figure;
plot_dim(1000,300);
plot(dn, nanmedian(sa));
hold on
plot(dn, nanmedian(sb));
plot(dn, nanmedian(sc));
plot(dn, nanmedian(sd));
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('SA', 'SB', 'SC', 'SD', 'orientation', 'horizontal', 'location', 'southwest');
title('Sector 14 median stage of development values');
xlim([min(dn)-50, max(dn)+50]);


%%% same but mode
figure;
plot_dim(1000,300);
plot(dn, mode(sa));
hold on
plot(dn, mode(sb));
plot(dn, mode(sc));
plot(dn, mode(sd));
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('SA', 'SB', 'SC', 'SD', 'orientation', 'horizontal', 'location', 'southwest');
title('Sector 14 modal stage of development values');
xlim([min(dn)-50, max(dn)+50]);



%% now weight by number of grid points to determine relative abundance 

msa = sa; msa(~isfinite(sa))=0;
msb = sb; msb(~isfinite(sb))=0;
msc = sc; msc(~isfinite(sc))=0;
msd = sd; msd(~isfinite(sd))=0;
%%

figure;
plot_dim(1000,300);
plot(dn, nanmean(msa));
hold on
plot(dn, nanmean(msb));
plot(dn, nanmean(msc), 'c');
plot(dn, nanmean(msd), 'm');
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('SA', 'SB', 'SC', 'SD', 'orientation', 'horizontal');
title('Sector 14 mean stage of development values with zeros for missing data');
xlim([min(dn)-50, max(dn)+50]);
ylim([50,100]);


%% 
%a8 and a9 are essentially empty
a6 = sa==86 | sb==86 | sc==86 | sd==86; % First year ice [>=30 - 200 cm]
a7 = sa==87 | sb==87 | sc==87 | sd==87; % Thin First year ice [30 - <70 cm]
a8 = sa==88 | sb==88 | sc==88 | sd==88; % Thin First year ice stage 1 [30 - <50 cm]
a9 = sa==89 | sb==89 | sc==89 | sd==89; % Thin First year ice stage 2 [50 - <70 cm]
n1 = sa==91 | sb==91 | sc==91 | sd==91; % Medium First year ice [70 - <120 cm]
n3 = sa==93 | sb==93 | sc==93 | sd==93; % Thick First year ice [>120 cm]



figure;
plot_dim(1000,300);
plot(dn, sum(a6));
hold on
plot(dn, sum(a7));
plot(dn, sum(n1),'m');
plot(dn, sum(n3),'c');
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('First Year Ice [>=30 - 200 cm]', 'Thin FYI [30 - <70 cm]', 'Med. FYI [70 - <120 cm]', 'Thick FYI [>120 cm]');
title('AA shelf abundance of first year ice category use');
xlim([min(dn)-50, max(dn)+50]);
%print('ICE/ICETHICKNESS/Figures/Shapefiles/Category_use/AAshelf_firstyears.png', '-dpng', '-r400')

%% What about other thin ice categories?

a1 = sa==81 | sb==81 | sc==81 | sd==81; % new ice [<10 cm]
a2 = sa==82 | sb==82 | sc==82 | sd==82; % Nilas, Ice Rind [<10 cm]
a3 = sa==83 | sb==83 | sc==83 | sd==83; % Young Ice [10 - <30 cm]
a4 = sa==84 | sb==84 | sc==84 | sd==84; % Grey Ice [10 - <15 cm]
a5 = sa==85 | sb==85 | sc==85 | sd==85; % Grey-White Ice [15 - <30 cm]

% Total number represented: 
%  --> a1: 7670902
%  --> a2: 5558
%  --> a3: 18969572
%  --> a4: 0
%  --> a5: 2324

figure;
plot_dim(1000,300);
plot(dn, sum(a1));
hold on
plot(dn, sum(a2), 'c');
plot(dn, sum(a3));
%plot(dn, sum(a4)); % never occurred
plot(dn, sum(a5), 'm');

xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('New Ice [<10 cm]', 'Nilas [<10 cm]', 'Young Ice [10 - <30 cm]', 'Grey-White Ice [15 - <30 cm]');
title('AA shelf abundance of first year ice vs thin first year ice category use');
xlim([min(dn)-50, max(dn)+50]);
%print('ICE/ICETHICKNESS/Figures/Shapefiles/Category_use/AAshelf_otherThinIce.png', '-dpng', '-r400')




%% What about thick categories


n5 = sa==95 | sb==95 | sc==95 | sd==95; % old ice [265 cm]
n6 = sa==96 | sb==96 | sc==96 | sd==96; % second year ice [215 cm]
n7 = sa==97 | sb==97 | sc==97 | sd==97; % multi-year ice [300 cm]


figure;
plot_dim(1000,300);
plot(dn, sum(n5));
hold on
plot(dn, sum(n6));
plot(dn, sum(n7));

xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend('Old Ice [265 cm]', 'Second Year Ice [215 cm]', 'Multi-Year Ice [300 cm]');
title('AA shelf abundance of old ice category use');
xlim([min(dn)-50, max(dn)+50]);

print('ICE/ICETHICKNESS/Figures/Shapefiles/Category_use/AAshelf_thickIce.png', '-dpng', '-r400')







%% Partial Concentration
ca = SIT.ca; cb = SIT.cb; cc = SIT.cc; cd = SIT.cd;
ca(ca<=0) = nan; ca(ca==99) = nan;
cb(cb<=0) = nan; cb(cb==99) = nan;
cc(cc<=0) = nan; cc(cc==99) = nan;
cd(cd<=0) = nan; cd(cd==99) = nan;

%%




ticker = dnticker(1997,2022,1,1);

figure;
plot_dim(1000,300);
p1 = plot(dn, nanmean(ca));
hold on
p2 = plot(dn, nanmean(cb));
p3 = plot(dn, nanmean(cc));
p4 = plot(dn, nanmean(cd));
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(27)
legend([p1,p2,p3,p4],'CA', 'CB', 'CC', 'CD', 'orientation', 'horizontal', 'location', 'southwest');
title('AA shelf mean stage of development values');
xlim([min(dn)-50, max(dn)+50]);
%ylim([75,100]);

%print('ICE/ICETHICKNESS/Figures/Shapefiles/Category_use/AAshelf_meanSOD.png', '-dpng', '-r400')
















