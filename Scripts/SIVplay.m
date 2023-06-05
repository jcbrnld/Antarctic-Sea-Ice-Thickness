% Jacob Arnold

% 05-May-2022

% Play with SIV timeseries

for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end

     load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    p = polyfit(seaice.dn, seaice.SIV, 1);
    y = polyval(p, seaice.dn);
    slope = (((y(2)-y(1))/y(1))*100)*521.77; % weeks in a decade


    figure; 
    plot_dim(900,270);
    plot(seaice.dn, seaice.SIV, 'color', [0.9,0.4,0.4], 'linewidth', 1.2);
    hold on;
    midtick = dnticker(1997,2022,7,1);
    for tt = 1:length(midtick)
        xline(midtick(tt), 'color', [0.8,0.8,0.8], 'linewidth', 0.7);
    end
    pline = plot(seaice.dn, y, '--','color', [.02,.02,.02], 'linewidth', 1.2);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm/yyyy', 'keepticks');
    xtickangle(26);
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Sector ',sector,' Sea Ice Volume'])
    legend(pline, ['Slope = ',num2str(slope), ' %dec^-^1'], 'fontsize', 13);
    ylabel('Sea Ice Volume [km^3]');
    grid on
    %print(['ICE/ICETHICKNESS/Figures/Sectors/sector',sector,'/sector',sector,'SIV.png'], '-dpng', '-r500');

end


%% try some filtered data too

fSIV = filtout(seaice.SIV,104);


p = polyfit(seaice.dn, seaice.SIV, 1);
y = polyval(p, seaice.dn);
slope = (((y(2)-y(1))/y(1))*100)*521.77; % weeks in a decade


figure; 
plot_dim(1100,300);
plot(seaice.dn, seaice.SIV, 'color', [0.8,0.38,0.35], 'linewidth', 1.2);
hold on;
pline = plot(seaice.dn, y, '--','color', [.02,.02,.02], 'linewidth', 1.2);
plot(seaice.dn, fSIV, 'linewidth', 1.2, 'color', [0.3,0.4,0.7])
xticks(dnticker(1997,2022));
datetick('x', 'mm/yyyy', 'keepticks');
xtickangle(26);
xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
title(['Sector ',sector,' Sea Ice Volume'])
legend(pline, ['Slope = ',num2str(slope), ' %dec^-^1'], 'fontsize', 13);
grid on



%% Try detrended anomaly

dt = seaice.SIV-y;

figure;
plot_dim(1100,300);
plot(seaice.dn, dt, 'color', [0.2,0.5,0.7], 'linewidth', 1.2);
xticks(dnticker(1997,2022));
datetick('x', 'mm/yyyy', 'keepticks');
xtickangle(26);
xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
title(['Sector ',sector,' Detrended Sea Ice Volume Anomaly'])
grid on



%% Seasonal trends

offshore = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po', 'so'};
onames = {'Subpolar Atlantic', 'Subpolar Indian', 'Subpolar Pacific', 'ACC Antlantic', 'ACC Indian', 'ACC Pacific', 'Southern Hemisphere'};


for ii = 19:25
    if ii < 10
        sector = ['0', num2str(ii)];
    elseif ii>=10 & ii<19
        sector = num2str(ii);
    elseif ii >=19
        sector = offshore{ii-18};
    end
    if ii < 19
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat']);
    end

    wint = find((seaice.dv(:,2)==6 & seaice.dv(:,3)>=16) | (seaice.dv(:,2)==7) | (seaice.dv(:,2)==8) | (seaice.dv(:,2)==9 & seaice.dv(:,3)<=15));
    summ = find((seaice.dv(:,2)==12 & seaice.dv(:,3)>=16) | (seaice.dv(:,2)==1) | (seaice.dv(:,2)==2) | (seaice.dv(:,2)==3 & seaice.dv(:,3)<=15));
    

    p = polyfit(seaice.dn, seaice.SIV, 1);
    pw = polyfit(seaice.dn(wint), seaice.SIV(wint), 1);
    ps = polyfit(seaice.dn(summ), seaice.SIV(summ), 1);
    y = polyval(p, seaice.dn);
    yw = polyval(pw, seaice.dn(wint));
    ys = polyval(ps, seaice.dn(summ));
    slope = (((y(2)-y(1))/y(1))*100)*521.77; % weeks in a decade
    slopew = (((yw(2)-yw(1))/yw(1))*100)*521.77; % weeks in a decade
    slopes = (((ys(2)-ys(1))/ys(1))*100)*521.77; % weeks in a decade


    figure; 
    plot_dim(900,270);
    plot(seaice.dn, seaice.SIV, 'color', [0.2,0.2,0.2], 'linewidth', 1.2);
    hold on;
    midtick = dnticker(1997,2022,7,1);
    for tt = 1:length(midtick)
        xline(midtick(tt), 'color', [0.8,0.8,0.8], 'linewidth', 0.7);
    end
    scatter(seaice.dn(wint), seaice.SIV(wint), 20, [0.1,0.4,0.8], 'filled');
    scatter(seaice.dn(summ), seaice.SIV(summ), 20, [0.9,0.3,0.3], 'filled')
    pline = plot(seaice.dn, y, '--','color', [0.2,0.2,0.2], 'linewidth', 1.2);
    plinew = plot(seaice.dn(wint), yw, '--', 'color', [0.1,0.4,0.8], 'linewidth', 1.2);
    plines = plot(seaice.dn(summ), ys, '--', 'color', [0.9,0.3,0.3], 'linewidth', 1.2);
    
    xticks(dnticker(1997,2022));
    datetick('x', 'mm/yyyy', 'keepticks');
    xtickangle(26);
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    if ii < 19
        title(['Sector ',sector,' Sea Ice Volume with winter [16-jun:15-Sep, blue] and summer [16-Dec:15-Mar, orange] trends'])
        saveloc = 'Sectors/sector';
    else
        title([onames{ii-18},' Sea Ice Volume with winter [16-jun:15-Sep, blue] and summer [16-Dec:15-Mar, orange] trends'])
        saveloc = 'Zones/';
    end
  
    legend([pline, plinew, plines], ['Slope = ',num2str(slope), ' %dec^-^1'],['Slope = ',num2str(slopew),...
        ' %dec^-^1'],['Slope = ',num2str(slopes), ' %dec^-^1'], 'fontsize', 12, 'orientation', 'horizontal');
    ylabel('Sea Ice Volume [km^3]');
    grid on
    %print(['ICE/ICETHICKNESS/Figures/',saveloc,sector,'/sector',sector,'SIVseasonalTrends.png'], '-dpng', '-r500');

    clearvars -except offshore onames
