% Jacob Arnold

% 11-Feb-2022

% RERUN BUT ADD Atlantic, Indian, and Pacific regions

% Check out sea ice properties from newly created structures 
zones = {'00', 'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po', 'offshore', 'so'};

for ss = 27

    if ss < 10
        sector = ['0', num2str(ss)];
    elseif ss >= 10 & ss <= 18
        sector = num2str(ss);
    else
        sector = zones{ss-18};
    end
    
    if ss <= 19
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat']);
    end
   %%% Sea Ice Volume

    ticker = dnticker(1997,2022);
    ticker2 = dnticker(1997,2022,7);

    figure;
    plot_dim(1000,300);
    plot(seaice.dn, seaice.SIV, 'color', [0.95, 0.2, 0.3], 'linewidth', 1.1); hold on
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    grid on
    for ii = 1:length(ticker2)
        xline(ticker2(ii), 'color', [0.7,0.7,0.7,0.3], 'linewidth', 0.3);
    end
    xtickangle(27)
    title(['Sector ',sector,' Sea Ice Volume'], 'fontsize', 13)
    ylabel('Sea Ice Volume [km^3]', 'fontsize', 13);


    p = polyfit(seaice.dn, seaice.SIV',1);
    y = polyval(p, seaice.dn);

    % Get slope 52.18 weeks in a year ~522 weeks in 10 years
    slope = y(622)-y(101);
    slopeper = (slope/y(101))*100;

    trend = plot(seaice.dn, y, '--', 'color', [0.2,0.2,0.2], 'linewidth', 1.5);

    legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14);

    if ss <= 19
        print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'SIV.png'], '-dpng', '-r500');
    else
        print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'SIV.png'], '-dpng', '-r500');
    end

    %%% SIV with linear fit before and from 2008 (chart data quality
    %%% increased after 2007
    ticker = dnticker(1997,2022);
    ticker2 = dnticker(1997,2022,7);

    figure;
    plot_dim(1000,300);
    plot(seaice.dn, seaice.SIV, 'color', [0.95, 0.2, 0.3], 'linewidth', 1.1); hold on
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    grid on
    for ii = 1:length(ticker2)
        xline(ticker2(ii), 'color', [0.7,0.7,0.7,0.3], 'linewidth', 0.3);
    end
    xtickangle(27)
    title(['Sector ',sector,' Sea Ice Volume with linear fits for 1997-2007 and 2008 to 2021'], 'fontsize', 13)
    ylabel('Sea Ice Volume [km^3]', 'fontsize', 13);

    nind = find(seaice.dv(:,1)>=2008); 
    oind = find(seaice.dv(:,1)<2008);
    p1 = polyfit(seaice.dn(oind), seaice.SIV(oind)',1);
    y1 = polyval(p1, seaice.dn(oind));
    p2 = polyfit(seaice.dn(nind), seaice.SIV(nind)',1);
    y2 = polyval(p2, seaice.dn(nind));

    % Get slope 52.18 weeks in a year ~522 weeks in 10 years
    slope1 = y1(522)-y1(1);
    slopeper1 = (slope1/y1(101))*100;
    slope2 = y2(end)-y2(end-260);slope2 = slope2*2;
    slopeper2 = (slope2/y2(end-260))*100;

    trend1 = plot(seaice.dn(oind), y1, '--', 'color', [.2,.35,.65,.8], 'linewidth', 1.5);
    trend2 = plot(seaice.dn(nind), y2, '--', 'color', [.25,.7,.15,.8], 'linewidth', 1.5);

    legend([trend1, trend2], ['Slope = ',num2str(slopeper1),'% dec^-^1'], ['Slope = ',num2str(slopeper2),'% dec^-^1'], 'fontsize', 14);

    if ss <= 19
        print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'SIV_2.png'], '-dpng', '-r500');
    else
        print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'SIV_2.png'], '-dpng', '-r500');
    end


    %%% SIA 

    ymax = max(seaice.SIE)+1500;
    ticker = dnticker(1997,2022);
    ticker2 = dnticker(1997,2022,7);

    figure;
    plot_dim(1000,300);
    plot(seaice.dn, seaice.SIA/1000, 'color', [0.2, 0.5, 0.75], 'linewidth', 1.1); hold on
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    grid on
    for ii = 1:length(ticker2)
        xline(ticker2(ii), 'color', [0.7,0.7,0.7,0.3], 'linewidth', 0.3);
    end
    xtickangle(27)
    title(['Sector ',sector,' Sea Ice Area'], 'fontsize', 13)
    ylabel('Sea Ice Area [x 10^3 km^2]', 'fontsize', 13);
    ylim([0,ymax/1000])

    p = polyfit(seaice.dn, seaice.SIA'./1000,1);
    y = polyval(p, seaice.dn);

    % Get slope 52.18 weeks in a year ~522 weeks in 10 years
    slope = y(622)-y(101);
    slopeper = (slope/y(101))*100;

    trend = plot(seaice.dn, y, '--', 'color', [.2,.2,.2], 'linewidth', 1.5);

    %legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14);
    if num2str(sector)~=18
        legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14, 'location', 'southeast');
    else
        legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14, 'location', 'northeast');
    end

    if ss <= 19
        print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'SIA.png'], '-dpng', '-r500');
    else
        print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'SIA.png'], '-dpng', '-r500');
    end

    %%% SIE
    ymax = max(seaice.SIE)+2000;
    ticker = dnticker(1997,2022);
    ticker2 = dnticker(1997,2022,7);

    figure;
    plot_dim(1000,300);
    plot(seaice.dn, seaice.SIE/1000, 'color', [0.4, 0.7, 0.3], 'linewidth', 1.1); hold on
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    grid on
    for ii = 1:length(ticker2)
        xline(ticker2(ii), 'color', [0.7,0.7,0.7,0.3], 'linewidth', 0.3);
    end
    xtickangle(27)
    title(['Sector ',sector,' Sea Ice Extent'], 'fontsize', 13)
    ylabel('Sea Ice Extent [x 10^3 km^2]', 'fontsize', 13);
    ylim([0,ymax/1000])

    p = polyfit(seaice.dn, seaice.SIE'./1000,1);
    y = polyval(p, seaice.dn);

    % Get slope 52.18 weeks in a year ~522 weeks in 10 years
    slope = y(622)-y(101);
    slopeper = (slope/y(101))*100;

    trend = plot(seaice.dn, y, '--', 'color', [.2,.2,.2], 'linewidth', 1.5);
    if num2str(sector)~=18
        legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14, 'location', 'southeast');
    else
        legend([trend], ['Slope = ',num2str(slopeper),'% dec^-^1'], 'fontsize', 14, 'location', 'northeast');
    end

    if ss <= 19
        print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'SIE.png'], '-dpng', '-r500');
    else
        print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'SIE.png'], '-dpng', '-r500');
    end




