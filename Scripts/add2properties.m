% Jacob Arnold

% 28-Feb-2022

% add a few more properties to sector property files

% --> sea ice divergence yes
% --> wind stress curl no
% --> dpdy (pressure difference across region) no

%sector = '10';
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else 
        sector = num2str(ss);
    end
    
    disp(['Beginning sector ',sector,'...']);
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

    %%%

    % Average u and v to H timescale
    newU = nan(length(SIC.lon), length(seaice.dn));
    newV = newU;
    for ii = 1:length(seaice.dn)
        if seaice.dn(ii) > max(SIC.dnuv);
            newU(:,ii) = nan;
            newV(:,ii) = nan;
            continue
        end

        dnloc = find(SIC.dnuv==seaice.dn(ii));

        if SIC.dnuv(dnloc)+3>max(SIC.dnuv)
            newU(:,ii) = nanmean(SIC.u(:,dnloc-3:length(SIC.dnuv)),2);
            newV(:,ii) = nanmean(SIC.v(:,dnloc-3:length(SIC.dnuv)),2);
        else
            newU(:,ii) = nanmean(SIC.u(:,dnloc-3:dnloc+3),2);
            newV(:,ii) = nanmean(SIC.v(:,dnloc-3:dnloc+3),2);

        end

        clear dnloc

    end


    seaice.mU_ice = nanmean(newU);
    seaice.mV_ice = nanmean(newV);

    %%% Add newu and newv to SIT structure;
    disp(['Sector ',sector,' U and V averaged to SIT timescale; saving'])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    SIT.iceU = newU;
    SIT.iceV = newV;
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    clear SIT


    %%% Divergence
    % convert to 2d I think 
    index = SIC.index;
    lon2d = SIC.grid3p125km.lon;
    lat2d = SIC.grid3p125km.lat;
    [x2d, y2d] = ll2ps(lat2d, lon2d);

    u2d = nan(size(SIC.grid3p125km.lon));
    v2d = u2d;
    u2d(index) = newU(:,500);
    v2d(index) = newV(:,500);

    %%% calculate divergence in the sector
    disp(['Calculating sector ',sector,' sea ice divergence'])
    div = nan(length(SIC.lon), length(seaice.dn));
    for ii = 1:length(seaice.dn)
        u2d = nan(size(SIC.grid3p125km.lon));
        v2d = u2d;
        u2d(index) = newU(:,ii);
        v2d(index) = newV(:,ii);

        div2d = divergence(x2d, y2d, u2d, v2d);
        div2d2 = cdtdivergence(lat2d, lon2d, u2d, v2d);
        div(:,ii) = div2d(index);

    end

    % use index from SIC to assign values to original 2d array. 


    ticker = dnticker(1997,2022);
    figure
    plot_dim(1200,300)
    plot(seaice.dn, nanmean(div), 'linewidth', 1.2, 'color', [0.5,0.8,0.7])
    xticks(ticker)
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title(['Sector ',sector,' mean divergence']);
    ylabel('Divergence [1/s]')
    grid on

    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/seaicedivergence_cdt.png'], '-dpng', '-r400');

    seaice.divergence = div;
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');
    clearvars
end







