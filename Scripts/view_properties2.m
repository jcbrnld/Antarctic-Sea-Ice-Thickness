% Jacob Arnold

% 06-Apr-2022

% Make Trend plots of all remaining variables for all sectors
% need to include:
% SID, iSPD, SI uvel, SI vvel, wind speed, wind divergence, wind curl, sst,
% t2m, sp

% Use view_properties as inspiration. 

sector = '10';
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);


properties = {'SID', 'ispd', 'iu', 'iv', 'wspd', 'wdiv', 'wcurl', 'sst', 't2m', 'sp'};

longnames = {'Sea Ice Divergence', 'Sea Ice Speed', 'Sea Ice U Velocity', 'Sea Ice V Velocity',...
    'Wind Speed', 'Wind Divergence', 'Wind Curl', 'Sea Surface Temperature', 'Surface Air Temperature',...
    'Surface Pressure'};

units = {'1/s', 'cm/s', 'cm/s', 'cm/s', 'm/s', '1/s', 'N/m^3', '\circC', '\circC', 'hPa'};

for pp = 1:length(properties);
    
    word = ['property = seaice.',properties{pp}];
    eval(word);

    ymax = max(property);
    ymin = min(property);
    ticker = dnticker(1997,2022);
    ticker2 = dnticker(1997,2022,7);

    figure;
    plot_dim(1000,300);
    plot(seaice.dn, property, 'color', [0.4, 0.7, 0.3], 'linewidth', 1.1); hold on
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    grid on
    for ii = 1:length(ticker2)
        xline(ticker2(ii), 'color', [0.7,0.7,0.7,0.3], 'linewidth', 0.3);
    end
    xtickangle(27)
    title(['Sector ',sector,' ',longnames{pp}], 'fontsize', 13)
    ylabel([longnames{pp},' [',units{pp},']'], 'fontsize', 13);
    ylim([ymin-ymin/20,ymax+ymax/20])

    p = polyfit(seaice.dn(isfinite(property)), property(isfinite(property)),1);
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

    % if ss <= 19
    %     print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/sector',sector,'properties{pp}.png'], '-dpng', '-r500');
    % else
    %     print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'properties{pp}.png'], '-dpng', '-r500');
    % end



end