drawnow

    %%% Now on to spatial... 

    % start with record length average

    if ss <= 18
        [londom, latdom] = sectordomain(ss);
        sdots = sectordotsize(ss);
    elseif ss == 25
        sdots = 1.5;
    else
        sdots = 7;
    end

    if ss<=18
        m_basemap('a', londom, latdom)
        sectorexpand(str2num(sector));
    elseif ss==19 % sector00
        m_basemap('m', [0,360], [-79,-60.3]);
        plot_dim(1200,320);
    else
        m_basemap('p', [0,360], [-90,-51]);
        plot_dim(1000,800);
        m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
        textloc = [-0.1, 0];
    end

    datzer = seaice.meanH>0;

    m_scatter(seaice.lon(datzer), seaice.lat(datzer),  sdots, seaice.meanH(datzer), 's', 'filled')

    if ss > 19
        text(textloc(1), textloc(2), {[sector,'Record Length Mean'], 'Sea Ice Thickness [m]'}, 'fontsize', 15, 'fontweight', 'bold');
    else
        xlabel(['Sector',sector,' Record Length Mean SIT [m]'], 'fontsize', 14, 'fontweight', 'bold');
    end

    ind1 = find(seaice.meanH<=0.05 & seaice.meanH>0);
    ind2 = find(seaice.meanH>0.05 & seaice.meanH<0.2);

    cmap = colormap(colormapinterp(mycolormap('id3'),11, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
    caxis([-0.2,2]);

     m_scatter(seaice.lon(ind2), seaice.lat(ind2), sdots, cmap(2,:), 's','filled'); % 
     m_scatter(seaice.lon(ind1), seaice.lat(ind1), sdots, cmap(1,:), 's','filled'); % 
    cbh = colorbar;
    cbh.Ticks = [-0.2:0.2:1.8];
    %cbh.Label.String = ('[m]');
    cbh.FontSize = 15;
    % cbh.Label.FontSize = 17;
    % cbh.Label.FontWeight = 'bold';
    % cbh.Label.Rotation = 0;
    % cbh.Label.Margin = 4;

    cbh.TickLabels = {'0','0.05','0.2','0.4','0.6','0.8','1','1.2','1.4','1.6', '1.8', '2'};


    if ss <= 19
        print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'_meanH.png'], '-dpng', '-r500');
    else
        print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'_meanH.png'], '-dpng', '-r500');
    end



    clearvars -except zones
    close all

