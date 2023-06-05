% Jacob Arnold

% 02-Feb-2022

% Make movies of sectors with SIV timeseries along the bottom
% Check nan_movie.m for examples and inspiration


%%

% to practice:
%_________________
%ss = 12;
%-----------------
for ss = 13:18
% CHECK WHERE IT SAVES 

    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

    % UNCOMMENT FOR CONTOURS
% load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
% 
% 
% lon2d = SIC.grid3p125km.lon;
% lat2d = SIC.grid3p125km.lat;
% ___
    SIT.SIV = nansum((SIT.H./1000).*3.125);

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
    for ii = 1:length(SIT.H(1,:));
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
        m_basemap_subplot('a', londom, latdom);
        scat1 = m_scatter(SIT.lon, SIT.lat, sdot+sdot*multfac, SIT.H(:,ii), 'filled');
        %________
        %m_contourf(lon2d, lat2d, newH, [0:0.3:2.4], 'linestyle', 'none') %contour plot
        
        %colormap(s1,colormapinterp(mycolormap('id3'),8));
        cmap = colormap(colormapinterp(mycolormap('id3'),10, [0,0,0], [0.99    0.76    0.6469])); % ASSIGN this color to 0
        % Scatter plot specifc categories
        m_scatter(SIT.lon(zeroind), SIT.lat(zeroind), sdot+sdot*multfac, cmap(1,:), 'filled'); % [0.2,0.01,0.15]
        m_scatter(SIT.lon(cat2), SIT.lat(cat2), sdot+sdot*multfac, cmap(2,:), 'filled'); % [0.2,0.01,0.15]
        % uncomment to CONTOUR higher levels
        %m_contour(lon2d, lat2d, newH, contvec, 'color', [0.5,0.5,0.5], 'ShowText', 'on');
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

        xlabel(['Sector ',sector,': ',datestr(SIT.dn(ii)), ' indx: ', num2str(ii)],...
            'Position', xpos, 'fontsize', 15, 'fontweight', 'bold');

        s2 = subplot(4,1,4);
        linevar = SIT.SIV;
        set(s2, 'Position', s2pos)

        plot(SIT.dn, linevar, 'linewidth', 1.5,'color', [0.2,0.7,0.6])
        xline(SIT.dn(ii), 'linewidth', 1.2, 'color', [0.9, 0.3, 0.4]);
        xticks(dticker);
        datetick('x', 'mm-yyyy', 'keepticks')
        xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
        xtickangle(33)
        %ylim([0, max(linevar) + 10])
        ylabel('Sea Ice Volume [km^3]', 'fontweight', 'bold')
        grid on
        

        F(ii) = getframe(gcf);

        clear nanlocs s1 s2 
        close gcf

    end

    writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/orig_timescale/sector',sector,'SIT_SIV_id3.mp4'], 'MPEG-4');

    writerobj.FrameRate = 5;
    open (writerobj);

    for jj=1:length(F)
        frame = F(jj);
        writeVideo(writerobj, frame);
    end
    close(writerobj);
    disp(['Success! Sector ',sector,' Video saved'])

    clearvars

    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