end









%% seasonal but using yearly average as primary

offshore = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po', 'so'};
onames = {'Subpolar Atlantic', 'Subpolar Indian', 'Subpolar Pacific', 'ACC Antlantic', 'ACC Indian', 'ACC Pacific', 'Southern Hemisphere'};

for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    elseif ii>=10 & ii<19
        sector = num2str(ii);
    elseif ii >=19
        sector = offshore{ii-18};
    end
    if ii < 19
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat']);
    end
    wint = find((seaice.dv(:,2)==6 & seaice.dv(:,3)>=16) | (seaice.dv(:,2)==7) | (seaice.dv(:,2)==8) | (seaice.dv(:,2)==9 & seaice.dv(:,3)<=15));
    summ = find((seaice.dv(:,2)==12 & seaice.dv(:,3)>=16) | (seaice.dv(:,2)==1) | (seaice.dv(:,2)==2) | (seaice.dv(:,2)==3 & seaice.dv(:,3)<=15));
    years = 1998:2021;
    for yy = 1:length(years);
        yind = find(seaice.dv(:,1)==years(yy));
        ymean(yy) = nanmean(seaice.SIV(yind));
        mdn(yy) = nanmean(seaice.dn(yind));
        clear yind
    end

    p = polyfit(mdn, ymean, 1);
    pw = polyfit(seaice.dn(wint), seaice.SIV(wint), 1);
    ps = polyfit(seaice.dn(summ), seaice.SIV(summ), 1);
    y = polyval(p, mdn);
    yw = polyval(pw, seaice.dn(wint));
    ys = polyval(ps, seaice.dn(summ));
    slope = (((y(2)-y(1))/y(1))*100)*10; % weeks in a decade
    slopew = (((yw(2)-yw(1))/yw(1))*100)*521.77; % weeks in a decade
    slopes = (((ys(2)-ys(1))/ys(1))*100)*521.77; % weeks in a decade


    figure; 
    plot_dim(900,270);
    plot(seaice.dn, seaice.SIV, 'color', [0.2,0.2,0.2], 'linewidth', 1.2);
    hold on;
    midtick = dnticker(1997,2022,7,1);
    for tt = 1:length(midtick)
        xline(midtick(tt), 'color', [0.8,0.8,0.8], 'linewidth', 0.7);
    end
    scatter(mdn, ymean, 100, 'm', 'filled')
    scatter(seaice.dn(wint), seaice.SIV(wint), 20, [0.1,0.4,0.8], 'filled');
    scatter(seaice.dn(summ), seaice.SIV(summ), 20, [0.9,0.3,0.3], 'filled')
    pline = plot(mdn, y, '--','color', [0.2,0.2,0.2], 'linewidth', 1.2);
    plinew = plot(seaice.dn(wint), yw, '--', 'color', [0.1,0.4,0.8], 'linewidth', 1.2);
    plines = plot(seaice.dn(summ), ys, '--', 'color', [0.9,0.3,0.3], 'linewidth', 1.2);
    
    xticks(dnticker(1997,2022));
    datetick('x', 'mm/yyyy', 'keepticks');
    xtickangle(26);
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    
    legend([pline, plinew, plines], ['Slope = ',num2str(slope), ' %dec^-^1'],['Slope = ',num2str(slopew),...
        ' %dec^-^1'],['Slope = ',num2str(slopes), ' %dec^-^1'], 'fontsize', 12, 'orientation', 'horizontal');
    ylabel('Sea Ice Volume [km^3]');
    grid on
    if ii < 19
        title(['Sector ',sector,' Sea Ice Volume with winter [16-jun:15-Sep, blue] and summer [16-Dec:15-Mar, orange] trends'])
        saveloc = 'Sectors';
    else
        title([onames{ii},' Sea Ice Volume with winter [16-jun:15-Sep, blue] and summer [16-Dec:15-Mar, orange] trends'])
        saveloc = 'Zones';
    end
    %print(['ICE/ICETHICKNESS/Figures/',saveloc,'/sector',sector,'/sector',sector,'SIVseasonalTrends.png'], '-dpng', '-r500');

    clearvars -except offshore onames
end




















