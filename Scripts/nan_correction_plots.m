% Jacob Arnold
% 20-Jan-2022

% create some figures showing nan areas before /after each fill/correction
% The fills/corrections are:
% 1. reinterpolating older SIC and filling nan areas with CT
% 2. Re-nanning grid points that were always nan in Bremen AMSRe and AMSR2 SIC data.


for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors_b4CTnanfill/sector',sector,'.mat']);
    oSIT = SIT; clear SIT;
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/backup14jan22/sector',sector,'.mat']);
    mSIT = SIT; clear SIT
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    nSIT = SIT; clear SIT

    %%% 12 km SIC
    % before
    osub = oSIT.H(:,1:201);
    nan1 = find(sum(isnan(osub),2)./201==1);

    [londom, latdom] = sectordomain(str2num(sector));
    dots = sectordotsize(str2num(sector));
    m_basemap('a', londom, latdom)
    sectorexpand(str2num(sector));
    s1 = m_scatter(oSIT.lon, oSIT.lat, dots, [0.7,.8,.7], 'filled');
    s2 = m_scatter(oSIT.lon(nan1), oSIT.lat(nan1), dots, [0.9,0.4,0.4], 'filled');
    legend([s1, s2], 'Finite', 'NaN', 'fontsize', 13);
    xlabel(['97-2001: Sector ',sector,' before SIC CT extension'], 'fontsize', 12);
    %print(['ICE/ICETHICKNESS/Figures/Diagnostic/BremenAMSRnan_correction/before_after/sector',sector,'_before.png'], '-dpng', '-r500');


    % after before
    msub = mSIT.H(:,1:201);
    nan2 = find(sum(isnan(msub),2)./201==1);

    [londom, latdom] = sectordomain(str2num(sector));
    dots = sectordotsize(str2num(sector));
    m_basemap('a', londom, latdom)
    sectorexpand(str2num(sector));
    s1 = m_scatter(mSIT.lon, mSIT.lat, dots, [0.7,.8,.7], 'filled');
    s2 = m_scatter(mSIT.lon(nan2), mSIT.lat(nan2), dots, [0.9,0.4,0.4], 'filled');
    legend([s1, s2], 'Finite', 'NaN', 'fontsize', 13);
    xlabel({['97-2001: Sector ',sector,' after SIC CT extension'],'Before Bremen NaN correction'}, 'fontsize', 12);
    print(['ICE/ICETHICKNESS/Figures/Diagnostic/BremenAMSRnan_correction/before_after/sector',sector,'_afterbefore.png'], '-dpng', '-r500');



    % after after
    nsub = nSIT.H(:,1:201);
    nan3 = find(sum(isnan(nsub),2)./201==1);

    [londom, latdom] = sectordomain(str2num(sector));
    dots = sectordotsize(str2num(sector));
    m_basemap('a', londom, latdom)
    sectorexpand(str2num(sector));
    s1 = m_scatter(nSIT.lon, nSIT.lat, dots, [0.7,.8,.7], 'filled');
    s2 = m_scatter(nSIT.lon(nan3), nSIT.lat(nan3), dots, [0.9,0.4,0.4], 'filled');
    legend([s1, s2], 'Finite', 'NaN', 'fontsize', 13);
    xlabel(['97-2001: Sector ',sector,' After Bremen NaN correction'], 'fontsize', 12);
    %print(['ICE/ICETHICKNESS/Figures/Diagnostic/BremenAMSRnan_correction/before_after/sector',sector,'_afterafter.png'], '-dpng', '-r500');

    clearvars
    close all

end



