end








%% monthly averages 
month = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
if ss <= 18
    [londom, latdom] = sectordomain(num2str(ss));
    sdots = sectordotsize(str2num(sec));
elseif ss == 25
    sdots = 1.5;
else
    sdots = 7;
end
for ii = 1:12
    if ss<=18
        m_basemap('a', londom, latdom)
        sectorexpand(str2num(sector));
    elseif ss==25 % sector00
        m_basemap('m', [0,360], [-79,-60.3]);
        plot_dim(1200,320);
    else
        m_basemap('p', [0,360], [-90,-51]);
        plot_dim(1000,800);
        m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
        textloc = [-0.1, 0];
    end

    datzer = seaice.MONTH_AV(:,ii)>0;

    m_scatter(seaice.lon(datzer), seaice.lat(datzer),  sdots, seaice.MONTH_AV(datzer,ii), 's', 'filled')
   
    if sector > 18
        text(textloc(1), textloc(2), [month{ii}, ' Mean SIT'], 'fontsize', 15, 'fontweight', 'bold');
    else
        title(month{ii}, ' Mean SIT');
    end
   
    ind1 = find(seaice.MONTH_AV(:,ii)<=0.05 & seaice.MONTH_AV(:,ii)>0);
    ind2 = find(seaice.MONTH_AV(:,ii)>0.05 & seaice.MONTH_AV(:,ii)<0.2);
    
    cmap = colormap(colormapinterp(mycolormap('id3'),12, [0,0,0], [0.99    0.76    0.6469])); % ASSIGN this color to 0
    caxis([-0.2,2.2]);
    
     m_scatter(seaice.lon(ind2), seaice.lat(ind2), sdots, cmap(2,:), 's','filled'); % 
     m_scatter(seaice.lon(ind1), seaice.lat(ind1), sdots, cmap(1,:), 's','filled'); % 
    cbh = colorbar;
    cbh.Ticks = [-0.2:0.2:2];
    cbh.Label.String = ('Sea Ice Thickness [m]');
    cbh.FontSize = 15;
    cbh.Label.FontSize = 19;
    cbh.Label.FontWeight = 'bold';

    cbh.TickLength = 0.048;
    cbh.TickLabels = {'0','0.05','0.2','0.4','0.6','0.8','1','1.2','1.4','1.6', '1.8', '2'};
    cbh.Position = [0.82 0.3 0.027 0.6]; 
     
    
    
    
    
end






















