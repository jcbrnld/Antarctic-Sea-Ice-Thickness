



load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector10.mat;




%% find little grid inds within big grid
% THIS IS HOW IT SHOULD BE DONE. 

% step 1: Get the original (big) grid
load ICE/Concentration/ant-sectors/sector10.mat;
glon = sector10.grid3p125km.lon;
glat = sector10.grid3p125km.lat;
clear sector10

% step 2: find indices of the big grid corresponding to little grid locs
for ii = 1:length(SIT.lon)
    gind(ii) = find((glon == SIT.lon(ii)) & (glat == SIT.lat(ii)));
    
end

% step 3: Add values at those locs
data = nan(size(glon)); % everything outside grid is nan
data(gind) = SIT.H(:,400);

% step 4: create contour plot
% - remember the data is the size of the large grid still though most of it
% is nan. 
m_basemap('a', [111.5,123.5], [-67.3,-64.5])
plot_dim(1000,700)
contvec = [0:0.2:2]; % define where to put the contour lines
m_contourf(glon,glat,data,contvec)
%colormap(jet(10))
cmocean('ice', 10);
caxis([0,2])
cbh = colorbar;
cbh.Ticks = contvec;
cbh.Label.String = ('Sea Ice Thickness [cm]');
cbh.FontSize = 16;
cbh.Label.FontSize = 18;









