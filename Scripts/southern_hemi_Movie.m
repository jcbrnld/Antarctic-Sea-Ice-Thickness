% Jacob Arnold
% 17-nov-2021

% Make movie of all southern ocean sea ice thickness


clear all
close all

sector = 'Southern Ocean';


visquest = questdlg('See plots momentarily as they are created?');
if visquest(1)=='C'
    error('Cancel selected at visibility question')
end

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat'])

% Make the movie: Notice where it saves

cntr = [1:50:20000];
mnths = {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'};

for ii = 1:length(SO_SIT.H(1,:));
    if ismember(ii,cntr)
        disp(['Finished through...     ', num2str(SO_SIT.dv(ii,3)), '-', mnths{SO_SIT.dv(ii,2)}, '-', num2str(SO_SIT.dv(ii,1))])
    end
    if visquest(1)=='Y'
        m_basemap('p', [0,360], [-90,-45])
    else
        m_basemap2('p', [0,360], [-90,-45]) 
    end

    size1 = .9;
    size2 = 8;

    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 700])
    m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind), size1,SO_SIT.H(SO_SIT.shelf_ind,ii), 'filled');
    m_scatter(SO_SIT.lon(SO_SIT.offshore_ind), SO_SIT.lat(SO_SIT.offshore_ind), size2,SO_SIT.H(SO_SIT.offshore_ind,ii), 'filled');

    if isnan(SO_SIT.dv(ii))==0
        xlabel(datestr(datetime(SO_SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap(jet(10))
    %cmocean('ice', 10);
    caxis([0,2])
    %caxis([0,1])
    cbh = colorbar;
    cbh.Ticks = [0:0.2:2];
    cbh.Label.String = ('Sea Ice Thickness [cm]');
    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/Full_length/',sector,'nancheck.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Sector ',sector,' Video saved'])
clear F 


