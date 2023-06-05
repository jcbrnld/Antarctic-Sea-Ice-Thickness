% Jacob Arnold

% 05-aug-2021

% Make movies of combined e00 and shp raw gridded data (years 1997-2021+)



sector = 14;

load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpE00.mat;
e00SIT = SIT;clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpSIG.mat;
shp = SIT;clear SIT


SIT.dn = [e00SIT.dn;shp.dn];
SIT.dv = [e00SIT.dv;shp.dv];
SIT.sa = [e00SIT.sa,shp.sa];
SIT.ct = [e00SIT.ct,shp.ct];
SIT.sa = [e00SIT.sa,shp.sa];
SIT.lon = shp.lon; SIT.lat = shp.lat;

splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53 69]; splot{6,2}=[-68 -65.1];
splot{7,1}=[66.5 86.5]; splot{7,2}=[-71 -64.5]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99 114]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[120.5 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[132.5 151.5]; splot{12,2}=[-69.3 -64.2];
splot{13,1}=[148 174]; splot{13,2}=[-72.5 -65]; splot{14,1}=[159.5 207]; splot{14,2}=[-79.5 -69];
splot{15,1}=[200 236]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-69 -59];

%%

mnths = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];

cntr = [1:50:2000];
for ii = 1:length(SIT.dn);
    if ismember(ii,cntr)
        disp(['Finished through... ', num2str(SIT.dv(ii,3)), '-', mnths(SIT.dv(ii,2)), '-', num2str(SIT.dv(ii,1))])
    end
    m_basemap2('a', splot{sector,1}, splot{sector,2}, 'sdL_v10', [2000,4000], [8,8]); % 2000 and 4000 m isobaths
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 800])

    m_scatter(SIT.lon, SIT.lat,40, SIT.sa(:,ii), 'filled'); 
  
    xlabel(datestr(SIT.dn(ii)))
    %colormap(jet(10))
    cmocean('ice');
    caxis([0,100]);
    cbh = colorbar;
    %cbh.Ticks = [0:5:100];
    cbh.Label.String = ('CT');

    F(ii) = getframe(gcf);
    close gcf
    
end

   
writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Raw_gridded/sector14/e00_shp_mergedCT.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Video saved'])
clear F 




