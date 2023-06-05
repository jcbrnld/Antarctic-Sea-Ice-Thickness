% Jacob Arnold
% 24-nov-2021
% Contour southern hemisphere SIT



load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat


load ICE/Concentration/ant-sectors/sector10.mat;
glon = sector10.grid3p125km.lon;
glat = sector10.grid3p125km.lat;
glon2 = sector10.grid25km.lon;
glat2 = sector10.grid25km.lat;
clear sector10

slon = SO_SIT.lon(SO_SIT.shelf_ind);
slat = SO_SIT.lat(SO_SIT.shelf_ind);
olon = SO_SIT.lon(SO_SIT.offshore_ind);
olat = SO_SIT.lat(SO_SIT.offshore_ind);


% step 2: find indices of the big grid corresponding to little grid locs
cntr = 0:5000:10000000;
disp('Starting shelf')
for ii = 1:length(slon)
    if ismember(ii,cntr)
        disp(['Working on shelf: ii = ',num2str(ii),' of ',num2str(length(slon))])
    end
    sgind(ii) = find((glon == slon(ii)) & (glat == slat(ii)));
    
end
disp('Finished with Shelf... Starting offshore')

for ii = 1:length(olon)
    if ismember(ii,cntr)
        disp(['Working on shelf: ii = ',num2str(ii),' of ',num2str(length(olon))])
    end
    tind = find((glon2 == olon(ii)) & (glat2 == olat(ii)));
    if isempty(tind)==0;
        ogind(ii) = tind(1);
    else
        warning(['No Match; ii = ',num2str(ii)]) 
        ogind(ii) = nan;
    end
    
end
disp('Finished with offshore')
matchind = find(~isnan(ogind));

%% trouble offshore
glon2v = glon2(:);
glat2v = glat2(:);


m_basemap('p', [0,360], [-90,-50])
m_scatter(glon2v(ogind(isfinite(ogind))),glat2v(ogind(isfinite(ogind))), 'filled');
miss = find(isnan(ogind));

m_scatter(olon(miss),olat(miss),'c')

% It looks like the little filled boundary indices are the ones that don't
% match original grid. 

%% step 3: Add values at those locs
% HAVING TROUBLE WITH THOSE BOUNDARY indices - points that I had to fill
% previously. NEED to find which grid points in glon2v glat2v (original 25
% km grid) are NEAREST to those missing points. The missing points are
% olon(miss),olat(miss).

lonmiss = olon(miss);
latmiss = olat(miss);

m_basemap('p', [0,360], [-90,-50])
m_scatter(glon2(:),glat2(:),'filled')
m_scatter(lonmiss,latmiss,'filled')

% Convert to XY coordinates and try to find nearest indices. 
[xmiss, ymiss] = ll2ps(latmiss,lonmiss);
[gx2v, gy2v] = ll2ps(glat2v, glon2v);

% Find (in xy space) indices of the big grid where lat and lon are closest
% to those of the missing points. 
for ii = 1:length(xmiss);
    [val,missind(ii)] = min(abs(gx2v-xmiss(ii))+abs(gy2v-ymiss(ii)));

end


 % Actual lon and lat values of missing points (on original grid)
 missAlon = glon2v(missind);
 missAlat = glat2v(missind);
% 
for ii = 1:length(missAlon)
    
    tindF = find((glon2==missAlon(ii)) & glat2==missAlat(ii));
    if isempty(tindF)==0
        Find(ii) = tindF(1);
    else 
        warning(['Still no match: ii = ', num2str(ii)])
        Find(ii) = nan;
    end
end
% THIS WORKS. now glon2(Find) and glat2(Find) are the actual missing
% points. Find inidex needs to be added to larger offshore index ogind
% where ogind==nan
ogind(isnan(ogind)) = Find;
    


%%
% Shelf
sdata = nan(size(glon)); % everything outside grid is nan
sdata(sgind) = SO_SIT.H(SO_SIT.shelf_ind,400);

% offshore
odata = nan(size(glon2)); % everything outside grid is nan
odata(ogind) = SO_SIT.H(SO_SIT.offshore_ind,400);

% step 4: create contour plot
% - remember the data is the size of the large grid still though most of it
% is nan. 
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,700)
contvec = [0:0.2:2]; % define where to put the contour lines
m_contourf(glon,glat,sdata,contvec)
m_contourf(glon2,glat2,odata,contvec)
%colormap(jet(10))
cmocean('ice', 10);
caxis([0,2])
cbh = colorbar;
cbh.Ticks = contvec;
cbh.Label.String = ('Sea Ice Thickness [cm]');
cbh.FontSize = 16;
cbh.Label.FontSize = 18;

%% Create MxNxTime variable of SIT

clear odata
for ii = 1:length(SO_SIT.dn)
    tempdata = nan(size(glon2));
    tempdata(ogind) = SO_SIT.H(SO_SIT.offshore_ind,ii);
    if ii==1
        odata = tempdata;
    else
        odata = cat(3,odata,tempdata);
    end
end
        
    
clear sdata
for ii = 1:length(SO_SIT.dn)
    tempdata = nan(size(glon));
    tempdata(sgind) = SO_SIT.H(SO_SIT.shelf_ind,ii);
    if ii==1
        sdata = tempdata;
    else
        sdata = cat(3,sdata,tempdata);
    end
end
        
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,700)
contvec = [0:0.2:2]; % define where to put the contour lines
m_contourf(glon,glat,sdata(:,:,100), contvec);
m_contourf(glon2,glat2,odata(:,:,100), contvec);
cmocean('ice', 10);
caxis([0,2])
cbh = colorbar;
cbh.Ticks = contvec;
cbh.Label.String = ('Sea Ice Thickness [cm]');
cbh.FontSize = 16;
cbh.Label.FontSize = 18;

%% add to SO_SIT structure
indices_readme = {'These indices are used to identify where the vector grid points can be found within the original MxN grid';...
    'This is necessary for creating contour plots which cannot interpret vector inputs.';...
    'To use: see SO_Contour.m, MxNxTime SIT variables will be saved in the SIT structures.';...
    'OcontH variable stores the offshore MxNxTime SIT data'};
SO_SIT.grid_indices.offshore = ogind;
SO_SIT.grid_indices.shelf = sgind;
SO_SIT.grid_indices.indices_readme = indices_readme;

SO_SIT.OcontH = odata;
SO_SIT.olon = glon2;
SO_SIT.olat = glat2;
SO_SIT.slon = glon;
SO_SIT.slat = glat;


save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat', 'SO_SIT', '-v7.3');











