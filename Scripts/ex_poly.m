% Jacob Arnold


% Plot example polygons with finer grid resolution



t = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC090406')

load('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector07.mat');

[londom, latdom] = sectordomain(07);
%m_basemap('m', londom, latdom)
m_basemap('p', [0,360], [-90,-60])
m_scatter(SIT.lon, SIT.lat, 5, [0.2,0.8,0.6], 'filled');
for ii = 1:length(t.ncst(:,1))
    [lat, lon] = ps2ll(t.ncst{ii}(:,1), t.ncst{ii}(:,2), 'TrueLat',-60);
    lon = lon+180;
    m_plot(lon, lat, 'linewidth', 1);
end