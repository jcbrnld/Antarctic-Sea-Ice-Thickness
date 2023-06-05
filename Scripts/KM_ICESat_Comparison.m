% Jeacob Arnold

% 24-Sep-2021

% Compare sector SOD SIT with Kurtz and Markus SIT data
% USING THE spatially interpolated data
% Will need to perform this for each sector
% Need to:
%   1. Import sector SOD SIT
%   2. Import all ICESat campaign SITs
%   3. Interpolate ICESat data to 3.125 km grid
%   4. Average SOD SIT to match ICESat campaign periods 
%   5. COMPARE!

% I did this once before in Read_ICESat_SIT.m so much can be copied/adapted
% from there. 

% Sector 00 is the entire shelf 

% ON = Spring
% FM = Summer
% MJ = Fall

% dates:
% 2003 ||                                           ON03 = Oct1-Nov18
% 2004 || FM04 = Feb17-Mar21    MJ04 = May18-Jun21  ON04 = Oct3-Nov08
% 2005 || FM05 = Feb17-Mar24    MJ05 = May20-Jun23
% 2006 || FM06 = Feb22-Mar27    MJ06 = May24-Jun26  ON06 = Oct25-Nov27
% 2007 || MA07 = Mar12-Apr14                        ON07 = Oct02-Nov05
% 2008 || FM08 = Feb17-Mar21

% IF YOU NEED TO RUN THIS AGAIN be sure to uncomment the necessary prints


ii = '18';

% Loop for all 19 sectors
%for ii = 0:18
    
    clearvars -except ii; close all
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    disp(['Working On Sector ', sector])


    if length(sector)==2
        %sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
        load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/Sector',sector,'.mat']);
    else
        %sect = load(['ICE/Concentration/so-zones/',sector,'_SIC.mat']);
        %load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/sector',sector,'.mat']);
    end


    % Create variable of ideal lon and lat limits for sector plots
    splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
    splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
    splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53.5 68.5]; splot{6,2}=[-68 -65.2];
    splot{7,1}=[67 86]; splot{7,2}=[-70.5 -65]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
    splot{9,1}=[99.5 113.5]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
    splot{11,1}=[121 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[133.5 150.5]; splot{12,2}=[-69 -64.5];
    splot{13,1}=[149 173]; splot{13,2}=[-72 -65]; splot{14,1}=[160 207]; splot{14,2}=[-79 -69];
    splot{15,1}=[202 235.5]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
    splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-70 -59];

    if str2num(sector)~=0
        londom = splot{str2num(sector),1}; latdom = splot{str2num(sector),2};
    end

    load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/kmSIT.mat



    % Interpolate KM to sector grid

    tempH = kmSIT.H;
    lat25 = kmSIT.lat; lon25 = kmSIT.lon;
    tempH(isnan(tempH))=0;

    % Interpolate ICESat to our grid
    for ii = 1:length(tempH(1,:))
        interpH(:,ii) = griddata(lon25, lat25, tempH(:,ii), double(SIT.lon), double(SIT.lat),  'linear');
    
    end



    % Average SOD SIT to match km cruise periods

    for ii = 1:length(interpH(1,:))
        bounds = [kmSIT.dn_range{ii}(1), kmSIT.dn_range{ii}(end)];
        inds = find(SIT.dn>=bounds(1) & SIT.dn<=bounds(2));

        avgH(:,ii) = nanmean(SIT.H(:,inds),2);

    end


    % Add nan areas to interpolated data
    interpH(isnan(avgH)) = nan;

    corrVals = corrcoef(nanmean(avgH), nanmean(interpH));
    disp(['Means Correlation: ', num2str(corrVals(2,1))])

