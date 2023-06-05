% Jacob Arnold

% 02-Mar-2022

% calculate dpdy and dpdx from ECMWF segment data


% try out sector 10


%sector = '10';
for ss = 1:18
    if ss<10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Beginning sector ',sector,'...']);
    data = load(['/Volumes/Data/Research/ECMWF/matfiles/segment',sector,'.mat']);
    data2 = struct2cell(data);
    ecmwf = data2{1,1};
    clear data data2

    if length(ecmwf.dv(1,:))>6
        ecmwf.dv = ecmwf.dv';
    end
    
    % fix date formatting issues with ecmfw data
    if length(ecmwf.dv(1,:))>3
        if sum(ecmwf.dv(:,4))~=0
            ecmwf.dv(:,4)=0;
            ecmwf.dn = datenum(ecmwf.dv);
        end
    end
    %%%

    % pressure gradient latitudes and longitudes
    % first just use outer edge of segment .
    counter = 0:1000:20000;
    for ii = 1:length(ecmwf.dn)
        if ismember(ii,counter)
            disp(['Gradient calculation ',num2str(ii), ' of ',num2str(length(ecmwf.dn))])
        end

        lowlon(ii) = nanmean(ecmwf.sp(:,1,ii));
        highlon(ii) = nanmean(ecmwf.sp(:,end,ii));
        lowlat(ii) = nanmean(ecmwf.sp(end,:,ii));
        highlat(ii) = nanmean(ecmwf.sp(1,:,ii));

        dpdy(ii) = highlat(ii)-lowlat(ii);
        dpdx(ii) = highlon(ii)-lowlon(ii);

    end
    % remove outside 3 standard deviations (extremely wild stuff) (pretty rare)
    ystd = std(dpdy);
    xstd = std(dpdx);
    lowstd = std(lowlat);
    highstd = std(highlat);
    dpdy(dpdy>=nanmean(dpdy)+ystd*3) = nan;
    dpdy(dpdy<=nanmean(dpdy)-ystd*3) = nan;
    dpdx(dpdx>=nanmean(dpdx)+xstd*3) = nan;
    dpdx(dpdx<=nanmean(dpdx)-xstd*3) = nan;
    lowlat(lowlat>=nanmean(lowlat)+lowstd*3) = nan;
    highlat(highlat>=nanmean(highlat)+lowstd*3) = nan;
    lowlat(lowlat<=nanmean(lowlat)-lowstd*3) = nan;
    highlat(highlat<=nanmean(highlat)-lowstd*3) = nan;
    % average to H timescale and add to properties
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    
    meanu = nanmean(ecmwf.u10);
