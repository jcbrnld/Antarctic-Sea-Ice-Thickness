% Jacob Arnold

% 02-Feb-2022

% Check SIT after weekly interpolation

for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    oSIT = SIT; clear SIT;
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);


    [londom, latdom] = sectordomain(str2num(sector));
    dots = sectordotsize(str2num(sector));
    %%%

    % Check mean SIT

    ticker = (1997:2022)';
    ticker(:,2:3) = 1;
    ticker = datenum(ticker);

    figure
    plot_dim(900,420);
    h1 = subplot(3,1,1:2);
    plot(oSIT.dn, nanmean(oSIT.H),'color',[0.4,0.9,0.6] , 'linewidth', 1.1)
    hold on
    plot(SIT.dn, nanmean(SIT.H),'color',[0.3,0.65,0.9] , 'linewidth', 1.2)
    xticks(ticker);

    datetick('x', 'mm-yyyy','keepticks');
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    %xtickangle(25);
    grid on;
    title(['Sector ',sector,' mean Sea Ice Thickness and percent NaN after temporal interpolation']);
    ylabel('SIT [m]')
    legend('Before Interp', 'After Interp')
    % check % nan
    pernan = (sum(isnan(SIT.H))./length(SIT.lon)).*100;
    opernan = (sum(isnan(oSIT.H))./length(oSIT.lon)).*100;
    ylim([0,2.4])
    yticks(0:0.3:2.4);
    set(gca,'Xticklabel',[])

    set(h1, 'Position', [0.13, .37, .775, .54]);




    h3 = subplot(3,1,3);
    plot(oSIT.dn, opernan, 'color', [0.9,0.7,0.2], 'linewidth', 1.1);
    hold on;
    plot(SIT.dn,  pernan, 'color',[0.9,0.1,0.6], 'linewidth', 1.2);
    xticks(ticker);
    datetick('x', 'mm-yyyy','keepticks');
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    xtickangle(25);
    grid on;
    ylim([0,max(pernan)+10])
    %title(['Sector ',sector,' Percent NaN']);
    ylabel('NaN [%]')
    legend('Before Interp', 'After Interp');

    set(h3, 'Position', [0.13, .15, .775, .2]);

    disp(['Sector: ',sector,': Length of new dn: ',num2str(length(SIT.dn))])

    print(['ICE/ICETHICKNESS/Figures/Diagnostic/temporal_interp/sector',sector,'mean_and_pernan.png'], '-dpng', '-r400');

    clearvars
    
end