% -------------------
    avMean = nanmean(avgH,2);
    avdif = nanmean(avgH,2)-nanmean(interpH,2);
    perDif = (avdif./avMean).*100; % Difference as percent of SOD SIT *****
    
    if sector == '00'
        m_basemap('p', [0,360], [-90,-60])
        scatsize = 3;
    else
        m_basemap('a', londom, latdom)
        scatsize = 10;
    end
    set(gcf, 'position', [500,600,1000,800]);
    m_scatter(SIT.lon, SIT.lat, scatsize, perDif, 'filled'); % CHANGE perDif to avdif TO SHOW DIFFERENCE IN M RATHER THAN PERCENT.
    caxis([-100,100])
    cmocean('diff', 20);
    cbh = colorbar;
    cbh.Ticks  = [-100:10:100];
    xlabel(['Sector ',sector,': SOD SIT-ICESat SIT % of SOD SIT Averaged Across all Campaign Periods']);
    %print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allAverage_PERCENT_difference.png'], '-dpng', '-r500');
% -----------------------

% average trends with % difference plot
  diffav = nanmean(avgH)-nanmean(interpH);
    diffper = (diffav./nanmean(avgH)).*100;
    
    figure
    set(gcf, 'position', [500, 600, 1000, 600])
    h1 = subplot(3,2,1:4)
