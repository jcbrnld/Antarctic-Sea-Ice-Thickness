% Jacob Arnold

% 16-May-2022

% Make plots of sectors with their gates and the 25 km grid points to see
% how much "no man's land" space there is. ie how much is not being
% described by using only the portions of the sectors within the flux gate


load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/subpolar_ao.mat; ao = SIT; clear SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/subpolar_io.mat; io = SIT; clear SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/subpolar_po.mat; po = SIT; clear SIT;
load ICE/Sectors/all_grids.mat

for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector  = num2str(ii);
    end
    disp(['Sector ',sector,'...'])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat'])
    %

    hi = sum(isnan(SIT.H),2)<length(SIT.dn);
    mi = sum(isnan(SIM.uh),2)<length(SIM.dnh);
    c = [hi,mi];
    ci = find(sum(c,2)==2);


    dots = sectordotsize(str2num(sector));
    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom)
    sectorexpand(str2num(sector));
    m_scatter(SIT.lon, SIT.lat, dots, [0.7,.7,.7], 'filled')
    m_scatter(SIT.lon(ci), SIT.lat(ci), dots, [0.4,0.7,0.6], 'filled');
    m_plot(gate.whole.lon, gate.whole.lat, 'm', 'linewidth', 1.1)
    m_scatter(gate.whole.lon, gate.whole.lat, dots/2, 'm', 'filled')
    m_scatter(lon.sim25km(:), lat.sim25km(:), dots*2, [0.7,0.4,0.4], 'filled')
    m_scatter(ao.lon, ao.lat, dots*2, [0.4,0.7,0.6], 'filled')
    m_scatter(io.lon, io.lat, dots*2, [0.4,0.7,0.6], 'filled')
    m_scatter(po.lon, po.lat, dots*2, [0.4,0.7,0.6], 'filled')

    xlabel(['Sector ',sector]);
    print(['ICE/Sectors/Gates/Figures/noMansLand/sector',sector,'gridsandgate.png'], '-dpng', '-r400');
    
    clearvars -except ao io po lon lat
end




