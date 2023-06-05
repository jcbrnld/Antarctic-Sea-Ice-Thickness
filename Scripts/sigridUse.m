% Jacob Arnold

% 28-Feb-2021

% Reveiw raw gridded data - check temporal change of specific ice type use


sector = '01';

if str2num(sector) == 0;
    load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector00_all.mat
else
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat']);
    E00 = SIT; clear SIT;
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']);
    SIG = SIT; clear SIT;

    SIT.lon = SIG.lon; SIT.lat = SIG.lat;
    SIT.dn = [E00.dn;SIG.dn]; SIT.dv = [E00.dv; SIG.dv];

    SIT.ca = [E00.ca, SIG.ca];
    SIT.cb = [E00.cb, SIG.cb];
    SIT.cc = [E00.cc, SIG.cc];
    SIT.cd = [E00.cd, SIG.cd];
    SIT.ct = [E00.ct, SIG.ct];
    SIT.sa = [E00.sa, SIG.sa];
    SIT.sb = [E00.sb, SIG.sb];
    SIT.sc = [E00.sc, SIG.sc];
    SIT.sd = [E00.sd, SIG.sd];
end


%% stage of development 

% use of old ice vs second year or multi year
% Interesting. Old Ice is basically the only category of the three used and
% it is only used in SA and SB
% SA shows decreasing use of old ice and SB increasing
% When the two are combined the trend is decreasing. 


% sa
saold = (sum(SIT.sa==95)./length(SIT.lon)).*100; % percent use OLD ICE
sasy = (sum(SIT.sa==96)./length(SIT.lon)).*100; % second year ice
samy = (sum(SIT.sa==97)./length(SIT.lon)).*100; % multi-year ice


ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300)
plot(SIT.dn, saold);
hold on
plot(SIT.dn, sasy);
plot(SIT.dn, samy);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);

% sb
sbold = (sum(SIT.sb==95)./length(SIT.lon)).*100; % percent use OLD ICE
sbsy = (sum(SIT.sb==96)./length(SIT.lon)).*100; % second year ice
sbmy = (sum(SIT.sb==97)./length(SIT.lon)).*100; % multi-year ice


ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300)
plot(SIT.dn, sbold);
hold on
plot(SIT.dn, sbsy);
plot(SIT.dn, sbmy);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);

% sc
scold = (sum(SIT.sc==95)./length(SIT.lon)).*100; % percent use OLD ICE
scsy = (sum(SIT.sc==96)./length(SIT.lon)).*100; % second year ice
scmy = (sum(SIT.sc==97)./length(SIT.lon)).*100; % multi-year ice


ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300)
plot(SIT.dn, scold);
hold on
plot(SIT.dn, scsy);
plot(SIT.dn, scmy);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);


% ab sum
abold = sum([saold; sbold]);
ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300)
plot(SIT.dn, abold);

xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);

