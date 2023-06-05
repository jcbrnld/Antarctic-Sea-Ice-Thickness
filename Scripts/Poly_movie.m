% Jacob Arnold

% 03-Aug-2021

% Make movie of e00 polygons

load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat;



%%

for ii = 1:length(e00_data.shpfiles);
    disp(['e00 Shapefile ',num2str(ii), ' of ',num2str(length(e00_data.shpfiles))])
    m_basemap2('p', [0,360,60], [-89, -57], 'sdL_v10', [2000,4000], [8,8]); % 2000 and 4000 m isobaths
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 700])
    for jj = 1:length(e00_data.shpfiles{ii}.ncst)
        
        [lat,lon] = ps2ll(e00_data.shpfiles{ii}.ncst{jj}(:,1),e00_data.shpfiles{ii}.ncst{jj}(:,2), 'TrueLat',-60);
        
        m_plot(lon+180, lat, 'linewidth', 1.2);
        
        clear lon lat
        
    end
    xlabel(datestr(e00_data.dn))


    F(ii) = getframe(gcf);
    close gcf
    
end

   
writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Polygons/e00/Alle00_2.mp4'], 'MPEG-4');

writerobj.FrameRate = 3;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Video saved'])
clear F 














