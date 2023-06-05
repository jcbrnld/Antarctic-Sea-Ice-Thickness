% Jacob Arnold

% 25-May-2022


% plot mean H and normal transport for all sectors


for ii = 1:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    
    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('m', londom, latdom); sectorexpand(str2num(sector));
    dots = sectordotsize(str2num(sector));
    m_scatter(gate.inside.lon, gate.inside.lat, dots, nanmean(gate.inside.Hin,2), 'filled');
    colormap(jet(10));
    cbh = colorbar;
    caxis([0,2]);
    cbh.Ticks = [0:0.2:2];
    m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.4);
    m_quiver(gate.midlon, gate.midlat, nanmean(gate.midnx, 2), nanmean(gate.midny, 2),...
        'linewidth', 1.3, 'color', [.1,.1,.1], 'autoscale', 'off')
    
    title(['Sector ',sector,' mean SIT and SIM normal to the gate']);
    cbh.Label.String = 'SIT [m]';
    
    m_quiver(londom(1)+0.3, latdom(2)-0.5, 1, 0, 'linewidth', 1.4, 'color', [.1,.1,.1], 'autoscale', 'off');
    m_text(londom(1)+0.5, latdom(2)-0.3, '1 cm/s', 'fontsize', 11)
    print(['ICE/Production/figures/mean_conditions/sector',sector,'meaninteriorH_andgatemotionSPATIAL.png'], '-dpng', '-r400');

    mgh = nanmean(gate.midH,2);
    figure;plot_dim(900,300);
    d = cumsum(gate.dist);
    p1 = plot(d, mgh, 'linewidth', 1.2);
    hold on
    p2 = plot(d, nanmean(gate.midn,2), 'linewidth', 1.2);
    xlabel('distance along gate [W-E km]');
    title(['Sector ',sector,' mean gate SIT and normal SIM'])
    yline(0, '--', 'color', [.1,.1,.1], 'linewidth', 1);
    ylim([-2.5,5])
    legend([p1, p2], 'Gate SIT [m]', 'Normal SIM [cm/s]', 'fontsize', 11)
    print(['ICE/Production/figures/mean_conditions/sector',sector,'gateHandmeannormalmotion.png'], '-dpng', '-r400');
    clearvars
end



%% alter to investigate 6 regime shift



for ii = 6
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    
    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('m', londom, latdom); sectorexpand(str2num(sector));
    dots = sectordotsize(str2num(sector));
    m_scatter(gate.inside.lon, gate.inside.lat, dots, nanmean(gate.inside.Hin(:,1:584),2), 'filled');
    colormap(jet(10));
    cbh = colorbar;
    caxis([0,2]);
    cbh.Ticks = [0:0.2:2];
    m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.4);
    m_quiver(gate.midlon, gate.midlat, nanmean(gate.midnx(:,1:584), 2), nanmean(gate.midny(:,1:584), 2),...
        'linewidth', 1.3, 'color', [.1,.1,.1], 'autoscale', 'off')
    
    title(['Sector ',sector,' mean SIT and SIM normal to the gate']);
    cbh.Label.String = 'SIT [m]';
    
    m_quiver(londom(1)+0.3, latdom(2)-0.5, 1, 0, 'linewidth', 1.4, 'color', [.1,.1,.1], 'autoscale', 'off');
    m_text(londom(1)+0.5, latdom(2)-0.3, '1 cm/s', 'fontsize', 11)
    %print(['ICE/Production/figures/mean_conditions/sector',sector,'meaninteriorH_andgatemotionSPATIAL.png'], '-dpng', '-r400');

    mgh = nanmean(gate.midH(:,1:584),2);
    figure;plot_dim(900,300);
    d = cumsum(gate.dist);
    p1 = plot(d, mgh, 'linewidth', 1.2);
    hold on
    p2 = plot(d, nanmean(gate.midn(:,1:584),2), 'linewidth', 1.2);
    xlabel('distance along gate [W-E km]');
    title(['Sector ',sector,' mean gate SIT and normal SIM'])
    yline(0, '--', 'color', [.1,.1,.1], 'linewidth', 1);
    ylim([-2.5,5])
    legend([p1, p2], 'Gate SIT [m]', 'Normal SIM [cm/s]', 'fontsize', 11)
    %print(['ICE/Production/figures/mean_conditions/sector',sector,'gateHandmeannormalmotion.png'], '-dpng', '-r400');
    clearvars
end




























