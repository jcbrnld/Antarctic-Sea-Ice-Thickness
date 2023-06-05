% Jacob Arnold

% 18-may-2022

% Make movies of SIT with SIM vectors in each sector
% Include SIP timeseries below 

% Use 25 km SIM so we can actually see the arrows 





%-----------------

for ss = 1:18
% CHECK WHERE IT SAVES 

    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    if ss == 03 | ss == 04 | ss == 07;
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'b.mat']);
        gb = gate;clear gate
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
        gate.lon = [gate.lon; nan; gb.lon];
        gate.lat = [gate.lat; nan; gb.lat];
        gate.midlon = [gate.midlon; nan; gb.midlon];
        gate.midlat = [gate.midlat; nan; gb.midlat];
        gate.midn = [gate.midn; nan(1,length(gate.midn(1,:))); gb.midn];
        gate.midnx = [gate.midnx; nan(1,length(gate.midnx(1,:))); gb.midnx];
        gate.midny = [gate.midny; nan(1,length(gate.midny(1,:))); gb.midny];
        gate.inside.in = [gate.inside.in; gb.inside.in];
        gate.inside.Hin = [gate.inside.Hin; gb.inside.Hin];
        gate.dist = [gate.dist; gb.dist];
    else
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Motion/Data/NSIDC/25_km_sectors/sector',sector,'.mat']);
    % Just within flux gate
    % temporarily replace SIT.H
    SIT.H = gate.inside.Hin;
    SIT.lon = SIT.lon(gate.inside.in);
    SIT.lat = SIT.lat(gate.inside.in);
    
    dists(ss) = sum(gate.dist, 'all', 'omitnan');
% ___

    dticker = unique(SIT.dv(:,1));
    dticker(end+1) = 2022;
    dticker(:,2:3) = 1;
    dticker = datenum(dticker);

    cntr = [1:50:2000];
    [londom, latdom] = sectordomain(str2num(sector));
    sdot = sectordotsize(str2num(sector));
     ii = 500; % to test single frame

    [lpos, xpos, s2pos, tickl, multfac] = sector_movie_params(sector,1);
    
    % try contouring beyond color range
    contvec = [2.4,2.7,3];
     %%%
    for ii = 2:length(SIP.dn);
        if ismember(ii,cntr)
            disp(['Finished through... ' datestr(SIT.dn(ii))])
        end

        figure;
        s1 = subplot(4,1,1:3); 
        set(s1, 'Position', [0.1,0.3,0.81,0.6])
        if str2num(sector) == 01
            plot_dim(800,950);
        else
            plot_dim(800,800);
        end
        
        % Uncomment these for contours
        %newH = nan(size(lon2d));
        %newH(SIC.index) = SIT.H(:,ii);
        
        zeroind = find(SIT.H(:,ii)<=0.05);
        cat2 = find(SIT.H(:,ii)>0.05 & SIT.H(:,ii)<0.3);
        m_basemap_subplot('m', londom, latdom);
        scat1 = m_scatter(SIT.lon, SIT.lat, sdot+sdot*multfac, SIT.H(:,ii), 'filled');
        %________
        %m_contourf(lon2d, lat2d, newH, [0:0.3:2.4], 'linestyle', 'none') %contour plot
        
        %colormap(s1,colormapinterp(mycolormap('id3'),8));
        cmap = colormap(colormapinterp(mycolormap('id3'),10, [0,0,0], [0.99    0.76    0.6469])); % ASSIGN this color to 0
        % Scatter plot specifc categories
        m_scatter(SIT.lon(zeroind), SIT.lat(zeroind), sdot+sdot*multfac, cmap(1,:), 'filled'); % [0.2,0.01,0.15]
        m_scatter(SIT.lon(cat2), SIT.lat(cat2), sdot+sdot*multfac, cmap(2,:), 'filled'); % [0.2,0.01,0.15]
        m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.1);
        %m_quiver(gate.midlon, gate.midlat, gate.midnx(:,ii), gate.midny(:,ii));
        %m_scatter(inSIM.lon(isfinite(inSIM.u(:,ii))), inSIM.lat(isfinite(inSIM.u(:,ii))), sdot*1.5, [.01,.01,.01], 'filled')
        %m_quiver(inSIM.lon, inSIM.lat, inSIM.u(:,ii), inSIM.v(:,ii), 'color', [.02,.02,.02], 'linewidth', 1.1, 'ShowArrowHead', 'off');
        m_quiver(gate.midlon, gate.midlat, gate.midnx(:,ii), gate.midny(:,ii),'color', [.02,.02,.02], 'linewidth', 1.1, 'ShowArrowHead', 'off');
        m_scatter(gate.midlon(isfinite(gate.midn(:,ii))), gate.midlat(isfinite(gate.midn(:,ii))), sdot*1.5, [.01,.01,.01], 'filled')

        cbh = colorbar;
        cbh.Ticks = [-0.3:0.3:2.4];
        cbh.Label.String = ('Sea Ice Thickness [m]');
        cbh.FontSize = 13;
        cbh.Label.FontSize = 15;
        cbh.Label.FontWeight = 'bold';
        caxis([-0.3,2.7]);
        %cbh.TickDirection = 'out'
        cbh.TickLength = tickl;
        cbh.TickLabels = {'0','0.05','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'}; % if including nan

        title(['Sector ',sector,': ',datestr(SIT.dn(ii)), ' indx: ', num2str(ii)],...
             'fontsize', 15, 'fontweight', 'bold');

        s2 = subplot(4,1,4);
        linevar = SIP.P;
        set(s2, 'Position', s2pos)

        plot(SIP.dn, linevar, 'linewidth', 1.5,'color', [0.2,0.7,0.6])
        xline(SIP.dn(ii-1), 'linewidth', 1.2, 'color', [0.9, 0.3, 0.4]);
        xticks(dticker);
        datetick('x', 'mm-yyyy', 'keepticks')
        xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
        xtickangle(33)
        %ylim([0, max(linevar) + 10])
        ylabel('Sea Ice Production [km^3 wk^-^1]', 'fontweight', 'bold')
        grid on
        

        F(ii-1) = getframe(gcf);

        clear nanlocs s1 s2 
        close gcf

    end

    writerobj = VideoWriter(['ICE/Production/figures/Videos/sector',sector,'_SIT_GateSIM_SIP.mp4'], 'MPEG-4');
    %writerobj = VideoWriter(['ICE/Production/figures/Videos/sector',sector,'_SIT_gateSIM_SIP.mp4'], 'MPEG-4');

    writerobj.FrameRate = 5;
    open (writerobj);

    for jj=1:length(F)
        frame = F(jj);
        writeVideo(writerobj, frame);
    end
    close(writerobj);
    disp(['Success! Sector ',sector,' Video saved'])

    clearvars -except dists

    
end
    
disp(['Remember to check dists for total gate distances for each sector']);

