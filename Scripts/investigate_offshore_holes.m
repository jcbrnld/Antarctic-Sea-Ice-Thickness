

% Shapefiles loaded with first part of SITworkingscript_Final.m




% looking at 10-jan-2005 gap in southwest accpo region
% shpfile # 52

m_basemap('p', [0,360], [-90,-45]);
plot_dim(1000,900)
[shplat, shplon] = ps2ll(shpfiles{52}.ncst{150}(:,1), shpfiles{52}.ncst{150}(:,2));
%m_plot(shpfiles{52}.ncst{20}(:,2), shpfiles{52}.ncst{20}(:,1), 'linewidth', 1.2)
m_plot(shplon, shplat, 'linewidth', 2)







% First in xy
figure
for ii = 1:length(shpfiles{52}.ncst)
    plot(shpfiles{52}.ncst{ii}(:,1), shpfiles{52}.ncst{ii}(:,2))
    hold on
end
    




m_basemap('p', [0,360], [-90,-45]);
plot_dim(1000,900)
for ii = 1:length(shpfiles{52}.ncst)
    [slat,slon] = ps2ll(shpfiles{52}.ncst{ii}(:,2), shpfiles{52}.ncst{ii}(:,1));
    
    m_plot(slat,slon, 'linewidth',2);
    clear slat slon
    
end
    
    
    