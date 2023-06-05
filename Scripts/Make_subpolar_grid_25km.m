% 09-July-2021

% Jacob Arnold


% Make subpolar 25km grids



% Currently subpolar regions are defined in 3.125 km grids. 
% Need to open subpolar grid, use boundary function to find the indices of
% the edge, and us inpolygon to find which of the 25km grid points are
% within the boundary. 

sect = load('ICE/Concentration/so-zones/subpolar_io_SIC.mat');

sectc = struct2cell(sect);
olon = sectc{1,1}.lon;
olat = sectc{1,1}.lat;

sbound = boundary(double(olon), double(olat));

grids = load('ECMWF/all_grids.mat');
nlon = grids.lon.sim25km(:);
nlat = grids.lat.sim25km(:);

% View

m_basemap('m', [21,160], [-73, -55]); % subpolar io
set(gcf, 'position', [500,600,1200, 500]);
m_scatter(olon, olat, 2,'filled');hold on;
m_plot(olon(sbound), olat(sbound), 'c', 'linewidth', 1.2);


