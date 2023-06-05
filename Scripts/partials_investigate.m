% Jacob Arnold

% 24-Feb-2022

% Create plots of relative abundance of 99s and -9s in raw gridded data


% Sector 17
sector = '17';
load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector17_shpE00.mat']);
E00 = SIT; clear SIT

load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector17_shpSIG.mat']);
SIG = SIT; clear SIT;

SIT.dn = [E00.dn; SIG.dn];

SIT.ca = [E00.ca, SIG.ca];
SIT.cb = [E00.cb, SIG.cb];
SIT.cc = [E00.cc, SIG.cc];
SIT.cd = [E00.cd, SIG.cd];
SIT.ct = [E00.ct, SIG.ct];
SIT.sa = [E00.sa, SIG.sa];
SIT.sb = [E00.sb, SIG.sb];
SIT.sc = [E00.sc, SIG.sc];
SIT.sd = [E00.sd, SIG.sd];

SIT.lon = SIG.lon;
SIT.lat = SIG.lat;

%%

ticker = dnticker(1997,2022);
figure
plot_dim(800,200);
plot(SIT.dn, (sum(SIT.ca==99 | isnan(SIT.ca))./length(SIT.lon)).*100, 'linewidth', 1.2);
hold on
plot(SIT.dn, (sum(SIT.cb==99 | isnan(SIT.cb))./length(SIT.lon)).*100, 'linewidth', 1.2);
plot(SIT.dn, (sum(SIT.cc==99 | isnan(SIT.cc))./length(SIT.lon)).*100, 'linewidth', 1.2);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
ylabel('% of grid');
title(['Sector ',sector,' Partial concentrations == 99']);
legend('CA', 'CB', 'CC');

%print(['ICE/ICETHICKNESS/Figures/Diagnostic/raw_gridded_properties/sector',sector,'Cn99.png'], '-dpng', '-r500');



%%
ticker = dnticker(1997,2022);
figure
plot_dim(800,200);
plot(SIT.dn, (sum(SIT.sa==99 | isnan(SIT.sa))./length(SIT.lon)).*100, 'linewidth', 1.2);
hold on
plot(SIT.dn, (sum(SIT.sb==99)./length(SIT.lon)).*100, 'linewidth', 1.2);
plot(SIT.dn, (sum(SIT.sc==99)./length(SIT.lon)).*100, 'linewidth', 1.2);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
ylabel('% of grid');
title(['Sector ',sector,' Stage of Developments == 99']);
legend('SA', 'SB', 'SC');

%print(['ICE/ICETHICKNESS/Figures/Diagnostic/raw_gridded_properties/sector',sector,'Sn99.png'], '-dpng', '-r500');


%%

ticker = dnticker(1997,2022);
figure
plot_dim(800,200);
plot(SIT.dn, (sum(SIT.ca==-9 & SIT.sa==-9 & SIT.ct~=0)./length(SIT.lon)).*100, 'linewidth', 1.2);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
ylabel('% of grid');
title(['Sector ',sector,' CA == -9 and SA == -9 and CT ~= 0']);


print(['ICE/ICETHICKNESS/Figures/Diagnostic/raw_gridded_properties/sector',sector,'CaSa-9.png'], '-dpng', '-r500');

