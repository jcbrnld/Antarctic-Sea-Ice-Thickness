% Jacob Arnold

% 14-Oct-2021

% Comparisons between EnviSat/CryoSat SIT and SOD SIT

% Import data 
% Join with averaging overlap years
% Interpolate to 3.125 km grid
% Average SOD SIT monthly
% Spatial Comparisons
% Trend Comparisons




%% 1. 
% Already ran for 00
% Now loop through other 18 sectors
ii = 00;
%for ii = 1:18
    
    clearvars -except ii
    close all
    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    tic
    disp(['Starting sector ', sector])



    load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/EnviSat_SIT.mat;

    load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_CryoSat_2/CryoSat2_SIT.mat;


    %%% ---------------------------------------------------------------------------------------------
    % Overlap indices for both datasets
    esoverlap = [102:118];
    csoverlap = [1:17];
    avOverlap = (esSIT.SIT(:,esoverlap)+csSIT.SIT(:,csoverlap))./2;

    for ii = 1:17
        junkcols(:,1) = esSIT.SIT(:,esoverlap(ii));
        junkcols(:,2) = csSIT.SIT(:,csoverlap(ii));
        avOverlap2(:,ii) = nanmean(junkcols, 2);

        clear junkcols
    end

    % figure
    % set(gcf, 'position', [500,600,1000,300])
    % plot(nanmean(esSIT.SIT(:,esoverlap)));
    % hold on
    % plot(nanmean(csSIT.SIT(:,csoverlap)))
    % plot(nanmean(avOverlap2));
    % legend('EnviSat', 'CryoSat', 'Averaged')
    % xlabel('Overlap Months')
    % ylabel('Sea Ice Thickness [m]')
    % title('Area Averaged Values During Overlap')
    % grid on
    %print('ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_99/Overlap_average.png', '-dpng', '-r500')

    % Create joined vars
    tdn = [esSIT.dn(1:end-17); csSIT.dn];
    tH = [esSIT.SIT(:,1:end-17),avOverlap2, csSIT.SIT(:,18:end)];
    escsSIT.H = tH;
    escsSIT.dn = tdn;
    escsSIT.lon = csSIT.lon; 
    escsSIT.lat = csSIT.lat;
    escsSIT.dv = datevec(escsSIT.dn);

    % View timeseries
    % figure;
    % set(gcf, 'position', [500,600,1000,350]);
    % plot(escsSIT.dn, nanmean(escsSIT.H), 'color', [1,1,0.6])
    % hold on
    % datetick('x', 'mm-yyyy');
    % xtickangle(25)
    % set(gca, 'color', [0.2,0.2,0.2]);
    % set(gcf, 'color', [1,1,1]);
    % grid on
    % title('Merged EnviSat and CryoSat SIT and Trends')
    % ylabel('Sea Ice Thickness [m]');
    % ax = gca;
    % ax.GridColor = [1,1,1];

    %%% Fill non permanent nans with 0 --------------------------------------------------------------

    % Fill appropriate zeros! (open water but not land)
    % figure;plot(escsSIT.dn,sum(isnan(escsSIT.H))./length(escsSIT.H(:,1))); set(gcf, 'position', [500,600,1000,300]);
    % datetick('x', 'mm-yyyy'); xtickangle(25);
    % title('% of EnviSat-CryoSat SIT dataset NaN Originally'); 
    % first find indices that are always NaN
    test = nanmean(escsSIT.H, 2);
    sum(isnan(test));
    test2 = find(isnan(test));
    % m_basemap('p', [0,360], [-90,-40]);
    % m_scatter(escsSIT.lon(test2), escsSIT.lat(test2), 2, 'filled');
    % % BEAutiful! All those points need to be nan, all other nan locations need
    % % to be 0.
     notNan = find(~isnan(test));
    % m_basemap('p', [0,360], [-90,-40]);
    % m_scatter(escsSIT.lon(notNan), escsSIT.lat(notNan), 2, 'filled');

    tempH = escsSIT.H;
    tempH2 = esSIT.SIT;
    tempH3 = csSIT.SIT;

    subsetH = tempH(notNan,:);
    subsetH2 = tempH2(notNan,:);
    subsetH3 = tempH3(notNan,:);

    subsetH(isnan(subsetH)) = 0;
    subsetH2(isnan(subsetH2)) = 0;
    subsetH3(isnan(subsetH3)) = 0;

    tempH(notNan,:) = subsetH;
    tempH2(notNan,:) = subsetH2;
    tempH3(notNan,:) = subsetH3;

    escsSIT.H = tempH;
    esSIT.SIT = tempH2;
    csSIT.SIT = tempH3;

    % figure;plot(escsSIT.dn,sum(isnan(tempH))./length(escsSIT.H(:,1))); set(gcf, 'position', [500,600,1000,300]);
    % datetick('x', 'mm-yyyy'); xtickangle(25);
    % title('% of EnviSat-CryoSat SIT dataset NaN After Correction'); 



    %%% Interpolate to 3.125 km sector grid --------------------------------------------------------------


    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);


    tempH = escsSIT.H;
    lat25 = escsSIT.lat; 
    lon25 = escsSIT.lon;
    neglon = find(lon25<0);
    lon25(neglon) = lon25(neglon)+360;
    %tempH(isnan(tempH))=0;

    % Interpolate to our grid
    for ii = 1:length(tempH(1,:))
        finloc = find(isfinite(tempH(:,ii))==1);
        interpH(:,ii) = griddata(lon25(finloc), lat25(finloc), double(tempH(finloc,ii)), double(SIT.lon), double(SIT.lat),  'linear');

    end
    %%% INTERP COMPARE PLOTS --------------------------------------------------------------
    % m_basemap('p', [0,360], [-90, -60]);
    % %m_basemap('a', [112 123], [-67.5 -64.5])
    % set(gcf, 'position', [500,600,1000,800])
    % m_scatter(SIT.lon, SIT.lat, 1.5, interpH(:,50), 'filled')
    % %m_scatter(SIT.lon, SIT.lat,  'filled')
    % text(-0.05, 0, 'Interpolated');
    % cmocean('ice', 10);
    % caxis([0,2])
    % %caxis([0,1])
    % cbh = colorbar;
    % cbh.Ticks = [0:0.2:2];
    % cbh.Label.String = ('Sea Ice Thickness [cm]');
    % % print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/InterpWnans.png'], '-dpng', '-r600');
    % 
    % 
    % %m_basemap('a', [112 123], [-67.5 -64.5])
    % m_basemap('p', [0 360], [-90 -60])
    % set(gcf, 'position', [500,600,1000,800])
    % m_scatter(escsSIT.lon, escsSIT.lat, 30, escsSIT.H(:,50),'filled')
    % finloc = find(isfinite(escsSIT.H(:,50))==1);
    % cmocean('ice', 10);
    % caxis([0,2])
    % %caxis([0,1])
    % cbh = colorbar;
    % cbh.Ticks = [0:0.2:2];
    % cbh.Label.String = ('Sea Ice Thickness [cm]');
    % hold on
    % %m_scatter(escsSIT.lon(finloc), escsSIT.lat(finloc), 100, 'm', 'filled');

    %%% Monthly Average SOD SIT --------------------------------------------------------------

    years = unique(SIT.dv(:,1));
    counter = 0;
    for ii = 1:length(years)
        yearloc = find(SIT.dv(:,1)==years(ii));
        months = unique(SIT.dv(yearloc,2));
        for jj = 1:length(months)
            mloc = find(SIT.dv(yearloc,2)==months(jj)); % get indices of indices
            msuploc = yearloc(mloc); % get indices of original data
            avH(:,counter+1) = nanmean(SIT.H(:,msuploc), 2);

            clear mloc msuploc
            counter=counter+1;
        end
        clear yearloc months
    end

    % Create monthly datenum
    % First month is 10/1997 
    % Last month is 2/2021
    avdv(1:3,1) = [1997];avdv(1:3,2) = [10, 11, 12];
    floc=4;
    for ii = 2:length(years)-1
        avdv(floc:floc+11,1) = years(ii);
        avdv(floc:floc+11,2) = [1:12];
        floc = floc+12;
    end
    avdv(length(avdv(:,1))+1:length(avdv(:,1))+2,1) = 2021;
    avdv(:,3) = 15;
    avdn = datenum(avdv);

    %%% Trend Comparisons 1 --------------------------------------------------------------
    % In this section concentration has not been accounted for in the ESCS
    % dataset. 

    % Start with shortened SODSIT data matching the temporal domain of the escsSIT
    firstdn = find(avdn == escsSIT.dn(1));
    lastdn = find(avdn == escsSIT.dn(end));


    shortdn = avdn(firstdn:lastdn);
    shortH = avH(:,firstdn:lastdn);
    interpH(isnan(shortH)==1) = nan;


    figure
    set(gcf, 'position', [500,500,1200,400]);
    plot(shortdn, nanmean(shortH), 'color', [0.2,0.7,0.4], 'linewidth', 1.0);
    hold on
    plot(escsSIT.dn, nanmean(interpH), 'color', [0.7, 0.1, 0.5], 'linewidth', 1.0);
    datetick('x', 'dd-mmm-yyyy')
    xtickangle(25);
    grid on
    legend('SOD SIT', 'ESCS SIT');
    title(['Sector ',sector, ' area averaged SIT: SOD and ESCS'])
    ylabel('Sea Ice Thickness [m]');
    %print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/CompTimeseries_b4SIC_CORR.png'],'-dpng', '-r500');




    %%% Trend comparisons 2 --------------------------------------------------------------

    % Here concentration will be accounted for in the ESCS sit dataset
    % First load in SIC data 
    % Then average monthly
    % Then multiply ESCS SIT by SIC


    sicdata = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    sicdata = struct2cell(sicdata);
    SIC = sicdata{1,1}.sic; 
    SICdn = sicdata{1,1}.dn;
    SICdv = datevec(double(SICdn));
    clear sicdata

    avSIC = nan(size(interpH));
    for ii = 1:length(escsSIT.dn)

        yr = escsSIT.dv(ii,1);
        mnth = escsSIT.dv(ii,2);

        mnthInd = find((SICdv(:,1)==yr) & (SICdv(:,2)==mnth));
        vals2av = SIC(:,mnthInd);
        avSIC(:,ii) = nanmean(vals2av, 2)./100;

        clear yr mnth mnthInd vals2av

    end


    % Multiply ESCS SIT times temporally averaged SIC  
    corrESCSH = interpH.*avSIC;
    
    clear esSIT csSIT tempH tempH2 tempH3 subsetH subsetH2 subsetH3 test test2 SIC SICdn SICdv lat25 lon25
    
    

    figure;
    scatter(nanmean(corrESCSH), nanmean(interpH), 'filled');
    title(['Sector ', sector, ' Area Averaged ESCS SIT After vs Before SIC Correction'])
    xlabel('SIC-Corrected Interpolated ESCS SIT');
    ylabel('Original Interpolated ESCS SIT')
    grid on; box on; 
    xlim([0,4.5]);
    ylim([0,4.5]);
    tempx = [0:0.1:4];
    coef = polyfit(nanmean(corrESCSH), nanmean(interpH), 1);
    YFit = coef(1)*tempx+coef(2);
    hold on
    fit = plot(tempx, YFit, '--m', 'linewidth', 1.1);
    legend([fit], ['Y = ',num2str(coef(1)), 'X + ',num2str(coef(2))], 'fontsize', 14, 'location', 'northwest');
    %print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/SICcorrscat.png'],'-dpng', '-r500');


    figure
    set(gcf, 'position', [500,500,1200,400]);
    plot(shortdn, nanmean(shortH), 'color', [0.2,0.7,0.4], 'linewidth', 1.0);
    hold on
    plot(escsSIT.dn, nanmean(corrESCSH), 'color', [0.2, 0.4, 0.7], 'linewidth', 1.0);
    datetick('x', 'dd-mmm-yyyy')
    xtickangle(25);
    grid on
    legend('SOD SIT', 'ESCS SIT');
    title(['Sector ',sector, ' area averaged SIT: SOD and ESCS'])
    ylabel('Sea Ice Thickness [m]');
    %print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/CompTimeseries_aftSIC_CORR.png'],'-dpng', '-r500');


    % correlation coef
    corrvals = corrcoef(nanmean(shortH), nanmean(corrESCSH));
    rval = corrvals(2);
    disp(['r = ',num2str(rval)])

    figure
    scatter(nanmean(shortH), nanmean(corrESCSH), 'filled');
    xlim([0,4]);
    ylim([0,4]);
    grid on
    grid minor; box on
    legend(['r = ',num2str(rval)], 'fontsize', 14, 'location', 'northwest')
    title(['Sector ',sector, ' area averaged SIT: SOD vs ESCS']);
    xlabel('SOD Sea Ice Thickness [m]');
    ylabel('ESCS Sea Ice Thickness [m]');
    %print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/SODvsESCS.png'],'-dpng', '-r500');

    disp(['Finished Sector ',sector])
    toc
    
