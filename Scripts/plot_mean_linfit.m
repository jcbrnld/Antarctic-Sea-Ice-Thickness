% Jacob Arnold

% 09-sep-2021

% Make some plots of average SIT and linear best fit for all sectors
% These may be useful for "preliminary results" section of thesis proposal

% Section one creates these for the new (1997-2021) dates and 
% section 2 creates these plots for all (1973-2021) with separate best fit
% lines for each period. 



for ii = 1:18;
    if ii<10
        sector = ['0',num2str(ii)]
    else
        sector = num2str(ii)
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Full_length/sector',sector,'.mat']);

    Hmean = nanmean(allSIT.H(:,length(allSIT.dn)-length(allSIT.newdn)+1:end));
    figure;
    plot(allSIT.newdn, Hmean,'color', [0.8 0.4 0.1],'linewidth', 1.1);
    set(gcf, 'position', [500,500,1000, 400]);
    tick5 = datenum(1997:1:2022,1,1);
    set(gca, 'xtick', tick5);
    datetick('x', 'mm-yyyy', 'keepticks');

    xtickangle(32);
    title(['Mean SIT for sector ', sector]);
    ylabel('Sea Ice Thickness [m]');
    grid on; %grid minor
    hold on
    % mean of all
    % plot([allSIT.newdn(1), allSIT.newdn(end)], [mean(Hmean), mean(Hmean)], '--','color',[0.1, 0.5, 0.8] );
    % Get coefficients of a line fit through the data.
    coefficients = polyfit(allSIT.newdn, Hmean.', 1);
    % Create a new x axis with exactly 1000 points (or whatever you want).
    xFit = linspace(min(allSIT.newdn), max(allSIT.newdn), 1000);
    % Get the estimated yFit value for each of those 1000 new x locations.
    yFit = polyval(coefficients , xFit);

    plot(xFit, yFit, '--', 'color', [0.2,0.7,0.6],'LineWidth', 1); % Plot fitted line.

    legend('Mean SIT', 'Linear Fit');

    print(['ICE/ICETHICKNESS/Figures/Averages/Sector_',sector,'/mean_linfit.png'], '-dpng','-r800'); 

    clearvars

end


%% Now for the old AND new 


for ii = 1:18;
    if ii<10
        sector = ['0',num2str(ii)]
    else
        sector = num2str(ii)
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Full_length/sector',sector,'.mat']);

    newmean = nanmean(allSIT.H(:,length(allSIT.dn)-length(allSIT.newdn)+1:end));
    oldmean = nanmean(allSIT.H(:,1:length(allSIT.olddn)));
    
    figure;
    plot(allSIT.dn, nanmean(allSIT.H),'color', [0.8 0.4 0.1],'linewidth', 1.1);
    set(gcf, 'position', [500,500,1000, 400]);
    tick5 = datenum(1972:2:2022,1,1);
    set(gca, 'xtick', tick5);
    datetick('x', 'mm-yyyy', 'keepticks');

    xtickangle(32);
    title(['Mean SIT for sector ', sector]);
    ylabel('Sea Ice Thickness [m]');
    grid on; %grid minor
    hold on
    % mean of all
    % plot([allSIT.newdn(1), allSIT.newdn(end)], [mean(Hmean), mean(Hmean)], '--','color',[0.1, 0.5, 0.8] );
    % Get coefficients of a line fit through the data.
    coefficients1 = polyfit(allSIT.newdn, newmean.', 1);
    coefficients2 = polyfit(allSIT.olddn, oldmean.', 1);
    
    % Create a new x axis with exactly 1000 points (or whatever you want).
    xFit1 = linspace(min(allSIT.newdn), max(allSIT.newdn), 1000);
    xFit2 = linspace(min(allSIT.olddn), max(allSIT.olddn), 1000);
    
    % Get the estimated yFit value for each of those 1000 new x locations.
    yFit1 = polyval(coefficients1 , xFit1);
    yFit2 = polyval(coefficients2 , xFit2);

    plot(xFit1, yFit1, '--', 'color', [0,0.2 0.9],'LineWidth', 1); % Plot fitted line.
    plot(xFit2, yFit2, '--', 'color', [0.1,0.8,0.3],'LineWidth', 1); % Plot fitted line.

    legend('Mean SIT', 'New SIT Linear Fit','Ad Hoc SIT Linear Fit' );

    print(['ICE/ICETHICKNESS/Figures/Averages/Sector_',sector,'/mean_linfit_OldAndNew.png'], '-dpng','-r800'); 

    clearvars

end