%     yyaxis right
%     plot(kmSIT.mid_dn, diffper, 'color', [.9, .7, .6])
%     ylim([-10,70]);
%     ylabel('% of SOD SIT', 'color','r');
%     hold on
    p1 = plot(kmSIT.mid_dn, nanmean(avgH), 'color', [0.65, 1, 0.75], 'linewidth', 1.2);
    hold on
    p2 = plot(kmSIT.mid_dn, nanmean(interpH), 'color', [0.65,0.75, 1], 'linewidth', 1.2);
    set(h1, 'Units', 'normalized');
    set(h1, 'Position', [0.1, .32575, .8, .6]); % Controlling subplot size
    datetick('x', 'mm-yyyy');
    xticks(kmSIT.mid_dn);
    %xticklabels(kmSIT.Cruises)
    xticklabels([])
    %xlabel('ICESat Campaigns');
    set(gca, 'color', [0.2,0.2,0.2]);
    set(gcf, 'color', [1,1,1]);

    coefficients1 = polyfit(kmSIT.mid_dn.', nanmean(avgH).', 1);
    coefficients2 = polyfit(kmSIT.mid_dn.', nanmean(interpH).', 1);
    YFit1 = coefficients1(1)*kmSIT.mid_dn+coefficients1(2);
    YFit2 = coefficients2(1)*kmSIT.mid_dn+coefficients2(2);
    plot(kmSIT.mid_dn, YFit1, '--', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
    plot(kmSIT.mid_dn, YFit2, '-.', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
    totalSlope1 = YFit1(end)-YFit1(1);
    totalSlope2 = YFit2(end)-YFit2(1);

    grid on
    ax = gca;
    ax.GridColor = [1,1,1];
    legend('\color{white} SOD SIT', '\color{white} ICESat SIT',...
        ['\color{white} SOD Slope = ', num2str(totalSlope1)],...
        ['\color{white} ICESat Slope = ', num2str(totalSlope2)]);
    ylabel('Sea Ice Thickness [m]');
    ylim([0,2])
    yticks([0:0.2:3]);

    title(['Sector ',sector,': Mean SIT from SOD and ICESat']);
    h2 = subplot(3,2,5:6)
    plot(kmSIT.mid_dn, abs(diffper), 'color', [.9, .7, .6], 'linewidth', 1.1)
    set(h2, 'Units', 'normalized');
    set(h2, 'Position', [0.1, .10, .8, .2]); % Controlling subplot size ---- Handy trick
    datetick('x', 'mm-yyyy');
    xticks(kmSIT.mid_dn);
    xticklabels(kmSIT.Cruises)
    xlabel('ICESat Campaigns');
    set(gca, 'color', [0.2,0.2,0.2]);grid on
    ax = gca;
    ax.GridColor = [1,1,1];
    ylabel('% Difference')
    %ylim([0,100])
    if max(abs(diffper))<100
        
        yticks([0:5:max(abs(diffper))+50]);
    else
        if max(abs(diffper))>500
            yticks([0:100:max(abs(diffper))+200]);
        else
            
            yticks([0:10:max(abs(diffper))+100]);
        end
    end
    set(gcf, 'InvertHardcopy', 'off')
    %print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Average_compare2_WithPercDiff.png'], '-dpng','-r600');
    
    %-----------------------


    % Scatterplot of avgH and interpH
    figure;
    scatter(nanmean(avgH), nanmean(interpH), 60,'filled');
    hold on
    ylim([0,2.1]);xlim([0,2.1]);
    grid on ;grid minor
    title(['Sector ', sector, ' Mean SOD SIT vs ICESat for Each Campaign Period'])
    text(0.08, 2, ['r = ', num2str(corrVals(2,1))], 'fontsize', 16);
    xlabel('SOD SIT [m]');
    ylabel('ICESat SIT [m]')
    box on
    tempx = [0:0.1:3];
    coef = polyfit(nanmean(avgH), nanmean(interpH), 1);
    YFit = coef(1)*tempx+coef(2);
    fit = plot(tempx, YFit, '--m', 'linewidth', 1.1);
    legend([fit], ['Slope = ',num2str(coef(1))], 'fontsize', 14);


    %print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/average_camp.png'], '-dpng','-r400');

%end



    %% Line plot of average SODSIT and ICESat SIT over each campaign period
    % OLD VERSION
    avgHall = nanmean(avgH, 'all'); interpHall = nanmean(interpH, 'all');

    figure
    set(gcf, 'position', [500, 600, 1000, 500])
    p1 = plot(kmSIT.mid_dn, nanmean(avgH), 'color', [0.65, 1, 0.75], 'linewidth', 1.2);
    hold on
    p2 = plot(kmSIT.mid_dn, nanmean(interpH), 'color', [0.65,0.75, 1], 'linewidth', 1.2);
    datetick('x', 'mm-yyyy');
    xticks(kmSIT.mid_dn);
    xticklabels(kmSIT.Cruises)
    %xtickangle(30)
    xlabel('ICESat Campaigns');
    set(gca, 'color', [0.2,0.2,0.2]);
    set(gcf, 'color', [1,1,1]);

    yline(nanmean(avgH, 'all'), '--w', 'LineWidth', 1);
    yline(nanmean(interpH, 'all'), '-.w' ,'LineWidth', 1);
    grid on
    ax = gca;
    ax.GridColor = [1,1,1];
    legend([p1,p2],'\color{white} SOD SIT', '\color{white} ICESat SIT');
    ylabel('Sea Ice Thickness [m]');
    ylim([0,2.5])
    yticks([0:0.2:3]);
    title(['Sector ',sector,' Mean SIT from SOD and ICESat']);
    if avgHall>interpHall;
        text(731879, double(nanmean(avgH,'all')+0.05), ['SOD mean=',num2str(nanmean(avgH,'all'))], 'color', [1,1,1])
        text(731879, double(nanmean(interpH,'all')-0.05), ['ICESat mean=',num2str(nanmean(interpH,'all'))], 'color', [1,1,1])
    else
        text(731879, double(nanmean(avgH,'all')-0.05), ['SOD mean=',num2str(nanmean(avgH,'all'))], 'color', [1,1,1])
        text(731879, double(nanmean(interpH,'all')+0.05), ['ICESat mean=',num2str(nanmean(interpH,'all'))], 'color', [1,1,1])
    end
    set(gcf, 'InvertHardcopy', 'off')
    %print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Average_compare.png'], '-dpng','-r600');

    % --------
    % Same thing BUT place best fit lines rather than mean lines
    figure
    set(gcf, 'position', [500, 600, 1000, 500])
    p1 = plot(kmSIT.mid_dn, nanmean(avgH), 'color', [0.65, 1, 0.75], 'linewidth', 1.2);
    hold on
    p2 = plot(kmSIT.mid_dn, nanmean(interpH), 'color', [0.65,0.75, 1], 'linewidth', 1.2);
    datetick('x', 'mm-yyyy');
    xticks(kmSIT.mid_dn);
    xticklabels(kmSIT.Cruises)
    xlabel('ICESat Campaigns');
    set(gca, 'color', [0.2,0.2,0.2]);
    set(gcf, 'color', [1,1,1]);

    coefficients1 = polyfit(kmSIT.mid_dn.', nanmean(avgH).', 1);
    coefficients2 = polyfit(kmSIT.mid_dn.', nanmean(interpH).', 1);
    YFit1 = coefficients1(1)*kmSIT.mid_dn+coefficients1(2);
    YFit2 = coefficients2(1)*kmSIT.mid_dn+coefficients2(2);
    plot(kmSIT.mid_dn, YFit1, '--', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
    plot(kmSIT.mid_dn, YFit2, '-.', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
    totalSlope1 = YFit1(end)-YFit1(1);
    totalSlope2 = YFit2(end)-YFit2(1);

    grid on
    ax = gca;
    ax.GridColor = [1,1,1];
    legend('\color{white} SOD SIT', '\color{white} ICESat SIT',...
        ['\color{white} SOD Slope = ', num2str(totalSlope1)],...
        ['\color{white} ICESat Slope = ', num2str(totalSlope2)]);
    ylabel('Sea Ice Thickness [m]');
    ylim([0,2.5])
    yticks([0:0.2:3]);
    title(['Sector ',sector,' Mean SIT from SOD and ICESat']);

    set(gcf, 'InvertHardcopy', 'off')
    %print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Average_compare2.png'], '-dpng','-r600');


%%





% Sector 00
% Means Correlation: 0.69047
% Sector 01
% Means Correlation: 0.49588
% Sector 02
% Means Correlation: 0.17943
% Sector 03
% Means Correlation: 0.4085
% Sector 04
% Means Correlation: 0.28848
% Sector 05
% Means Correlation: 0.43934
% Sector 06
% Means Correlation: 0.30605
% Sector 07
% Means Correlation: 0.36726
% Sector 08
% Means Correlation: 0.40019
% Sector 09
% Means Correlation: 0.53542
% Sector 10
% Means Correlation: 0.39898
% Sector 11
% Means Correlation: 0.39665
% Sector 12
% Means Correlation: -0.37908
% Sector 13
% Means Correlation: 0.28683
% Sector 14
% Means Correlation: 0.5417
% Sector 15
% Means Correlation: -0.087145
% Sector 16
% Means Correlation: 0.49808
% Sector 17
% Means Correlation: 0.94116
% Sector 18
% Means Correlation: 0.67048

%%
SITdif = avgH-interpH;

for ii = 1:12;
    loc = ii;
    if sector == '00'
        m_basemap('p', [0,360], [-90,-60])
        scatsize = 1;
    else
        m_basemap('a', londom, latdom)
        scatsize = 10;
    end
    m_scatter(SIT.lon, SIT.lat, scatsize, avgH(:,loc), 'filled')
    caxis([0,3])
    cmocean('ice');
    cbh = colorbar;
    cbh.Ticks  = [0:0.25:3];
    xlabel(['SOD SIT Averaged to Match ', kmSIT.Cruises{ii}, ' Campaign Period']);
    print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/',...
        kmSIT.Cruises{ii},'camp_avg_SIT.png'], '-dpng', '-r400');
    
    if sector == '00'
        m_basemap('p', [0,360], [-90,-60])
    else
        m_basemap('a', londom, latdom)
    end
    m_scatter(SIT.lon, SIT.lat, scatsize, interpH(:,loc), 'filled')
    caxis([0,3])
    cmocean('ice')
    cbh = colorbar;
    cbh.Ticks  = [0:0.25:3];
    xlabel([kmSIT.Cruises{ii}, ' Interpolated ICESat SIT']);
    print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/',...
        kmSIT.Cruises{ii},'interp_ICESat.png'], '-dpng', '-r400');
    
    if sector == '00'
        m_basemap('p', [0,360], [-90,-60])
    else
        m_basemap('a', londom, latdom)
    end
    m_scatter(SIT.lon, SIT.lat, scatsize, SITdif(:,loc), 'filled')
    caxis([-2,2]);
    cmocean('diff')
    %cmocean('balance')
    cbh = colorbar;
    xlabel([kmSIT.Cruises{ii}, ' SOD SIT - ICESat SIT']);

    print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/',...
        kmSIT.Cruises{ii},'difference.png'], '-dpng', '-r400');
    
    close all
