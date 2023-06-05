% Jacob Arnold

% 14-Apr-2022

% find where sector gates should be drawn
% Create spatial plots showing which grid points have SIT data and SIM data
% more than 10% of the time. ie which grid points have at least some SIT
% and at least some SIM

for ss = 1:18
    if ss < 10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    disp(['plotting sector ',sector, ' SIT and SIM Domains'])

    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

    nnSIT = ~isnan(SIT.H);
    nnSIM = ~isnan(SIM.uh);

    SITloc = sum(nnSIT, 2, 'omitnan')./length(SIT.dn) >= 0.01;

    % SIM: everything after index 1210 is nan
    SIMloc = sum(nnSIM(:,1:1210), 2, 'omitnan')./length(SIM.dnh(1:1210)) >= 0.01;


    %[C, IA, IB] = intersect(find(SITloc==1), find(SIMloc==1));
    both = find(SITloc==1 & SIMloc==1);
    justSIT = find(SITloc==1 & SIMloc==0);
    justSIM = find(SITloc==0 & SIMloc==1);


    sss = sectordotsize(str2num(sector));
    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom); sectorexpand(str2num(sector))
    s1 = m_scatter(SIT.lon, SIT.lat, sss, [0.7,0.7,0.7], 'filled');
    s2 = m_scatter(SIT.lon(both), SIT.lat(both), sss, [0.6,0.8,0.7] , 'filled');
    s3 = m_scatter(SIT.lon(justSIT), SIT.lat(justSIT), sss, [0.9,0.6,0.56], 'filled');
    %m_scatter(SIT.lon(justSIM), SIT.lat(justSIM), sss, [0.9,0.7,0.4], 'filled')
    legend([s1,s2,s3], 'Neither', 'SIT and SIM', 'SIT only', 'fontsize', 13);
    xlabel(['Sector ',sector,' SIT and SIM Coverage'], 'fontsize', 12, 'fontweight', 'bold')

    print(['ICE/Sectors/Gates/DataDomains/One_Percent/sector',sector,'SIT_SIM_Domains_1percent.png'], '-dpng', '-r500');

    clearvars
    
end



