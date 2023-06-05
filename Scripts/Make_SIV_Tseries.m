% Jacob Arnold

% 28-Mar-2023

% Make better SIV plots


load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat;
SIV = SIT.SIV./10000; % units are 10^4 km^3
dn = SIT.dn;
dv = SIT.dv;

%%

figure;plot_dim(700,170)
plot(dn, SIV, 'color', [0.01,.01,.01], 'linewidth', 1.1);

xticks(dnticker(1997,2023));

datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
title('All Antarctic SIV');
grid on
ylim([0,2.7])

%print('ICE/ICETHICKNESS/Figures/SIV/all_Antarctic/aa_SIV.png', '-dpng', '-r400');


%% remove seasonality with 104 week low pass filter 

fSIV10 = filtout(SIV, 10);
fSIV104 = filtout(SIV, 104);

figure;plot_dim(700,170)
plot(dn, fSIV10, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
hold on
plot(dn, fSIV104, 'color', [0.01,.01,.01], 'linewidth', 1.1);
xticks(dnticker(1997,2023));

datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
title('All Antarctic SIV');
grid on
ylim([0,2.7])

%print('ICE/ICETHICKNESS/Figures/SIV/all_Antarctic/aa_SIV_102weekfilt.png', '-dpng', '-r400');


%% ENSO or SAM? 

load ICE/ENSO_SAM/indices.mat

%%

SAM = indices.mySAM;
ENSO = indices.myENSO;
fSAM = filtout(SAM, 104);
fENSO = filtout(ENSO, 104);


fSIV = filtout(SIV, 104);

figure;plot_dim(700,170)
plot(dn, SIV, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
hold on
plot(dn, fSIV, 'color', [0.01,.01,.01], 'linewidth', 1.1);
xticks(dnticker(1997,2023));
ylim([0,2.7])
datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
% ENSO
yyaxis right
plot(dn, fENSO, 'm', 'linewidth', 1.1);
hold on
plot(dn, fSAM, 'c', 'linewidth', 1.1);
ylim([-5,5])
title('All Antarctic SIV');
grid on


%% Compare indices to just winter max

years = unique(dv(:,1));years(1) = [];
for ii =1:length(years)
    dloc = find(dv(:,1)==years(ii));
    tsiv = SIV(dloc);
    maxloc = find(tsiv==max(tsiv));
    peakSIV(ii) = tsiv(maxloc);
    peakdn(ii) = dn(dloc(maxloc));
    
    clear dloc tsiv maxloc
end

figure;plot_dim(700,170)
plot(dn, SIV, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
hold on
plot(peakdn, peakSIV, 'color', [0.01,.01,.01], 'linewidth', 1.1);
xticks(dnticker(1997,2023));
ylim([0,2.7])
datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
% ENSO
yyaxis right
plot(dn, fENSO, 'm', 'linewidth', 1.1);
hold on
plot(dn, fSAM, 'c', 'linewidth', 1.1);
ylim([-5,5])
title('All Antarctic SIV');
grid on

%% remove average months data each year

for ii = 1:12
    dloc = find(dv(:,2)==ii);
    mmean(ii) = nanmean(SIV(dloc));
end

for ii = 1:length(dn)
    month = dv(ii,2);
    mmSIV(ii) = SIV(ii)-mmean(month); % minus month SIV
end

figure;plot_dim(700,170)
plot(dn, SIV, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
hold on
plot(dn, mmSIV, 'color', [0.01,.01,.01], 'linewidth', 1.1);
xticks(dnticker(1997,2023));
ylim([0,2.7])
datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
% ENSO
yyaxis right
plot(dn, fENSO, 'm', 'linewidth', 1.1);
hold on
plot(dn, fSAM, 'c', 'linewidth', 1.1);
ylim([-5,5])
title('All Antarctic SIV');
grid on
    
    

%% PLOT ALL years' data together (on top of each other)
tickerdv(:,2) = [01;04;07;10;01];
tickerdv(:,1) = 2000; tickerdv(end,1) = 2001;
tickerdv(:,3) = 1;
ticker = datenum(tickerdv);

years = unique(dv(:,1));
figure; plot_dim(400,170);
for ii = 1:length(years)
    ind = find(dv(:,1)==years(ii));
    tdv = dv(ind,:);
    tdv(:,1)=2000;
    tdn = datenum(tdv);
    plot(tdn, SIV(ind), 'color', [.01,.01,.01,.3],'linewidth', 1);
    hold on
    
    minloc = find(SIV(ind)==min(SIV(ind)));
    mindv(ii,:) = tdv(minloc,:);
    mindv(ii,1) = years(ii);
    
    maxloc = find(SIV(ind)==max(SIV(ind)));
    maxdv(ii,:) = tdv(maxloc,:);
    maxdv(ii,1) = years(ii);
    
    minval(ii) = min(SIV(ind));
    maxval(ii) = max(SIV(ind));

    
    clear ind tdv tdn
end
xticks(ticker);
datetick('x', 'mmm', 'keepticks');
xlim([min(ticker)-10, max(ticker)+10]);
ylim([0,2.6]);
yticks([0:0.5:3])
ylabel('SIV [10^4 km^3]');
ax = gca;
ax.FontSize = 16

print('ICE/ICETHICKNESS/Figures/SIV/all_Antarctic/aa_SIV_yearcycles.png', '-dpng', '-r300');
minval = minval(2:end);
maxval = maxval(2:end);
mi = mean(minval);
ma = mean(maxval);

%% timeseries with mean max and min bars
fSIV10 = filtout(SIV, 10);
figure;plot_dim(450,150)
plot(dn, fSIV10, 'color', [0.01,.01,.01], 'linewidth', 1.1);

xticks(dnticker(1997,2023));

datetick('x', 'yy', 'keepticks');
xlim([min(dn)-50, max(dn)+50]);
ylabel('SIV [10^4 km^3]');
title('All Antarctic SIV');
grid on
ylim([0,2.8])
yline(mi, '--', 'color', [.01,.01,.01]);
yline(ma, '--', 'color', [.01,.01,.01]);

print('ICE/ICETHICKNESS/Figures/SIV/all_Antarctic/aa_SIV_withmaxmin.png', '-dpng', '-r400');
%print('ICE/ICETHICKNESS/Figures/SIV/all_Antarctic/aa_SIV_withmaxmin.eps', '-depsc', '-r400');


%% SIV histogram 

figure; plot_dim(500,300);
histogram(SIV, 50, 'FaceColor', [.01,.01,.01], 'edgecolor', [.9,.9,.9]);






