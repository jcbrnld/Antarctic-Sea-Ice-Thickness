% jacob Arnold

% 03-Mar-2022

% test cdtdivergence and divergence on monotonically spaced wind grid
% REMEMBER to convert to xy before divergence
% if the result is the same - can use divergence approach
% if result ~the same - see what cody did for ice divergence

load /Volumes/Data/Research/ECMWF/matfiles/segment10.mat;


%% divergence
% lets try divergence at day 7000

d = 7000;
[x,y] = ll2ps(segment10.lat, segment10.lon);

div1 = cdtdivergence(segment10.lat, segment10.lon, segment10.u10(:,:,d), segment10.v10(:,:,d));

div2 = divergence(x, y, segment10.u10(:,:,d), segment10.v10(:,:,d));

div3 = divergence(segment10.lon, segment10.lat, segment10.u10(:,:,d), segment10.v10(:,:,d));

div4 = cdtdivergence(x, y, segment10.u10(:,:,d), segment10.v10(:,:,d));

ot = segment10.div10(:,:,d);


figure;
plot_dim(1200,300);
plot(div1(:))
hold on
plot(div2(:));
plot(div3(:), 'm');


%% Try making monotonic grid based on sector with similar resolution

% 381 km 
mi = min(seaice.lon)-0.2;
ma = max(seaice.lon)+0.2;
di = ma-mi;
la = min(seaice.lat);

dv = (-max(seaice.lat)+0.1)+(min(seaice.lat)-0.1);
% distance in km along bottom edge (min lat) of minlon:maxlon
lowdistance = di*cos(deg2rad(-la))*111;
vertdistance = dv*111;

% now decide how many gpoints there should be across this region
nph = lowdistance/3.125;
npv = vertdistance/3.125;

% now determine deg. step
dsh = di/nph;
dsv = dv/npv;

defx = (min(seaice.lon)-0.2):dsh:(max(seaice.lon)+0.2);
defy = (min(seaice.lat)-0.1):dsv:(max(seaice.lat)+0.1);
[tlon, tlat] = meshgrid(defx, defy);
[londom, latdom] = sectordomain(10);
m_basemap('a', londom, latdom); plot_dim(1000,700);
m_scatter(seaice.lon, seaice.lat, 10, [0.8,0.8,0.8], 'filled')
m_scatter(tlon(:), tlat(:),10, 'filled')


%% now we have new grid

% interpolate example day to that grid and try divergence

[nx, ny] = ll2ps(tlat, tlon);
[ox, oy] = ll2ps(seaice.lat, seaice.lon);

nu = griddata(double(ox), double(oy), double(SIC.u(:,13000)), double(nx), double(ny));
nv = griddata(double(ox), double(oy), double(SIC.v(:,13000)), double(nx), double(ny));

m_basemap('a', londom, latdom); plot_dim(1000,700);
m_scatter(seaice.lon, seaice.lat, 10, [0.8,0.8,0.8], 'filled')
m_quiver(tlon(:), tlat(:), nu(:), nv(:))
%m_scatter(tlon(:), tlat(:),10,nu(:), 'filled')

divn1 = cdtdivergence(tlat, tlon, nu, nv);
divn2 = divergence(nx, ny, nu, nv);


m_basemap('a', londom, latdom); plot_dim(1000,700);
m_scatter(seaice.lon, seaice.lat, 10, [0.8,0.8,0.8], 'filled')
m_scatter(tlon(:), tlat(:),20,divn1(:), 'filled'); xlabel('cdtdivergence');
colorbar;
colormap(mycolormap('grp'));
caxis([-0.00007, 0.00007]);

m_basemap('a', londom, latdom); plot_dim(1000,700);
m_scatter(seaice.lon, seaice.lat, 10, [0.8,0.8,0.8], 'filled')
m_scatter(tlon(:), tlat(:),20,-divn2(:), 'filled'); xlabel('divergence')
colorbar;
colormap(mycolormap('grp'));
caxis([-0.00007, 0.00007]);

% OKAY SO 
% it looks like we need to on the fly in a for loop interpolate to
% monotonic sector grid, calculate divergence and curl, and interpolate
% back to sector grid. 






