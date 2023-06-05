% Jacob Arnold

% 11-Nov-2021

% Fill missing grid points at 25km zone borders

% - Load SO_SIT.mat;
% - Load subpolar_io_SIC_SIM.mat;
% - overlay SO_SIT grid on top of entire 25km grid;
% - Find lat and lon values for the missing grid points;
% - Add them into lat and lon at the correct locations (or at the end);
% - Interpolate from SO_SIT.lat, SO_SIT.lon, SO_SIT.H(:,ii) to new lat and lon.


load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat;
load ICE/Concentration/so-zones/subpolar_io_SIC_SIM.mat;

%%

lon25 = subpolario.grid25km.lon(:);
lat25 = subpolario.grid25km.lat(:);
clear subpolario

neglon = find(lon25<0);
lon25(neglon) = lon25(neglon)+360;

[sox, soy] = ll2ps(SO_SIT.lat, SO_SIT.lon);

[sicx, sicy] = ll2ps(lat25, lon25);


% Use ginput to individually select the grid points 
figure;
scatter(sicx, sicy, 20,'filled', 'markerfacecolor', [.2, .6, .8]);
hold on
scatter(sox, soy, 20, 'filled', 'markerfacecolor', [.8, .5, .4]);





%% 

locs = find(ismember(sicy, soy)==0 | ismember(sicx, sox)==0);
figure;plot(locs)


figure;
scatter(sicx, sicy);
hold on
scatter(sicx(locs), sicy(locs),50, 'filled')



%%
% New alternative approach
% Find boundary of sox, soy
shelfx = sox(SO_SIT.shelf_ind);
shelfy = soy(SO_SIT.shelf_ind);

boundinds = boundary(double(sox), double(soy), 1);
innerinds = boundary(double(shelfx), double(shelfy), .5); 
%oipoly = innerinds(1:2250); % outer/inner polly - outer portion of shelf *only when S=1 in boundary
diffx = sicx(locs);
diffy = sicy(locs);

figure
scatter(diffx, diffy, 20, 'filled')
hold on
plot(sox(boundinds), soy(boundinds), 'm')
plot(sox(innerinds), soy(innerinds), 'r')


inside = find(inpolygon(diffx, diffy, sox(boundinds), soy(boundinds))==1 &...
    inpolygon(diffx, diffy, sox(innerinds), soy(innerinds))==0);

figure
scatter(diffx, diffy, 20, 'filled')
hold on
scatter(diffx(inside), diffy(inside), 'm','filled')
scatter(shelfx, shelfy, 2,'c', 'filled')

ex = diffx(inside);
ey = diffy(inside);

figure;scatter(diffx, diffy, 20, 'filled', 'markerfacecolor', [0.2, 0.7, 0.5])
hold on
scatter(ex, ey, 20, 'filled','m');

%% find ex and ey along coast and remove
% Then find which ex and ey belong to which zones

figure;scatter(diffx, diffy, 20, 'filled', 'markerfacecolor', [0.2, 0.7, 0.5])
hold on
scatter(ex, ey, 20, 'filled','m');
[x,y] = ginput

for ii = 1:length(x)
    [val,idx(ii)]=min(abs(ex-x(ii)) + abs(ey-y(ii)));
    %[val2, idx2(ii)] = min(abs(ey-y(ii)));
    
end

    
ex2 = ex; ex2(idx)=[];
ey2 = ey; ey2(idx)=[];

figure;scatter(diffx, diffy, 20, 'filled', 'markerfacecolor', [0.2, 0.7, 0.5])
hold on
scatter(ex, ey, 20, 'filled','m');
scatter(ex2,ey2, 30, 'filled', 'c');

%% ex2 and ey2 are our points to be filled 

% Need to:
% - add these to lat and lon
% - interpolate H(:,ii) at these points 
% - find which points belong to which zones and add data and lat+lon vals
% to those zone files. 


figure;scatter(diffx, diffy, 20, 'filled', 'markerfacecolor', [0.2, 0.7, 0.5])
hold on
scatter(ex2,ey2, 30, 'filled', 'c');

[plat, plon] = ps2ll(ex2, ey2);

m_basemap('p', [0,360], [-90, -45])
m_scatter(SO_SIT.lon, SO_SIT.lat, 'filled')
m_scatter(plon, plat, 'filled', 'm');

% Lon and lat variables including those missing points 
alon = [SO_SIT.lon; plon];
alat = [SO_SIT.lat; plat];


m_basemap('p', [0,360], [-90, -45])
m_scatter(alon, alat, 'filled');

[sox, soy] = ll2ps(alat, alon);

figure
scatter(sox, soy,15, 'filled', 'markerfacecolor', [0.5, 0.2, 0.6])

[lx, ly] = ginput;


for ii = 1:length(lx)
    [val,lastidx(ii)]=min(abs(sicx-lx(ii)) + abs(sicy-ly(ii)));
    %[val2, idx2(ii)] = min(abs(ey-y(ii)));
    
end
lxc = sicx(lastidx);
lyc = sicy(lastidx);

hold on
scatter(lxc, lyc, 50, 'filled', 'c')

[lastlat, lastlon] = ps2ll(lxc, lyc);

alon = [alon; lastlon];
alat = [alat; lastlat];
m_basemap('p', [0,360], [-90,-45])
m_scatter(alon, alat, 10, 'filled');

misspoint_ind = [(length(alon)-(length(plon)+length(lastlon)))+1:length(alon)];


% Temp save alon, alat, misspoint_ind
fullg.lon = alon; 
fullg.lat = alat;
fullg.misspoint_ind = misspoint_ind;
save('ICE/ICETHICKNESS/Data/MAT_files/Final/full_g.mat', 'fullg');

%% NOW we have the final grid

% alon and alat are the grid vectors
% 
load ICE/ICETHICKNESS/Data/MAT_files/Final/full_g.mat
load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat;


% Convert to xy
[ax, ay] = ll2ps(fullg.lat, fullg.lon);
[sox, soy] = ll2ps(SO_SIT.lat, SO_SIT.lon);

% Interpolate just for those previously mising points
for ii = 1:length(SO_SIT.H(1,:))
    disp(['Interpolating ', num2str(ii), ' of ', num2str(length(SO_SIT.H(1,:)))])

    fullH(:,ii) = griddata(double(sox), double(soy), double(SO_SIT.H(:,ii)),... 
        double(ax(fullg.misspoint_ind)), double(ay(fullg.misspoint_ind))); % Just the new points


end


% figure;
% scatter(ax, ay, 15, fullH(:,550), 'filled');

%%

allSIT = [SO_SIT.H; fullH];

figure;
scatter(ax, ay, 10, allSIT(:,820), 'filled');


m_basemap('p', [0,360], [-90,-45]);
m_scatter(fullg.lon, fullg.lat,10, allSIT(:,734), 'filled')

SO_SIT.H = allSIT;
SO_SIT.lon = fullg.lon;
SO_SIT.lat = fullg.lat;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat', 'SO_SIT');



m_basemap('p', [0,360], [-90,-45]);
m_scatter(SO_SIT.lon, SO_SIT.lat,10, SO_SIT.H(:,704), 'filled')


































