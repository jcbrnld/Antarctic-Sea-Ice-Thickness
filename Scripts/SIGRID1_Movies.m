% 18-Aug-2021

% Jacob Arnold

% Create movies of SIGRID 1 data


load 'ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts_gridded'

%%


% Make the movie: Notice where it saves

cntr = [1:50:2000];
mnths = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];

for ii = 1:length(charts_gridded.dn);
    if ismember(ii,cntr)
        disp(['Finished through... ', num2str(charts_gridded.dv(ii,3)), '-', char(mnths(charts_gridded.dv(ii,2))), '-', num2str(charts_gridded.dv(ii,1))])
    end
    size = 6;
    m_basemap('p', [-180,180], [-89, -43], 'sdL_v10', [2000,4000], [8,8]);
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 700])
    m_scatter(charts_gridded.lon, charts_gridded.lat, size, charts_gridded.SB(:,ii), 'filled');hold on
    if isnan(charts_gridded.dv(ii))==0
        text(-0.07, 0, datestr(datetime(charts_gridded.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        text(-0.03, 0,'-- --- ----')
    end
    colormap(jet(10))
    %cmocean('ice', 12);
    caxis([0,100])
    %caxis([0,1])
    cbh = colorbar;
    cbh.Ticks = [0:10:100];
    cbh.Label.String = ('SB [%]');
    F(ii) = getframe(gcf);
    close gcf
end
writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/SIGRID1/ALL_SB.mp4'], 'MPEG-4');
  

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success!  Video saved'])
clear F 
