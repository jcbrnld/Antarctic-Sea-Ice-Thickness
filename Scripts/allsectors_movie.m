% Jacob Arnold

% 11-Jan-2022

% Make movies of all sectors SIT 
% For coastal sectors try using m_contourf


% Try contour plotting
sector = '10';
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);


lon2d = SIC.grid3p125km.lon;
lat2d = SIC.grid3p125km.lat;

dummyH = SIT.H;
%%
plotind = 830; %  plot the 500th recording
newH = nan(size(lon2d));

newH(SIC.index) = SIT.H(:,plotind);


 % For scatter:
        nanind = find(isnan(SIT.H(:,plotind)));
        zeroind = find(SIT.H(:,plotind)==0);
        dummyH(nanind,plotind) = -1; % to use nans in colorbar
        
[londom, latdom] = sectordomain(10);
sizes = sectordotsize(str2num(sector));
%
m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1])

sectorexpand(10);
%m_contourf(lon2d, lat2d, newH, [0:0.3:2.4], 'linestyle', 'none') % THIS is the way!

        m_scatter(SIT.lon, SIT.lat, sizes,SIT.H(:,plotind), 'filled'); % scatter plot
        %m_scatter(SIT.lon(nanind), SIT.lat(nanind), sizes, [0.8,0.8,0.8], 'filled');
        %m_scatter(SIT.lon(zeroind), SIT.lat(zeroind), sizes, [0.5,0.05,0.3], 'filled');
        
% MUCH OF THIS SHOWS YOU HOW TO ASSIGN A SPECIFIC COLOR TO 0 
% THIS will be useful when viewing on very large scale but not as much for
% individual sectors. 

%colormap(jet(8))
%colormap(colormapinterp(mycolormap('mint'),10, [0.5,0.04,0.3], [0.9,0.6,0.7]))
%colormap(colormapinterp(mycolormap('mint'),10, [0.85,0.85,0.85; 0.3,0.1,0.3])) % specify both 0 color and nan color
colormap(colormapinterp(mycolormap('mint'),10, [0.3,0.1,0.3])) % ASSIGN this color to 0


%caxis([-0.599,2.4]) % THIS IS HOW YOU ASSIGN A COLOR TO 0 and NaN
caxis([-0.299,2.4]) % THIS IS HOW YOU ASSIGN A COLOR TO 0
    cbh = colorbar;
%cbh.Ticks = [0:0.3:2.4];
%cbh.Ticks = [-0.44,0,0.3:0.3:2.4]; if including nan
cbh.Ticks = [0,0.3:0.3:2.4];
%cbh.TickLabels =
%{'NaN','0','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'}; % if including nan
cbh.Label.String = ('Sea Ice Thickness [m]');
cbh.FontSize = 13;
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'Bold';
cbh.TickLength = 0.0499;
%cbh.TickLength = 0; % for nan

%% Make movie for all sectors

for ss = 1:18
    
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

    
    cntr = [1:50:2000];
    [londom, latdom] = sectordomain(str2num(sector));
    sizes = sectordotsize(str2num(sector));
    for ii = 1:length(SIT.H(1,:));
        if ismember(ii,cntr)
            disp(['Finished through... ' datestr(SIT.dn(ii))])
        end

        % Uncomment these for contours
        %newH = nan(size(lon2d));
        %newH(SIC.index) = SIT.H(:,ii);
        
        % For scatter:
        nanind = find(isnan(SIT.H(:,ii)));
        zeroind = find(SIT.H(:,ii)==0);

        m_basemap2('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) 
        %m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
        sectorexpand(str2num(sector));
        
        m_scatter(SIT.lon, SIT.lat, sizes,SIT.H(:,ii), 'filled'); % scatter plot
        %m_scatter(SIT.lon(nanind), SIT.lat(nanind), sizes, [0.8,0.8,0.8], 'filled');
        %m_scatter(SIT.lon(zeroind), SIT.lat(zeroind), sizes, [0.2,0.01,0.15]);
        
        %m_contourf(lon2d, lat2d, newH, [0:0.3:2.4], 'linestyle', 'none') % THIS is the way!

        if isnan(SIT.dv(ii))==0
            xlabel(datestr(datetime(SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
        else
            xlabel('-- --- ----')
        end
        colormap(colormapinterp(mycolormap('mint'),8))
        %cmocean('-matter', 8); % -matter, -tempo, -rain, and -amp are nice
        caxis([0,2.4])
        cbh = colorbar;
        cbh.Ticks = [0:0.3:2.4];
        cbh.Label.String = ('Sea Ice Thickness [m]');
        cbh.FontSize = 13;
        cbh.Label.FontSize = 16;
        cbh.Label.FontWeight = 'Bold';
        cbh.TickLength = 0.05;
        F(ii) = getframe(gcf);
        close gcf
        clear newH
    end

    writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/Plain_Thickness_orig_timescale/sector',sector,'_mint_scat.mp4'], 'MPEG-4');


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









