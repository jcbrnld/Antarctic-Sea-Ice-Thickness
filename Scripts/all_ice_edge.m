% Jacob Arnold

% 02-Dec-2021

% 
% Load in SIT data and use m_contourf to create variable of sea ice edge contour

load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat;
load ICE/Concentration/so-zones/fronts_0_360_lons.mat
Nsaccf = [saccf(1:478,:);nan nan; saccf(479:end,:)];
%%

[sox, soy] = ll2ps(SO_SIT.lat, SO_SIT.lon);
sobound = boundary(double(sox), double(soy), 1);

m_basemap('p', [0,360], [-90,-49]);
plot_dim(1200,1000)

% Plot ice edge contour (line between SIT==0 and SIT==0.01) at all times 
for ii = 1:length(SO_SIT.dn)
        
    m_contour(SO_SIT.olon, SO_SIT.olat, SO_SIT.OcontH(:,:,ii), [0,0.01], 'color', [0.85,0.3,0.7]);


end
dummy = m_plot([0,0],[-40,-40], 'm', 'linewidth', 2);
% then plot the acc polar front
pfline = m_plot(pf(2:end-1,1), pf(2:end-1,2), 'color', [0.2,0.6,0.8], 'linewidth', 2);
%saccfline = m_plot(Nsaccf(2:end-1,1), Nsaccf(2:end-1,2), 'color', [0.5,0.8,0.6], 'linewidth', 2);
gridedge = m_plot(SO_SIT.lon(sobound), SO_SIT.lat(sobound), 'linewidth', 1.5, 'color', [0.1,0.1,0.1]);
legend([dummy,pfline,gridedge],'Ice Edges', 'ACC Polar Front', 'Extent of Grid',...
    'position', [0.46,0.495,0.12,0.05], 'fontsize', 12);

print -dpng -r600 ICE/ICETHICKNESS/Figures/Southern_Ocean/Ice_Edge/All_edge_PF_gridedge.png