emptydn = [];
    emptytracker = 0; case1tracker = 0; case2tracker = 0;
    for ii = 1:length(seaice.dn)
        loc = find(ecmwf.dn==seaice.dn(ii));
        if ~isempty(loc);
            if ecmwf.dn(loc)+3 > ecmwf.dn(end)
                case1tracker = case1tracker+1;
                mydpdy(ii) = nanmean([dpdy(loc-3:end)]);
                mydpdx(ii) = nanmean([dpdx(loc-3:end)]);
                mylowlat(ii) = nanmean([lowlat(loc-3:end)]);
                myhighlat(ii) = nanmean([highlat(loc-3:end)]);
            else
                case2tracker = case2tracker+1;
                mydpdy(ii) = nanmean(dpdy(loc-3:loc+3));
                mydpdx(ii) = nanmean(dpdx(loc-3:loc+3));
                mylowlat(ii) = nanmean(lowlat(loc-3:loc+3));
                myhighlat(ii) = nanmean(highlat(loc-3:loc+3));
                myu(ii) = nanmean(meanu(loc-3:loc+3));
            end
        else
            emptytracker = emptytracker+1;
            emptydn(length(emptydn)+1) = seaice.dn(ii);
            mydpdy(ii) = nan;
            mydpdx(ii) = nan;
            mylowlat(ii) = nan;
            myhighlat(ii) = nan;
            myu(ii) = nan;
        end
        
        clear loc
    end

    
    dpdyanom = mydpdy-nanmean(mydpdy);
    dpdxanom = mydpdx-nanmean(mydpdx);
    lowanom = mylowlat-nanmean(mylowlat);
    highanom = myhighlat-nanmean(myhighlat);

    figure;
    subplot(2,1,1)
    plot_dim(1200,500)
    plot(seaice.dn, dpdyanom, 'color', [0.3,0.7,0.5], 'linewidth', 0.6);
    hold on
    %plot(ecmwf.dn, dpdx);
    %legend('dpdy', 'dpdx');
    xticks(dnticker(1997, 2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(30);
    grid on
    ylabel('Surface Pressure [mb]');
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Segment', sector, ' meridional pressure difference anomaly']);

    subplot(2,1,2)
    plot(seaice.dn, dpdxanom, 'linewidth', 0.6);
    hold on
    %plot(ecmwf.dn, dpdx);
    %legend('dpdy', 'dpdx');
    xticks(dnticker(1997, 2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(30);
    grid on
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Segment ', sector, ' zonal pressure difference anomaly']);
    ylabel('Surface Pressure [mb]');
    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/dpdy_dpdx_anoms.png'], '-dpng', '-r400')

    % offshore vs shelf anomaly
    figure;
    subplot(2,1,1)
    plot_dim(1200,500)
    plot(seaice.dn, highanom, 'color', [0.9,0.7,0.8], 'linewidth', 0.6);
    hold on
    %plot(ecmwf.dn, dpdx);
    %legend('dpdy', 'dpdx');
    xticks(dnticker(1997, 2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(30);
    grid on
    ylabel('Surface Pressure [mb]');
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Segment ', sector, ' offshore pressure anomaly']);
   

    subplot(2,1,2)
    plot(seaice.dn, lowanom, 'linewidth', 0.6, 'color', [0.4,0.2,0.4]);
    hold on
    %plot(ecmwf.dn, dpdx);
    %legend('dpdy', 'dpdx');
    xticks(dnticker(1997, 2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(30);
    grid on
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Segment', sector, ' continent pressure anomaly']);
    ylabel('Surface Pressure [mb]');
    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/offshorevscont_anoms.png'], '-dpng', '-r400')



    seaice.dpdy = mydpdy;
    seaice.dpdx = mydpdx;
    seaice.dpdyanom = dpdyanom;
    seaice.dpdxanom = dpdxanom;
    seaice.segment.lon = ecmwf.lon;
    seaice.segment.lat = ecmwf.lat;
    seaice.readme{length(seaice.readme)+1} = 'dpdy and dpdx are not true pressure gradient variables. Rather they are the difference between the mean pressure at min and max lon and lat across the segment. dpd_anom are dpd_ - mean(dpd_';

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice');

    %%%
    loc = find(ecmwf.dn==seaice.dn(1));
    sp2plot = nanmean(ecmwf.sp(:,:,loc:end), 3);
    u2plot = nanmean(ecmwf.u10(:,:,loc:end), 3);
    v2plot = nanmean(ecmwf.v10(:,:,loc:end), 3);

    m_basemap('m', double([ecmwf.lon(1,1)-0.5, ecmwf.lon(end,1)+0.5]), double([ecmwf.lat(1,end)-0.25, ecmwf.lat(1,1)+0.25]));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), 'filled', 'markerfacecolor', [0.7,0.7,0.7])
    m_scatter(ecmwf.lon(:), ecmwf.lat(:), 200, sp2plot(:), 's', 'filled')
    m_quiver(ecmwf.lon, ecmwf.lat, ecmwf.u10(:,:,5000), ecmwf.v10(:,:,5000),1.5, 'linewidth', 1, 'color', [0.4,0.1,0.1])
    %m_vec(100,ecmwf.lon(:), ecmwf.lat(:), u2plot(:), v2plot(:),'headwidth', 0, 'shaftwidth',1);
           % 1, 'FaceColor', 'r', 'EdgeColor', 'r', 'FaceAlpha', .3, 'EdgeAlpha', .3);
    plot_dim(900,700);
    caxis([810,990]);
    cbh = colorbar;
    cbh.Ticks = 820:20:980;
    cbh.Label.String = 'Surface Pressure [hPa]';
    cbh.Label.FontSize = 16;
    title(['Segment ',sector,' 1997-2021 mean Wind velocity and surface pressure'], 'fontsize', 16); 
    colormap(mycolormap('mist'))

    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/meanSLP_windvecs.png'], '-dpng', '-r400')


    drawnow

    clearvars

end






