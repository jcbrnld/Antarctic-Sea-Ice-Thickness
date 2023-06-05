% Jacob Arnold

% 04-Mar-2022

% calculate sea ice divergence on 25 km grid and interpolate to sector
% grids. Zones should already be on the SIM grid so find corresponding
% indices. 


% NOTE
% the 25 km grid for ice motion is not monotonic 
% Will need motion on a different grid in order to calculate divergence



% load in global SIM
load ICE/Motion/1978-2020-daily-25km-SIM.mat

%%


d = 9000;

tu = u(:,:,d);
tv = v(:,:,d);

% check out the vecs
m_basemap('p', [-180, 180], [-90,-50]);
m_scatter(lon(:), lat(:), 7, tu(:),'s', 'filled');
colormap(mycolormap('mint'));
colorbar





%%


div = cdtdivergence(lat, lon, tu, tv);