%end

%% load KM ICESat SIT and plot with these 

% Only have sector 00 and 01 track data .mat files currently. 

load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/For_Comparison/sector00_onTrack_RedunAve.mat;

for ii = 1:12
    kmSITav(ii) = nanmean(TSOD.kmSIT{ii});
end

%%

years1 = (shortdn(end)-shortdn(1))/365;
years2 = (escsSIT.dn(end)-escsSIT.dn(1))/365;
years3 = (TSOD.mid_dn(end)-TSOD.mid_dn(1))/365;


figure
set(gcf, 'position', [500,500,1200,400]);
plot(shortdn, nanmean(shortH), 'color', [0.2,0.7,0.4], 'linewidth', 1.0);
hold on
plot(escsSIT.dn, nanmean(corrESCSH), 'color', [0.2, 0.4, 0.7], 'linewidth', 1.0);
plot(TSOD.mid_dn, kmSITav, 'color', [0.7, 0.2, 0.2], 'linewidth', 1)
datetick('x', 'dd-mmm-yyyy')
xtickangle(25);
grid on

title(['Sector ',sector, ' area averaged SIT: SOD, ESCS, and KM_ICESat'])
ylabel('Sea Ice Thickness [m]');

coefficients1 = polyfit(shortdn.', nanmean(shortH), 1);
coefficients2 = polyfit(escsSIT.dn.', nanmean(corrESCSH), 1);
coefficients3 = polyfit(TSOD.mid_dn, kmSITav, 1);
YFit1 = coefficients1(1)*shortdn+coefficients1(2);
YFit2 = coefficients2(1)*escsSIT.dn+coefficients2(2);
YFit3 = coefficients3(1)*TSOD.mid_dn+coefficients3(2);
plot(shortdn, YFit1, '--', 'color', [0.1,0.1,0.1],'LineWidth', 1); % Linear best fit
plot(escsSIT.dn, YFit2, '-.', 'color', [0.1,0.1,0.1],'LineWidth', 1); % Linear best fit
plot(TSOD.mid_dn, YFit3, ':', 'color', [0.1,0.1,0.1],'LineWidth', 1); % Linear best fit
totalSlope1 = YFit1(end)-YFit1(1);
totalSlope2 = YFit2(end)-YFit2(1);
totalSlope3 = YFit3(end)-YFit3(1);
yearSlope1 = (totalSlope1/years1)*100; % This makes it cm/y
yearSlope2 = (totalSlope2/years2)*100;
yearSlope3 = (totalSlope3/years3)*100;

legend('SOD SIT', 'ESCS SIT', 'KM SIT', ['SOD Slope = ',num2str(yearSlope1),'cm/y'],...
    ['ESCS Slope = ',num2str(yearSlope2),'cm/y'], ['KM\_ICESat Slope = ',num2str(yearSlope3),'cm/y'], ...
    'Orientation', 'Horizontal', 'fontsize', 13);


%print(['ICE/ICETHICKNESS/Figures/ES_CS_SIT/Sector_',sector,'/CompTimeseries_withICESat.png'],'-dpng', '-r500');






%% Interpolate to ICESat tracks and compare
% Find ESCS indices closest to ICESat campaign periods
% Use same months for SOD
    % so ESCS and SOD will be on same timescale and interpolated to ICESat
    % spatial scale. 
    
    
    










