end











%%

% average all campaigns and make spatial plots


if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end

m_scatter(SIT.lon, SIT.lat, scatsize, nanmean(avgH,2), 'filled');
caxis([0,3])
cmocean('ice');
cbh = colorbar;
cbh.Ticks  = [0:0.25:3];
xlabel(['SOD SIT Averaged Across all Campaign Periods']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allAverage_avgSOD.png'], '-dpng', '-r400');



if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end

m_scatter(SIT.lon, SIT.lat, scatsize, nanmean(interpH,2), 'filled');
caxis([0,3])
cmocean('ice');
cbh = colorbar;
cbh.Ticks  = [0:0.25:3];
xlabel(['ICESat SIT Averaged Across all Campaign Periods']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allAverage_interp_ICESat.png'], '-dpng', '-r400');




if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end

avdif = nanmean(avgH,2)-nanmean(interpH,2);
m_scatter(SIT.lon, SIT.lat, scatsize, avdif, 'filled');
caxis([-1,1])
cmocean('diff', 20);
cbh = colorbar;
cbh.Ticks  = [-1:0.1:1];
xlabel(['SOD SIT - ICESat SIT Averaged Across all Campaign Periods']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allAverage_difference.png'], '-dpng', '-r400');


% 
% corr(nanmean(avgH,2), nanmean(interpH,2), 'rows', 'complete')
% 
% ans =
% 
%   single
% 
%     0.5945
% 
% figure;scatter(nanmean(avgH,2), nanmean(interpH,2),'filled')
% 


%% Average each campaign type and make spatial plots


% Only 1 MA so not concerned 
ONind = [1,4,9,11];
FMind = [2,5, 7, 12];
MJind = [3, 6, 8];

avgON = nanmean(avgH(:,ONind),2);
interpON = nanmean(interpH(:,ONind), 2);
diffON = avgON-interpON;

avgFM = nanmean(avgH(:,FMind),2);
interpFM = nanmean(interpH(:,FMind), 2);
diffFM = avgFM-interpFM;

avgMJ = nanmean(avgH(:,MJind),2);
interpMJ = nanmean(interpH(:,MJind), 2);
diffMJ = avgMJ-interpMJ;

if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end
m_scatter(SIT.lon, SIT.lat, scatsize, diffON, 'filled');
caxis([-1,1])
cmocean('diff', 20);
cbh = colorbar;
cbh.Ticks  = [-1:0.1:1];
xlabel(['SOD SIT - ICESat SIT All ON Campaigns']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allON_difference.png'], '-dpng', '-r400');




if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end
m_scatter(SIT.lon, SIT.lat, scatsize, diffFM, 'filled');
caxis([-1,1])
cmocean('diff', 20);
cbh = colorbar;
cbh.Ticks  = [-1:0.1:1];
xlabel(['SOD SIT - ICESat SIT All FM Campaigns']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allFM_difference.png'], '-dpng', '-r400');




if sector == '00'
    m_basemap('p', [0,360], [-90,-60])
    scatsize = 1;
else
    m_basemap('a', londom, latdom)
    scatsize = 10;
end
m_scatter(SIT.lon, SIT.lat, scatsize, diffMJ, 'filled');
caxis([-1,1])
cmocean('diff', 20);
cbh = colorbar;
cbh.Ticks  = [-1:0.1:1];
xlabel(['SOD SIT - ICESat SIT All MJ Campaigns']);
%print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/allMJ_difference.png'], '-dpng', '-r400');































